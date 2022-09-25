part of masamune;

// ignore: subtype_of_sealed_class
/// Provider to provide [TextEditingController].
/// [TextEditingController]を提供するためのプロバイダーです。
///
/// Returns the same [TextEditingController] if it is within the scope of that page.
/// そのページの範囲内であれば同じ[TextEditingController]を返します。
///
/// You can change the initial page of [TextEditingController] by giving the provider an `argument` at watch time. In that case, [TextEditingController] will return a different object.
/// プロバイダーをwatch時に`argument`を与えることで[TextEditingController]の初期ページを変更できます。その場合[TextEditingController]は別オブジェクトが返されます。
///
///
/// ```dart
/// fianl textEditingControllerProvider = TextEditingControllerProvider();
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final textEditingController = ref.watch(textEditingControllerProvider());
///   }
/// }
/// ```
class TextEditingControllerProvider
    extends AutoDisposeChangeNotifierProviderFamily<TextEditingController,
        String?> {
  TextEditingControllerProvider()
      : super(
          (ref, value) => TextEditingController(text: value),
        );

  /// Obtains a unique [TextEditingController] within the page.
  /// ページ内で一意な[TextEditingController]を取得します。
  ///
  /// You can change the initial page of [TextEditingController] by giving the provider an [argument]. In that case, [TextEditingController] will return a different object.
  /// [argument]を与えることで[TextEditingController]の初期ページを変更できます。その場合[TextEditingController]は別オブジェクトが返されます。
  @override
  AutoDisposeChangeNotifierProvider<TextEditingController> call([
    String? argument,
  ]) {
    return super.call(argument);
  }
}
