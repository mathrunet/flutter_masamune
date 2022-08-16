import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:masamune_module/masamune_module.dart';

export 'tutorial_required_reroute_config.dart';

@immutable
class TutorialModule extends PageModule {
  const TutorialModule({
    bool enabled = true,
    String? title,
    this.displayedKey = "@tutorialDisplayed",
    this.redirectTo = "/",
    String routePathPrefix = "tutorial",
    this.automaticallyImplyLeadingOnHome = true,
    this.sliverLayoutWhenModernDesignOnHome = true,
    List<RerouteConfig> rerouteConfigs = const [],
    required this.tutorials,
    this.homePage = const PageConfig(
      "/",
      TutorialModuleHomePage(),
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
  final PageConfig<PageModuleWidget<TutorialModule>> homePage;
  final List<ModuleWidget<TutorialModule>> tutorials;

  /// チュートリアルを表示したフラグを保存するキー。
  final String displayedKey;

  /// ログイン後のパス。
  final String redirectTo;

  /// True if Home is a sliver layout.
  final bool sliverLayoutWhenModernDesignOnHome;

  /// True if you want to automatically display the back button when you are at home.
  final bool automaticallyImplyLeadingOnHome;
}

class TutorialModuleHomePage extends PageModuleWidget<TutorialModule> {
  const TutorialModuleHomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref, TutorialModule module) {
    // Please describe reference.
    final pageController = ref.usePageController();
    final notifier = ref.state("pageNotifier", 0.0);

    // Please describe the Widget.
    return UIScaffold(
      body: Center(
        child: Stack(
          children: [
            _SlidingTutorial(
              pages: module.tutorials,
              controller: pageController,
              notifier: notifier,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconTheme(
                data: IconThemeData(
                  color: context.theme.textColorOnPrimary,
                ),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: context.theme.textColorOnPrimary,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (notifier.value <= 0)
                        IconButton(
                          onPressed: () {
                            Prefs.set(module.displayedKey, true);
                            context.navigator.pushReplacementNamed(
                              ref.applyModuleTag(
                                module.redirectTo,
                              ),
                            );
                          },
                          color: context.theme.textColorOnPrimary,
                          icon: const Icon(Icons.close),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOutQuart,
                            );
                          },
                          color: context.theme.textColorOnPrimary,
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      Expanded(
                        child: SlidingIndicator(
                          indicatorCount: module.pages.length,
                          notifier: notifier,
                          activeIndicator: const Icon(
                            Icons.circle,
                          ),
                          inActiveIndicator: const Icon(
                            Icons.circle_outlined,
                          ),
                          margin: 8,
                          inactiveIndicatorSize: 14,
                          activeIndicatorSize: 14,
                        ),
                      ),
                      if (notifier.value >= module.pages.length - 1)
                        IconButton(
                          onPressed: () {
                            Prefs.set(module.displayedKey, true);
                            context.navigator.pushReplacementNamed(
                              ref.applyModuleTag(
                                module.redirectTo,
                              ),
                            );
                          },
                          color: context.theme.textColorOnPrimary,
                          icon: const Icon(Icons.check_circle),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOutQuart,
                            );
                          },
                          color: context.theme.textColorOnPrimary,
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlidingTutorial extends StatefulWidget {
  const _SlidingTutorial({
    Key? key,
    required this.pages,
    required this.notifier,
    required this.controller,
  }) : super(key: key);

  final PageController controller;
  final ValueNotifier<double> notifier;
  final List<Widget> pages;

  @override
  State<_SlidingTutorial> createState() => _SlidingTutorialState();
}

class _SlidingTutorialState extends State<_SlidingTutorial> {
  @override
  void initState() {
    widget.controller.addListener(_handledOnScroll);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handledOnScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      children: widget.pages,
    );
  }

  void _handledOnScroll() {
    widget.notifier.value = widget.controller.page ?? 0;
  }
}

class TutorialModuleView extends ModuleWidget<TutorialModule> {
  const TutorialModuleView({
    this.color,
    this.backgroundColor,
    this.image,
    this.imagePath,
    this.text,
    this.textLabel,
  });

  final Color? color;
  final Color? backgroundColor;
  final String? imagePath;
  final Widget? image;
  final String? textLabel;
  final Widget? text;

  @override
  Widget build(BuildContext context, WidgetRef ref, TutorialModule module) {
    final width = context.mediaQuery.size.width * 0.125;
    final height = context.mediaQuery.size.height * 0.125;
    return IconTheme(
      data: IconThemeData(color: color ?? context.theme.textColorOnPrimary),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 20,
          color: color ?? context.theme.textColorOnPrimary,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height, horizontal: width),
          color: backgroundColor ?? context.theme.primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: _image(context, ref, module),
              ),
              _text(context, ref, module),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image(BuildContext context, WidgetRef ref, TutorialModule module) {
    if (image != null) {
      return image!;
    }
    if (imagePath.isNotEmpty) {
      return Image(
        image: Asset.image(imagePath!),
        fit: BoxFit.contain,
      );
    }
    return const Empty();
  }

  Widget _text(BuildContext context, WidgetRef ref, TutorialModule module) {
    if (text != null) {
      return text!;
    }
    if (textLabel.isNotEmpty) {
      return Text(textLabel!);
    }
    return const Empty();
  }
}
