part of masamune.ui;

class UIScaffold extends StatefulWidget {
  /// Creates a visual scaffold for material design widgets.
  const UIScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.webStyle,
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
    this.inlineNavigatorControllerOnWeb,
    this.loadingFutures,
    this.loadingWidget,
    this.loadingIndicatorColor,
    this.designType,
    this.modalSizeRatio = 0.8,
    this.waitTransition = false,
  }) : super(key: key);

  final bool? webStyle;
  final DesignType? designType;
  final bool waitTransition;

  final NavigatorController? inlineNavigatorControllerOnWeb;
  final List<FutureOr<dynamic>>? loadingFutures;
  final Widget? loadingWidget;
  final Color? loadingIndicatorColor;
  final double modalSizeRatio;

  /// If true, and [bottomNavigationBar] or [persistentFooterButtons]
  /// is specified, then the [body] extends to the bottom of the Scaffold,
  /// instead of only extending to the top of the [bottomNavigationBar]
  /// or the [persistentFooterButtons].
  ///
  /// If true, a [MediaQuery] widget whose bottom padding matches the height
  /// of the [bottomNavigationBar] will be added above the scaffold's [body].
  ///
  /// This property is often useful when the [bottomNavigationBar] has
  /// a non-rectangular shape, like [CircularNotchedRectangle], which
  /// adds a [FloatingActionButton] sized notch to the top edge of the bar.
  /// In this case specifying `extendBody: true` ensures that that scaffold's
  /// body will be visible through the bottom navigation bar's notch.
  ///
  /// See also:
  ///
  ///  * [extendBodyBehindAppBar], which extends the height of the body
  ///    to the top of the scaffold.
  final bool extendBody;

  /// If true, and an [appBar] is specified, then the height of the [body] is
  /// extended to include the height of the app bar and the top of the body
  /// is aligned with the top of the app bar.
  ///
  /// This is useful if the app bar's [AppBar.backgroundColor] is not
  /// completely opaque.
  ///
  /// This property is false by default. It must not be null.
  ///
  /// See also:
  ///
  ///  * [extendBody], which extends the height of the body to the bottom
  ///    of the scaffold.
  final bool extendBodyBehindAppBar;

  /// An app bar to display at the top of the scaffold.
  final Widget? appBar;

  /// The primary content of the scaffold.
  ///
  /// Displayed below the [appBar], above the bottom of the ambient
  /// [MediaQuery]'s [MediaQueryData.viewInsets], and behind the
  /// [floatingActionButton] and [drawer]. If [resizeToAvoidBottomInset] is
  /// false then the body is not resized when the onscreen keyboard appears,
  /// i.e. it is not inset by `viewInsets.bottom`.
  ///
  /// The widget in the body of the scaffold is positioned at the top-left of
  /// the available space between the app bar and the bottom of the scaffold. To
  /// center this widget instead, consider putting it in a [Center] widget and
  /// having that be the body. To expand this widget instead, consider
  /// putting it in a [SizedBox.expand].
  ///
  /// If you have a column of widgets that should normally fit on the screen,
  /// but may overflow and would in such cases need to scroll, consider using a
  /// [ListView] as the body of the scaffold. This is also a good choice for
  /// the case where your body is a scrollable list.
  final Widget? body;

  /// A button displayed floating above [body], in the bottom right corner.
  ///
  /// Typically a [FloatingActionButton].
  final Widget? floatingActionButton;

  /// Responsible for determining where the [floatingActionButton] should go.
  ///
  /// If null, the [ScaffoldState] will use the default location, [FloatingActionButtonLocation.endFloat].
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Animator to move the [floatingActionButton] to a new [floatingActionButtonLocation].
  ///
  /// If null, the [ScaffoldState] will use the default animator, [FloatingActionButtonAnimator.scaling].
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// A set of buttons that are displayed at the bottom of the scaffold.
  ///
  /// Typically this is a list of [TextButton] widgets. These buttons are
  /// persistently visible, even if the [body] of the scaffold scrolls.
  ///
  /// These widgets will be wrapped in an [OverflowBar].
  ///
  /// The [persistentFooterButtons] are rendered above the
  /// [bottomNavigationBar] but below the [body].
  final List<Widget>? persistentFooterButtons;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices. Swipes in from either left-to-right ([TextDirection.ltr]) or
  /// right-to-left ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  ///
  /// To open the drawer, use the [ScaffoldState.openDrawer] function.
  ///
  /// To close the drawer, use [Navigator.pop].
  ///
  /// {@tool dartpad --template=stateful_widget_material}
  /// To disable the drawer edge swipe, set the
  /// [Scaffold.drawerEnableOpenDragGesture] to false. Then, use
  /// [ScaffoldState.openDrawer] to open the drawer and [Navigator.pop] to close
  /// it.
  ///
  /// ```dart
  /// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ///
  /// void _openDrawer() {
  ///   _scaffoldKey.currentState!.openDrawer();
  /// }
  ///
  /// void _closeDrawer() {
  ///   Navigator.of(context).pop();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     key: _scaffoldKey,
  ///     appBar: AppBar(title: const Text('Drawer Demo')),
  ///     body: Center(
  ///       child: ElevatedButton(
  ///         onPressed: _openDrawer,
  ///         child: const Text('Open Drawer'),
  ///       ),
  ///     ),
  ///     drawer: Drawer(
  ///       child: Center(
  ///         child: Column(
  ///           mainAxisAlignment: MainAxisAlignment.center,
  ///           children: <Widget>[
  ///             const Text('This is the Drawer'),
  ///             ElevatedButton(
  ///               onPressed: _closeDrawer,
  ///               child: const Text('Close Drawer'),
  ///             ),
  ///           ],
  ///         ),
  ///       ),
  ///     ),
  ///     // Disable opening the drawer with a swipe gesture.
  ///     drawerEnableOpenDragGesture: false,
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final Widget? drawer;

  /// Optional callback that is called when the [Scaffold.drawer] is opened or closed.
  final DrawerCallback? onDrawerChanged;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices. Swipes in from right-to-left ([TextDirection.ltr]) or
  /// left-to-right ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  ///
  /// To open the drawer, use the [ScaffoldState.openEndDrawer] function.
  ///
  /// To close the drawer, use [Navigator.pop].
  ///
  /// {@tool dartpad --template=stateful_widget_material}
  /// To disable the drawer edge swipe, set the
  /// [Scaffold.endDrawerEnableOpenDragGesture] to false. Then, use
  /// [ScaffoldState.openEndDrawer] to open the drawer and [Navigator.pop] to
  /// close it.
  ///
  /// ```dart
  /// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ///
  /// void _openEndDrawer() {
  ///   _scaffoldKey.currentState!.openEndDrawer();
  /// }
  ///
  /// void _closeEndDrawer() {
  ///   Navigator.of(context).pop();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     key: _scaffoldKey,
  ///     appBar: AppBar(title: const Text('Drawer Demo')),
  ///     body: Center(
  ///       child: ElevatedButton(
  ///         onPressed: _openEndDrawer,
  ///         child: const Text('Open End Drawer'),
  ///       ),
  ///     ),
  ///     endDrawer: Drawer(
  ///       child: Center(
  ///         child: Column(
  ///           mainAxisAlignment: MainAxisAlignment.center,
  ///           children: <Widget>[
  ///             const Text('This is the Drawer'),
  ///             ElevatedButton(
  ///               onPressed: _closeEndDrawer,
  ///               child: const Text('Close Drawer'),
  ///             ),
  ///           ],
  ///         ),
  ///       ),
  ///     ),
  ///     // Disable opening the end drawer with a swipe gesture.
  ///     endDrawerEnableOpenDragGesture: false,
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final Widget? endDrawer;

  /// Optional callback that is called when the [Scaffold.endDrawer] is opened or closed.
  final DrawerCallback? onEndDrawerChanged;

  /// The color to use for the scrim that obscures primary content while a drawer is open.
  ///
  /// By default, the color is [Colors.black54]
  final Color? drawerScrimColor;

  /// The color of the [Material] widget that underlies the entire Scaffold.
  ///
  /// The theme's [ThemeData.scaffoldBackgroundColor] by default.
  final Color? backgroundColor;

  /// A bottom navigation bar to display at the bottom of the scaffold.
  ///
  /// Snack bars slide from underneath the bottom navigation bar while bottom
  /// sheets are stacked on top.
  ///
  /// The [bottomNavigationBar] is rendered below the [persistentFooterButtons]
  /// and the [body].
  final Widget? bottomNavigationBar;

  /// The persistent bottom sheet to display.
  ///
  /// A persistent bottom sheet shows information that supplements the primary
  /// content of the app. A persistent bottom sheet remains visible even when
  /// the user interacts with other parts of the app.
  ///
  /// A closely related widget is a modal bottom sheet, which is an alternative
  /// to a menu or a dialog and prevents the user from interacting with the rest
  /// of the app. Modal bottom sheets can be created and displayed with the
  /// [showModalBottomSheet] function.
  ///
  /// Unlike the persistent bottom sheet displayed by [showBottomSheet]
  /// this bottom sheet is not a [LocalHistoryEntry] and cannot be dismissed
  /// with the scaffold appbar's back button.
  ///
  /// If a persistent bottom sheet created with [showBottomSheet] is already
  /// visible, it must be closed before building the Scaffold with a new
  /// [bottomSheet].
  ///
  /// The value of [bottomSheet] can be any widget at all. It's unlikely to
  /// actually be a [BottomSheet], which is used by the implementations of
  /// [showBottomSheet] and [showModalBottomSheet]. Typically it's a widget
  /// that includes [Material].
  ///
  /// See also:
  ///
  ///  * [showBottomSheet], which displays a bottom sheet as a route that can
  ///    be dismissed with the scaffold's back button.
  ///  * [showModalBottomSheet], which displays a modal bottom sheet.
  final Widget? bottomSheet;

  /// If true the [body] and the scaffold's floating widgets should size
  /// themselves to avoid the onscreen keyboard whose height is defined by the
  /// ambient [MediaQuery]'s [MediaQueryData.viewInsets] `bottom` property.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool? resizeToAvoidBottomInset;

  /// Whether this scaffold is being displayed at the top of the screen.
  ///
  /// If true then the height of the [appBar] will be extended by the height
  /// of the screen's status bar, i.e. the top padding for [MediaQuery].
  ///
  /// The default value of this property, like the default value of
  /// [AppBar.primary], is true.
  final bool primary;

  /// {@macro flutter.material.DrawerController.dragStartBehavior}
  final DragStartBehavior drawerDragStartBehavior;

  /// The width of the area within which a horizontal swipe will open the
  /// drawer.
  ///
  /// By default, the value used is 20.0 added to the padding edge of
  /// `MediaQuery.of(context).padding` that corresponds to the surrounding
  /// [TextDirection]. This ensures that the drag area for notched devices is
  /// not obscured. For example, if `TextDirection.of(context)` is set to
  /// [TextDirection.ltr], 20.0 will be added to
  /// `MediaQuery.of(context).padding.left`.
  final double? drawerEdgeDragWidth;

  /// Determines if the [Scaffold.drawer] can be opened with a drag
  /// gesture.
  ///
  /// By default, the drag gesture is enabled.
  final bool drawerEnableOpenDragGesture;

  /// Determines if the [Scaffold.endDrawer] can be opened with a
  /// drag gesture.
  ///
  /// By default, the drag gesture is enabled.
  final bool endDrawerEnableOpenDragGesture;

  /// Restoration ID to save and restore the state of the [Scaffold].
  ///
  /// If it is non-null, the scaffold will persist and restore whether the
  /// [drawer] and [endDrawer] was open or closed.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  @override
  State<StatefulWidget> createState() => _UIScaffoldState();
}

