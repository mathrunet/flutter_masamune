part of masamune;

// ignore: subtype_of_sealed_class
/// Provider for [ValueNotifier] for [T].
/// [T]に対応した[ValueNotifier]を提供するためのプロバイダーです。
///
/// Returns the same [ValueNotifier] if it is within the scope of that page.
/// そのページの範囲内であれば同じ[ValueNotifier]を返します。
///
/// You can change the initial value of [ValueNotifier] by giving the provider a `value` at watch time. In that case, a different object will be returned for [ValueNotifier].
/// プロバイダーをwatch時に`value`を与えることで[ValueNotifier]の初期値を変更できます。その場合[ValueNotifier]は別オブジェクトが返されます。
///
///
/// ```dart
/// fianl valueNotifierProvider = ValueNotifierProvider<int>();
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final valueNotifier = ref.watch(valueNotifierProvider(0));
///   }
/// }
/// ```
class ValueNotifierProvider<T>
    extends AutoDisposeChangeNotifierProviderFamily<ValueNotifier<T>, T> {
  ValueNotifierProvider() : super((ref, value) => ValueNotifier<T>(value));

  /// Obtains a unique [ValueNotifier] within the page.
  /// ページ内で一意な[ValueNotifier]を取得します。
  ///
  /// You can change the initial value of [ValueNotifier] by giving the provider a [value]. In that case, a different object will be returned for [ValueNotifier].
  /// [value]を与えることで[ValueNotifier]の初期値を変更できます。その場合[ValueNotifier]は別オブジェクトが返されます。
  @override
  AutoDisposeChangeNotifierProvider<ValueNotifier<T>> call(T value) {
    return super.call(value);
  }
}
