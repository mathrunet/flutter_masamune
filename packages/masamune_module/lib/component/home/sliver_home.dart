import 'package:masamune_module/masamune_module.dart';

@immutable
class SliverHomeModule extends PageModule {
  const SliverHomeModule({
    bool enabled = true,
    String? title,
    this.backgroundImage,
    String routePathPrefix = "",
    this.automaticallyImplyLeadingOnHome = true,
    this.backgroundColor,
    this.foregroundColor,
    this.headerHeight = 210,
    this.components = const [],
    List<RerouteConfig> rerouteConfigs = const [],
    this.homePage = const PageConfig(
      "/home",
      SliverHomeModuleHomePage(),
    ),
  }) : super(
          enabled: enabled,
          title: title,
          routePathPrefix: routePathPrefix,
          rerouteConfigs: rerouteConfigs,
        );

  @override
  List<PageConfig<Widget>> get pages => [
        homePage,
      ];

  // Widget.
  final PageConfig<PageModuleWidget<SliverHomeModule>> homePage;

  final List<ModuleWidget<SliverHomeModule>> components;

  /// ヘッダーのカラー。
  final Color? backgroundColor;
  final Color? foregroundColor;

  /// ヘッダーの画像。
  final String? backgroundImage;

  /// ヘッダーの高さ。
  final double headerHeight;

  /// True if you want to automatically display the back button when you are at home.
  final bool automaticallyImplyLeadingOnHome;
}

class SliverHomeModuleHomePage extends PageModuleWidget<SliverHomeModule> {
  const SliverHomeModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, SliverHomeModule module) {
    // Please describe reference.

    // Please describe the Widget.
    return UIScaffold(
      appBar: UIAppBar(
        title: Text(
          module.title ?? context.app?.title ?? "",
          style: TextStyle(
            color: module.foregroundColor ?? context.theme.textColorOnPrimary,
          ),
        ),
        expandedHeight: module.headerHeight,
        automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
        backgroundColor: module.backgroundColor ?? context.theme.primaryColor,
        foregroundColor:
            module.foregroundColor ?? context.theme.textColorOnPrimary,
        background: module.backgroundImage.isEmpty
            ? null
            : Image(
                image: Asset.image(module.backgroundImage!),
                fit: BoxFit.cover,
              ),
      ),
      body: UIListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: module.components.expandAndRemoveEmpty(
          (element) => [
            element,
            const Space.height(16),
          ],
        ),
      ),
    );
  }
}

class SliverHomeModuleListWidget extends ModuleWidget<SliverHomeModule> {
  const SliverHomeModuleListWidget({
    required this.query,
    required this.title,
    this.child = const SliverHomeModuleListTileComponent(),
    this.icon,
    this.filterQuery,
  });

  final ModelQuery query;
  final ModuleValueWidget<SliverHomeModule, DynamicMap> child;
  final String title;
  final IconData? icon;
  final FilterQuery? filterQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref, SliverHomeModule module) {
    final data = ref.watchCollectionModel(query.value);
    final filtered = filterQuery?.build(data, context, ref) ?? data;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DividHeadline(
          title,
          icon: icon,
        ),
        ...filtered.mapAndRemoveEmpty((item) {
          return ModuleValueProvider(value: item, child: child);
        }),
        const Space.height(16),
      ],
    );
  }
}

class SliverHomeModuleListTileComponent
    extends ModuleValueWidget<SliverHomeModule, DynamicMap> {
  const SliverHomeModuleListTileComponent();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    SliverHomeModule module,
    DynamicMap value,
  ) {
    final image = value.get("image", "");
    final title = value.get("name", "");
    return ListTile(
      leading: image.isEmpty
          ? null
          : CircleAvatar(
              backgroundImage: Asset.image(image),
            ),
      title: Text(title),
    );
  }
}

class SliverHomeModuleMenuWidget extends ModuleWidget<SliverHomeModule> {
  const SliverHomeModuleMenuWidget(this.menu);

  final List<MenuModuleComponent> menu;

  @override
  Widget build(BuildContext context, WidgetRef ref, SliverHomeModule module) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: menu.expandAndRemoveEmpty(
        (item) {
          return [
            item,
          ];
        },
      ),
    );
  }
}