class _UIScaffoldState extends State<UIScaffold> {
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
    final useWebStyle = widget.webStyle ?? context.webStyle;
    if (context.isMobile || !useWebStyle) {
      final design = widget.designType ?? context.designType;
      final appBar = widget.appBar;
      final useSliver = !(appBar == null ||
              appBar is! UIAppBar ||
              !appBar._useSliverAppBar(context)) &&
          design == DesignType.modern;
      if (useSliver) {
        return Scaffold(
          key: widget.key,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                if (widget.appBar != null) widget.appBar!,
              ];
            },
            body: _loading(context),
          ),
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
          persistentFooterButtons: widget.persistentFooterButtons,
          drawer: widget.drawer,
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
        return Scaffold(
          key: widget.key,
          appBar: _toMobileAppBar(context),
          body: _loading(context),
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
          persistentFooterButtons: widget.persistentFooterButtons,
          drawer: widget.drawer,
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
    } else if (context.isModal) {
      return _WebModalView(
        widthRatio: widget.modalSizeRatio,
        heightRatio: widget.modalSizeRatio,
        child: Scaffold(
          key: widget.key,
          appBar: _toMobileAppBar(context),
          body: _loading(context),
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
          persistentFooterButtons: widget.persistentFooterButtons,
          drawer: widget.drawer,
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
        ),
      );
    } else if (context.navigator != context.rootNavigator) {
      return Scaffold(
        key: widget.key,
        appBar: _toInlineAppBar(context),
        body: _loading(context),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        drawer: widget.drawer,
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
      return Scaffold(
        key: widget.key,
        appBar: _toMainAppBar(context),
        body: _loading(context),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        drawer: widget.drawer,
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
        builder: (context) => _body(context),
      );
    } else {
      if (widget.loadingFutures.isEmpty) {
        return _body(context);
      }
      return LoadingBuilder(
        futures: widget.loadingFutures!,
        loading: widget.loadingWidget,
        indicatorColor: widget.loadingIndicatorColor,
        builder: (context) => _body(context),
      );
    }
  }

