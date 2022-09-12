// ignore_for_file: implementation_imports

import 'dart:convert';

import 'package:flutter_quill/src/models/documents/document.dart';
import 'package:flutter_quill/src/widgets/controller.dart';
import 'package:flutter_quill/src/widgets/default_styles.dart';
import 'package:flutter_quill/src/widgets/editor.dart';
import 'package:flutter_quill/src/widgets/toolbar.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:masamune_module/masamune_module.dart';
import 'package:tuple/tuple.dart';

const _kQuillToolbarHeight = 80;

@immutable
class PostModule extends PageModule with VerifyAppReroutePageModuleMixin {
  const PostModule({
    bool enabled = true,
    String? title = "",
    required String routePathPrefix,
    String queryPath = "post",
    ModelQuery? query,
    this.userPath = "user",
    this.nameKey = Const.name,
    this.textKey = Const.text,
    this.enableEdit = true,
    this.createdTimeKey = Const.createdTime,
    this.sliverLayoutWhenModernDesignOnHome = true,
    this.automaticallyImplyLeadingOnHome = true,
    this.editingType = PostEditingType.planeText,
    List<RerouteConfig> rerouteConfigs = const [],
    this.postQuery,
    this.homePage = const PageConfig(
      "/",
      PostModuleHomePage(),
    ),
    this.addPage = const PageConfig(
      "/edit",
      PostModuleEditPage(),
    ),
    this.viewPage = const PageConfig(
      "/{post_id}",
      PostModuleViewPage(),
    ),
    this.editPage = const PageConfig(
      "/{post_id}/edit",
      PostModuleEditPage(),
    ),
  }) : super(
          enabled: enabled,
          title: title,
          query: query,
          queryPath: queryPath,
          routePathPrefix: routePathPrefix,
          rerouteConfigs: rerouteConfigs,
        );

  @override
  List<PageConfig<Widget>> get pages => [
        homePage,
        addPage,
        viewPage,
        editPage,
      ];

  /// ページ設定。
  final PageConfig<PageModuleWidget<PostModule>> homePage;
  final PageConfig<PageModuleWidget<PostModule>> addPage;
  final PageConfig<PageModuleWidget<PostModule>> editPage;
  final PageConfig<PageModuleWidget<PostModule>> viewPage;

  /// ホームをスライバーレイアウトにする場合True.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// ホームのときのバックボタンを削除するかどうか。
  final bool automaticallyImplyLeadingOnHome;

  /// ユーザーのデータパス。
  final String userPath;

  /// タイトルのキー。
  final String nameKey;

  /// テキストのキー。
  final String textKey;

  /// 作成日のキー。
  final String createdTimeKey;

  /// エディターのタイプ。
  final PostEditingType editingType;

  /// クエリー。
  final ModelQuery? postQuery;

  /// True if editing is allowed.
  final bool enableEdit;
}

class PostModuleHomePage extends PageModuleWidget<PostModule> {
  const PostModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, PostModule module) {
    final now = ref.useNow();
    final user = ref.watchUserDocumentModel(userPath: module.userPath);
    final post =
        ref.watchCollectionModel(module.postQuery?.value ?? module.queryPath);
    final postWithUser = post.mergeUserInformation(
      ref,
      userCollectionPath: module.userPath,
    );
    final controller = ref.useNavigatorController(
      module.viewPage.apply(
        module,
        {"post_id": postWithUser.firstOrNull.get(Const.uid, "")},
      ),
      (route) => postWithUser.isEmpty,
    );

    return UIScaffold(
      waitTransition: true,
      loadingFutures: [
        user.loading,
        post.loading,
      ],
      inlineNavigatorControllerOnWeb: controller,
      appBar: UIAppBar(
        title: Text(module.title ?? "Post".localize()),
        sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
        automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
      ),
      body: UIListBuilder<DynamicMap>(
        source: postWithUser,
        builder: (context, item, index) {
          return [
            ListItem(
              selected: !context.isMobileOrModal &&
                  controller.route?.name.last() == item.get(Const.uid, ""),
              selectedColor: context.theme.textColorOnPrimary,
              selectedTileColor: context.theme.primaryColor.withOpacity(0.8),
              title: Text(item.get(module.nameKey, "")),
              subtitle: Text(
                DateTime.fromMillisecondsSinceEpoch(
                  item.get(module.createdTimeKey, now.millisecondsSinceEpoch),
                ).format("yyyy/MM/dd HH:mm"),
              ),
              onTap: () {
                if (context.isMobile) {
                  context.navigator.pushNamed(
                    module.viewPage.apply(
                      module,
                      {"post_id": item.get(Const.uid, "")},
                    ),
                    arguments: RouteQuery.fullscreen,
                  );
                } else {
                  controller.navigator.pushReplacementNamed(
                    module.viewPage.apply(
                      module,
                      {"post_id": item.get(Const.uid, "")},
                    ),
                  );
                }
              },
            ),
          ];
        },
      ),
      floatingActionButton: module.enableEdit
          ? FloatingActionButton.extended(
              label: Text("Add".localize()),
              icon: const Icon(Icons.add),
              onPressed: () {
                context.navigator.pushNamed(
                  module.addPage.apply(module),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              },
            )
          : null,
    );
  }
}

