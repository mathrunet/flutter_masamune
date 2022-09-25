import 'package:masamune_module/masamune_module.dart';

@immutable
class TileMenuHomeModule extends PageModule
    with VerifyAppReroutePageModuleMixin {
  const TileMenuHomeModule({
    bool enabled = true,
    String? title = "",
    this.color,
    this.textColor,
    this.featureIcon,
    this.featureImage,
    this.featureImageFit = BoxFit.cover,
    this.featureImageAlignment = Alignment.center,
    this.titleTextStyle,
    String routePathPrefix = "",
    this.titleAlignment = Alignment.center,
    this.titlePadding = const EdgeInsets.all(12),
    this.contentPadding = const EdgeInsets.all(8),
    this.headerHeight = 90,
    this.userPath = "user",
    this.nameKey = Const.name,
    this.menu = const [],
    this.subMenu = const [],
    this.menuIconSize,
    this.menuMaxCrossAxisExtent = 200,
    this.submenuMaxCrossAxisExtent = 400,
    this.menuChildAspectRatio = 1.0,
    this.submenuChildAspectRatio = 3.0,
    this.menuContentPadding = const EdgeInsets.all(8),
    this.submenuContentPadding = const EdgeInsets.all(8),
    List<RerouteConfig> rerouteConfigs = const [],
    this.header,
    this.footer,
    this.homePage = const PageConfig(
      "/",
      TileMenuHomeModuleHomePage(),
    ),
    this.profilePage = const ExternalPageConfig("/user/{user_id}"),
    this.profile = const TileMenuHomeModuleProfileWidget(),
    this.tileMenuHomeInformationWidget =
        const TileMenuHomeModuleInformationWidget(),
    this.tileMenuHomeCalendarWidget = const TileMenuHomeModuleCalendarWidget(),
  }) : super(
          enabled: enabled,
          title: title,
          routePathPrefix: routePathPrefix,
          rerouteConfigs: rerouteConfigs,
        );

  @override
  List<PageConfig<Widget>> get pages => [
        homePage,
        profilePage,
      ];

  // ページの設定。
  final PageConfig<PageModuleWidget<TileMenuHomeModule>> homePage;
  final ExternalPageConfig<PageModuleWidget<TileMenuHomeModule>> profilePage;
  final ModuleWidget<TileMenuHomeModule>? tileMenuHomeInformationWidget;
  final ModuleWidget<TileMenuHomeModule>? tileMenuHomeCalendarWidget;

  // ホームのパーツ。
  final ModuleWidget<TileMenuHomeModule>? header;
  final ModuleWidget<TileMenuHomeModule>? footer;
  final ModuleWidget<TileMenuHomeModule>? profile;

  /// デフォルトのメニュー。
  final List<MenuConfig> menu;

  /// サブメニュー。
  final List<MenuConfig> subMenu;

  /// テキストカラー。
  final Color? textColor;

  /// メインカラー。
  final Color? color;

  /// フィーチャーアイコン。
  final String? featureIcon;

  /// フィーチャー画像。
  final String? featureImage;

  /// フィーチャー画像のサイズ。
  final BoxFit featureImageFit;

  /// フィーチャー画像の配置。
  final Alignment featureImageAlignment;

  /// タイトルのテキストスタイル。
  final TextStyle? titleTextStyle;

  /// タイトルの位置。
  final Alignment titleAlignment;

  /// タイトルのパディング。
  final EdgeInsetsGeometry titlePadding;

  /// コンテンツのパディング。
  final EdgeInsetsGeometry contentPadding;

  /// ヘッダーの高さ。
  final double headerHeight;

  /// ユーザーのデータパス。
  final String userPath;

  /// 名前のキー。
  final String nameKey;

  /// メニューアイコンサイズ。
  final double? menuIconSize;

  /// メニューの横幅。
  final double menuMaxCrossAxisExtent;
  final double submenuMaxCrossAxisExtent;

  /// メニューの比率。
  final double menuChildAspectRatio;
  final double submenuChildAspectRatio;

  /// メニューのパディング。
  final EdgeInsetsGeometry menuContentPadding;
  final EdgeInsetsGeometry submenuContentPadding;
}

