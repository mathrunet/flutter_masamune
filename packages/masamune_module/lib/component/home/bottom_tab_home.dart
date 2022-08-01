import 'package:masamune_module/masamune_module.dart';

@immutable
class BottomTabHomeModule extends PageModule
    with VerifyAppReroutePageModuleMixin {
  const BottomTabHomeModule({
    bool enabled = true,
    String? title = "",
    this.initialPath,
    String routePathPrefix = "",
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.disableOnTapWhenInitialIndex = true,
    this.floatingButtonOnCenter = false,
    required this.menu,
    this.dividerColor = Colors.transparent,
    List<RerouteConfig> rerouteConfigs = const [],
    this.homePage = const PageConfig(
      "/",
      BottomTabHomeModuleHomePage(),
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

  // ホームのパス。
  final String? initialPath;

  final List<MenuConfig> menu;

  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final bool disableOnTapWhenInitialIndex;
  final bool floatingButtonOnCenter;

  final Color? dividerColor;

  // ページの設定。
  final PageConfig<PageModuleWidget<BottomTabHomeModule>> homePage;
}

class BottomTabHomeModuleHomePage
    extends PageModuleWidget<BottomTabHomeModule> {
  const BottomTabHomeModuleHomePage();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    BottomTabHomeModule module,
  ) {
    final initialId = module.initialPath ??
        module.menu.firstWhereOrNull((e) => e.path.isNotEmpty)?.path ??
        "";
    final controller = ref.useNavigatorController(initialId);
    final floatingButtonOnCenter =
        module.menu.length.isOdd && module.floatingButtonOnCenter;
    final center = floatingButtonOnCenter
        ? module.menu[(module.menu.length / 2).floor()]
        : null;

    return Scaffold(
      body: InlinePageBuilder(
        controller: controller,
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: floatingButtonOnCenter
          ? FloatingActionButtonLocation.centerDocked
          : null,
      floatingActionButton:
          floatingButtonOnCenter && center != null && center.path.isNotEmpty
              ? FloatingActionButton(
                  elevation: 2.0,
                  backgroundColor:
                      module.selectedItemColor ?? context.theme.primaryColor,
                  onPressed: () {
                    context.rootNavigator.pushNamed(
                      ref.applyModuleTag(center.path!),
                      arguments: RouteQuery.fullscreenOrModal,
                    );
                  },
                  child: center.name.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(center.icon),
                            const Space.height(2.0),
                            Text(
                              center.name,
                              style: TextStyle(
                                color: context.theme.textColorOnPrimary,
                                fontSize: 10,
                              ),
                            )
                          ],
                        )
                      : Icon(center.icon),
                )
              : null,
      bottomNavigationBar: ColoredBox(
        color: context.theme.backgroundColor,
        child: UIBottomNavigationBar(
          elevation: 0,
          controller: controller,
          backgroundColor: module.backgroundColor,
          selectedItemColor:
              module.selectedItemColor ?? context.theme.primaryColor,
          unselectedItemColor:
              module.unselectedItemColor ?? context.theme.disabledColor,
          showSelectedLabels: module.showSelectedLabels,
          showUnselectedLabels: module.showUnselectedLabels,
          disableOnTapWhenInitialIndex: module.disableOnTapWhenInitialIndex,
          dividerColor: module.dividerColor,
          dividerSize: 0,
          indexID: initialId,
          items: [
            ...module.menu.mapAndRemoveEmpty((e) {
              if (e.path.isEmpty) {
                return null;
              }
              final path = ref.applyModuleTag(e.path!);
              if (e == center) {
                return UIBottomNavigationBarItem(
                  id: path,
                  icon: const Empty(),
                  onRouteChange: (settings) => settings?.name == path,
                );
              }
              return UIBottomNavigationBarItem(
                id: path,
                icon: Icon(e.icon),
                label: e.name.isEmpty ? null : e.name,
                onRouteChange: (settings) => settings?.name == path,
                onTap: () {
                  controller.navigator.pushNamed(ref.applyModuleTag(path));
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
