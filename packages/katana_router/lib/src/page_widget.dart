part of katana_router;

/// Reference for page. Replaces [ValueNotifier].
/// ページ用のリファレンス。[ValueNotifier]を置き換えたものです。
///
/// Replacing this value will update the widget.
/// こちらの値を入れ替えるとウィジェットが更新されます。
typedef PageRef<T> = ValueNotifier<T>;

/// Widget-based for pages.
/// ページ用のウィジェットベース。
///
/// By giving a `value`, the corresponding [PageRef] will be passed in the [build] method.
/// `value`を与えることでそれに対応した[PageRef]が[build]メソッド内で渡されます。
///
/// Referencing or updating that [PageRef] will preserve or rebuild the widget's value.
/// その[PageRef]を参照したり、更新したりすることでウィジェットの値を保持したりリビルドしたりします。
@immutable
abstract class PageWidget<T> extends StatefulWidget {
  /// Widget-based for pages.
  /// ページ用のウィジェットベース。
  ///
  /// By giving a `value`, the corresponding [PageRef] will be passed in the [build] method.
  /// `value`を与えることでそれに対応した[PageRef]が[build]メソッド内で渡されます。
  ///
  /// Referencing or updating that [PageRef] will preserve or rebuild the widget's value.
  /// その[PageRef]を参照したり、更新したりすることでウィジェットの値を保持したりリビルドしたりします。
  const PageWidget(T value, {super.key}) : _value = value;

  final T _value;

  /// Run build.
  /// ビルドを行います。
  ///
  /// The context for the build is passed to [context].
  /// [context]にビルド用のコンテキストが渡されます。
  ///
  /// The [PageRef] associated with this [PageWidget] is passed to [page]. Page-related information is passed here. Also, updating `page.value` will rebuild the page.
  /// [page]にこの[PageWidget]に関連した[PageRef]が渡されます。ここにページ関連の情報が渡されます。また`page.value`を更新することでベージがリビルドされます。
  Widget build(BuildContext context, PageRef<T> page);

  @override
  State<StatefulWidget> createState() => PageWidgetState<T, PageWidget<T>>();
}

/// Create a state for [PageWidget].
/// [PageWidget]用ののステートを作成します。
class PageWidgetState<T, TState extends PageWidget<T>> extends State<TState> {
  late PageRef<T> _page;

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _page = PageRef(widget._value);
    _page.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(covariant TState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._value != oldWidget._value) {
      _page.removeListener(_handledOnUpdate);
      _page = PageRef(widget._value);
      _page.addListener(_handledOnUpdate);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _page.removeListener(_handledOnUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Theme.of(context).primaryColor),
        child: SafeArea(
          child: widget.build(context, _page),
        ),
      ),
    );
  }
}

/// A method to achieve the same functionality as [PageWidget] without the [T] argument.
/// [PageWidget]と同じ機能を[T]の引数を与えずに実現するためのメソッド。
///
/// When a widget is created, the [create] method is executed to create the necessary [T].
/// ウィジェット作成時に[create]メソッドが実行され必要な[T]を作成します。
///
/// PageRef] is created from that [T].
/// その[T]から[PageRef]が作成されます。
///
/// Referencing or updating that [PageRef] will preserve or rebuild the widget's value.
/// その[PageRef]を参照したり、更新したりすることでウィジェットの値を保持したりリビルドしたりします。
@immutable
abstract class PageWidgetBuilder<T> extends StatefulWidget {
  /// A method to achieve the same functionality as [PageWidget] without the [T] argument.
  /// [PageWidget]と同じ機能を[T]の引数を与えずに実現するためのメソッド。
  ///
  /// When a widget is created, the [create] method is executed to create the necessary [T].
  /// ウィジェット作成時に[create]メソッドが実行され必要な[T]を作成します。
  ///
  /// PageRef] is created from that [T].
  /// その[T]から[PageRef]が作成されます。
  ///
  /// Referencing or updating that [PageRef] will preserve or rebuild the widget's value.
  /// その[PageRef]を参照したり、更新したりすることでウィジェットの値を保持したりリビルドしたりします。
  const PageWidgetBuilder({super.key});

  /// Runs when a widget is created and creates a [T] object associated with the page.
  /// ウィジェット作成時に実行され、ページに関連した[T]のオブジェクトを作成します。
  ///
  /// PageRef] is created from that [T].
  /// その[T]から[PageRef]が作成されます。
  T create();

  /// Run build.
  /// ビルドを行います。
  ///
  /// The context for the build is passed to [context].
  /// [context]にビルド用のコンテキストが渡されます。
  ///
  /// The [PageRef] associated with this [PageWidget] is passed to [page]. Page-related information is passed here. Also, updating `page.value` will rebuild the page.
  /// [page]にこの[PageWidget]に関連した[PageRef]が渡されます。ここにページ関連の情報が渡されます。また`page.value`を更新することでベージがリビルドされます。
  Widget build(BuildContext context, PageRef<T> page);

  @override
  State<StatefulWidget> createState() =>
      PageWidgetBuilderState<T, PageWidgetBuilder<T>>();
}

/// Create a state for [PageWidgetBuilder].
/// [PageWidgetBuilder]用ののステートを作成します。
class PageWidgetBuilderState<T, TState extends PageWidgetBuilder<T>>
    extends State<TState> {
  late PageRef<T> _page;

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _page = PageRef(widget.create());
    _page.addListener(_handledOnUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _page.removeListener(_handledOnUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Theme.of(context).primaryColor),
        child: SafeArea(
          child: widget.build(context, _page),
        ),
      ),
    );
  }
}
