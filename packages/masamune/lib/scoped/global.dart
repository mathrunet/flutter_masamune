part of "/masamune.dart";

/// Create an **application scope** extension method to handle the globally defined [ChangeNotifier].
///
/// グローバル定義されている[ChangeNotifier]を処理するための**アプリケーションスコープ**の拡張メソッドを作成します。
extension MasamuneChangeNotifierScopedValueRefExtensions on RefHasApp {
  @Deprecated(
    "This method is no longer available. Please use [watch] instead. このメソッドは利用できなくなります。代わりに[watch]を利用してください。",
  )
  TController global<TController extends Listenable>(
    TController globalChangeNotifier, {
    Object? name,
  }) {
    return app.watch(
      (ref) => globalChangeNotifier,
      name: name,
      disposal: false,
    );
  }
}
