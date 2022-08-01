import 'package:masamune_module/masamune_module.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

@immutable
class DetailModule extends PageModule {
  const DetailModule({
    bool enabled = true,
    String? title,
    required String queryPath,
    ModelQuery? query,
    required String routePathPrefix,
    this.commentQueryPath = "comment",
    this.nameKey = Const.name,
    this.textKey = Const.text,
    this.imageKey = Const.image,
    this.iconKey = Const.icon,
    this.timeKey = Const.time,
    this.userKey = Const.user,
    this.tagKey = Const.tag,
    this.likeCountKey = "likeCount",
    this.userPath = Const.user,
    this.enableBookmark = true,
    this.enableComment = true,
    this.enableLike = true,
    this.enableShare = true,
    this.multipleImage = false,
    this.enableFeatureImage = true,
    this.bookmarkPath = "bookmark",
    this.likePath = "like",
    this.automaticallyImplyLeadingOnHome = true,
    this.expandedHeight = 240,
    List<RerouteConfig> rerouteConfigs = const [],
    this.homePage = const PageConfig(
      "/{detail_id}",
      DetailModuleHomePage(),
    ),
    this.imagePage = const PageConfig(
      "/{detail_id}/view",
      DetailModuleImageViewPage(),
    ),
    this.editPage = const PageConfig("/{detail_id}/edit"),
    this.searchPage = const ExternalPageConfig("/search"),
    this.userPage = const ExternalPageConfig("/user/{user_id}"),
    this.appBarActions = const [],
    this.appBarBottomActions = const [
      DetailModuleDateWidget(),
    ],
    this.contents = const [
      DetailModuleNameWidget(),
      DetailModuleTextWidget(),
      DetailModuleTagsWidget(),
      Space.height(16),
      DetailModuleActionWidget(),
    ],
    this.bottom,
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
        searchPage,
        userPage,
        homePage,
        imagePage,
        editPage,
      ];

  // Page settings.
  final PageConfig<PageModuleWidget<DetailModule>> homePage;
  final PageConfig<PageModuleWidget<DetailModule>> imagePage;
  final PageConfig<PageModuleWidget<DetailModule>> editPage;
  final ExternalPageConfig<PageModuleWidget<DetailModule>> searchPage;
  final ExternalPageConfig<PageModuleWidget<DetailModule>> userPage;

  /// Keys.
  final String tagKey;
  final String nameKey;
  final String iconKey;
  final String textKey;
  final String imageKey;
  final String timeKey;
  final String userKey;
  final String likeCountKey;

  /// ホームのときのバックボタンを削除するかどうか。
  final bool automaticallyImplyLeadingOnHome;

  /// ツールバーの高さ
  final double expandedHeight;

  final String userPath;
  final String likePath;
  final String bookmarkPath;
  final String commentQueryPath;

  final bool enableLike;
  final bool enableBookmark;
  final bool enableComment;
  final bool enableShare;
  final bool enableFeatureImage;

  final bool multipleImage;

  // Widget.
  final List<Widget> appBarBottomActions;
  final List<Widget> contents;
  final List<Widget> appBarActions;

  final Widget? bottom;
}

class DetailModuleHomePage extends PageModuleWidget<DetailModule> {
  const DetailModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    // Please describe reference.
    final detailId = context.get("detail_id", "");
    if (detailId.isEmpty) {
      return UIScaffold(
        appBar: AppBar(
          title: Text("No data.".localize()),
        ),
        body: const Empty(),
      );
    }
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    if (detail.isEmpty) {
      return UIScaffold(
        appBar: AppBar(
          title: Text("No data.".localize()),
        ),
        body: const Empty(),
      );
    }
    final name = detail.get(module.nameKey, "");
    final images = module.multipleImage
        ? detail.getAsList(module.imageKey)
        : [
            if (detail.containsKey(module.imageKey))
              detail.get(module.imageKey, "")
          ];
    final focus = ref.useFocusNode(
      "comment",
      context.get("comment", false),
    );
    final comment = ref.watchCollectionModel(
      ModelQuery(
        "${module.queryPath}/$detailId/${module.commentQueryPath}",
        order: ModelQueryOrder.desc,
        orderBy: module.timeKey,
      ).value,
    );
    final commentWithUser = comment.mergeUserInformation(
      ref,
      userCollectionPath: module.userPath,
      userKey: module.userKey,
    );
    final multipleImage = images.length > 1;