  Widget _body(BuildContext context) {
    final useWebStyle = widget.webStyle ?? context.webStyle;
    if (!useWebStyle ||
        context.isMobile ||
        widget.inlineNavigatorControllerOnWeb?.route?.name == null) {
      return widget.body ?? const Empty();
    }
    final body = widget.body;
    final appBar = widget.appBar;
    if (body is TabBarView) {
      if (appBar is UIAppBar && appBar.bottom is TabBar) {
        return _WebTabLayout(
          tabBar: appBar.bottom! as TabBar,
          tabBarView: body,
        );
      } else if (appBar is SliverAppBar && appBar.bottom is TabBar) {
        return _WebTabLayout(
          tabBar: appBar.bottom! as TabBar,
          tabBarView: body,
        );
      } else if (appBar is AppBar && appBar.bottom is TabBar) {
        return _WebTabLayout(
          tabBar: appBar.bottom! as TabBar,
          tabBarView: body,
        );
      }
    }

    return _WebAppLayout(
      builder: (context) => widget.body ?? const Empty(),
      controller: widget.inlineNavigatorControllerOnWeb!,
    );
  }

  PreferredSizeWidget? _toMobileAppBar(BuildContext context) {
    final appBar = widget.appBar;
    if (appBar == null) {
      return null;
    }
    if (appBar is AppBar) {
      return appBar;
    } else if (appBar is SliverAppBar) {
      return AppBar(
        leading: appBar.leading,
        automaticallyImplyLeading: appBar.automaticallyImplyLeading,
        title: appBar.title,
        actions: appBar.actions,
        flexibleSpace: appBar.flexibleSpace,
        bottom: appBar.bottom,
        elevation: appBar.elevation,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        backgroundColor: appBar.backgroundColor,
        foregroundColor: appBar.foregroundColor,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        primary: appBar.primary,
        centerTitle: appBar.centerTitle,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    } else if (appBar is UIAppBar) {
      return AppBar(
        leading: appBar.leading,
        automaticallyImplyLeading: appBar.automaticallyImplyLeading,
        title: _mobileAppBarTitle(
          context,
          title: appBar.title,
          subtitle: appBar.subtitle,
        ),
        elevation: appBar.elevation ??
            (appBar.borderColor != null ||
                    appBar.backgroundColor != null ||
                    appBar.background != null
                ? 1
                : 0),
        shadowColor:
            appBar.borderColor ?? context.theme.scaffoldBackgroundColor,
        backgroundColor:
            appBar.backgroundColor ?? context.theme.appBarTheme.backgroundColor,
        foregroundColor: appBar.foregroundColor,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        actions: appBar.actions,
        flexibleSpace: appBar.flexibleSpace,
        bottom: appBar.bottom,
        shape: appBar.shape,
        primary: appBar.primary,
        centerTitle: appBar.centerTitle,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    } else if (appBar is PreferredSizeWidget) {
      return appBar;
    }
    return null;
  }

  Widget? _mobileAppBarTitle(
    BuildContext context, {
    Widget? title,
    Widget? subtitle,
  }) {
    return subtitle == null
        ? title
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null) title,
              DefaultTextStyle(
                style: context.theme.textTheme.overline
                        ?.copyWith(color: context.theme.textColorOnPrimary) ??
                    TextStyle(color: context.theme.textColorOnPrimary),
                child: subtitle,
              ),
            ],
          );
  }

  PreferredSizeWidget? _toInlineAppBar(BuildContext context) {
    final appBar = widget.appBar;
    if (appBar == null) {
      return null;
    }
    if (appBar is AppBar) {
      return AppBar(
        leading: appBar.leading,
        automaticallyImplyLeading: false,
        title: DefaultTextStyle(
          style: context.theme.textTheme.headline6 ?? const TextStyle(),
          child: appBar.title ?? const Empty(),
        ),
        actions: appBar.actions
            ?.map(
              (e) => IconTheme(
                data: IconThemeData(color: context.theme.textColor),
                child: e,
              ),
            )
            .toList(),
        flexibleSpace: appBar.flexibleSpace,
        bottom: PreferredSize(
          child: Container(
            color: context.theme.dividerColor.withOpacity(0.25),
            height: 1.0,
            child: appBar.bottom,
          ),
          preferredSize: Size.fromHeight(
            (appBar.bottom?.preferredSize.height ?? 0.0) + 1.0,
          ),
        ),
        elevation: 0,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        backgroundColor: Colors.transparent,
        foregroundColor: context.theme.textColor,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        primary: appBar.primary,
        centerTitle: false,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarOpacity: appBar.toolbarOpacity,
        bottomOpacity: appBar.bottomOpacity,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    } else if (appBar is SliverAppBar) {
      return AppBar(
        leading: appBar.leading,
        automaticallyImplyLeading: false,
        title: DefaultTextStyle(
          style: context.theme.textTheme.headline6 ?? const TextStyle(),
          child: appBar.title ?? const Empty(),
        ),
        actions: appBar.actions
            ?.map(
              (e) => IconTheme(
                data: IconThemeData(color: context.theme.textColor),
                child: e,
              ),
            )
            .toList(),
        flexibleSpace: appBar.flexibleSpace,
        bottom: PreferredSize(
          child: Container(
            color: context.theme.dividerColor.withOpacity(0.25),
            height: 1.0,
            child: appBar.bottom,
          ),
          preferredSize: Size.fromHeight(
            (appBar.bottom?.preferredSize.height ?? 0.0) + 1.0,
          ),
        ),
        elevation: 0,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        backgroundColor: Colors.transparent,
        foregroundColor: context.theme.textColor,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        primary: appBar.primary,
        centerTitle: false,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    } else if (appBar is UIAppBar) {
      return AppBar(
        leading: appBar.leading,
        automaticallyImplyLeading: false,
        title: _inlineAppBarTitle(
          context,
          title: appBar.title,
          subtitle: appBar.subtitle,
        ),
        actions: appBar.actions
            ?.map(
              (e) => IconTheme(
                data: IconThemeData(color: context.theme.textColor),
                child: e,
              ),
            )
            .toList(),
        flexibleSpace: appBar.flexibleSpace,
        bottom: PreferredSize(
          child: Container(
            color: context.theme.dividerColor.withOpacity(0.25),
            height: 1.0,
            child: appBar.bottom,
          ),
          preferredSize: Size.fromHeight(
            (appBar.bottom?.preferredSize.height ?? 0.0) + 1.0,
          ),
        ),
        elevation: 0,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        backgroundColor: Colors.transparent,
        foregroundColor: context.theme.textColor,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        primary: appBar.primary,
        centerTitle: false,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    } else if (appBar is PreferredSizeWidget) {
      return appBar;
    }
    return null;
  }

  Widget? _inlineAppBarTitle(
    BuildContext context, {
    Widget? title,
    Widget? subtitle,
  }) {
    return subtitle == null
        ? DefaultTextStyle(
            style: context.theme.textTheme.headline6 ?? const TextStyle(),
            child: title ?? const Empty(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                DefaultTextStyle(
                  style: context.theme.textTheme.headline6 ?? const TextStyle(),
                  child: title,
                ),
              DefaultTextStyle(
                style: context.theme.textTheme.overline?.copyWith(
                      color: context.theme.disabledColor,
                    ) ??
                    const TextStyle(),
                child: subtitle,
              ),
            ],
          );
  }

  PreferredSizeWidget? _toMainAppBar(BuildContext context) {
    final appBar = widget.appBar;
    if (appBar == null) {
      return null;
    }
    if (appBar is AppBar) {
      return _WebMainAppBar(
        leading: appBar.leading,
        automaticallyImplyLeading: false,
        title: appBar.title,
        actions: appBar.actions,
        flexibleSpace: appBar.flexibleSpace,
        bottom: appBar.bottom is TabBar ? null : appBar.bottom,
        elevation: appBar.elevation,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        backgroundColor: Colors.transparent,
        foregroundColor: context.theme.textColor,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        primary: appBar.primary,
        centerTitle: false,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarOpacity: appBar.toolbarOpacity,
        bottomOpacity: appBar.bottomOpacity,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    } else if (appBar is SliverAppBar) {
      return _WebMainAppBar(
        leading: appBar.leading,
        automaticallyImplyLeading: false,
        title: appBar.title,
        actions: appBar.actions,
        flexibleSpace: appBar.flexibleSpace,
        bottom: appBar.bottom is TabBar ? null : appBar.bottom,
        elevation: appBar.elevation,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        backgroundColor: Colors.transparent,
        foregroundColor: context.theme.textColor,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        primary: appBar.primary,
        centerTitle: false,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    } else if (appBar is UIAppBar) {
      return _WebMainAppBar(
        leading: appBar.leading,
        automaticallyImplyLeading: false,
        title: appBar.title,
        subtitle: appBar.subtitle,
        actions: appBar.actions,
        flexibleSpace: appBar.flexibleSpace,
        bottom: appBar.bottom is TabBar ? null : appBar.bottom,
        elevation: appBar.elevation,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        backgroundColor: Colors.transparent,
        foregroundColor: context.theme.textColor,
        iconTheme: appBar.iconTheme,
        actionsIconTheme: appBar.actionsIconTheme,
        primary: appBar.primary,
        centerTitle: false,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        titleSpacing: appBar.titleSpacing,
        toolbarHeight: appBar.toolbarHeight,
        leadingWidth: appBar.leadingWidth,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
      );
    } else if (appBar is PreferredSizeWidget) {
      return appBar;
    }
    return null;
  }
}

class _WebMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  _WebMainAppBar({
    Key? key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.subtitle,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.subToolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
  })  : assert(elevation == null || elevation >= 0.0),
        preferredSize = Size.fromHeight(
          (toolbarHeight ??
                  kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)) +
              (subToolbarHeight ??
                  (title != null ? _kSubToolbarHeight + 1.0 : 0.0)),
        ),
        super(key: key);

  static const double _kSubToolbarHeight = 48;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  final Widget? title;
  final Widget? subtitle;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  @override
  final Size preferredSize;
  final double? toolbarHeight;
  final double? subToolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final tHeight =
        toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0.0);
    final title = _title(context);

    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: leading,
            automaticallyImplyLeading: false,
            title: app == null
                ? null
                : GestureDetector(
                    onTap: app.initialRoute.isEmpty
                        ? null
                        : () {
                            context.rootNavigator
                                .resetAndPushNamed(app.initialRoute);
                          },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: app.logoUrl.isNotEmpty
                          ? Image(
                              image: NetworkOrAsset.image(app.logoUrl!),
                              fit: BoxFit.fitHeight,
                              height: tHeight - 8,
                            )
                          : Text(app.title),
                    ),
                  ),
            actions: [
              if (app != null)
                ...app.menus.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: e.icon != null
                        ? TextButton.icon(
                            onPressed: () {
                              if (e.path.isEmpty) {
                                return;
                              }
                              context.rootNavigator.pushNamed(e.path!);
                            },
                            style: TextButton.styleFrom(
                              primary: foregroundColor ??
                                  context.theme.appBarTheme.foregroundColor ??
                                  context.theme.textColorOnPrimary,
                            ),
                            icon: Icon(e.icon),
                            label: Text(e.name),
                          )
                        : TextButton(
                            onPressed: () {
                              if (e.path.isEmpty) {
                                return;
                              }
                              context.rootNavigator.pushNamed(e.path!);
                            },
                            style: TextButton.styleFrom(
                              primary: foregroundColor ??
                                  context.theme.appBarTheme.foregroundColor ??
                                  context.theme.textColorOnPrimary,
                            ),
                            child: Text(e.name),
                          ),
                  ),
                ),
              if (actions != null) ...actions!,
              const Space.width(16),
            ],
            flexibleSpace: flexibleSpace,
            bottom: bottom,
            elevation: elevation,
            shadowColor: shadowColor,
            shape: shape,
            backgroundColor: context.theme.primaryColor,
            foregroundColor: foregroundColor,
            iconTheme: iconTheme,
            actionsIconTheme: actionsIconTheme,
            primary: primary,
            centerTitle: false,
            excludeHeaderSemantics: excludeHeaderSemantics,
            titleSpacing: titleSpacing,
            toolbarOpacity: toolbarOpacity,
            bottomOpacity: bottomOpacity,
            toolbarHeight: toolbarHeight,
            leadingWidth: leadingWidth,
            toolbarTextStyle: toolbarTextStyle,
            titleTextStyle: titleTextStyle,
            systemOverlayStyle: systemOverlayStyle,
          ),
          Container(
            height: _kSubToolbarHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
            child: IconTheme(
              data: IconThemeData(color: context.theme.disabledColor),
              child: Row(
                children: [
                  if (title != null) Expanded(child: title),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: context.theme.dividerColor.withOpacity(0.25),
          )
        ],
      ),
    );
  }

  Widget? _title(BuildContext context) {
    if (subtitle == null) {
      if (title != null) {
        return DefaultTextStyle(
          style: context.theme.textTheme.headline6
                  ?.copyWith(color: context.theme.disabledColor) ??
              TextStyle(
                fontSize: 18,
                color: context.theme.disabledColor,
                fontWeight: FontWeight.bold,
              ),
          child: title!,
        );
      } else {
        return null;
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          DefaultTextStyle(
            style: context.theme.textTheme.headline6?.copyWith(
                  color: context.theme.disabledColor,
                  fontSize: 18,
                ) ??
                TextStyle(
                  fontSize: 18,
                  color: context.theme.disabledColor,
                  fontWeight: FontWeight.bold,
                ),
            child: title!,
          ),
        DefaultTextStyle(
          style: context.theme.textTheme.overline?.copyWith(
                color: context.theme.disabledColor,
                fontSize: 10,
              ) ??
              TextStyle(
                color: context.theme.disabledColor,
                fontSize: 10,
              ),
          child: subtitle!,
        ),
      ],
    );
  }
}

