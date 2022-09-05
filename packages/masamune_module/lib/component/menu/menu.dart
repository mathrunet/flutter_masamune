import 'package:masamune_module/masamune_module.dart';

@immutable
class MenuModule extends PageModule {
  const MenuModule({
    bool enabled = true,
    String? title,
    required String routePathPrefix,
    this.automaticallyImplyLeadingOnHome = true,
    this.sliverLayoutWhenModernDesignOnHome = true,
    required this.menu,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    List<RerouteConfig> rerouteConfigs = const [],
    this.top = const [],
    this.bottom = const [],
    this.homePage = const PageConfig(
      "/",
      MenuModuleHomePage(),
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

  // Page settings.
  final PageConfig<PageModuleWidget<MenuModule>> homePage;

  /// Widget parts.
  final List<Widget> top;
  final List<Widget> bottom;

  /// メニューの一覧。
  final List<MenuModuleComponent> menu;

  /// True if Home is a sliver layout.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// True if you want to automatically display the back button when you are at home.
  final bool automaticallyImplyLeadingOnHome;

  /// Padding.
  final EdgeInsetsGeometry padding;
}

abstract class MenuModuleComponent extends ScopedWidget {
  const MenuModuleComponent();
}

@immutable
class MenuModuleGroupComponent extends MenuModuleComponent {
  const MenuModuleGroupComponent({
    this.name,
    this.icon,
    this.menus = const [],
    this.dividerColor,
  });

  final String? name;
  final IconData? icon;
  final List<MenuModuleComponent> menus;
  final Color? dividerColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (name.isNotEmpty)
          Headline(
            name!.localize(),
            icon: icon,
          )
        else ...[
          Container(
            height: 40,
            color: dividerColor ?? context.theme.dividerColor.withOpacity(0.5),
          ),
          const Divid(),
        ],
        ...menus.expandAndRemoveEmpty((item) {
          return [
            item,
            const Divid(),
          ];
        }),
      ],
    );
  }
}

class MenuModuleItemComponent extends MenuModuleComponent {
  const MenuModuleItemComponent({
    required this.name,
    this.path,
    this.icon,
    this.color,
    this.backgroundColor,
  });

  /// Menu icon.
  final IconData? icon;

  /// Menu name.
  final String name;

  /// The root path to transition to when clicked.
  final String? path;

  /// Menu color.
  final Color? color;

  /// Background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListItem(
      tileColor: backgroundColor,
      leading: icon != null
          ? Icon(
              icon!,
              color: color,
            )
          : null,
      title: Text(name.localize()),
      onTap: path.isEmpty
          ? null
          : () {
              if (path!.startsWith("http")) {
                ref.open(path!);
              } else {
                context.rootNavigator.pushNamed(
                  ref.applyModuleTag(path!),
                  arguments: RouteQuery.fullscreenOrModal,
                );
              }
            },
    );
  }
}

class MenuModuleHomePage extends PageModuleWidget<MenuModule> {
  const MenuModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, MenuModule module) {
    // Please describe reference.

    // Please describe the Widget.
    return UIScaffold(
      appBar: UIAppBar(
        title: Text(module.title?.localize() ?? "Menu".localize()),
        automaticallyImplyLeading: module.automaticallyImplyLeadingOnHome,
        sliverLayoutWhenModernDesign: module.sliverLayoutWhenModernDesignOnHome,
      ),
      body: UIListBuilder<MenuModuleComponent>(
        source: module.menu,
        padding: module.padding,
        top: module.top,
        bottom: module.bottom,
        builder: (context, item, index) {
          return [
            item,
          ];
        },
      ),
    );
  }
}

class MenuModuleAccountComponent extends MenuModuleComponent {
  const MenuModuleAccountComponent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Headline(
          "Account".localize(),
          icon: Icons.person,
        ),
        ListItem(
          title: Text(
            "Logout".localize(),
            style: const TextStyle(color: Colors.red),
          ),
          leading: const Icon(Icons.logout),
          onTap: () async {
            UIConfirm.show(
              context,
              title: "Confirmation".localize(),
              text: "You're logging out. Are you sure?".localize(),
              submitText: "Yes".localize(),
              cancelText: "No".localize(),
              onSubmit: () async {
                await context.model?.signOut();
                UIDialog.show(
                  context,
                  title: "Success".localize(),
                  text: "Logout is complete.".localize(),
                  submitText: "Back".localize(),
                  onSubmit: () {
                    context.rootNavigator.resetAndPushNamed("/");
                  },
                );
              },
            );
          },
        ),
        const Divid(),
      ],
    );
  }
}
