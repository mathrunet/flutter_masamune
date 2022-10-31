part of katana_scoped;

/// Widgets for state management within a page or widget.
///
/// Be sure to place it under [PageScopedWidget].
///
/// Make sure to pass [page] that matches [TPage].
///
/// By passing [builder], you can place the widget you wish to reflect the update in it.
///
/// ページの中やウィジェットの中で状態管理を行うためのウィジェット。
///
/// 必ず[PageScopedWidget]の配下にくるように配置してください。
///
/// [TPage]に合う[page]を渡すようにしてください。
///
/// [builder]を渡すことでその中に更新を反映したいウィジェットを配置することができます。
@immutable
class Scoped<TPage extends PageScopedWidget> extends StatefulWidget {
  /// Widgets for state management within a page or widget.
  ///
  /// Be sure to place it under [PageScopedWidget].
  ///
  /// Make sure to pass [page] that matches [TPage].
  ///
  /// By passing [builder], you can place the widget you wish to reflect the update in it.
  ///
  /// ページの中やウィジェットの中で状態管理を行うためのウィジェット。
  ///
  /// 必ず[PageScopedWidget]の配下にくるように配置してください。
  ///
  /// [TPage]に合う[page]を渡すようにしてください。
  ///
  /// [builder]を渡すことでその中に更新を反映したいウィジェットを配置することができます。
  const Scoped({
    super.key,
    required this.page,
    required this.builder,
  });

  /// PageScopedWidget] placed at the top.
  ///
  /// You can refer to the value passed to the page.
  ///
  /// 上部に設置されている[PageScopedWidget]。
  ///
  /// ページに渡されている値を参照することができます。
  final TPage page;

  /// A builder for building widgets under the page.
  ///
  /// When an update is notified in [ScopedValue] referenced by [WidgetRef], the widget in this widget will also be updated.
  ///
  /// ページ配下のウィジェットをビルドするためのビルダー。
  ///
  /// [WidgetRef]で参照された[ScopedValue]における更新が通知された場合この中のウィジェットも更新されます。
  final Widget Function(BuildContext context, WidgetRef ref) builder;

  @override
  State<StatefulWidget> createState() => _ScopedState<TPage>();
}

class _ScopedState<TPage extends PageScopedWidget>
    extends State<Scoped<TPage>> {
  late final ScopedValueContainer _container;
  late final AppScopedValueListener _appListener;
  late final PageScopedValueListener _pageListener;
  late final ScopedValueListener _widgetListener;
  late final WidgetRef _ref;

  @override
  void initState() {
    super.initState();
    _container = ScopedValueContainer();
    _appListener = AppScopedValueListener._(
      context: context,
      callback: _handledOnRebuild,
    );
    _pageListener = PageScopedValueListener._(
      context: context,
      callback: _handledOnRebuild,
    );
    _widgetListener = ScopedValueListener._(
      context: context,
      callback: _handledOnRebuild,
      container: _container,
    );
    _ref = WidgetRef._(
      appListener: _appListener,
      pageListener: _pageListener,
      widgetListener: _widgetListener,
      context: context,
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    _appListener.diactivate();
    _pageListener.diactivate();
    _widgetListener.diactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _appListener.dispose();
    _pageListener.dispose();
    _widgetListener.dispose();
  }

  void _handledOnRebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _ref,
    );
  }
}

/// Abstract class for creating widgets that can perform state management under the page.
///
/// Be sure to place the created widget under [PageScopedWidget].
///
/// Make sure to pass [page] that matches [TPage].
///
/// ページの配下で状態管理を行うことが可能なウィジェットを作成するための抽象クラス。
///
/// 作成したウィジェットは必ず[PageScopedWidget]の配下にくるように配置してください。
///
/// [TPage]に合う[page]を渡すようにしてください。
abstract class ScopedWidget<TPage extends PageScopedWidget>
    extends StatefulWidget {
  /// Abstract class for creating widgets that can perform state management under the page.
  ///
  /// Be sure to place the created widget under [PageScopedWidget].
  ///
  /// Make sure to pass [page] that matches [TPage].
  ///
  /// ページの配下で状態管理を行うことが可能なウィジェットを作成するための抽象クラス。
  ///
  /// 作成したウィジェットは必ず[PageScopedWidget]の配下にくるように配置してください。
  ///
  /// [TPage]に合う[page]を渡すようにしてください。
  const ScopedWidget({
    super.key,
    required this.page,
  });

  /// PageScopedWidget] placed at the top.
  ///
  /// You can refer to the value passed to the page.
  ///
  /// 上部に設置されている[PageScopedWidget]。
  ///
  /// ページに渡されている値を参照することができます。
  final TPage page;

  /// Build the internal widget.
  ///
  /// The [context] used during the build is passed as is.
  ///
  /// Also, [WidgetRef] is passed to [ref] to update the state.
  ///
  /// 内部のウィジェットをビルドします。
  ///
  /// ビルド中に使用される[context]がそのまま渡されます。
  ///
  /// また、[ref]に状態を更新するための[WidgetRef]が渡されます。
  Widget build(BuildContext context, WidgetRef ref);

  @override
  State<StatefulWidget> createState() => _ScopedWidgetState<TPage>();
}

class _ScopedWidgetState<TPage extends PageScopedWidget>
    extends State<ScopedWidget> {
  @override
  Widget build(BuildContext context) {
    return Scoped(
      page: widget.page,
      builder: widget.build,
    );
  }
}

/// Abstract class for creating widgets for use on pages.
///
/// Since [PageRef] is passed to [build], you can subscribe to it to update the internal widget according to update notifications.
///
/// ページで利用するウィジェットを作成するための抽象クラス。
///
/// [build]に[PageRef]が渡されるためそれを購読することで更新通知に応じて内部のウィジェットを更新することができます。
abstract class PageScopedWidget extends StatefulWidget {
  const PageScopedWidget({super.key});

  /// Build the internal widget.
  ///
  /// The [context] used during the build is passed as is.
  ///
  /// Also, [WidgetRef] is passed to [ref] to update the state.
  ///
  /// 内部のウィジェットをビルドします。
  ///
  /// ビルド中に使用される[context]がそのまま渡されます。
  ///
  /// また、[ref]に状態を更新するための[PageRef]が渡されます。
  Widget build(BuildContext context, PageRef ref);

  @override
  State<StatefulWidget> createState() => _PageScopedWidgetState();
}

class _PageScopedWidgetState extends State<PageScopedWidget> {
  late final ScopedValueContainer _container;
  late final AppScopedValueListener _appListener;
  late final ScopedValueListener _pageListener;
  late final PageRef _ref;

  @override
  void initState() {
    super.initState();
    _container = ScopedValueContainer();
    _appListener = AppScopedValueListener._(
      context: context,
      callback: _handledOnRebuild,
    );
    _pageListener = ScopedValueListener._(
      context: context,
      callback: _handledOnRebuild,
      container: _container,
    );
    _ref = PageRef._(
      appListener: _appListener,
      pageListener: _pageListener,
      context: context,
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    _appListener.diactivate();
    _pageListener.diactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _appListener.dispose();
    _pageListener.dispose();
  }

  void _handledOnRebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _PageScopedScope(
      state: this,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: widget.build(context, _ref),
      ),
    );
  }
}