class _WebTabLayout extends StatefulWidget {
  const _WebTabLayout({
    required this.tabBar,
    required this.tabBarView,
  });

  final TabBar tabBar;
  final TabBarView tabBarView;

  @override
  State<StatefulWidget> createState() => _WebTabLayoutState();
}

class _WebTabLayoutState extends State<_WebTabLayout>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  TabController? get effectiveController =>
      widget.tabBarView.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.tabBarView.controller == null) {
      _controller =
          TabController(length: widget.tabBar.tabs.length, vsync: this);
    }
    effectiveController?.addListener(_handledOnUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    effectiveController?.removeListener(_handledOnUpdate);
    _controller?.dispose();
  }

  @override
  void didUpdateWidget(_WebTabLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabBarView.controller != oldWidget.tabBarView.controller ||
        widget.tabBar.tabs.length != oldWidget.tabBar.tabs.length) {
      oldWidget.tabBarView.controller?.removeListener(_handledOnUpdate);
      _controller?.dispose();
      if (widget.tabBarView.controller == null) {
        _controller =
            TabController(length: widget.tabBar.tabs.length, vsync: this);
      }
      effectiveController?.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CMSLayout(
      sideBorder: const BorderSide(),
      leftBar: UIListBuilder<Widget>(
        source: widget.tabBar.tabs,
        builder: (context, item, index) {
          final i = widget.tabBar.tabs.indexOf(item);
          return [
            ListItem(
              title: item,
              selectedColor: context.theme.textColorOnPrimary,
              selectedTileColor: context.theme.primaryColor,
              selected: effectiveController!.index == i,
              onTap: () {
                effectiveController?.animateTo(i);
              },
            ),
          ];
        },
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: effectiveController,
        children: widget.tabBarView.children,
      ),
    );
  }
}

