part of katana_responsive;

const kSideBarWidth = 160.0;

/// Responsive [Scaffold].
///
/// The basic functions are the same as those of [Scaffold].
///
/// By specifying [breakpoint], the width of [ResponsiveAppBar], [ResponsiveContainer], [ResponsiveListView], etc. under it are automatically adjusted.
/// It is not necessary to specify the [breakpoint] of each widget.
/// If specified, [breakpoint] such as [ResponsiveAppBar], [ResponsiveContainer], or [ResponsiveListView] will take precedence.
///
/// レスポンシブ対応した[Scaffold]。
///
/// 基本的な機能は[Scaffold]と同じです。
///
/// [breakpoint]を指定することにより、その配下にある[ResponsiveAppBar]や[ResponsiveContainer]、[ResponsiveListView]などの横幅が自動で調整されます。
/// その際各ウィジェットの[breakpoint]を指定する必要はありません。
/// 指定した場合は、[ResponsiveAppBar]や[ResponsiveContainer]、[ResponsiveListView]などの[breakpoint]が優先されます。
class ResponsiveScaffold extends StatelessWidget {
  /// Responsive [Scaffold].
  ///
  /// The basic functions are the same as those of [Scaffold].
  ///
  /// By specifying [breakpoint], the width of [ResponsiveAppBar], [ResponsiveContainer], [ResponsiveListView], etc. under it are automatically adjusted.
  /// It is not necessary to specify the [breakpoint] of each widget.
  /// If specified, [breakpoint] such as [ResponsiveAppBar], [ResponsiveContainer], or [ResponsiveListView] will take precedence.
  ///
  /// レスポンシブ対応した[Scaffold]。
  ///
  /// 基本的な機能は[Scaffold]と同じです。
  ///
  /// [breakpoint]を指定することにより、その配下にある[ResponsiveAppBar]や[ResponsiveContainer]、[ResponsiveListView]などの横幅が自動で調整されます。
  /// その際各ウィジェットの[breakpoint]を指定する必要はありません。
  /// 指定した場合は、[ResponsiveAppBar]や[ResponsiveContainer]、[ResponsiveListView]などの[breakpoint]が優先されます。
  const ResponsiveScaffold({
    super.key,
    this.breakpoint,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.appBar,
    this.body,
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
    this.sideBar,
    this.sideBarWidth = kSideBarWidth,
  }) : assert(sideBarWidth > 0, "[sideBarWidth] must be greater than 0.");

  /// Pass [context] to get [ResponsiveContainerType] set by [ResponsiveScaffold] at the top.
  ///
  /// [context]を渡して上部にある[ResponsiveScaffold]で設定されている[ResponsiveContainerType]を取得します。
  static ResponsiveScaffoldScope? of(BuildContext context) {
    final ResponsiveScaffoldScope? scope =
        context.dependOnInheritedWidgetOfExactType<ResponsiveScaffoldScope>();
    return scope;
  }

  /// Describe breakpoints for responsive containers.
  ///
  /// The width of [ResponsiveAppBar], [ResponsiveContainer], [ResponsiveListView], etc., under the control of [ResponsiveAppBar] are automatically adjusted.
  ///
  /// レスポンシブコンテナのブレークポイントを記述します。
  ///
  /// 配下にある[ResponsiveAppBar]や[ResponsiveContainer]、[ResponsiveListView]などの横幅が自動で調整されます。
  final ResponsiveContainerType? breakpoint;

  /// {@template flutter.material.scaffold.appBar}
  /// The [AppBar] to display at the top of the scaffold.
  ///
  /// [Scaffold]の上部に表示する[AppBar]。
  /// {@endtemplate}
  final PreferredSizeWidget? appBar;

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

  /// Width of sidebar.
  ///
  /// If the sidebar does not exist, it is set to 0.
  ///
  /// サイドバーの横幅。
  ///
  /// サイドバーが存在しない場合は0になります。
  final double sideBarWidth;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffoldScope(
      breakpoint: breakpoint,
      sideBarWidth: sideBar != null ? sideBarWidth : 0.0,
      child: Scaffold(
        key: key,
        primary: primary,
        drawerDragStartBehavior: drawerDragStartBehavior,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        drawerScrimColor: drawerScrimColor,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        restorationId: restorationId,
        appBar: appBar,
        body: _buildBody(context),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        persistentFooterButtons: persistentFooterButtons,
        persistentFooterAlignment: persistentFooterAlignment,
        drawer: _buildDrawer(context),
        onDrawerChanged: onDrawerChanged,
        endDrawer: endDrawer,
        onEndDrawerChanged: onEndDrawerChanged,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }

  Widget? _buildDrawer(BuildContext context) {
    if (drawer != null || sideBar == null) {
      return drawer;
    }
    final shouldShowSideBar = breakpoint?.shouldShowSideBar(context) ?? true;
    if (shouldShowSideBar) {
      return null;
    }
    return Drawer(
      width: sideBarWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: sideBar!,
      ),
    );
  }

  Widget? _buildBody(BuildContext context) {
    if (sideBar == null) {
      return body;
    }
    final shouldShowSideBar = breakpoint?.shouldShowSideBar(context) ?? true;
    if (!shouldShowSideBar) {
      return body;
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: sideBarWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: sideBar!,
          ),
        ),
        if (body != null)
          Expanded(
            child: body!,
          ),
      ],
    );
  }
}

/// Scope for retrieving information in [ResponsiveScaffold].
///
/// It can be obtained at [ResponsiveScaffold.of].
///
/// [ResponsiveScaffold]の中の情報を取得するためのスコープ。
///
/// [ResponsiveScaffold.of]で取得できます。
class ResponsiveScaffoldScope extends InheritedWidget {
  /// Scope for retrieving information in [ResponsiveScaffold].
  ///
  /// It can be obtained at [ResponsiveScaffold.of].
  ///
  /// [ResponsiveScaffold]の中の情報を取得するためのスコープ。
  ///
  /// [ResponsiveScaffold.of]で取得できます。
  const ResponsiveScaffoldScope({
    super.key,
    required super.child,
    required this.breakpoint,
    required this.sideBarWidth,
  });

  /// Describe breakpoints for responsive containers.
  ///
  /// The width of [ResponsiveAppBar], [ResponsiveContainer], [ResponsiveListView], etc., under the control of [ResponsiveAppBar] are automatically adjusted.
  ///
  /// レスポンシブコンテナのブレークポイントを記述します。
  ///
  /// 配下にある[ResponsiveAppBar]や[ResponsiveContainer]、[ResponsiveListView]などの横幅が自動で調整されます。
  final ResponsiveContainerType? breakpoint;

  /// Width of sidebar.
  ///
  /// If the sidebar does not exist, it is set to 0.
  ///
  /// サイドバーの横幅。
  ///
  /// サイドバーが存在しない場合は0になります。
  final double sideBarWidth;

  @override
  bool updateShouldNotify(covariant ResponsiveScaffoldScope oldWidget) => false;
}
