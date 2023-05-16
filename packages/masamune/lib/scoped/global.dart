part of masamune;

/// Create an **application scope** extension method to handle the globally defined [ChangeNotifier].
///
/// グローバル定義されている[ChangeNotifier]を処理するための**アプリケーションスコープ**の拡張メソッドを作成します。
extension MasamuneChangeNotifierScopedValueRefExtensions on RefHasApp {
  /// Used to monitor [globalChangeNotifier], a globally defined [ChangeNotifier], within a Widget.
  ///
  /// State is managed in the application scope, but state is not destroyed.
  ///
  /// Basically, the status is registered with [TController]. If you want to monitor multiple [TController], specify [name].
  ///
  /// グローバルに定義された[ChangeNotifier]である[globalChangeNotifier]をWidget内で監視するために使用します。
  ///
  /// アプリケーションスコープで状態は管理されますが、状態は破棄されません。
  ///
  /// 基本的には[TController]で状態が登録されます。複数の[TController]を監視したい場合は[name]を指定してください。
  ///
  /// ```dart
  /// final globalChangeNotifier = ValueNotifier(0); // Create a global change notifier.
  ///
  /// class TestWidget extends PageScopedWidget {
  ///   const TestWidget({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   Widget build(BuildContext context, PageRef ref) {
  ///     final globalChangeNotifier = ref.global(globalChangeNotifier); // Get the global change notifier.
  ///
  ///     ~~~~~~~
  ///   }
  /// }
  /// ```
  TController global<TController extends Listenable>(
    TController globalChangeNotifier, {
    String? name,
  }) {
    return app.watch(
      (ref) => globalChangeNotifier,
      name: name,
      disposal: false,
    );
  }
}
