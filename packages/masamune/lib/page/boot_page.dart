part of masamune;

/// Class for creating boot pages.
///
/// It is inherited and used by the class that displays the page.
///
/// Scaffold is built in by default, and the provided method is overridden and used.
class BootPage extends PageScopedWidget {
  const BootPage({Key? key}) : super(key: key);

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
      final redirectUri = await retrieveRedirectUri(context);
      final pageTransition = context.app?.initialPageTransition;
      context.navigator.pushReplacementNamed(
        redirectUri ??
            context.get(kRedirectTo, context.app?.initialRoute ?? "/"),
        arguments: RouteQuery(
          transition: pageTransition ?? PageTransition.fade,
        ),
      );
      await Future.wait([
        ...Module.registeredHooks.map((e) => e.onAfterFinishBoot(root)),
        onAfterFinishBoot(root),
      ]);
    } catch (error) {
      onError(root, error);
    }
  }

  /// Executed in the event of an error.
  ///
  /// The error is passed to [error].
  @protected
  void onError(BuildContext context, Object error) {
    print(error.toString());
    UIDialog.show(
      context,
      title: "Error".localize(),
      text: "Initialization failed. Application is quit.".localize(),
      submitText: "OK".localize(),
      onSubmit: () => SystemNavigator.pop(),
    );
  }

  /// It is executed after the boot process is finished and
  /// after transitioning to another page.
  @protected
  @mustCallSuper
  Future<void> onAfterFinishBoot(BuildContext context) => Future.value();

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

  // /// This is called if you want to redirect to a specific URL when Boot redirects.
  // ///
  // /// If null or non-empty is returned, it is ignored.
  @protected
  @mustCallSuper
  Future<String?> retrieveRedirectUri(BuildContext context) async {
    for (final e in Module.registeredHooks) {
      final res = await e.retrieveRedirectUriOnBoot(context);
      if (res.isNotEmpty) {
        return res;
      }
    }
    return context.get(kRedirectTo, context.app?.initialRoute ?? "/");
  }

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

    return applySafeArea
        ? SafeArea(
            child: _build(context, ref),
          )
        : _build(context, ref);
  }

  Widget _build(BuildContext context, WidgetRef ref) {
    final config = context.app?.bootConfig;
    final background = context.theme.image.bootBackgroundImage.isEmpty
        ? backgroundImage
        : Asset.image(context.theme.image.bootBackgroundImage!);

    return ColoredBox(
      color: config?.backgroundColor ??
          backgroundColor ??
          context.theme.backgroundColor,
      child: AnimationScope(
        animation: ref.useAutoPlayAnimationScenario(
          r"_$bootRoot",
          [
            AnimationUnit(
              tag: "opacity",
              tween: DoubleTween(begin: 0.0, end: 1.0),
              from: const Duration(milliseconds: 250),
              to: const Duration(milliseconds: 500),
            )
          ],
        ),
        builder: (context, child, animator) {
          return Opacity(
            opacity: animator.get("opacity", 0.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (background != null)
                  Image(image: background, fit: BoxFit.cover),
                _body(context, ref),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref) {
    final config = context.app?.bootConfig;
    final logoPath = context.theme.image.bootFeatureImage ?? config?.logoPath;
    final image = config != null &&
            config.designType == BootDesignType.logo &&
            logoPath.isNotEmpty
        ? Asset.image(logoPath!, ImageSize.medium)
        : featureImage;
    if (image != null) {
      return Stack(
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
    return Center(
      child: LoadingIndicator(
        color: config?.color ?? indicatorColor ?? context.theme.dividerColor,
      ),
    );
  }
}
