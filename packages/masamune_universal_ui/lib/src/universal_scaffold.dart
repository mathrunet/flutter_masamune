part of '/masamune_universal_ui.dart';

/// Create Scaffold to provide a consistent UI across web, desktop and mobile.
///
/// [UniversalScaffold] can be used with [UniversalAppBar] and [UniversalListView] to create a responsive modern UI.
///
/// It is basically available in the same way as [Scaffold].
///
/// You can specify [UniversalAppBar], [SliverAppBar], [AppBar] or [PreferredSizeWidget] for [appBar]. If you specify a Sliver-compatible widget, the whole page will scroll Sliver-compatible.
///
/// If [breakpoint] is specified, the UI will change to a mobile-oriented UI when the window size becomes smaller than the breakpoint. In this case, [sideBar] will be placed on [drawer] and the width will be maximized.
///
/// If [loadingFutures] is specified, the loading widget will be displayed until the specified [Future] is completed.
/// [loadingWidget] to change the loading widget.
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
///
/// [loadingFutures]を指定すると、指定した[Future]が完了するまでローディングウィジェットを表示します。
/// [loadingWidget]を指定すると、ローディングウィジェットを変更できます。
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
  ///
  /// If [loadingFutures] is specified, the loading widget will be displayed until the specified [Future] is completed.
  /// [loadingWidget] to change the loading widget.
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
  ///
  /// [loadingFutures]を指定すると、指定した[Future]が完了するまでローディングウィジェットを表示します。
  /// [loadingWidget]を指定すると、ローディングウィジェットを変更できます。
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
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.header,
    this.footer,
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
    this.sideBarOnDrawerAlways = false,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.loadingFutures,
    this.loadingWidget,
    this.waitTransition = false,
    this.breakpoint,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.sideBar,
    this.width,
    this.height,
    this.borderRadius,
    this.alignment = Alignment.center,
  });

  /// Pass [context] to get [Breakpoint] set by [UniversalScaffold] at the top.
  ///
  /// [context]を渡して上部にある[UniversalScaffold]で設定されている[Breakpoint]を取得します。
  static UniversalScaffoldScope? of(BuildContext context) {
    final UniversalScaffoldScope? scope =
        context.dependOnInheritedWidgetOfExactType<UniversalScaffoldScope>();
    return scope;
  }

  /// You can specify the size of the [UniversalScaffold] itself.
  ///
  /// Please use when displaying as a modal.
  ///
  /// [UniversalScaffold]自体のサイズを指定できます。
  ///
  /// モーダルとして表示する場合にご利用ください。
  final double? width;

  /// You can specify the size of the [UniversalScaffold] itself.
  ///
  /// Please use when displaying as a modal.
  ///
  /// [UniversalScaffold]自体のサイズを指定できます。
  ///
  /// モーダルとして表示する場合にご利用ください。
  final double? height;

  /// You can specify where to place the [UniversalScaffold] itself.
  ///
  /// Please use when displaying as a modal.
  ///
  /// [UniversalScaffold]自体をどこに配置するかを指定できます。
  ///
  /// モーダルとして表示する場合にご利用ください。
  final AlignmentGeometry alignment;

  /// Specify rounded corners.
  ///
  /// Please use when displaying as a modal.
  ///
  /// 四隅の角丸を指定します。
  ///
  /// モーダルとして表示する場合にご利用ください。
  final BorderRadiusGeometry? borderRadius;

  /// If set to `true`, the sidebar will always be placed in the drawer regardless of screen size.
  ///
  /// `true`に設定されている場合、画面サイズによらずサイドバーを常にドロワーに設置します。
  final bool sideBarOnDrawerAlways;

  /// Setting this to `true` will prevent [body] from being displayed during the transition animation, resulting in a smooth animation.
  ///
  /// これを`true`にするとトランジションアニメーションの間に[body]を表示しないようにすることができ、スムーズなアニメーションを実現できます。
  final bool waitTransition;

  /// Create a sidebar.
  ///
  /// If [breakpoint] is specified, the UI will change to a mobile-oriented UI when the window size becomes smaller than the breakpoint. At that time, [sideBar] will be placed on [drawer], and the width will be maximized.
  ///
  /// サイドバーを作成します。
  ///
  /// [breakpoint]を指定するとそのブレークポイント以下のウインドウサイズになると、モバイル向けのUIに変化します。その際[sideBar]は[drawer]に配置されるようになり、横幅は最大化されます。
  final PreferredSizeWidget? sideBar;

  /// Specify the widget to be displayed at the top of [body].
  ///
  /// [body]の上部に表示するウィジェットを指定します。
  final Widget? header;

  /// Specify the widget to be displayed at the bottom of [body].
  ///
  /// [body]の下部に表示するウィジェットを指定します。
  final Widget? footer;

  /// The loading widget will now be displayed until the specified [Future] is completed.
  ///
  /// これで指定した[Future]が完了するまでローディングウィジェットを表示します。
  final List<FutureOr<dynamic>>? loadingFutures;

  /// You can specify which widgets to display when [loadingFutures] is specified.
  ///
  /// [loadingFutures]が指定されている場合に表示するウィジェットを指定できます。
  final Widget? loadingWidget;

  /// You can specify the breakpoint at which the UI will change to a mobile-oriented UI.
  ///
  /// UIがモバイル向けのUIに変化するブレークポイントを指定できます。
  final Breakpoint? breakpoint;

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
    final appBar = widget.appBar;
    final useSliver = !(appBar == null ||
            appBar is! UniversalAppBarMixin ||
            !appBar.useSliver(context)) ||
        appBar is SliverAppBar ||
        appBar is SliverAppBarMixin;
    final universalScope =
        MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    final breakpoint = universalScope?.defaultBreakpoint ?? widget.breakpoint;

    if (useSliver) {
      return _sizedBox(
        context,
        UniversalScaffoldScope(
          breakpoint: breakpoint,
          sideBarWidth: 0.0,
          child: Scaffold(
            key: widget.key,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
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
            endDrawerEnableOpenDragGesture:
                widget.endDrawerEnableOpenDragGesture,
            restorationId: widget.restorationId,
          ),
        ),
      );
    } else {
      return _sizedBox(
        context,
        UniversalScaffoldScope(
          breakpoint: breakpoint,
          sideBarWidth: 0.0,
          child: Scaffold(
            key: widget.key,
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
            endDrawerEnableOpenDragGesture:
                widget.endDrawerEnableOpenDragGesture,
            restorationId: widget.restorationId,
          ),
        ),
      );
    }
  }

  Widget _sizedBox(BuildContext context, Widget child) {
    if (widget.width == null && widget.height == null) {
      return child;
    }
    return Align(
      alignment: widget.alignment,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _borderRadius(context, child),
      ),
    );
  }

  Widget _borderRadius(BuildContext context, Widget child) {
    if (widget.borderRadius == null) {
      return child;
    }
    return ClipRRect(
      borderRadius: widget.borderRadius!,
      child: child,
    );
  }

  Widget _loading(BuildContext context) {
    if (waitTransition) {
      return LoadingBuilder(
        futures: [
          Future.delayed(kTransitionDuration),
          if (widget.loadingFutures.isNotEmpty) widget.loadingFutures!
        ],
        loading: widget.loadingWidget,
        builder: (context) => widget.body ?? const SizedBox.shrink(),
      );
    } else {
      if (widget.loadingFutures.isEmpty) {
        return widget.body ?? const SizedBox.shrink();
      }
      return LoadingBuilder(
        futures: widget.loadingFutures!,
        loading: widget.loadingWidget,
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
    } else if (appBar is UniversalAppBarMixin) {
      return appBar.buildUnsliverAppBar(context);
    } else if (appBar is PreferredSizeWidget) {
      return appBar;
    }
    throw Exception(
      "[appBar] is available only for [AppBar], [UniversalAppBarMixin], and [PreferredSizeWidget].",
    );
  }

  Widget? _buildDrawer(BuildContext context) {
    if (widget.drawer != null || widget.sideBar == null) {
      return widget.drawer;
    }
    final universalScope =
        MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    final breakpoint = universalScope?.defaultBreakpoint ?? widget.breakpoint;
    final shouldShowSideBar =
        (breakpoint?.shouldShowSideBar(context) ?? true) &&
            !widget.sideBarOnDrawerAlways;
    if (shouldShowSideBar) {
      return null;
    }
    return AutoDrawerSettings(
      child: Drawer(
        width: widget.sideBar!.preferredSize.width,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        child: widget.sideBar,
      ),
    );
  }

  Widget _buildBody(BuildContext context, Widget body) {
    if (widget.sideBar == null) {
      return _buildInnerBody(context, body);
    }
    final universalScope =
        MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    final breakpoint = universalScope?.defaultBreakpoint ?? widget.breakpoint;
    final shouldShowSideBar =
        (breakpoint?.shouldShowSideBar(context) ?? true) &&
            !widget.sideBarOnDrawerAlways;
    if (!shouldShowSideBar) {
      return _buildInnerBody(context, body);
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.sideBar!.preferredSize.width,
          child: widget.sideBar,
        ),
        Expanded(
          child: _buildInnerBody(context, body),
        ),
      ],
    );
  }

  Widget _buildInnerBody(BuildContext context, Widget body) {
    if (widget.header == null && widget.footer == null) {
      return body;
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.header != null) widget.header!,
        Expanded(
          child: body,
        ),
        if (widget.footer != null) widget.footer!,
      ],
    );
  }
}

