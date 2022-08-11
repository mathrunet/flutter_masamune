part of masamune;

/// Class for creating boot pages.
///
/// It is inherited and used by the class that displays the page.
///
/// Scaffold is built in by default, and the provided method is overridden and used.
class Boot extends PageScopedWidget {
  const Boot({Key? key}) : super(key: key);

  Future<void> _onInit(
    BuildContext context,
    WidgetRef ref,
    BuildContext root,
  ) async {
    try {
      await Future.wait([
        Future.delayed(
          context.app?.splashScreenMinimumDuration ??
              const Duration(seconds: 1),
        ),
        _initializeProcess(context, root),
      ]);
      final pageTransition = context.app?.initialPageTransition;
      context.navigator.pushReplacementNamed(
        context.get(kRedirectTo, context.app?.initialRoute ?? "/"),
        arguments: RouteQuery(
          transition: pageTransition ?? PageTransition.fade,
        ),
      );
      await Future.wait([
        ...Module.registeredHooks.map((e) => e.onAfterFinishBoot(root)),
        onAfterFinish(root),
      ]);
    } catch (e) {
      print(e.toString());
      UIDialog.show(
        context,
        title: "Error".localize(),
        text: "Initialization failed. Application is quit.".localize(),
        submitText: "OK".localize(),
        onSubmit: () => SystemNavigator.pop(),
      );
    }
  }

  /// It is executed after the boot process is finished and
  /// after transitioning to another page.
  @protected
  @mustCallSuper
  Future<void> onAfterFinish(BuildContext context) => Future.value();