    // Please describe the Widget.
    return UIScaffold(
      appBar: module.enableFeatureImage
          ? UIModernDetailAppBar(
              title: Text(name),
              actions: module.appBarActions,
              onTapImage: () {
                context.navigator.pushNamed(
                  module.imagePage.apply(
                    module,
                    {"detail_id": detailId},
                  ),
                );
              },
              designType: DesignType.modern,
              expandedHeight: module.expandedHeight,
              automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
              background: multipleImage
                  ? ColoredBox(
                      color: context.theme.dividerColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Image(
                              image: NetworkOrAsset.image(images.first),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Space.height(1),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                for (int i = 1; i < 4; i++)
                                  if (i < images.length) ...[
                                    Expanded(
                                      child: Image(
                                        image: NetworkOrAsset.image(images[i]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Space.width(1),
                                  ] else ...[
                                    const Expanded(
                                      child: ColoredBox(color: Colors.black),
                                    ),
                                    const Space.width(1),
                                  ]
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : null,
              backgroundImage:
                  images.isNotEmpty ? NetworkOrAsset.image(images.first) : null,
              bottomActions: module.appBarBottomActions,
            )
          : AppBar(
              title: Text(name),
              automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
              actions: module.appBarActions,
            ),
      body: ListBuilder<DynamicMap>(
        padding: const EdgeInsets.all(0),
        source: commentWithUser,
        top: [
          if (!module.enableFeatureImage)
            if (module.appBarBottomActions.isNotEmpty)
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: module.appBarBottomActions,
                  ),
                ),
              ),
          ...module.contents,
          if (module.enableComment) ...[
            const Divid(),
            FormItemCommentField(
              focusNode: focus,
              hintText: "Input %s".localize().format(["Comment".localize()]),
              controller: ref.useTextEditingController("comment"),
              onSubmitted: (value) async {
                if (value.isEmpty) {
                  return;
                }
                final doc = context.model?.createDocument(comment);
                if (doc == null) {
                  return;
                }
                doc[module.userKey] = context.model?.userId;
                doc[module.textKey] = value;
                await context.model?.saveDocument(doc);
              },
            ),
            const Divid(),
          ],
        ],
        builder: (context, item, index) {
          return [
            CommentTile(
              avatar: NetworkOrAsset.image(
                item.get("${module.userKey}${module.iconKey}", ""),
              ),
              name: item.get("${module.userKey}${module.nameKey}", ""),
              text: item.get(module.textKey, ""),
              date: item.getAsDateTime(module.timeKey),
            ),
            const Divid(),
          ];
        },
      ),
      bottomNavigationBar: module.bottom,
    );
  }
}

class DetailModuleDateWidget extends ModuleWidget<DetailModule> {
  const DetailModuleDateWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    final time = detail.getAsDateTime(module.timeKey);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        time.format("yyyy/MM/dd HH:mm"),
        textAlign: TextAlign.right,
        style: TextStyle(
          color: context.theme.textColor.withOpacity(0.5),
        ),
      ),
    );
  }
}

class DetailModuleNameWidget extends ModuleWidget<DetailModule> {
  const DetailModuleNameWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    final name = detail.get(module.nameKey, "");

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Text(name, style: context.theme.textTheme.headline5),
    );
  }
}

class DetailModuleTextWidget extends ModuleWidget<DetailModule> {
  const DetailModuleTextWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    final text = detail.get(module.textKey, "");

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(text),
    );
  }
}

class DetailModuleContentWidget extends ModuleWidget<DetailModule> {
  const DetailModuleContentWidget({
    this.contentLabel,
    this.textKey,
  });
  final String? contentLabel;
  final String? textKey;

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    final text = detail.get(textKey ?? module.textKey, "");

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (contentLabel.isNotEmpty) ...[
            Text(
              contentLabel!.localize(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Space.height(16),
          ],
          Text(text),
        ],
      ),
    );
  }
}