class TileMenuHomeModuleHomePage extends PageModuleWidget<TileMenuHomeModule> {
  const TileMenuHomeModuleHomePage();
  @override
  Widget build(BuildContext context, WidgetRef ref, TileMenuHomeModule module) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: module.headerHeight,
                  width: context.isMobileOrSmallWidth
                      ? null
                      : () {
                          return context.mediaQuery.size.width / 2;
                        }(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: module.textColor ??
                                context.theme.textColorOnPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Container(
                            alignment: module.titleAlignment,
                            padding: module.titlePadding,
                            decoration: BoxDecoration(
                              image: module.featureImage.isNotEmpty
                                  ? DecorationImage(
                                      image: Asset.image(
                                        module.featureImage!,
                                      ),
                                      fit: module.featureImageFit,
                                      alignment: module.featureImageAlignment,
                                    )
                                  : null,
                              color: module.color ?? context.theme.primaryColor,
                            ),
                            child: Row(
                              children: [
                                if (module.featureIcon.isNotEmpty) ...[
                                  Image(
                                    image: Asset.image(
                                      module.featureIcon!,
                                    ),
                                  ),
                                  const Space.width(8),
                                ],
                                Expanded(
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    child: Text(
                                      module.title ?? "",
                                      textAlign: TextAlign.center,
                                      style: module.titleTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Space.width(4),
                      Expanded(
                        flex: 1,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: module.textColor ??
                                context.theme.textColorOnPrimary,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 0,
                                  ),
                                  color: module.color ??
                                      context.theme.primaryColor,
                                  child: module.profile,
                                ),
                              ),
                              const Space.height(4),
                              ClickableBox(
                                color:
                                    module.color ?? context.theme.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "MyPage".localize(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  context.navigator.pushNamed(
                                    module.profilePage.apply(
                                      module,
                                      {"user_id": context.model!.userId},
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (module.header != null) ...[
                const Space.height(8),
                module.header!,
              ],
              const Space.height(8),
              if (module.tileMenuHomeInformationWidget != null) ...[
                module.tileMenuHomeInformationWidget!,
                const Space.height(8),
              ],
              if (module.tileMenuHomeCalendarWidget != null) ...[
                module.tileMenuHomeCalendarWidget!,
                const Space.height(8),
              ],
              TileMenuHomeModuleHeadline(
                "Menu".localize(),
                icon: Icons.menu,
                color: module.textColor ?? context.theme.textColorOnPrimary,
                backgroundColor:
                    module.color ?? context.theme.primaryColor.lighten(0.15),
              ),
              const Space.height(4),
              Grid.extent(
                padding: const EdgeInsets.all(0),
                maxCrossAxisExtent: module.menuMaxCrossAxisExtent,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: module.menuChildAspectRatio,
                children: [
                  ...module.menu.mapAndRemoveEmpty(
                    (item) {
                      return ClickableBox(
                        color: module.color ?? context.theme.primaryColor,
                        onTap: item.path.isEmpty
                            ? null
                            : () {
                                ref.open(item.path!);
                              },
                        child: Padding(
                          padding: module.menuContentPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon ?? Icons.info,
                                size: module.menuIconSize ??
                                    (context.isMobileOrSmallWidth ? 64 : 78),
                                color: module.textColor ??
                                    context.theme.textColorOnPrimary,
                              ),
                              const Space.height(8),
                              Text(
                                item.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: module.textColor ??
                                      context.theme.textColorOnPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      context.isMobileOrSmallWidth ? null : 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Space.height(8),
              Grid.extent(
                padding: const EdgeInsets.all(0),
                maxCrossAxisExtent: module.submenuMaxCrossAxisExtent,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: module.submenuChildAspectRatio,
                children: [
                  ...module.subMenu.mapAndRemoveEmpty((item) {
                    return ClickableBox(
                      color: module.color ?? context.theme.primaryColor,
                      onTap: item.path.isEmpty
                          ? null
                          : () {
                              ref.open(item.path!);
                            },
                      child: Container(
                        alignment: Alignment.center,
                        padding: module.submenuContentPadding,
                        child: Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: module.textColor ??
                                context.theme.textColorOnPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              if (module.footer != null) ...[
                const Space.height(8),
                module.footer!,
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _banner(context),
    );
  }

  Widget? _banner(BuildContext context) {
    if (context.plugin?.ads == null || !context.plugin!.ads!.enabled) {
      return null;
    }
    return context.plugin!.ads!.banner(context);
  }
}

class TileMenuHomeModuleProfileWidget extends ModuleWidget<TileMenuHomeModule> {
  const TileMenuHomeModuleProfileWidget({
    this.roleName,
    this.roleIcon,
  });

  final IconData? roleIcon;
  final String? roleName;

  @override
  Widget build(BuildContext context, WidgetRef ref, TileMenuHomeModule module) {
    final user = ref.watchUserDocumentModel(userPath: module.userPath);
    final name = user.get(module.nameKey, "Unknown".localize());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (roleName.isNotEmpty) ...[
              if (roleIcon != null) ...[
                Icon(
                  roleIcon,
                  color:
                      module.textColor ?? context.theme.colorScheme.onPrimary,
                  size: 15,
                ),
                const Space.width(4),
              ],
              Text(
                roleName ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ]
          ],
        ),
        const Space.height(4),
        Text(
          "%s san".localize().format([name]),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class TileMenuHomeModuleInformationWidget
    extends ModuleWidget<TileMenuHomeModule> {
  const TileMenuHomeModuleInformationWidget({
    this.title,
    this.queryPath = "info",
    this.icon = Icons.info_rounded,
    this.nameKey = Const.name,
    this.dataLabel,
    this.infoPage = const ExternalPageConfig("/info/{info_id}"),
    this.createdTimeKey = Const.createdTime,
    this.limit = 10,
    this.enableNewIcon = true,
  });

  final String? title;
  final String queryPath;
  final String? dataLabel;
  final IconData icon;
  final String nameKey;
  final String createdTimeKey;
  final int limit;
  final bool enableNewIcon;

  final ExternalPageConfig<PageModuleWidget<TileMenuHomeModule>> infoPage;

  @override
  Widget build(BuildContext context, WidgetRef ref, TileMenuHomeModule module) {
    final now = ref.useNow();
    final info = ref.watchCollectionModel(queryPath);
    info.sort((a, b) {
      return b.get(createdTimeKey, now.millisecondsSinceEpoch) -
          a.get(createdTimeKey, now.millisecondsSinceEpoch);
    });

    return LoadingBuilder(
      futures: [
        info.loading,
      ],
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TileMenuHomeModuleHeadline(
              title ?? "Information".localize(),
              icon: icon,
              color: module.textColor ?? context.theme.textColorOnPrimary,
              backgroundColor:
                  module.color ?? context.theme.primaryColor.lighten(0.15),
            ),
            const Space.height(4),
            if (info.isEmpty)
              Container(
                alignment: Alignment.center,
                height: 60,
                child: Text(
                  dataLabel.isEmpty
                      ? "No data.".localize()
                      : "No %s.".localize().format([dataLabel!.localize()]),
                ),
              )
            else
              Grid.extent(
                padding: const EdgeInsets.all(0),
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 2,
                children: [
                  ...info.limitEnd(limit).mapListenable((item) {
                    final dateTime = DateTime.fromMillisecondsSinceEpoch(
                      item.get(createdTimeKey, now.millisecondsSinceEpoch),
                    );
                    return DefaultTextStyle(
                      style: TextStyle(
                        color: module.textColor ??
                            context.theme.textColorOnPrimary,
                      ),
                      child: ClickableBox(
                        color: module.color ?? context.theme.primaryColor,
                        onTap: () {
                          context.navigator.pushNamed(
                            infoPage.apply(
                              module,
                              {"info_id": item.get(Const.uid, "")},
                            ),
                            arguments: RouteQuery.fullscreenOrModal,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(dateTime.format("yyyy/MM/dd HH:mm")),
                                  if (enableNewIcon && dateTime.isToday()) ...[
                                    const Space.width(4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      color: context.theme.colorScheme.error,
                                      child: Text(
                                        "NEW".localize(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              context.theme.colorScheme.onError,
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              const Space.height(8),
                              Text(item.get(nameKey, "--")),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
          ],
        );
      },
    );
  }
}

class TileMenuHomeModuleCalendarWidget
    extends ModuleWidget<TileMenuHomeModule> {
  const TileMenuHomeModuleCalendarWidget({
    this.title,
    this.queryPath = "event",
    this.startTimeKey = Const.startTime,
    this.endTimeKey = Const.endTime,
    this.allDayKey = "allDay",
    this.icon = Icons.calendar_today,
    this.alwaysShown = false,
    this.detailPage = const ExternalPageConfig("/calendar/{event_id}/detail"),
  });

  final String? title;
  final String queryPath;
  final String startTimeKey;
  final String endTimeKey;
  final String allDayKey;
  final IconData icon;
  final bool alwaysShown;
  final ExternalPageConfig<PageModuleWidget<TileMenuHomeModule>> detailPage;

  @override
  Widget build(BuildContext context, WidgetRef ref, TileMenuHomeModule module) {
    final now = ref.useNow();
    final start = now.toDate();
    final event = ref.watchCollectionModel(queryPath).where((element) {
      final time = element.getAsDateTime(startTimeKey);
      return time.millisecondsSinceEpoch >= start.millisecondsSinceEpoch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TileMenuHomeModuleHeadline(
          title ?? "Calendar".localize(),
          icon: icon,
          color: module.textColor ?? context.theme.textColorOnPrimary,
          backgroundColor:
              module.color ?? context.theme.primaryColor.lighten(0.15),
        ),
        const Space.height(4),
        ColoredBox(
          color: context.theme.primaryColor,
          child: event.isEmpty && !alwaysShown
              ? Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Text(
                    "No data.".localize(),
                    style: TextStyle(
                      color: context.theme.scaffoldBackgroundColor,
                    ),
                  ),
                )
              : UIScheduleCalendar(
                  source: event,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  alwaysShown: alwaysShown,
                  startDate: now.toDate(),
                  endDate: now.toDate().add(const Duration(days: 7)),
                  physics: const NeverScrollableScrollPhysics(),
                  dayTextStyle:
                      TextStyle(color: context.theme.textColorOnPrimary),
                  emptyWidget: Container(
                    color: context.theme.scaffoldBackgroundColor,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 4),
                    alignment: Alignment.center,
                    child: Text(
                      "No data.".localize(),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                  builder: (context, item) {
                    final endTimeValue = item.get<int?>(endTimeKey, null);
                    final endTime = endTimeValue != null
                        ? DateTime.fromMillisecondsSinceEpoch(endTimeValue)
                        : null;

                    return InkWell(
                      onTap: () {
                        context.navigator.pushNamed(
                          detailPage.apply(
                            module,
                            {"event_id": item.uid},
                          ),
                          arguments: RouteQuery.fullscreenOrModal,
                        );
                      },
                      child: Container(
                        color: context.theme.scaffoldBackgroundColor,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.get(module.nameKey, ""),
                              style: TextStyle(
                                color: context.theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _timeString(
                                startTime: item.getAsDateTime(startTimeKey),
                                endTime: endTime,
                                allDay: item.get(allDayKey, false),
                              ),
                              style: TextStyle(
                                color: context.theme.primaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

String _timeString({
  required DateTime startTime,
  DateTime? endTime,
  bool allDay = false,
}) {
  if (endTime == null) {
    allDay = true;
  }
  if (allDay) {
    return "${startTime.format("yyyy/MM/dd")} ${"All day".localize()}";
  } else {
    return "${startTime.format("yyyy/MM/dd HH:mm")} - ${endTime?.format("yyyy/MM/dd HH:mm")}";
  }
}

class TileMenuHomeModuleHeadline extends ModuleWidget<TileMenuHomeModule> {
  const TileMenuHomeModuleHeadline(
    this.label, {
    this.icon,
    this.color,
    this.backgroundColor,
  });
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref, TileMenuHomeModule module) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: DefaultBoxDecoration(
        radius: 0,
        backgroundColor: backgroundColor ?? context.theme.primaryColor,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: color ?? context.theme.textColorOnPrimary,
            ),
            const Space.width(12),
          ],
          Text(
            label,
            style: TextStyle(
              color: color ?? context.theme.textColorOnPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class TileMenuHomeModuleChangeAffiliationWidget
    extends ModuleWidget<TileMenuHomeModule> {
  const TileMenuHomeModuleChangeAffiliationWidget({
    required this.title,
    this.affiliationKey = "affiliation",
    this.targetPath = "user",
    this.namekey = Const.name,
    this.imageKey = Const.icon,
    this.affiliationListKey = "affiliations",
  });
  final String title;
  final String namekey;
  final String imageKey;
  final String affiliationKey;
  final String affiliationListKey;
  final String targetPath;

  @override
  Widget build(BuildContext context, WidgetRef ref, TileMenuHomeModule module) {
    final user = ref.watchUserDocumentModel();
    final affiliationId = user.get(affiliationKey, "");
    final affiliation = ref
        .watchCollectionModel(
          ModelQuery(targetPath, key: Const.uid, isEqualTo: affiliationId)
              .value,
        )
        .firstOrNull;
    final name = affiliation?.get(namekey, "") ?? "";

    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.theme.colorScheme.onPrimary,
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title.isNotEmpty)
              Expanded(
                flex: 1,
                child: Container(
                  color: context.theme.primaryColor,
                  child: Text(title),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            const Space.width(4),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
                color: context.theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (affiliation != null)
                      IconButton(
                        color: context.theme.colorScheme.onPrimary,
                        onPressed: () async {
                          final uid = await context.navigator.push<String>(
                            UIPageRoute<String>(
                              builder: (context) => PageModuleScope(
                                module: module,
                                child:
                                    TileMenuHomeModuleChangeAffiliationSelectionPage(
                                  title: title,
                                  affiliationKey: affiliationKey,
                                  targetPath: targetPath,
                                  imageKey: imageKey,
                                  namekey: namekey,
                                  affiliationListKey: affiliationListKey,
                                ),
                              ),
                              transition: PageTransition.fullscreen,
                            ),
                          );
                          if (uid.isEmpty) {
                            return;
                          }
                          user[affiliationKey] = uid;
                          await user.save().showIndicator(context);
                          UIDialog.show(
                            context,
                            title: "Success".localize(),
                            text: "%s is completed."
                                .localize()
                                .format(["Editing".localize()]),
                            submitText: "Close".localize(),
                          );
                        },
                        icon: const Icon(Icons.change_circle),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TileMenuHomeModuleChangeAffiliationSelectionPage
    extends PageModuleWidget<TileMenuHomeModule> {
  const TileMenuHomeModuleChangeAffiliationSelectionPage({
    required this.title,
    this.affiliationKey = "affiliation",
    this.targetPath = "user",
    this.imageKey = Const.icon,
    this.namekey = Const.name,
    this.affiliationListKey = "affiliations",
  });
  final String title;
  final String namekey;
  final String imageKey;
  final String affiliationKey;
  final String affiliationListKey;
  final String targetPath;

  @override
  Widget build(BuildContext context, WidgetRef ref, TileMenuHomeModule module) {
    final user = ref.watchUserDocumentModel();
    final affiliationId = user.get(affiliationKey, "");
    final affiliationList = user.getAsList<String>(affiliationListKey, []);
    final affiliation = ref.watchCollectionModel(
      ModelQuery(targetPath, key: Const.uid, whereIn: affiliationList).value,
    );

    return UIScaffold(
      waitTransition: true,
      loadingFutures: [
        user.loading,
        affiliation.loading,
      ],
      appBar: UIAppBar(title: Text("Select %s".localize().format([title]))),
      body: UIListBuilder<DynamicMap>(
        source: affiliation,
        builder: (context, item, index) {
          return [
            ListItem(
              leading: CircleAvatar(
                backgroundImage: Asset.image(item.get(imageKey, "")),
              ),
              onTap: affiliationId == item.uid
                  ? null
                  : () {
                      context.navigator.pop(item.uid);
                    },
              title: Text(item.get(namekey, "")),
              trailing: affiliationId == item.uid
                  ? Icon(Icons.check_circle, color: context.theme.primaryColor)
                  : null,
            )
          ];
        },
      ),
    );
  }
}
