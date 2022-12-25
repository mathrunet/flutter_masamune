part of katana_scoped;

/// Widgets for state management within a page or widget.
///
/// Be sure to place it under [PageScopedWidget].
///
/// By passing [builder], you can place the widget you wish to reflect the update in it.
///
/// ページの中やウィジェットの中で状態管理を行うためのウィジェット。
///
/// 必ず[PageScopedWidget]の配下にくるように配置してください。
///
/// [builder]を渡すことでその中に更新を反映したいウィジェットを配置することができます。
@immutable
class Scoped extends StatefulWidget {
  /// Widgets for state management within a page or widget.
  ///
  /// Be sure to place it under [PageScopedWidget].
  ///
  /// By passing [builder], you can place the widget you wish to reflect the update in it.
  ///
  /// ページの中やウィジェットの中で状態管理を行うためのウィジェット。
  ///
  /// 必ず[PageScopedWidget]の配下にくるように配置してください。
  ///
  /// [builder]を渡すことでその中に更新を反映したいウィジェットを配置することができます。
  const Scoped({
    super.key,
    this.page,
    required this.builder,
  });

  @Deprecated("Delete the page as there is no need to pass it on.")
  final PageScopedWidget? page;

  /// A builder for building widgets under the page.
  ///
  /// When an update is notified in [ScopedValue] referenced by [WidgetRef], the widget in this widget will also be updated.
  ///
  /// ページ配下のウィジェットをビルドするためのビルダー。
  ///
  /// [WidgetRef]で参照された[ScopedValue]における更新が通知された場合この中のウィジェットも更新されます。
  final Widget Function(BuildContext context, WidgetRef ref) builder;

  @override
  State<StatefulWidget> createState() => _ScopedState();
}

class _ScopedState extends State<Scoped> {
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
/// You can get the widget content with [ScopedWidgetScope.of] since it inherits from [ScopedWidgetBase].
///
/// ページの配下で状態管理を行うことが可能なウィジェットを作成するための抽象クラス。
///
/// 作成したウィジェットは必ず[PageScopedWidget]の配下にくるように配置してください。
///
/// [ScopedWidgetBase]を継承しているため[ScopedWidgetScope.of]でウィジェットの内容を取得できます。
abstract class ScopedWidget extends StatefulWidget implements ScopedWidgetBase {
  /// Abstract class for creating widgets that can perform state management under the page.
  ///
  /// Be sure to place the created widget under [PageScopedWidget].
  ///
  /// You can get the widget content with [ScopedWidgetScope.of] since it inherits from [ScopedWidgetBase].
  ///
  /// ページの配下で状態管理を行うことが可能なウィジェットを作成するための抽象クラス。
  ///
  /// 作成したウィジェットは必ず[PageScopedWidget]の配下にくるように配置してください。
  ///
  /// [ScopedWidgetBase]を継承しているため[ScopedWidgetScope.of]でウィジェットの内容を取得できます。
  const ScopedWidget({
    super.key,
    this.page,
  });

  @Deprecated("Delete the page as there is no need to pass it on.")
  final PageScopedWidget? page;

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
  State<StatefulWidget> createState() => _ScopedWidgetState();
}

class _ScopedWidgetState extends State<ScopedWidget> {
  @override
  Widget build(BuildContext context) {
    return ScopedWidgetScope(
      widget: widget,
      child: Scoped(
        page: widget.page,
        builder: widget.build,
      ),
    );
  }
}

/// Abstract class for creating widgets for use on pages.
///
/// Since [PageRef] is passed to [build], you can subscribe to it to update the internal widget according to update notifications.
///
/// ScopedWidgetScope.of] to get the widget's content, since it inherits from [ScopedWidgetBase].
///
/// ページで利用するウィジェットを作成するための抽象クラス。
///
/// [build]に[PageRef]が渡されるためそれを購読することで更新通知に応じて内部のウィジェットを更新することができます。
///
/// [ScopedWidgetBase]を継承しているため[ScopedWidgetScope.of]でウィジェットの内容を取得できます。
abstract class PageScopedWidget extends StatefulWidget
    implements ScopedWidgetBase {
  /// Abstract class for creating widgets for use on pages.
  ///
  /// Since [PageRef] is passed to [build], you can subscribe to it to update the internal widget according to update notifications.
  ///
  /// ScopedWidgetScope.of] to get the widget's content, since it inherits from [ScopedWidgetBase].
  ///
  /// ページで利用するウィジェットを作成するための抽象クラス。
  ///
  /// [build]に[PageRef]が渡されるためそれを購読することで更新通知に応じて内部のウィジェットを更新することができます。
  ///
  /// [ScopedWidgetBase]を継承しているため[ScopedWidgetScope.of]でウィジェットの内容を取得できます。
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
      child: ScopedWidgetScope(
        widget: widget,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: widget.build(context, _ref),
        ),
      ),
    );
  }
}

