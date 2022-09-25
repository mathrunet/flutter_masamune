part of masamune;

// ignore: subtype_of_sealed_class
/// Provider to provide [PageController].
/// [PageController]を提供するためのプロバイダーです。
///
/// Returns the same [PageController] if it is within the scope of that page.
/// そのページの範囲内であれば同じ[PageController]を返します。
///
/// You can change the initial page of [PageController] by giving the provider an `initialRoute` at watch time. In that case, a different object will be returned for [PageController].
/// プロバイダーをwatch時に`initialRoute`を与えることで[PageController]の初期ページを変更できます。その場合[PageController]は別オブジェクトが返されます。
///
///
/// ```dart
/// fianl pageControllerProvider = PageControllerProvider();
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final pageController = ref.watch(pageControllerProvider(0));
///   }
/// }
/// ```
class PageControllerProvider
    extends AutoDisposeChangeNotifierProviderFamily<PageController, int> {
  PageControllerProvider({
    this.keepPage = true,
    this.viewportFraction = 1.0,
  }) : super(
          (ref, initialPage) => PageController(
            initialPage: initialPage,
            keepPage: keepPage,
            viewportFraction: viewportFraction,
          ),
        );

  /// Save the current [page] with [PageStorage] and restore it if this controller's scrollable is recreated.
  /// 現在の [page] を [PageStorage] で保存し、このコントローラーのスクロール可能オブジェクトが再作成された場合に復元します。
  ///
  /// If this property is set to false, the current [page] is never saved and [initialPage] is always used to initialize the scroll offset. If true (the default), the initial page is used the first time the controller's scrollable is created, since there's isn't a page to restore yet. Subsequently the saved page is restored and [initialPage] is ignored.
  /// このプロパティが false に設定されている場合、現在の [page] は保存されず、[initialPage] が常にスクロール オフセットの初期化に使用されます。 true (デフォルト) の場合、復元するページがまだないため、コントローラーのスクロール可能オブジェクトが最初に作成されるときに初期ページが使用されます。その後、保存されたページが復元され、[initialPage] は無視されます。
  ///
  /// See also:
  ///
  ///  * [PageStorageKey], which should be used when more than one scrollable appears in the same route, to distinguish the [PageStorage] locations used to save scroll offsets.
  ///  * [PageStorageKey] は、スクロール オフセットを保存するために使用される [PageStorage] の場所を区別するために、同じルートに複数の scrollable が表示される場合に使用する必要があります。
  final bool keepPage;

  /// The fraction of the viewport that each page should occupy.
  /// 各ページが占めるビューポートの割合。
  ///
  /// Defaults to 1.0, which means each page fills the viewport in the scrolling direction.
  /// デフォルトは 1.0 です。これは、各ページがスクロール方向にビューポートを埋めることを意味します。
  final double viewportFraction;

  /// Obtains a unique [PageController] within the page.
  /// ページ内で一意な[PageController]を取得します。
  ///
  /// You can change the initial page of [PageController] by giving the provider an [initialPage]. In this case, [PageController] will return a different object.
  /// [initialPage]を与えることで[PageController]の初期ページを変更できます。その場合[PageController]は別オブジェクトが返されます。
  @override
  AutoDisposeChangeNotifierProvider<PageController> call([
    // ignore: avoid_renaming_method_parameters
    int initialPage = 0,
  ]) {
    return super.call(initialPage);
  }
}
