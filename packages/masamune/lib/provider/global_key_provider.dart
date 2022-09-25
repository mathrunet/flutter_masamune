part of masamune;

// ignore: subtype_of_sealed_class
/// Provider for [GlobalKey] and [GlobalObjectKey] for [T].
/// [T]に対応した[GlobalKey]および[GlobalObjectKey]を提供するためのプロバイダーです。
///
/// It returns the same [GlobalKey] or [GlobalObjectKey] if it is within the range of that page.
/// そのページの範囲内であれば同じ[GlobalKey]や[GlobalObjectKey]を返します。
///
///
/// You can get the corresponding [GlobalObjectKey] by giving an object to the `value` object when you watch the provider. If you do not give a `value` object, [GlobalKey] will be returned.
/// プロバイダーをwatch時に`value`にオブジェクトを与えることでそのオブジェクトに対応した[GlobalObjectKey]を取得できます。`value`オブジェクトを与えない場合は[GlobalKey]が返されます。
///
/// ```dart
/// fianl navigationSteteKeyProvider = GlobalKeyProvider<NavigatorState>();
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final navigationSteteKey = ref.watch(navigationSteteKeyProvider()); // GlobalKey<NavigatorState>
///   }
/// }
/// ```
class GlobalKeyProvider<T extends State<StatefulWidget>>
    extends AutoDisposeProviderFamily<GlobalKey<T>, Object?> {
  GlobalKeyProvider()
      : super((ref, value) {
          if (value != null) {
            return GlobalObjectKey(value);
          } else {
            return GlobalKey();
          }
        });

  /// Obtains [GlobalKey] and [GlobalObjectKey], which are unique within a page.
  /// ページ内で一意な[GlobalKey]および[GlobalObjectKey]を取得します。
  ///
  /// You can get the corresponding [GlobalObjectKey] by giving an object to the [value] object. If you do not give a [value] object, [GlobalKey] will be returned.
  /// [value]にオブジェクトを与えることでそのオブジェクトに対応した[GlobalObjectKey]を取得できます。[value]オブジェクトを与えない場合は[GlobalKey]が返されます。
  @override
  AutoDisposeProvider<GlobalKey<T>> call([
    // ignore: avoid_renaming_method_parameters
    Object? value,
  ]) {
    return super.call(value);
  }
}
