part of masamune.ui;

extension WidgetRefTabControllerExtensions on WidgetRef {
  TabContext<T> useTab<T>(List<T> source) {
    return valueBuilder<TabContext<T>, _TabContextValue<T>>(
      key: "tab",
      builder: () {
        return _TabContextValue<T>._(
          context: this as BuildContext,
          source: source,
        );
      },
    );
  }

  TabController useTabController({
    required int initialLength,
    TickerProvider? vsync,
    int initialIndex = 0,
  }) {
    return valueBuilder<TabController, _TabControllerValue>(
      key: "tabController",
      builder: () {
        return _TabControllerValue(
          initialIndex: initialIndex,
          vsync: vsync,
          initialLength: initialLength,
        );
      },
    );
  }

  TickerProvider useSingleTickerProvider() {
    return valueBuilder<TickerProvider, _TickerProviderValue>(
      key: "singleTickerProvider",
      builder: () {
        return const _TickerProviderValue();
      },
    );
  }
}

@immutable
class _TabControllerValue extends ScopedValue<TabController> {
  const _TabControllerValue({
    required this.initialLength,
    this.vsync,
    this.initialIndex = 0,
  });

  final int initialLength;
  final TickerProvider? vsync;
  final int initialIndex;

  @override
  ScopedValueState<TabController, ScopedValue<TabController>> createState() =>
      _TabControllerValueState();
}

class _TabControllerValueState
    extends ScopedValueState<TabController, _TabControllerValue>
    implements TickerProvider {
  late TabController _controller;
  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null) {
        return true;
      }
      throw FlutterError(
          'You attempted to use a TickerProviderContainer multiple times.\n'
          'A SingleTickerProviderStateMixin can only be used as a TickerProvider once. '
          'If you need multiple Ticker, consider using useSingleTickerProvider multiple times '
          'to create as many Tickers as needed.');
    }(), '');
    return _ticker =
        Ticker(onTick, debugLabel: 'created by TickerProviderContainer');
  }

  @override
  void initValue() {
    super.initValue();
    _controller = TabController(
      length: value.initialLength,
      vsync: value.vsync ?? this,
      initialIndex: value.initialIndex,
    );
  }

  @override
  void didUpdateValue(_TabControllerValue oldValue) {
    super.didUpdateValue(oldValue);
    if (value.initialLength != oldValue.initialLength) {
      _controller.dispose();
      _controller = TabController(
        length: value.initialLength,
        vsync: value.vsync ?? this,
        initialIndex: value.initialIndex,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  TabController build() => _controller;
}

@immutable
class _TickerProviderValue extends ScopedValue<TickerProvider> {
  const _TickerProviderValue();

  @override
  ScopedValueState<TickerProvider, ScopedValue<TickerProvider>> createState() =>
      _TickerProviderValueState();
}

class _TickerProviderValueState
    extends ScopedValueState<TickerProvider, _TickerProviderValue>
    implements TickerProvider {
  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null) {
        return true;
      }
      throw FlutterError(
          'You attempted to use a TickerProviderContainer multiple times.\n'
          'A SingleTickerProviderStateMixin can only be used as a TickerProvider once. '
          'If you need multiple Ticker, consider using useSingleTickerProvider multiple times '
          'to create as many Tickers as needed.');
    }(), '');
    return _ticker =
        Ticker(onTick, debugLabel: 'created by TickerProviderContainer');
  }

  @override
  TickerProvider build() => this;
}

@immutable
class _TabContextValue<T> extends ScopedValue<TabContext<T>> {
  const _TabContextValue._({
    required this.source,
    required BuildContext context,
  })  : length = source.length,
        _context = context;

  final BuildContext _context;
  final int length;
  final List<T> source;

  @override
  ScopedValueState<TabContext<T>, ScopedValue<TabContext<T>>> createState() =>
      TabContext<T>._();
}

class TabContext<T> extends ScopedValueState<TabContext<T>, _TabContextValue<T>>
    implements TickerProvider {
  TabContext._();

  late TabController _controller;
  Ticker? _ticker;

  TabController get controller => _controller;

  int get length => value.length;
  List<T> get source => value.source;

  BuildContext get _context => value._context;

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null) {
        return true;
      }
      throw FlutterError(
          'You attempted to use a TickerProviderContainer multiple times.\n'
          'A SingleTickerProviderStateMixin can only be used as a TickerProvider once. '
          'If you need multiple Ticker, consider using useSingleTickerProvider multiple times '
          'to create as many Tickers as needed.');
    }(), '');
    return _ticker =
        Ticker(onTick, debugLabel: 'created by TickerProviderContainer');
  }

  @override
  void initValue() {
    super.initValue();
    _controller = TabController(
      length: value.length,
      vsync: this,
    );
  }

  @override
  void didUpdateValue(_TabContextValue<T> oldValue) {
    super.didUpdateValue(oldValue);
    if (value.length != oldValue.length) {
      _controller.dispose();
      _controller = TabController(
        length: value.length,
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  TabContext<T> build() => this;
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