/// Scope for retrieving information in [UniversalScaffold].
///
/// It can be obtained at [UniversalScaffold.of].
///
/// [UniversalScaffold]の中の情報を取得するためのスコープ。
///
/// [UniversalScaffold.of]で取得できます。
class UniversalScaffoldScope extends InheritedWidget {
  /// Scope for retrieving information in [UniversalScaffold].
  ///
  /// It can be obtained at [UniversalScaffold.of].
  ///
  /// [UniversalScaffold]の中の情報を取得するためのスコープ。
  ///
  /// [UniversalScaffold.of]で取得できます。
  const UniversalScaffoldScope({
    super.key,
    required super.child,
    required this.breakpoint,
    required this.sideBarWidth,
  });

  /// Describe breakpoints for responsive containers.
  ///
  /// The width of the `UniversalUI` under the distribution is automatically adjusted.
  ///
  /// レスポンシブコンテナのブレークポイントを記述します。
  ///
  /// 配下にある`UniversalUI`の横幅が自動で調整されます。
  final Breakpoint? breakpoint;

  /// Width of sidebar.
  ///
  /// If the sidebar does not exist, it is set to 0.
  ///
  /// サイドバーの横幅。
  ///
  /// サイドバーが存在しない場合は0になります。
  final double sideBarWidth;