/// Base class from which widgets can be retrieved with [ScopedWidgetScope.of].
///
/// [PageScopedWidget] and [ScopedWidget].
///
/// [ScopedWidgetScope.of]でウィジェットを取り出し可能なベースクラス。
///
/// [PageScopedWidget]と[ScopedWidget]があります。
abstract class ScopedWidgetBase extends Widget {
  /// Base class from which widgets can be retrieved with [ScopedWidgetScope.of].
  ///
  /// [PageScopedWidget] and [ScopedWidget].
  ///
  /// [ScopedWidgetScope.of]でウィジェットを取り出し可能なベースクラス。
  ///
  /// [PageScopedWidget]と[ScopedWidget]があります。
  const ScopedWidgetBase({super.key});
}

/// [InheritedWidget] for making [ScopedWidgetBase] retrievable from descendant widgets.
///
/// Pass a class inheriting from [PageScopedWidget] or [ScopedWidget] to [widget].
///
/// [ScopedWidgetScope.of] allows you to retrieve the widget in the ancestor.
///
/// [ScopedWidgetBase]を子孫ウィジェットから取り出し可能にするための[InheritedWidget]。
///
/// [widget]に[PageScopedWidget]や[ScopedWidget]を継承したクラスを渡します。
///
/// [ScopedWidgetScope.of]で先祖にあるウィジェットを取り出すことができます。
class ScopedWidgetScope extends StatefulWidget {
  /// [InheritedWidget] for making [ScopedWidgetBase] retrievable from descendant widgets.
  ///
  /// Pass a class inheriting from [PageScopedWidget] or [ScopedWidget] to [widget].
  ///
  /// [ScopedWidgetScope.of] allows you to retrieve the widget in the ancestor.
  ///
  /// [ScopedWidgetBase]を子孫ウィジェットから取り出し可能にするための[InheritedWidget]。
  ///
  /// [widget]に[PageScopedWidget]や[ScopedWidget]を継承したクラスを渡します。
  ///
  /// [ScopedWidgetScope.of]で先祖にあるウィジェットを取り出すことができます。
  const ScopedWidgetScope({
    super.key,
    required this.child,
    required this.widget,
  });

  /// Widgets that inherit from [ScopedWidgetBase].
  ///
  /// [ScopedWidgetBase]を継承したウィジェット。
  final ScopedWidgetBase widget;

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// Pass [context] to retrieve [TWidget] in the ancestor.
  ///
  /// If [TWidget] does not exist in the ancestor, an error is output.
  ///
  /// [context]を渡して祖先にある[TWidget]を取り出します。
  ///
  /// 祖先に[TWidget]が存在しない場合はエラーが出力されます。
  static TWidget of<TWidget extends ScopedWidgetBase>(BuildContext context) {
    _ScopedWidgetScope? scope;
    if (context.widget is TWidget) {
      return context.widget as TWidget;
    }
    do {
      scope = context
          .getElementForInheritedWidgetOfExactType<_ScopedWidgetScope>()
          ?.widget as _ScopedWidgetScope?;
      if (scope == null) {
        break;
      }
      if (scope.state.widget.widget is TWidget) {
        break;
      }
      context = scope.state.context;
    } while (scope.state.widget.widget is! TWidget);
    assert(
      scope != null && scope.state.widget.widget is TWidget,
      "Could not find $TWidget. Please define $TWidget in the element above.",
    );
    return scope!.state.widget.widget as TWidget;
  }

  @override
  State<StatefulWidget> createState() => _ScopedWidgetScopeState();
}

class _ScopedWidgetScopeState extends State<ScopedWidgetScope> {
  @override
  Widget build(BuildContext context) {
    return _ScopedWidgetScope(
      state: this,
      child: widget.child,
    );
  }
}

class _ScopedWidgetScope extends InheritedWidget {
  const _ScopedWidgetScope({
    required super.child,
    required this.state,
  });

  final _ScopedWidgetScopeState state;

  @override
  bool updateShouldNotify(_ScopedWidgetScope oldWidget) => false;
}
