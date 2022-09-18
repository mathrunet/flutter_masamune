import 'package:masamune_module/masamune_module.dart';
import 'package:photo_view/photo_view.dart' as photo_view;

@immutable
class TileGalleryMediaModule extends PageModule {
  const TileGalleryMediaModule({
    bool enabled = true,
    String? title,
    String queryPath = "gallery",
    ModelQuery? query,
    String routePathPrefix = "gallery",
    this.mediaKey = Const.media,
    this.nameKey = Const.name,
    this.textKey = Const.text,
    this.createdTimeKey = Const.createdTime,
    this.maxCrossAxisExtentForMobile = 200,
    this.maxCrossAxisExtentForDesktop = 200,
    this.childAspectRatioForMobile = 0.5625,
    this.childAspectRatioForDesktop = 1,
    this.heightOnDetailView = 200,
    this.backgroundColor,
    this.tileSpacing = 1,
    this.automaticallyImplyLeadingOnHome = true,
    this.sliverLayoutWhenModernDesignOnHome = true,
    this.enableEdit = true,
    this.enableDetail = true,
    this.mediaType = AdapterMediaType.all,
    List<RerouteConfig> rerouteConfigs = const [],
    this.homePage = const PageConfig(
      "/",
      TileGalleryMediaModuleHomePage(),
    ),
    this.addPage = const PageConfig(
      "/edit",
      TileGalleryMediaModuleEditPage(),
    ),
    this.mediaDetailPage = const PageConfig(
      "/media/{media_id}",
      TileGalleryMediaModuleMediaDetailPage(),
    ),
    this.mediaViewPage = const PageConfig(
      "/media/{media_id}/view",
      TileGalleryMediaModuleMediaViewPage(),
    ),
    this.editPage = const PageConfig(
      "/media/{media_id}/edit",
      TileGalleryMediaModuleEditPage(),
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
        mediaDetailPage,
        mediaViewPage,
        editPage,
      ];

  // Widget.
  final PageConfig<PageModuleWidget<TileGalleryMediaModule>> homePage;
  final PageConfig<PageModuleWidget<TileGalleryMediaModule>> addPage;
  final PageConfig<PageModuleWidget<TileGalleryMediaModule>> editPage;
  final PageConfig<PageModuleWidget<TileGalleryMediaModule>> mediaDetailPage;
  final PageConfig<PageModuleWidget<TileGalleryMediaModule>> mediaViewPage;

  /// 画像・映像のキー。
  final String mediaKey;

  /// タイトルのキー。
  final String nameKey;

  /// テキストのキー。
  final String textKey;

  /// 作成日のキー。
  final String createdTimeKey;

  /// リスト画面の背景色。
  final Color? backgroundColor;

  /// 編集を可能にする場合true.
  final bool enableEdit;

  /// 詳細ページを表示する場合true.
  final bool enableDetail;

  /// 詳細画面の画像の高さ。
  final double heightOnDetailView;

  /// 対応するメディアタイプ。
  final AdapterMediaType mediaType;

  /// タイルの横方向のサイズ。
  final double maxCrossAxisExtentForMobile;
  final double maxCrossAxisExtentForDesktop;

  /// タイルのアスペクト比。
  final double childAspectRatioForMobile;
  final double childAspectRatioForDesktop;

  /// タイルのスペース。
  final double tileSpacing;

  /// True if Home is a sliver layout.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// True if you want to automatically display the back button when you are at home.
  final bool automaticallyImplyLeadingOnHome;
}

class TileGalleryMediaModuleHomePage
    extends PageModuleWidget<TileGalleryMediaModule> {
  const TileGalleryMediaModuleHomePage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    TileGalleryMediaModule module,
  ) {
    final gallery = ref.watchCollectionModel(
      module.query?.value ?? module.queryPath,
    );

    return UIScaffold(
      backgroundColor: module.backgroundColor,
      appBar: UIAppBar(
        title: Text(module.title ?? "Gallery".localize()),
        automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
        sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
      ),
      body: LoadingBuilder(
        futures: [
          gallery.loading,
        ],
        builder: (context) {
          return UIGridBuilder<DynamicDocumentModel>.extent(
            maxCrossAxisExtent: context.isMobile
                ? module.maxCrossAxisExtentForMobile
                : module.maxCrossAxisExtentForDesktop,
            childAspectRatio: context.isMobile
                ? module.childAspectRatioForMobile
                : module.childAspectRatioForDesktop,
            mainAxisSpacing: module.tileSpacing,
            crossAxisSpacing: module.tileSpacing,
            source: gallery,
            builder: (context, item) {
              final path = item.get(module.mediaKey, "");
              final type = getAdapterMediaType(path);
              switch (type) {
                case AdapterMediaType.video:
                  return Container(
                    color: context.theme.dividerColor,
                    child: ClipRRect(
                      child: ClickableBox.video(
                        video: Asset.video(path),
                        fit: BoxFit.cover,
                        onTap: () {
                          context.rootNavigator.pushNamed(
                            !module.enableDetail
                                ? module.mediaViewPage.apply(
                                    module,
                                    {"media_id": item.get(Const.uid, "")},
                                  )
                                : module.mediaDetailPage.apply(
                                    module,
                                    {"media_id": item.get(Const.uid, "")},
                                  ),
                            arguments: RouteQuery.fullscreenOrModal,
                          );
                        },
                      ),
                    ),
                  );
                default:
                  return ClickableBox.image(
                    image: Asset.image(path),
                    fit: BoxFit.cover,
                    onTap: () {
                      context.rootNavigator.pushNamed(
                        !module.enableDetail
                            ? module.mediaViewPage.apply(
                                module,
                                {"media_id": item.get(Const.uid, "")},
                              )
                            : module.mediaDetailPage.apply(
                                module,
                                {"media_id": item.get(Const.uid, "")},
                              ),
                        arguments: RouteQuery.fullscreenOrModal,
                      );
                    },
                  );
              }
            },
          );
        },
      ),
      floatingActionButton: module.enableEdit
          ? FloatingActionButton.extended(
              onPressed: () {
                context.navigator.pushNamed(
                  module.addPage.apply(module),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              },
              label: Text("Add".localize()),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class TileGalleryMediaModuleMediaDetailPage
    extends PageModuleWidget<TileGalleryMediaModule> {
  const TileGalleryMediaModuleMediaDetailPage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    TileGalleryMediaModule module,
  ) {
    final item = ref.watchDocumentModel(
      "${module.query?.value.trimQuery() ?? module.queryPath}/${context.get("media_id", "")}",
    );

    final now = ref.useNow();
    final name = item.get(module.nameKey, "");
    final text = item.get(module.textKey, "");
    final media = item.get(module.mediaKey, "");
    final createdTime =
        item.get(module.createdTimeKey, now.millisecondsSinceEpoch);
    final type = getAdapterMediaType(media);

    return UIScaffold(
      waitTransition: true,
      appBar: UIAppBar(
        title: Text(name),
        actions: [
          if (module.enableEdit)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.navigator.pushNamed(
                  module.editPage.apply(
                    module,
                    {"media_id": context.get("media_id", "")},
                  ),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              },
            ),
        ],
      ),
      body: UIListView(
        children: [
          InkWell(
            onTap: () {
              context.navigator.pushNamed(
                module.mediaViewPage.apply(
                  module,
                  {"media_id": context.get("media_id", "")},
                ),
                arguments: RouteQuery.fullscreenOrModal,
              );
            },
            child: () {
              switch (type) {
                case AdapterMediaType.video:
                  return Container(
                    color: context.theme.dividerColor,
                    height: module.heightOnDetailView,
                    child: ClipRRect(
                      child: Video(
                        Asset.video(media),
                        fit: BoxFit.cover,
                        autoplay: true,
                        mute: true,
                        mixWithOthers: true,
                      ),
                    ),
                  );
                default:
                  return Container(
                    height: module.heightOnDetailView,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Asset.image(media),
                        fit: BoxFit.cover,
                      ),
                      color: context.theme.disabledColor,
                    ),
                  );
              }
            }(),
          ),
          Indent(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Space.height(12),
              if (text.isNotEmpty) ...[
                Text(text),
                const Space.height(12),
              ],
              Text(
                DateTime.fromMillisecondsSinceEpoch(createdTime)
                    .format("yyyy/MM/dd HH:mm"),
                style: TextStyle(
                  color: context.theme.disabledColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Divid(),
        ],
      ),
    );
  }
}

class TileGalleryMediaModuleMediaViewPage
    extends PageModuleWidget<TileGalleryMediaModule> {
  const TileGalleryMediaModuleMediaViewPage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    TileGalleryMediaModule module,
  ) {
    final item = ref.watchDocumentModel(
      "${module.query?.value.trimQuery() ?? module.queryPath}/${context.get("media_id", "")}",
    );
    final name = item.get(module.nameKey, "");
    final media = item.get(module.mediaKey, "");
    final type = getAdapterMediaType(media);

    return UIScaffold(
      waitTransition: true,
      appBar: UIAppBar(
        title: Text(name),
        actions: [
          if (module.enableEdit && !module.enableDetail)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.navigator.pushNamed(
                  module.editPage.apply(
                    module,
                    {"media_id": context.get("media_id", "")},
                  ),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              },
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: media.isEmpty
          ? Center(
              child: Text(
                "No data.".localize(),
                style: const TextStyle(color: Colors.white),
              ),
            )
          : () {
              switch (type) {
                case AdapterMediaType.video:
                  return Center(
                    child: Video(
                      Asset.video(media),
                      fit: BoxFit.contain,
                      controllable: true,
                      mixWithOthers: true,
                    ),
                  );
                default:
                  return photo_view.PhotoView(
                    imageProvider: Asset.image(media),
                  );
              }
            }(),
    );
  }
}

class TileGalleryMediaModuleEditPage
    extends PageModuleWidget<TileGalleryMediaModule> {
  const TileGalleryMediaModuleEditPage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    TileGalleryMediaModule module,
  ) {
    final form = ref.useForm("media_id");
    final item = ref.watchDocumentModel(
      "${module.query?.value.trimQuery() ?? module.queryPath}/${form.uid}",
    );
    final name = item.get(module.nameKey, "");
    final text = item.get(module.textKey, "");
    final media = item.get(module.mediaKey, "");

    return UIScaffold(
      waitTransition: true,
      appBar: UIAppBar(
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
                    if (module.enableDetail) {
                      context.navigator.pop();
                      context.navigator.pop();
                      context.navigator.pop();
                    } else {
                      context.navigator.pop();
                      context.navigator.pop();
                    }
                  },
                );
              },
            ),
        ],
      ),
      body: FormBuilder(
        padding: const EdgeInsets.all(0),
        key: form.key,
        children: [
          FormItemMedia(
            height: 200,
            dense: true,
            controller: ref.useTextEditingController(
              hookId: module.mediaKey,
              defaultValue: form.select(media, ""),
            ),
            errorText: "No input %s".localize().format(["Image".localize()]),
            onTap: (onUpdate) async {
              final media = await context.plugin?.media?.mediaDialog(
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
              hookId: module.nameKey,
              defaultValue: form.select(name, ""),
            ),
            onSaved: (value) {
              context[module.nameKey] = value;
            },
          ),
          DividHeadline("Description".localize()),
          FormItemTextField(
            dense: true,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 5,
            hintText: "Input %s".localize().format(["Description".localize()]),
            allowEmpty: true,
            controller: ref.useTextEditingController(
              hookId: module.textKey,
              defaultValue: form.select(text, ""),
            ),
            onSaved: (value) {
              context[module.textKey] = value;
            },
          ),
          const Divid(),
          const Space.height(100),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!form.validate()) {
            return;
          }

          item[module.nameKey] = context.get(module.nameKey, "");
          item[module.textKey] = context.get(module.textKey, "");
          item[module.mediaKey] = await context.model
              ?.uploadMedia(context.get(module.mediaKey, ""))
              .showIndicator(context);
          await item.save().showIndicator(context);
          context.navigator.pop();
        },
        label: Text("Submit".localize()),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