class PostModuleViewPage extends PageModuleWidget<PostModule> {
  const PostModuleViewPage();

  @override
  Widget build(BuildContext context, WidgetRef ref, PostModule module) {
    final item = ref.watchDocumentModel(
      "${module.queryPath}/${context.get("post_id", "")}",
    );
    final now = ref.useNow();
    final name = item.get(module.nameKey, "");
    final text = item.get(module.textKey, "");
    final createdTime =
        item.get(module.createdTimeKey, now.millisecondsSinceEpoch);

    final editingType = text.isNotEmpty && !text.startsWith(RegExp(r"^(\[|\{)"))
        ? PostEditingType.planeText
        : module.editingType;

    final appBar = UIAppBar(
      title: Text(name),
      actions: [
        if (module.enableEdit)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.rootNavigator.pushNamed(
                module.editPage.apply(
                  module,
                  {"post_id": context.get("post_id", "")},
                ),
                arguments: RouteQuery.fullscreenOrModal,
              );
            },
          ),
      ],
    );

    switch (editingType) {
      case PostEditingType.wysiwyg:
        final controller = ref.cache(
          hookId: "controller",
          () => text.isEmpty
              ? QuillController.basic()
              : QuillController(
                  document: Document.fromJson(jsonDecode(text)),
                  selection: const TextSelection.collapsed(offset: 0),
                ),
          keys: [text],
        );

        return UIScaffold(
          waitTransition: true,
          appBar: appBar,
          body: UIListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              Text(
                DateTime.fromMillisecondsSinceEpoch(createdTime)
                    .format("yyyy/MM/dd HH:mm"),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: context.theme.disabledColor,
                  fontSize: 13,
                ),
              ),
              const Space.height(12),
              QuillEditor(
                scrollController: ScrollController(),
                scrollable: false,
                focusNode: ref.useFocusNode(autoFocus: false),
                autoFocus: false,
                controller: controller,
                placeholder: "Text".localize(),
                readOnly: true,
                expands: false,
                padding: EdgeInsets.zero,
                customStyles: DefaultStyles(
                  placeHolder: DefaultTextBlockStyle(
                    TextStyle(
                      color: context.theme.disabledColor,
                      fontSize: 16,
                    ),
                    const Tuple2(16, 0),
                    const Tuple2(0, 0),
                    null,
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return UIScaffold(
          waitTransition: true,
          appBar: appBar,
          body: UIListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              Text(
                DateTime.fromMillisecondsSinceEpoch(createdTime)
                    .format("yyyy/MM/dd HH:mm"),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: context.theme.disabledColor,
                  fontSize: 13,
                ),
              ),
              const Space.height(12),
              UIMarkdown(
                text,
                fontSize: 16,
                onTapLink: (url) {
                  ref.open(url);
                },
              )
            ],
          ),
        );
    }
  }
}

class PostModuleEditPage extends PageModuleWidget<PostModule> {
  const PostModuleEditPage();