class DetailModuleTagsWidget extends ModuleWidget<DetailModule> {
  const DetailModuleTagsWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    final tags = detail.getAsList(module.tagKey);

    if (tags.isEmpty) {
      return const Empty();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: tags.mapAndRemoveEmpty(
          (e) => TextButton(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              alignment: Alignment.centerLeft,
              primary: context.theme.textColor.withOpacity(0.5),
            ),
            child: Text(
              "#$e",
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {
              context.rootNavigator.pushNamed(
                module.searchPage.apply(module),
                arguments: RouteQuery(
                  transition: PageTransition.fullscreen,
                  parameters: {"query": e},
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DetailModuleActionWidget extends ModuleWidget<DetailModule> {
  const DetailModuleActionWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    final count = detail.get(module.likeCountKey, 0);
    final like = ref
        .watchDocumentModel(
          "${module.userPath}/${context.model?.userId}/${module.likePath}/$detailId",
        )
        .isNotEmpty;
    final bookmark = ref
        .watchDocumentModel(
          "${module.userPath}/${context.model?.userId}/${module.bookmarkPath}/$detailId",
        )
        .isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (module.enableLike)
            TextButton.icon(
              style: TextButton.styleFrom(
                primary:
                    like ? context.theme.primaryColor : context.theme.textColor,
              ),
              icon: const Icon(Icons.thumb_up),
              onPressed: () {
                final counter = context.model?.collectionTransaction(
                  collectionPath:
                      "${module.queryPath}/$detailId/${module.likePath}",
                  linkedCollectionPath:
                      "${module.userPath}/${context.model!.userId}/${module.likePath}",
                );
                if (like) {
                  counter?.delete(context.model!.userId, linkId: detail.uid);
                } else {
                  counter?.save(context.model!.userId, linkId: detail.uid);
                }
              },
              label: Text(
                count.toString(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          if (module.enableShare)
            IconButton(
              color: context.theme.textColor,
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          if (module.enableBookmark)
            IconButton(
              color: bookmark
                  ? context.theme.primaryColor
                  : context.theme.textColor,
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                final counter = context.model?.collectionTransaction(
                  collectionPath:
                      "${module.queryPath}/$detailId/${module.bookmarkPath}",
                  linkedCollectionPath:
                      "${module.userPath}/${context.model!.userId}/${module.bookmarkPath}",
                );
                if (bookmark) {
                  counter?.delete(context.model!.userId, linkId: detail.uid);
                } else {
                  counter?.save(context.model!.userId, linkId: detail.uid);
                }
              },
            )
        ],
      ),
    );
  }
}

class DetailModuleProfileWidget extends ModuleWidget<DetailModule> {
  const DetailModuleProfileWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final user = ref.watchUserDocumentModel();
    final icon = user.get(module.iconKey, "assets/default.png");
    final name = user.get(module.nameKey, "");
    final text = user.get(module.textKey, "");

    return InkWell(
      onTap: () {
        context.rootNavigator.pushNamed(
          module.userPage.apply(module, {"user_id": context.model!.userId}),
          arguments: RouteQuery.fullscreenOrModal,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: context.theme.dividerColor.withOpacity(0.25),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CircleAvatar(
                backgroundImage: NetworkOrAsset.image(icon),
              ),
            ),
            const Space.width(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Space.height(8),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailModuleBookmarkIcon extends ModuleWidget<DetailModule> {
  const DetailModuleBookmarkIcon({
    this.activeIcon = Icons.star,
    this.deactiveIcon = Icons.star_border,
    this.bookmarkPath,
  });

  final IconData activeIcon;
  final IconData deactiveIcon;
  final String? bookmarkPath;

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    if (detail.get(module.userKey, "") == context.model?.userId) {
      return const Empty();
    }
    final bookmark = ref
        .watchDocumentModel(
          "${module.userPath}/${context.model?.userId}/${bookmarkPath ?? module.bookmarkPath}/$detailId",
        )
        .isNotEmpty;

    return IconButton(
      icon: Icon(
        bookmark ? activeIcon : deactiveIcon,
        color: bookmark ? context.theme.primaryColor : context.theme.textColor,
      ),
      onPressed: () {
        final counter = context.model?.collectionTransaction(
          collectionPath:
              "${module.queryPath}/$detailId/${bookmarkPath ?? module.bookmarkPath}",
          linkedCollectionPath:
              "${module.userPath}/${context.model!.userId}/${bookmarkPath ?? module.bookmarkPath}",
        );
        if (bookmark) {
          counter?.delete(context.model!.userId, linkId: detailId);
        } else {
          counter?.save(context.model!.userId, linkId: detailId);
        }
      },
    );
  }
}

class DetailModuleEditIcon extends ModuleWidget<DetailModule> {
  const DetailModuleEditIcon({
    this.icon = Icons.edit,
    this.editPage,
  });

  final IconData icon;
  final PageConfig<PageModuleWidget<DetailModule>>? editPage;

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    if (detail.get(module.userKey, "") != context.model?.userId) {
      return const Empty();
    }

    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        context.rootNavigator.pushNamed(
          editPage?.apply(module, {"detail_id": detailId}) ??
              module.editPage.apply(
                module,
                {"detail_id": detailId},
              ),
          arguments: RouteQuery.fullscreenOrModal,
        );
      },
    );
  }
}

class DetailModuleDeleteIcon extends ModuleWidget<DetailModule> {
  const DetailModuleDeleteIcon({
    this.icon = Icons.delete,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    if (detail.get(module.userKey, "") != context.model?.userId) {
      return const Empty();
    }

    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        final name = detail.get(module.nameKey, "");
        UIConfirm.show(
          context,
          title: "Confirmation".localize(),
          text: "You will delete this %s. Are you sure?".localize().format(
            [name],
          ),
          submitText: "Yes".localize(),
          cancelText: "No".localize(),
          onSubmit: () async {
            await context.model?.deleteDocument(detail).showIndicator(context);
            UIDialog.show(
              context,
              title: "Success".localize(),
              text: "You have deleted this %s.".localize().format([name]),
              submitText: "Close".localize(),
              onSubmit: () {
                context.rootNavigator.pop();
              },
            );
          },
        );
      },
    );
  }
}

class DetailModuleImageViewPage extends PageModuleWidget<DetailModule> {
  const DetailModuleImageViewPage();

  @override
  Widget build(BuildContext context, WidgetRef ref, DetailModule module) {
    final detailId = context.get("detail_id", "");
    final detail = ref.watchDocumentModel("${module.queryPath}/$detailId");
    final name = detail.get(module.nameKey, "");
    final images = module.multipleImage
        ? detail.getAsList(module.imageKey)
        : [
            if (detail.containsKey(module.imageKey))
              detail.get(module.imageKey, "")
          ];
    final controller = ref.usePageController();
    final page = !controller.hasClients ? 0.0 : controller.page ?? 0.0;
    final length = images.length - 1;

    return UIScaffold(
      designType: DesignType.material,
      backgroundColor: Colors.black,
      appBar: UIAppBar(
        title: Text(name),
      ),
      body: images.length >= 2
          ? Stack(
              fit: StackFit.expand,
              children: [
                PhotoViewGallery.builder(
                  itemCount: images.length,
                  gaplessPlayback: true,
                  pageController: controller,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkOrAsset.image(images[index]),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 0, 16, 24),
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Slider(
                            divisions: length,
                            value: page / length,
                            onChanged: (value) {
                              if (!controller.hasClients) {
                                return;
                              }
                              final page = (value * length).round();
                              if (page == controller.page) {
                                return;
                              }
                              controller.animateToPage(
                                page,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOutQuart,
                              );
                            },
                          ),
                        ),
                        Text(
                          "${(page + 1).round()}/${images.length}",
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : PhotoView(
              imageProvider: NetworkOrAsset.image(images.firstOrNull),
            ),
    );
  }
}
