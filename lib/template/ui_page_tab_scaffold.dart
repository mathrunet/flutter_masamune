part of masamune;

/// Abstract class for Scaffold pages for tabs.
///
/// Please pass the IDataCollection data to [source].
///
/// Please inherit and use.
abstract class UIPageTabScaffold extends UIPageScaffold {
  /// Abstract class for creating pages.
  UIPageTabScaffold({Key? key}) : super(key: key);

  final _UITabData _tabData = _UITabData();

  /// Source data for tab.
  Iterable get source;

  /// Tab controller.
  TabController? get tabController => _tabData.controller;

  /// View of tabs.
  ///
  /// [context]: Build context.
  List<Widget> tabView(BuildContext context);

  /// The color of the indicator on the tab.
  ///
  /// [context]: Build context.
  Color indicatorColor(BuildContext context) => context.theme.accentColor;

  /// Tab label style.
  ///
  /// [context]: Build context.
  TextStyle labelStyle(BuildContext context) =>
      context.theme.textTheme.bodyText1 ?? const TextStyle();

  /// Tab.
  ///
  /// [context]: Build context.
  List<Widget> tabs(BuildContext context) {
    return source.mapAndRemoveEmpty((item) => Text(item));
  }

  /// Tab bar. Place this in the bottom of the AppBar.
  ///
  /// [context]: Build context.
  TabBar tabBar(BuildContext context) {
    return TabBar(
      indicatorColor: indicatorColor(context),
      controller: tabController,
      labelStyle: labelStyle(context),
      labelPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      isScrollable: true,
      tabs: tabs(context),
    );
  }

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  Widget body(BuildContext context) {
    return TabBarView(controller: tabController, children: tabView(context));
  }

  /// Callback for building.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @override
  Widget build(BuildContext context) {
    return _FlexibleTabController(
        key: key,
        data: source,
        child: (context, controller) {
          _tabData.controller = controller;
          return super.build(context);
        });
  }
}

class _UITabData {
  TabController? controller;
}

/// Tab controller in which the number of tabs is variable depending on the given Collection.
///
/// Give an ICollection to [data] and change the number of tabs by changing that collection.
class _FlexibleTabController extends StatefulWidget {
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
  final Iterable data;

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
  static TabController? of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_FlexibleTabControllerScope>();
    return scope?.controller;
  }

  /// Create a state.
  ///
  /// Do not use from outside.
  @override
  @protected
  _FlexibleTabControllerState createState() => _FlexibleTabControllerState();
}

class _FlexibleTabControllerState extends State<_FlexibleTabController>
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