  @override
  bool updateShouldNotify(covariant UniversalScaffoldScope oldWidget) => false;
}

/// This is given when generating a [Drawer] within [UniversalScaffold].
///
/// Please use this option if you want to check whether the file is in the automatically generated [Drawer] in [UniversalScaffold] or not.
///
/// [UniversalScaffold]内で[Drawer]を生成する際に付与されます。
///
/// [UniversalScaffold]内で自動生成された[Drawer]内であるかどうかを確認したい場合ご利用ください。
class AutoDrawerSettings extends InheritedWidget {
  /// This is given when generating a [Drawer] within [UniversalScaffold].
  ///
  /// Please use this option if you want to check whether the file is in the automatically generated [Drawer] in [UniversalScaffold] or not.
  ///
  /// [UniversalScaffold]内で[Drawer]を生成する際に付与されます。
  ///
  /// [UniversalScaffold]内で自動生成された[Drawer]内であるかどうかを確認したい場合ご利用ください。
  const AutoDrawerSettings({
    super.key,
    required super.child,
  });

  /// Get [AutoDrawerSettings] if the ancestor has [AutoDrawerSettings].
  ///
  /// Please use this option if you want to check whether the file is in the automatically generated [Drawer] in [UniversalScaffold] or not.
  ///
  /// 祖先に[AutoDrawerSettings]を持っていれば[AutoDrawerSettings]を取得します。
  ///
  /// [UniversalScaffold]内で自動生成された[Drawer]内であるかどうかを確認したい場合ご利用ください。
  static AutoDrawerSettings? maybeOf(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<AutoDrawerSettings>()
        ?.widget as AutoDrawerSettings?;
  }

  @override
  bool updateShouldNotify(covariant AutoDrawerSettings oldWidget) => false;
}