class _WebAppLayout extends StatefulWidget {
  const _WebAppLayout({required this.builder, required this.controller});

  final NavigatorController controller;
  final Widget Function(BuildContext context) builder;

  @override
  State<StatefulWidget> createState() => _WebAppLayoutState();
}

class _WebAppLayoutState extends State<_WebAppLayout> {
  Widget? _inlinePageCache;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(_WebAppLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Config.isMobile) {
      return;
    }
    if (widget.controller != oldWidget.controller) {
      _inlinePageCache = null;
      oldWidget.controller.removeListener(_handledOnUpdate);
      widget.controller.addListener(_handledOnUpdate);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CMSLayout(
      sideBorder: const BorderSide(),
      leftBar: widget.builder.call(context),
      child: _inlinePage(context),
    );
  }

  Widget _inlinePage(BuildContext context) {
    if (_inlinePageCache != null) {
      return _inlinePageCache!;
    }
    _inlinePageCache = InlinePageBuilder(controller: widget.controller);
    return _inlinePageCache!;
  }
}

class _WebModalView extends StatelessWidget {
  const _WebModalView({
    required this.child,
    // ignore: unused_element
    this.width,
    this.widthRatio,
    // ignore: unused_element
    this.height,
    this.heightRatio,
    // ignore: unused_element
    this.close,
    // ignore: unused_element
    this.borderRadius = 16.0,
  });
  final Widget child;
  final double? widthRatio;
  final double? heightRatio;
  final double? width;
  final double? height;
  final Widget? close;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuery.size;
    final w = width ??
        (widthRatio != null ? (size.width * (widthRatio ?? 1.0)) : null);
    final h = height ??
        (heightRatio != null ? (size.height * (heightRatio ?? 1.0)) : null);
    if (close != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: close,
          ),
          SizedBox(
            width: w,
            height: h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: child,
            ),
          )
        ],
      );
    } else {
      return SizedBox(
        width: w,
        height: h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      );
    }
  }
}
