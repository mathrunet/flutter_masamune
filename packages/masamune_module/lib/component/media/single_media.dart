import 'package:masamune_module/masamune_module.dart';
import 'package:photo_view/photo_view.dart';

@immutable
class SingleMediaModule extends PageModule {
  const SingleMediaModule({
    bool enabled = true,
    String? title,
    String queryPath = "media",
    ModelQuery? query,
    String routePathPrefix = "media",
    this.mediaKey = Const.media,
    this.nameKey = Const.name,
    this.textKey = Const.text,
    this.createdTimeKey = Const.createdTime,
    this.mediaType = PlatformMediaType.all,
    this.enableEdit = true,
    this.automaticallyImplyLeadingOnHome = true,
    this.sliverLayoutWhenModernDesignOnHome = true,
    List<RerouteConfig> rerouteConfigs = const [],
    this.homePage = const PageConfig(
      "/",
      SingleMediaModuleHomePage(),
    ),
    this.editPage = const PageConfig(
      "/edit",
      SingleMediaModuleEditPage(),
    ),
  }) : super(
          enabled: enabled,
          title: title,
          query: query,
          routePathPrefix: routePathPrefix,
          queryPath: queryPath,
          rerouteConfigs: rerouteConfigs,
        );

  @override
  List<PageConfig<Widget>> get pages => [
        homePage,
        editPage,
      ];

  // Widget.
  final PageConfig<PageModuleWidget<SingleMediaModule>> homePage;
  final PageConfig<PageModuleWidget<SingleMediaModule>> editPage;

  /// 画像・映像のキー。
  final String mediaKey;

  /// タイトルのキー。
  final String nameKey;

  /// テキストのキー。
  final String textKey;

  /// 編集を可能にする場合true.
  final bool enableEdit;

  /// 作成日のキー。
  final String createdTimeKey;

  /// True if Home is a sliver layout.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// True if you want to automatically display the back button when you are at home.
  final bool automaticallyImplyLeadingOnHome;

  /// 対応するメディアタイプ。
  final PlatformMediaType mediaType;
}

class SingleMediaModuleHomePage extends PageModuleWidget<SingleMediaModule> {
  const SingleMediaModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, SingleMediaModule module) {
    // Please describe reference.
    final item =
        ref.watchDocumentModel(module.query?.value ?? module.queryPath);
    final name = item.get(module.nameKey, "");
    final media = item.get(module.mediaKey, "");
    final type = getPlatformMediaType(media);

    // Please describe the Widget.
    return UIScaffold(
      waitTransition: true,
      appBar: UIAppBar(
        title: Text(
          name.isNotEmpty ? name : module.title ?? "Media".localize(),
        ),
        actions: [
          if (module.enableEdit && media.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.navigator.pushNamed(
                  module.editPage.apply(module),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              },
            ),
        ],
        sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
        automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
      ),
      backgroundColor: Colors.black,
      body: media.isEmpty
          ? module.enableEdit
              ? Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: context.theme.textColorOnPrimary,
                      backgroundColor: context.theme.primaryColor,
                    ),
                    label: Text("Add".localize()),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      context.navigator.pushNamed(
                        module.editPage.apply(module),
                        arguments: RouteQuery.fullscreenOrModal,
                      );
                    },
                  ),
                )
              : const Empty()
          : () {
              switch (type) {
                case PlatformMediaType.video:
                  return Center(
                    child: Video(
                      Asset.video(media),
                      fit: BoxFit.contain,
                      controllable: true,
                      mixWithOthers: true,
                    ),
                  );
                default:
                  return PhotoView(imageProvider: Asset.image(media));
              }
            }(),
    );
  }
}

class SingleMediaModuleEditPage extends PageModuleWidget<SingleMediaModule> {
  const SingleMediaModuleEditPage();

  @override
  Widget build(BuildContext context, WidgetRef ref, SingleMediaModule module) {
    final form = ref.useForm();
    final item = ref.watchDocumentModel(
      module.query?.value.trimQuery() ?? module.queryPath,
    );
    final name = item.get(module.nameKey, "");
    final media = item.get(module.mediaKey, "");

    return UIScaffold(
      waitTransition: true,
      appBar: UIAppBar(
        sliverLayoutWhenModernDesign: false,
        title: Text(
          "Editing %s".localize().format([
            if (name.isEmpty) "Media".localize() else name,
          ]),
        ),
      ),
      body: FormBuilder(
        padding: const EdgeInsets.all(0),
        key: form.key,
        children: [
          FormItemMedia(
            height: 200,
            dense: true,
            controller: ref.useTextEditingController(
              module.mediaKey,
              media,
            ),
            errorText: "No input %s".localize().format(["Image".localize()]),
            onTap: (onUpdate) async {
              final media = await context.platform?.mediaDialog(
                context,
                title: "Please select your %s"
                    .localize()
                    .format(["Media".localize().toLowerCase()]),
                type: module.mediaType,
              );
              onUpdate(media?.path);
            },
            onSaved: (value) {
              context[module.mediaKey] = value;
            },
          ),
          const Space.height(12),
          DividHeadline("Title".localize()),
          FormItemTextField(
            dense: true,
            hintText: "Input %s".localize().format(["Title".localize()]),
            errorText: "No input %s".localize().format(["Title".localize()]),
            controller: ref.useTextEditingController(
              module.nameKey,
              name,
            ),
            onSaved: (value) {
              context[module.nameKey] = value;
            },
          ),
          const Divid(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!form.validate()) {
            return;
          }

          item[module.nameKey] = context.get(module.nameKey, "");
          item[module.mediaKey] = await context.model
              ?.uploadMedia(context.get(module.mediaKey, ""))
              .showIndicator(context);
          await context.model?.saveDocument(item).showIndicator(context);
          context.navigator.pop();
        },
        label: Text("Submit".localize()),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
