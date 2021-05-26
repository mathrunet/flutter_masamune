part of masamune;

/// Abstract class for Scaffold pages for tabs.
///
/// Please pass the IDataCollection data to [source].
///
/// Please inherit and use.
class TabScaffold<T> extends StatefulWidget {
  /// Abstract class for creating pages.
  const TabScaffold(
      {Key? key,
      this.title,
      this.actions,
      this.leading,
      this.automaticallyImplyLeading = true,
      this.tabLabelStyle,
      this.indicatorColor,
      this.tabLabelPadding =
          const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      required this.source,
      required this.tabBuilder,
      required this.viewBuilder,
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
      this.centerTitle})
      : super(key: key);

  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final TextStyle? tabLabelStyle;
  final Color? indicatorColor;
  final EdgeInsetsGeometry tabLabelPadding;
  final List<T> source;
  final Widget Function(T item) tabBuilder;
  final Widget Function(T item) viewBuilder;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;

  @override
  State<StatefulWidget> createState() => _TabScaffoldState<T>();
}

class _TabScaffoldState<T> extends State<TabScaffold<T>> {
  /// Callback for building.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @override
  Widget build(BuildContext context) {
    return _FlexibleTabController<T>(
      key: widget.key,
      data: widget.source,
      child: (context, controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: widget.centerTitle,
            leading: widget.leading,
            title: widget.title,
            actions: widget.actions,
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            bottom: TabBar(
              indicatorColor:
                  widget.indicatorColor ?? context.theme.accentColor,
              controller: controller,
              labelStyle: widget.tabLabelStyle ??
                  context.theme.textTheme.bodyText1 ??
                  const TextStyle(),
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              isScrollable: true,
              tabs: widget.source.mapAndRemoveEmpty((item) {
                return widget.tabBuilder.call(item);
              }),
            ),
          ),
          body: TabBarView(
            controller: controller,
            children: widget.source.mapAndRemoveEmpty(
              (item) {
                return widget.viewBuilder.call(item);
              },
            ),
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
        );
      },
    );
  }
}

/// Tab controller in which the number of tabs is variable depending on the given Collection.
///
/// Give an ICollection to [data] and change the number of tabs by changing that collection.
class _FlexibleTabController<T> extends StatefulWidget {
  /// Tab controller in which the number of tabs is variable depending on the given Collection.
  ///
  /// Give an ICollection to [data] and change the number of tabs by changing that collection.
  ///
  /// [key]: Widget key.
  /// [data]: Data collection.
  /// [initialIndex]: First index number.
  /// [child]: Nesting widget.
  const _FlexibleTabController({
    Key? key,
    required this.data,
    this.initialIndex = 0,
    required this.child,
    this.onUpdateIndex,
  }) : super(key: key);

  final void Function(int index)? onUpdateIndex;

  /// Collection data for tabs.
  final Iterable<T> data;

  /// First index number.
  final int initialIndex;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Scaffold] whose [AppBar] includes a [TabBar].
  ///
  /// [context]: BuildContext.
  /// [controller]: Tab controller.
  final Widget Function(BuildContext context, TabController? controller) child;

  /// The closest instance of this class that encloses the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// TabController controller = FlexibleTabController.of(context);
  /// ```
  // static TabController? of(BuildContext context) {
  //   final scope = context
  //       .dependOnInheritedWidgetOfExactType<_FlexibleTabControllerScope>();
  //   return scope?.controller;
  // }

  /// Create a state.
  ///
  /// Do not use from outside.
  @override
  @protected
  _FlexibleTabControllerState createState() => _FlexibleTabControllerState<T>();
}

class _FlexibleTabControllerState<T> extends State<_FlexibleTabController>
    with TickerProviderStateMixin {
  TabController? _controller;
  @override
  void initState() {
    super.initState();
    final index = widget.initialIndex;
    _controller = TabController(
      vsync: this,
      length: widget.data.length,
      initialIndex: index,
    );
    _controller?.addListener(_updateIndex);
  }

  @override
  void dispose() {
    _controller?.removeListener(_updateIndex);
    _controller?.dispose();
    super.dispose();
  }

  void _updateIndex() {
    widget.onUpdateIndex?.call(_controller?.index ?? 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _FlexibleTabControllerScope(
      controller: _controller,
      enabled: TickerMode.of(context),
      child: widget.child(context, _controller),
    );
  }
}

class _FlexibleTabControllerScope extends InheritedWidget {
  const _FlexibleTabControllerScope({
    Key? key,
    this.controller,
    this.enabled = false,
    required Widget child,
  }) : super(key: key, child: child);
  final TabController? controller;
  final bool enabled;
  @override
  bool updateShouldNotify(_FlexibleTabControllerScope old) {
    return enabled != old.enabled || controller != old.controller;
  }
}
