part of masamune;

// ignore: subtype_of_sealed_class
/// Provider to provide [ScrollController].
/// [ScrollController]を提供するためのプロバイダーです。
///
/// Returns the same [ScrollController] if it is within the scope of that page.
/// そのページの範囲内であれば同じ[ScrollController]を返します。
///
/// You can change the initial offset of [ScrollController] by giving the provider `initialScrollOffset` at watch time. In that case, a different object will be returned for [ScrollController].
/// プロバイダーをwatch時に`initialScrollOffset`を与えることで[ScrollController]の初期オフセットを変更できます。その場合[ScrollController]は別オブジェクトが返されます。
///
///
/// ```dart
/// fianl scrollControllerProvider = ScrollControllerProvider();
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final scrollController = ref.watch(scrollControllerProvider(0.0));
///   }
/// }
/// ```
class ScrollControllerProvider
    extends AutoDisposeChangeNotifierProviderFamily<ScrollController, double> {
  ScrollControllerProvider({
    this.keepScrollOffset = true,
    this.debugLabel,
  }) : super(
          (ref, initialScrollOffset) => ScrollController(
            initialScrollOffset: initialScrollOffset,
            keepScrollOffset: keepScrollOffset,
            debugLabel: debugLabel,
          ),
        );

  /// Each time a scroll completes, save the current scroll [offset] with [PageStorage] and restore it if this controller's scrollable is recreated.
  /// スクロールが完了するたびに、現在のスクロール [offset] を [PageStorage] で保存し、このコントローラーのスクロール可能オブジェクトが再作成された場合に復元します。
  ///
  /// If this property is set to false, the scroll offset is never saved and [initialScrollOffset] is always used to initialize the scroll offset. If true (the default), the initial scroll offset is used the first time the controller's scrollable is created, since there's no scroll offset to restore yet. Subsequently the saved offset is restored and [initialScrollOffset] is ignored.
  /// このプロパティが false に設定されている場合、スクロール オフセットは保存されず、常に [initialScrollOffset] を使用してスクロール オフセットを初期化します。 true (デフォルト) の場合、復元するスクロール オフセットがまだないため、コントローラーのスクロール可能オブジェクトが最初に作成されるときに初期スクロール オフセットが使用されます。その後、保存されたオフセットが復元され、[initialScrollOffset] は無視されます。
  ///
  /// See also:
  ///
  ///  * [PageStorageKey], which should be used when more than one scrollable appears in the same route, to distinguish the [PageStorage] locations used to save scroll offsets.
  ///  * [PageStorageKey] は、スクロール オフセットを保存するために使用される [PageStorage] の場所を区別するために、同じルートに複数の scrollable が表示される場合に使用する必要があります。
  final bool keepScrollOffset;

  /// A label that is used in the [toString] output. Intended to aid with identifying scroll controller instances in debug output.
  /// [toString] 出力で使用されるラベル。デバッグ出力でスクロール コントローラー インスタンスを識別するのに役立つことを目的としています。
  final String? debugLabel;

  /// Obtains a unique [ScrollController] within the page.
  /// ページ内で一意な[ScrollController]を取得します。
  ///
  /// You can change the initial offset of [ScrollController] by giving the provider [initialScrollOffset]. In that case, a different object will be returned for [ScrollController].
  /// [initialScrollOffset]を与えることで[ScrollController]の初期オフセットを変更できます。その場合[ScrollController]は別オブジェクトが返されます。
  @override
  AutoDisposeChangeNotifierProvider<ScrollController> call([
    // ignore: avoid_renaming_method_parameters
    double initialScrollOffset = 0.0,
  ]) {
    return super.call(initialScrollOffset);
  }
}
