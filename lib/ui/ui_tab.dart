part of masamune.ui;

TabContext<T> useTab<T>(List<T> source) {
  final context = useContext();
  final controller = useTabController(
    initialLength: source.length,
    keys: [source.length],
  );
  return TabContext<T>._(
    context: context,
    controller: controller,
    source: source,
  );
}

class TabContext<T> {
  const TabContext._({
    required this.controller,
    required this.source,
    required BuildContext context,
  })  : length = source.length,
        _context = context;

  final BuildContext _context;
  final int length;
  final List<T> source;
  final TabController controller;
}

class UITabBar<T> extends TabBar {
  /// Creates a material design tab bar.
  ///
  /// The [tabs] argument must not be null and its length must match the [controller]'s
  /// [TabController.length].
  ///
  /// If a [TabController] is not provided, then there must be a
  /// [DefaultTabController] ancestor.
  ///
  /// The [indicatorWeight] parameter defaults to 2, and must not be null.
  ///
  /// The [indicatorPadding] parameter defaults to [EdgeInsets.zero], and must not be null.
  ///
  /// If [indicator] is not null or provided from [TabBarTheme],
  /// then [indicatorWeight], [indicatorPadding], and [indicatorColor] are ignored.
  UITabBar(
    TabContext tab, {
    Key? key,
    Widget? Function(BuildContext context, T item)? builder,
    bool isScrollable = false,
    Color? indicatorColor,
    bool automaticIndicatorColorAdjustment = true,
    double indicatorWeight = 2.0,
    EdgeInsetsGeometry indicatorPadding = EdgeInsets.zero,
    Decoration? indicator,
    TabBarIndicatorSize? indicatorSize,
    Color? labelColor,
    TextStyle? labelStyle,
    EdgeInsetsGeometry labelPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    MaterialStateProperty<Color?>? overlayColor,
    MouseCursor? mouseCursor,
    bool? enableFeedback,
    void Function(T item)? onTap,
    ScrollPhysics? physics,
  }) : super(
          tabs: tab.source.mapAndRemoveEmpty((item) {
            if (builder != null) {
              return builder.call(tab._context, item);
            }
            return Text(item.toString());
          }),
          controller: tab.controller,
          key: key,
          isScrollable: isScrollable,
          indicatorColor: indicatorColor,
          automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment,
          indicatorWeight: indicatorWeight,
          indicatorPadding: indicatorPadding,
          indicator: indicator,
          indicatorSize: indicatorSize,
          labelColor: labelColor,
          labelStyle: labelStyle,
          labelPadding: labelPadding,
          unselectedLabelColor: unselectedLabelColor,
          unselectedLabelStyle: unselectedLabelStyle,
          dragStartBehavior: dragStartBehavior,
          overlayColor: overlayColor,
          mouseCursor: mouseCursor,
          enableFeedback: enableFeedback,
          onTap: onTap != null ? (i) => onTap.call(tab.source[i]) : null,
          physics: physics,
        );
}

class UITabView<T> extends TabBarView {
  UITabView(
    this.tab, {
    Key? key,
    required this.builder,
    ScrollPhysics? physics,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) : super(
          key: key,
          children: tab.source.mapAndRemoveEmpty(
              (item) => builder.call(tab._context, item, PageStorageKey(item))),
          controller: tab.controller,
          physics: physics,
          dragStartBehavior: dragStartBehavior,
        );

  final TabContext tab;

  /// One widget per tab.
  ///
  /// Its length must match the length of the [TabBar.tabs]
  /// list, as well as the [controller]'s [TabController.length].
  final Widget? Function(BuildContext context, T item, Key key) builder;
}
