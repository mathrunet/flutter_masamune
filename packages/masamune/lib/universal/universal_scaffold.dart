part of masamune;

/// Create Scaffold to provide a consistent UI across web, desktop and mobile.
///
/// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
///
/// It is basically available in the same way as [Scaffold].
///
/// You can specify [UniversalAppBar], [SliverAppBar], [AppBar] or [PreferredSizeWidget] for [appBar]. If you specify a Sliver-compatible widget, the whole page will scroll Sliver-compatible.
///
/// If [breakpoint] is specified, the UI will change to a mobile-oriented UI when the window size becomes smaller than the breakpoint. In this case, [sideBar] will be placed on [drawer] and the width will be maximized.
/// If [sideBarWidth] is specified, you can specify the width of [sideBar].
///
/// If [loadingFutures] is specified, the loading widget will be displayed until the specified [Future] is completed.
/// [loadingWidget] to change the loading widget.
/// [loadingIndicatorColor] allows you to change the color of the loading indicator.
///
/// Setting [waitTransition] to `true` will prevent [body] from being displayed during the transition animation, resulting in a smooth animation.
///
/// Webとデスクトップ、モバイルで一貫したUIを提供するためのScaffoldを作成します。
///
/// [UniversalScaffold]は、[UniversalAppBar]と[UniversalListView]などを使用して、UIを構築するとレスポンシブ対応なモダンUIが作成可能です。
///
/// 基本的には[Scaffold]と同じように利用可能です。
///
/// [appBar]に[UniversalAppBar]、[SliverAppBar]、[AppBar]や[PreferredSizeWidget]を指定できます。Sliver対応のウィジェットを指定すると、ページ全体がSliver対応のスクロールになります。
///
/// [breakpoint]を指定するとそのブレークポイント以下のウインドウサイズになると、モバイル向けのUIに変化します。その際[sideBar]は[drawer]に配置されるようになり、横幅は最大化されます。
/// [sideBarWidth]を指定している場合は、[sideBar]の横幅を指定できます。
///
/// [loadingFutures]を指定すると、指定した[Future]が完了するまでローディングウィジェットを表示します。
/// [loadingWidget]を指定すると、ローディングウィジェットを変更できます。
/// [loadingIndicatorColor]を指定すると、ローディングインジケーターの色を変更できます。
///
/// [waitTransition]を`true`にするとトランジションアニメーションの間に[body]を表示しないようにすることができ、スムーズなアニメーションを実現できます。
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return UniversalScaffold(
///     appBar: UniversalAppBar(
///       title: Text("UniversalViewPage"),
///       subtitle: Text("UniversalViewPage"),
///       titlePosition: UniversalAppBarTitlePosition.bottom,
///       background: UniversalAppBarBackground(theme.asset.image.provider),
///     ),
///     body: UniversalListView(
///       children: [
///         ResponsiveRow(
///           children: [
///             ...List.generate(100, (i) {
///               return ListTile(
///                 tileColor: Colors.red,
///                 title: Text((i + 1).toString()),
///               );
///             }).mapResponsiveCol(sm: 6, md: 4),
///           ]
///         ),
///       ],
///     ),
///   );
/// }
/// ```
class UniversalScaffold extends StatefulWidget {
  /// Create Scaffold to provide a consistent UI across web, desktop and mobile.
  ///
  /// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
  ///
  /// It is basically available in the same way as [Scaffold].
  ///
  /// You can specify [UniversalAppBar], [SliverAppBar], [AppBar] or [PreferredSizeWidget] for [appBar]. If you specify a Sliver-compatible widget, the whole page will scroll Sliver-compatible.
  ///
  /// If [breakpoint] is specified, the UI will change to a mobile-oriented UI when the window size becomes smaller than the breakpoint. In this case, [sideBar] will be placed on [drawer] and the width will be maximized.
  /// If [sideBarWidth] is specified, you can specify the width of [sideBar].
  ///
  /// If [loadingFutures] is specified, the loading widget will be displayed until the specified [Future] is completed.
  /// [loadingWidget] to change the loading widget.
  /// [loadingIndicatorColor] allows you to change the color of the loading indicator.
  ///
  /// Setting [waitTransition] to `true` will prevent [body] from being displayed during the transition animation, resulting in a smooth animation.
  ///
  /// Webとデスクトップ、モバイルで一貫したUIを提供するためのScaffoldを作成します。
  ///
  /// [UniversalScaffold]は、[UniversalAppBar]と[UniversalListView]などを使用して、UIを構築するとレスポンシブ対応なモダンUIが作成可能です。
  ///
  /// 基本的には[Scaffold]と同じように利用可能です。
  ///
  /// [appBar]に[UniversalAppBar]、[SliverAppBar]、[AppBar]や[PreferredSizeWidget]を指定できます。Sliver対応のウィジェットを指定すると、ページ全体がSliver対応のスクロールになります。
  ///
  /// [breakpoint]を指定するとそのブレークポイント以下のウインドウサイズになると、モバイル向けのUIに変化します。その際[sideBar]は[drawer]に配置されるようになり、横幅は最大化されます。
  /// [sideBarWidth]を指定している場合は、[sideBar]の横幅を指定できます。
  ///
  /// [loadingFutures]を指定すると、指定した[Future]が完了するまでローディングウィジェットを表示します。
  /// [loadingWidget]を指定すると、ローディングウィジェットを変更できます。
  /// [loadingIndicatorColor]を指定すると、ローディングインジケーターの色を変更できます。
  ///
  /// [waitTransition]を`true`にするとトランジションアニメーションの間に[body]を表示しないようにすることができ、スムーズなアニメーションを実現できます。
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return UniversalScaffold(
  ///     appBar: UniversalAppBar(
  ///       title: Text("UniversalViewPage"),
  ///       subtitle: Text("UniversalViewPage"),
  ///       titlePosition: UniversalAppBarTitlePosition.bottom,
  ///       background: UniversalAppBarBackground(theme.asset.image.provider),
  ///     ),
  ///     body: UniversalListView(
  ///       children: [
  ///         ResponsiveRow(
  ///           children: [
  ///             ...List.generate(100, (i) {
  ///               return ListTile(
  ///                 tileColor: Colors.red,
  ///                 title: Text((i + 1).toString()),
  ///               );
  ///             }).mapResponsiveCol(sm: 6, md: 4),
  ///           ]
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  const UniversalScaffold({
    super.key,
    this.appBar,
    this.body,
    this.sideBarPrefixOnBody,
    this.sideBarPrefixOnDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.loadingFutures,
    this.loadingWidget,
    this.loadingIndicatorColor,
    this.waitTransition = false,
    this.breakpoint,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.sideBar,
    this.sideBarWidth = kSideBarWidth,
  });

  /// Setting this to `true` will prevent [body] from being displayed during the transition animation, resulting in a smooth animation.
  ///
  /// これを`true`にするとトランジションアニメーションの間に[body]を表示しないようにすることができ、スムーズなアニメーションを実現できます。
  final bool waitTransition;

  /// Create a sidebar.
  ///
  /// If [breakpoint] is specified, the UI will change to a mobile-oriented UI when the window size becomes smaller than the breakpoint. At that time, [sideBar] will be placed on [drawer] and the width will be maximized.
  ///
  /// If [sideBarWidth] is specified, you can specify the width of [sideBar].
  ///
  /// サイドバーを作成します。
  ///
  /// [breakpoint]を指定するとそのブレークポイント以下のウインドウサイズになると、モバイル向けのUIに変化します。その際[sideBar]は[drawer]に配置されるようになり、横幅は最大化されます。
  /// [sideBarWidth]を指定している場合は、[sideBar]の横幅を指定できます。
  final List<Widget>? sideBar;

  /// If [sideBar] is specified, you can specify a widget that will be placed before [drawer] when placed on [drawer] by [breakpoint].
  ///
  /// [sideBar]が指定されている場合、[breakpoint]によって[drawer]に配置された場合に、[drawer]の前に配置されるウィジェットを指定できます。
  final List<Widget>? sideBarPrefixOnDrawer;

  /// If [sideBar] is specified, you can specify a widget that will be placed before [body] when placed on [body] by [breakpoint].
  ///
  /// [sideBar]が指定されている場合、[breakpoint]によって[body]に配置された場合に、[body]の前に配置されるウィジェットを指定できます。
  final List<Widget>? sideBarPrefixOnBody;

  /// If [sideBar] is specified, you can specify the width of [sideBar].
  ///
  /// [sideBar]が指定されている場合、[sideBar]の横幅を指定できます。
  final double sideBarWidth;

  /// The loading widget will now be displayed until the specified [Future] is completed.
  ///
  /// これで指定した[Future]が完了するまでローディングウィジェットを表示します。
  final List<FutureOr<dynamic>>? loadingFutures;

  /// You can specify which widgets to display when [loadingFutures] is specified.
  ///
  /// [loadingFutures]が指定されている場合に表示するウィジェットを指定できます。
  final Widget? loadingWidget;

  /// You can specify the color of the loading widget to be displayed when [loadingFutures] is specified.
  ///
  /// [loadingFutures]が指定されている場合に表示するローディングウィジェットの色を指定できます。
  final Color? loadingIndicatorColor;

  /// You can specify the breakpoint at which the UI will change to a mobile-oriented UI.
  ///
  /// UIがモバイル向けのUIに変化するブレークポイントを指定できます。
  final ResponsiveBreakpoint? breakpoint;

  /// {@template flutter.material.scaffold.appBar}
  /// The [AppBar] to display at the top of the scaffold.
  ///
  /// [Scaffold]の上部に表示する[AppBar]。
  /// {@endtemplate}
  final Widget? appBar;

  /// {@template flutter.material.scaffold.body}
  /// The primary content of the scaffold.
  ///
  /// [Scaffold]の主要なコンテンツ。
  /// {@endtemplate}
  final Widget? body;

  /// {@template flutter.material.scaffold.floatingActionButton}
  /// A floating action button displayed in front of [body] (and other
  /// [floatingActionButtonLocation] widgets) with an
  /// [elevation] that animates when the scaffold scrolls.
  ///
  /// [body]の前に表示される浮遊アクションボタン（および他の[floatingActionButtonLocation]ウィジェット）。スクロール時にアニメーションする[elevation]を持ちます。
  /// {@endtemplate}
  final Widget? floatingActionButton;

  /// {@template flutter.material.scaffold.floatingActionButtonLocation}
  /// The [FloatingActionButtonLocation] used to position the [floatingActionButton].
  ///
  /// [floatingActionButton]の位置を決めるために使用される[FloatingActionButtonLocation]。
  /// {@endtemplate}
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// {@template flutter.material.scaffold.floatingActionButtonAnimator}
  /// The [FloatingActionButtonAnimator] used to animate the [floatingActionButton].
  ///
  /// [floatingActionButton]のアニメーションを行うために使用される[FloatingActionButtonAnimator]。
  /// {@endtemplate}
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// {@template flutter.material.scaffold.persistentFooterButtons}
  /// A list of widgets to display at the bottom of the scaffold.
  ///
  /// [Scaffold]の下部に表示するウィジェットのリスト。
  /// {@endtemplate}
  final List<Widget>? persistentFooterButtons;

  /// {@template flutter.material.scaffold.persistentFooterAlignment}
  /// The alignment of [persistentFooterButtons] relative to the [Scaffold]'s
  /// [ScaffoldGeometry.floatingActionButtonArea].
  ///
  /// [persistentFooterButtons]と[Scaffold]の[ScaffoldGeometry.floatingActionButtonArea]の相対的な位置合わせ。
  /// {@endtemplate}
  final AlignmentDirectional persistentFooterAlignment;

  /// {@template flutter.material.scaffold.drawer}
  /// The widget to display behind the [Scaffold]'s [appBar].
  /// This widget is usually a [Drawer].
  ///
  /// [Scaffold]の[appBar]の後ろに表示するウィジェット。通常は[Drawer]を利用します。
  /// {@endtemplate}
  final Widget? drawer;

  /// {@template flutter.material.scaffold.onDrawerChanged}
  /// Called when the [drawer] is opened or closed.
  ///
  /// [drawer]が開かれたり閉じられたりしたときに呼び出されます。
  /// {@endtemplate}
  final void Function(bool)? onDrawerChanged;

  /// {@template flutter.material.scaffold.endDrawer}
  /// The widget to display behind the [Scaffold]'s [appBar].
  ///
  /// [Scaffold]の[appBar]の後ろに表示するウィジェット。
  /// {@endtemplate}
  final Widget? endDrawer;

  /// {@template flutter.material.scaffold.onEndDrawerChanged}
  /// Called when the [endDrawer] is opened or closed.
  ///
  /// [endDrawer]が開かれたり閉じられたりしたときに呼び出されます。
  /// {@endtemplate}
  final void Function(bool)? onEndDrawerChanged;

  /// {@template flutter.material.scaffold.bottomNavigationBar}
  /// The widget to display at the bottom of the scaffold.
  ///
  /// The difference with [bottomSheet] is that it is always displayed. This one is always displayed.
  ///
  /// [Scaffold]の下部に表示するウィジェット。
  ///
  /// [bottomSheet]との違いは常に表示されるかどうかです。こちらは常に表示されます。
  /// {@endtemplate}
  final Widget? bottomNavigationBar;

  /// {@template flutter.material.scaffold.bottomSheet}
  /// The widget to display at the bottom of the scaffold.
  ///
  /// The difference with [bottomSheet] is that it is always visible. This one can be hidden.
  ///
  /// [Scaffold]の下部に表示するウィジェット。
  ///
  /// [bottomSheet]との違いは常に表示されるかどうかです。こちらは隠すことができます。
  /// {@endtemplate}
  final Widget? bottomSheet;

  /// {@template flutter.material.scaffold.backgroundColor}
  /// The color to be applied to the background of [Scaffold].
  ///
  /// [Scaffold]の背景に塗る色。
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template flutter.material.scaffold.resizeToAvoidBottomInset}
  /// Whether the body should resize to avoid the window padding when the
  /// keyboard is displayed. If `true`, resize.
  ///
  /// キーボードが表示されたときにウィンドウのパディングを避けるためにbodyをリサイズするかどうか。`true`だとリサイズします。
  /// {@endtemplate}
  final bool? resizeToAvoidBottomInset;

  /// {@template flutter.material.scaffold.primary}
  /// Whether the [appBar] is part of the [primary] [Scaffold] widget.
  ///
  /// [appBar]が[primary]の[Scaffold]ウィジェットの一部であるかどうか。
  /// {@endtemplate}
  final bool primary;

  /// {@template flutter.material.scaffold.drawerDragStartBehavior}
  /// Determines the way that drag start behavior is handled.
  ///
  /// ドラッグ開始の挙動をどのように扱うかを決めます。
  /// {@endtemplate}
  final DragStartBehavior drawerDragStartBehavior;

  /// {@template flutter.material.scaffold.extendBody}
  /// Whether the [body] extends underneath the [Scaffold]'s [FloatingActionButton].
  ///
  /// [body]が[Scaffold]の[FloatingActionButton]の下に伸びるかどうか。
  /// {@endtemplate}
  final bool extendBody;

  /// {@template flutter.material.scaffold.extendBodyBehindAppBar}
  /// Whether the [body] extends underneath the [Scaffold]'s [AppBar].
  ///
  /// [body]が[Scaffold]の[AppBar]の下に伸びるかどうか。
  /// {@endtemplate}
  final bool extendBodyBehindAppBar;

  /// {@template flutter.material.scaffold.drawerScrimColor}
  /// The color to use for the scrim that obscures primary content while a
  /// [Drawer] is open.
  ///
  /// [Drawer]が開いているときに主要なコンテンツを隠すスクリムに使う色。
  /// {@endtemplate}
  final Color? drawerScrimColor;

  /// {@template flutter.material.scaffold.drawerEdgeDragWidth}
  /// The width of the area that responds to edge drags.
  ///
  /// エッジドラッグに反応する領域の幅。
  /// {@endtemplate}
  final double? drawerEdgeDragWidth;

  /// {@template flutter.material.scaffold.drawerEnableOpenDragGesture}
  /// Whether to allow the user to open the [Drawer] by dragging from the edge of
  /// the screen.
  ///
  /// ユーザーが画面の端からドラッグして[Drawer]を開くことを許可するかどうか。
  /// {@endtemplate}
  final bool drawerEnableOpenDragGesture;

  /// {@template flutter.material.scaffold.endDrawerEnableOpenDragGesture}
  /// Whether to allow the user to open the [endDrawer] by dragging from the edge of
  /// the screen.
  ///
  /// ユーザーが画面の端からドラッグして[endDrawer]を開くことを許可するかどうか。
  /// {@endtemplate}
  final bool endDrawerEnableOpenDragGesture;

  /// {@template flutter.material.scaffold.restorationId}
  /// The restoration ID to save and restore the state of the [Scaffold].
  ///
  /// [Scaffold]の状態を保存して復元するための復元ID。
  /// {@endtemplate}
  final String? restorationId;

  @override
  State<StatefulWidget> createState() => _UniversalScaffoldState();
}

class _UniversalScaffoldState extends State<UniversalScaffold> {
  bool _transitionWaited = false;

  bool get waitTransition {
    if (_transitionWaited) {
      return false;
    }
    _transitionWaited = true;
    return widget.waitTransition;
  }

  @override
  Widget build(BuildContext context) {
    final universalScope = UniversalScope.of(context);
    final appBar = widget.appBar;
    final useSliver = !(appBar == null ||
            appBar is! UniversalAppBar ||
            !appBar._useSliverAppBar(context)) ||
        appBar is SliverAppBar;
    if (useSliver) {
      return ResponsiveScaffold(
        key: widget.key,
        breakpoint: universalScope?.breakpoint ?? widget.breakpoint,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              if (widget.appBar != null) widget.appBar!,
            ];
          },
          body: _buildBody(context, _loading(context)),
        ),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        drawer: _buildDrawer(context),
        onDrawerChanged: widget.onDrawerChanged,
        endDrawer: widget.endDrawer,
        onEndDrawerChanged: widget.onEndDrawerChanged,
        bottomNavigationBar: widget.bottomNavigationBar,
        bottomSheet: widget.bottomSheet,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        primary: widget.primary,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        drawerScrimColor: widget.drawerScrimColor,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        restorationId: widget.restorationId,
      );
    } else {
      return ResponsiveScaffold(
        key: widget.key,
        breakpoint: universalScope?.breakpoint ?? widget.breakpoint,
        appBar: _toMobileAppBar(context),
        body: _buildBody(context, _loading(context)),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        drawer: _buildDrawer(context),
        onDrawerChanged: widget.onDrawerChanged,
        endDrawer: widget.endDrawer,
        onEndDrawerChanged: widget.onEndDrawerChanged,
        bottomNavigationBar: widget.bottomNavigationBar,
        bottomSheet: widget.bottomSheet,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        primary: widget.primary,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        drawerScrimColor: widget.drawerScrimColor,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        restorationId: widget.restorationId,
      );
    }
  }

  Widget _loading(BuildContext context) {
    if (waitTransition) {
      return LoadingBuilder(
        futures: [
          Future.delayed(kTransitionDuration),
          if (widget.loadingFutures.isNotEmpty) widget.loadingFutures!
        ],
        loading: widget.loadingWidget,
        indicatorColor: widget.loadingIndicatorColor,
        builder: (context) => widget.body ?? const SizedBox.shrink(),
      );
    } else {
      if (widget.loadingFutures.isEmpty) {
        return widget.body ?? const SizedBox.shrink();
      }
      return LoadingBuilder(
        futures: widget.loadingFutures!,
        loading: widget.loadingWidget,
        indicatorColor: widget.loadingIndicatorColor,
        builder: (context) => widget.body ?? const SizedBox.shrink(),
      );
    }
  }

  PreferredSizeWidget? _toMobileAppBar(BuildContext context) {
    final appBar = widget.appBar;
    if (appBar == null) {
      return null;
    }
    if (appBar is AppBar) {
      return appBar;
    } else if (appBar is ResponsiveAppBar) {
      return appBar;
      // } else if (appBar is SliverAppBar) {
      //   return ResponsiveAppBar(
      //     leading: appBar.leading,
      //     automaticallyImplyLeading: appBar.automaticallyImplyLeading,
      //     title: appBar.title,
      //     actions: appBar.actions,
      //     flexibleSpace: appBar.flexibleSpace,
      //     bottom: appBar.bottom,
      //     elevation: appBar.elevation,
      //     shadowColor: appBar.shadowColor,
      //     shape: appBar.shape,
      //     backgroundColor: appBar.backgroundColor,
      //     foregroundColor: appBar.foregroundColor,
      //     iconTheme: appBar.iconTheme,
      //     actionsIconTheme: appBar.actionsIconTheme,
      //     primary: appBar.primary,
      //     centerTitle: appBar.centerTitle ?? false,
      //     excludeHeaderSemantics: appBar.excludeHeaderSemantics,
      //     titleSpacing: appBar.titleSpacing,
      //     toolbarHeight: appBar.toolbarHeight,
      //     leadingWidth: appBar.leadingWidth,
      //     toolbarTextStyle: appBar.toolbarTextStyle,
      //     titleTextStyle: appBar.titleTextStyle,
      //     systemOverlayStyle: appBar.systemOverlayStyle,
      //   );
    } else if (appBar is UniversalAppBar) {
      return appBar._buildUnsliverAppBar(context);
    } else if (appBar is PreferredSizeWidget) {
      return appBar;
    }
    return null;
  }

  Widget? _buildDrawer(BuildContext context) {
    if (widget.drawer != null || widget.sideBar == null) {
      return widget.drawer;
    }
    final shouldShowSideBar =
        widget.breakpoint?.shouldShowSideBar(context) ?? true;
    if (shouldShowSideBar) {
      return null;
    }
    return Drawer(
      width: widget.sideBarWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.sideBarPrefixOnDrawer != null)
            ...widget.sideBarPrefixOnDrawer!,
          ...widget.sideBar!,
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, Widget body) {
    if (widget.sideBar == null) {
      return body;
    }
    final shouldShowSideBar =
        widget.breakpoint?.shouldShowSideBar(context) ?? true;
    if (!shouldShowSideBar) {
      return body;
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.sideBarWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.sideBarPrefixOnBody != null)
                ...widget.sideBarPrefixOnBody!,
              ...widget.sideBar!,
            ],
          ),
        ),
        Expanded(
          child: body,
        ),
      ],
    );
  }
}