  @override
  Widget build(BuildContext context, WidgetRef ref, PostModule module) {
    final form = ref.useForm("post_id");
    final now = ref.useNow();
    final item = ref.watchDocumentModel("${module.queryPath}/${form.uid}");
    final name = item.get(module.nameKey, "");
    final text = item.get(module.textKey, "");
    final dateTime =
        item.get(module.createdTimeKey, now.millisecondsSinceEpoch);

    final appBar = UIAppBar(
      sliverLayoutWhenModernDesign: false,
      title: Text(
        form.select(
          "Editing %s".localize().format([name]),
          "A new entry".localize(),
        ),
      ),
      actions: [
        if (form.exists)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              UIConfirm.show(
                context,
                title: "Confirmation".localize(),
                text: "You can't undo it after deleting it. May I delete it?"
                    .localize(),
                submitText: "Yes".localize(),
                cancelText: "No".localize(),
                onSubmit: () async {
                  await item.delete().showIndicator(context);
                  context.navigator.pop();
                  context.navigator.pop();
                },
              );
            },
          ),
      ],
    );

    final editingType = text.isNotEmpty && !text.startsWith(RegExp(r"^(\[|\{)"))
        ? PostEditingType.planeText
        : module.editingType;

    final header = [
      FormItemTextField(
        dense: true,
        hintText: "Title".localize(),
        errorText: "No input %s".localize().format(["Title".localize()]),
        subColor: context.theme.disabledColor,
        controller: ref.useTextEditingController(
          hookId: module.nameKey,
          defaultValue: name,
        ),
        onSaved: (value) {
          context[module.nameKey] = value;
        },
      ),
      const Divid(),
      FormItemDateTimeField(
        dense: true,
        hintText: "Post time".localize(),
        errorText: "No input %s".localize().format(["Post time".localize()]),
        controller: ref.useTextEditingController(
          hookId: module.createdTimeKey,
          defaultValue: FormItemDateTimeField.formatDateTime(dateTime),
        ),
        onSaved: (value) {
          context[module.createdTimeKey] =
              value?.millisecondsSinceEpoch ?? now.millisecondsSinceEpoch;
        },
      ),
      const Divid(),
    ];

    switch (editingType) {
      case PostEditingType.wysiwyg:
        final controller = ref.cache(
          hookId: "controller",
          () => text.isEmpty
              ? QuillController.basic()
              : QuillController(
                  document: Document.fromJson(jsonDecode(text)),
                  selection: const TextSelection.collapsed(offset: 0),
                ),
          keys: [text],
        );

        return UIScaffold(
          waitTransition: true,
          appBar: appBar,
          body: FormBuilder(
            key: form.key,
            padding: const EdgeInsets.all(0),
            type: FormBuilderType.listView,
            children: [
              ...header,
              Theme(
                data: context.theme.copyWith(
                  canvasColor: context.theme.scaffoldBackgroundColor,
                ),
                child: QuillToolbar.basic(
                  controller: controller,
                  toolbarIconSize: 24,
                  multiRowsDisplay: false,
                  embedButtons: FlutterQuillEmbeds.buttons(
                    showVideoButton: false,
                    onImagePickCallback: (file) async {
                      if (file.path.isEmpty || !file.existsSync()) {
                        return "";
                      }
                      return await context.model!.uploadMedia(file.path);
                    },
                    onVideoPickCallback: (file) async {
                      if (file.path.isEmpty || !file.existsSync()) {
                        return "";
                      }
                      return await context.model!.uploadMedia(file.path);
                    },
                    filePickImpl: (context) async {
                      final media = await context.platform?.mediaDialog(
                        context,
                        title: "Select %s".localize().format(
                          ["Image".localize()],
                        ),
                      );
                      return media?.path;
                    },
                  ),
                ),
              ),
              Divid(color: context.theme.dividerColor.withOpacity(0.25)),
              SizedBox(
                height: (context.mediaQuery.size.height -
                        context.mediaQuery.viewInsets.bottom -
                        kToolbarHeight -
                        _kQuillToolbarHeight)
                    .limitLow(0),
                child: QuillEditor(
                  scrollController: ScrollController(),
                  scrollable: true,
                  focusNode: ref.useFocusNode(autoFocus: false),
                  autoFocus: false,
                  controller: controller,
                  placeholder: "Text".localize(),
                  readOnly: false,
                  expands: true,
                  padding: const EdgeInsets.all(12),
                  customStyles: DefaultStyles(
                    placeHolder: DefaultTextBlockStyle(
                      TextStyle(
                        color: context.theme.disabledColor,
                        fontSize: 16,
                      ),
                      const Tuple2(16, 0),
                      const Tuple2(0, 0),
                      null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (!form.validate()) {
                return;
              }
              try {
                item[module.nameKey] = context.get(module.nameKey, "");
                item[module.textKey] =
                    jsonEncode(controller.document.toDelta().toJson());
                item[module.createdTimeKey] = context.get(
                  module.createdTimeKey,
                  now.millisecondsSinceEpoch,
                );
                await item.save().showIndicator(context);
                context.navigator.pop();
              } catch (e) {
                UIDialog.show(
                  context,
                  title: "Error".localize(),
                  text: "%s is not completed."
                      .localize()
                      .format(["Editing".localize()]),
                );
              }
            },
            label: Text("Submit".localize()),
            icon: const Icon(Icons.check),
          ),
        );
      default:
        return UIScaffold(
          waitTransition: true,
          appBar: appBar,
          body: FormBuilder(
            key: form.key,
            padding: const EdgeInsets.all(0),
            type: FormBuilderType.listView,
            children: [
              ...header,
              SizedBox(
                height: (context.mediaQuery.size.height -
                        context.mediaQuery.viewInsets.bottom -
                        kToolbarHeight -
                        _kQuillToolbarHeight)
                    .limitLow(0),
                child: FormItemTextField(
                  dense: true,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  hintText: "Text".localize(),
                  subColor: context.theme.disabledColor,
                  controller: ref.useTextEditingController(
                    hookId: module.textKey,
                    defaultValue: text,
                  ),
                  onSaved: (value) {
                    context[module.textKey] = value;
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (!form.validate()) {
                return;
              }
              try {
                item[module.nameKey] = context.get(module.nameKey, "");
                item[module.textKey] = context.get(module.textKey, "");
                item[module.createdTimeKey] = context.get(
                  module.createdTimeKey,
                  now.millisecondsSinceEpoch,
                );
                await item.save().showIndicator(context);
                context.navigator.pop();
              } catch (e) {
                UIDialog.show(
                  context,
                  title: "Error".localize(),
                  text: "%s is not completed."
                      .localize()
                      .format(["Editing".localize()]),
                );
              }
            },
            label: Text("Submit".localize()),
            icon: const Icon(Icons.check),
          ),
        );
    }
  }
}