  /// Runs after authentication has taken place.
  ///
  /// It is also called after registration or login has been completed.
  @protected
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context) => Future.value();

  /// Run it the first time the app is launched.
  @protected
  @mustCallSuper
  Future<void> onInit(BuildContext context) => Future.value();

  /// Runs when restoring authentication.
  @protected
  @mustCallSuper
  Future<void> onRestoreAuth(BuildContext context) => Future.value();

  /// It is executed after the boot process is finished and
  /// before transitioning to another page.
  @protected
  @mustCallSuper
  Future<void> onBeforeFinishBoot(BuildContext context) => Future.value();

  /// Indicator color.
  ///
  /// If null, the color will be gradation.
  @protected
  Color? get indicatorColor => null;

  /// Feature image.
  ///
  /// If you register it,
  @protected
  ImageProvider? get featureImage => null;

  @protected
  ImageProvider? get backgroundImage => null;

  /// Feature widget.
  ///
  /// If you register it, this is the only one displayed.
  @protected
  Widget? get featureWidget => null;

  /// Background color.
  @protected
  Color? get backgroundColor => null;

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.effect(
      onInitOrUpdate: () {
        _onInit(context, ref, context.navigator.context);
      },
    );

    final background = context.theme.image.bootBackgroundImage.isEmpty
        ? backgroundImage
        : NetworkOrAsset.image(context.theme.image.bootBackgroundImage!);
    return applySafeArea
        ? SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (background != null)
                  Image(image: background, fit: BoxFit.cover),
                _body(context, ref),
              ],
            ),
          )
        : Stack(
            fit: StackFit.expand,
            children: [
              if (background != null)
                Image(image: background, fit: BoxFit.cover),
              _body(context, ref),
            ],
          );
  }

  Future<void> _initializeProcess(
    BuildContext context,
    BuildContext root,
  ) async {
    Config.onUserStateChanged.addListener((userId) async {
      if (userId.isEmpty) {
        return;
      }
      await Future.wait([
        ...Module.registeredHooks.map((e) => e.onAfterAuth(root)),
        onAfterAuth(root),
      ]);
    });
    await Future.wait([
      Config.initialize(
        flavor: context.flavor,
      ),
      Localize.initialize(
        path: context.app?.localizationFile ?? "assets/Localization.csv",
      ),
      ...Module.registeredHooks.map((e) => e.onInit(root)),
      onInit(root),
    ]);
    await UIConnectDialog.show(context, showBackButton: false);
    await Future.wait([
      ...Module.registeredHooks.map((e) => e.onRestoreAuth(root)),
      onRestoreAuth(root),
    ]);
    await UIConnectDialog.show(context, showBackButton: false);
    await Future.wait([
      ...Module.registeredHooks.map((e) => e.onBeforeFinishBoot(root)),
    ]);
  }

  Widget _body(BuildContext context, WidgetRef ref) {
    final config = context.app?.bootConfig;
    final logoPath = context.theme.image.bootFeatureImage ?? config?.logoPath;
    final image = config != null &&
            config.designType == BootDesignType.logo &&
            logoPath.isNotEmpty
        ? NetworkOrAsset.image(logoPath!, ImageSize.medium)
        : featureImage;
    if (image != null) {
      return ColoredBox(
        color: config?.backgroundColor ??
            backgroundColor ??
            context.theme.backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (config?.logoSize != null)
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: config!.logoSize!.width,
                  height: config.logoSize!.height,
                  child: ClipRRect(
                    borderRadius: config.logoBorderRadius ?? BorderRadius.zero,
                    child: Image(
                      image: image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: config?.logoBorderRadius ?? BorderRadius.zero,
                child: Image(
                  image: image,
                  fit: BoxFit.contain,
                ),
              )
          ],
        ),
      );
    }
    final widget =
        config != null && config.designType == BootDesignType.indicator
            ? CircularProgressIndicator(
                backgroundColor: config.backgroundColor,
                color: config.color,
              )
            : featureWidget;
    if (widget != null) {
      return Container(
        color: config?.backgroundColor ??
            backgroundColor ??
            context.theme.backgroundColor,
        alignment: Alignment.center,
        child: widget,
      );
    }
    return ColoredBox(
      color: config?.backgroundColor ??
          backgroundColor ??
          context.theme.backgroundColor,
      child: AnimationScope(
        animation: ref.useAutoRepeatAnimationScenario(
          r"_$boot",
          [
            AnimationUnit(
              tween: DoubleTween(begin: 150, end: 100),
              from: const Duration(milliseconds: 0),
              to: const Duration(milliseconds: 2500),
              curve: Curves.easeInOutQuint,
              tag: "size",
            ),
            AnimationUnit(
              tween: DoubleTween(begin: 100, end: 150),
              from: const Duration(milliseconds: 2500),
              to: const Duration(milliseconds: 5000),
              curve: Curves.easeInOutQuint,
              tag: "size",
            ),
            AnimationUnit(
              tween: ColorTween(
                begin: config?.color ?? indicatorColor ?? Colors.red,
                end: config?.color ?? indicatorColor ?? Colors.purple,
              ),
              from: const Duration(seconds: 0),
              to: const Duration(seconds: 1),
              tag: "color",
            ),
            AnimationUnit(
              tween: ColorTween(
                begin: config?.color ?? indicatorColor ?? Colors.purple,
                end: config?.color ?? indicatorColor ?? Colors.blue,
              ),
              from: const Duration(seconds: 2),
              to: const Duration(seconds: 3),
              tag: "color",
            ),
            AnimationUnit(
              tween: ColorTween(
                begin: config?.color ?? indicatorColor ?? Colors.blue,
                end: config?.color ?? indicatorColor ?? Colors.purple,
              ),
              from: const Duration(seconds: 4),
              to: const Duration(seconds: 5),
              tag: "color",
            ),
            AnimationUnit(
              tween: ColorTween(
                begin: config?.color ?? indicatorColor ?? Colors.purple,
                end: config?.color ?? indicatorColor ?? Colors.red,
              ),
              from: const Duration(seconds: 8),
              to: const Duration(seconds: 10),
              tag: "color",
            )
          ],
        ),
        builder: (context, child, animator) {
          return LoadingBouncingGrid.circle(
            size: animator.get("size", 0),
            backgroundColor: animator.get(
              "color",
              config?.color ?? indicatorColor ?? Colors.red,
            ),
          );
        },
      ),
    );
  }
}
