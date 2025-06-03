part of "/katana_scoped.dart";

/// Place it close to the route (e.g., on top of MaterialApp) to use state management in the app.
///
/// Pass the globally defined [AppRef] in [appRef] and the child widget in [child].
///
/// アプリ内で状態管理を利用するためにルートに近い場所（MaterialAppの上など）に置いてください。
///
/// [appRef]にグローバルに定義した[AppRef]、[child]に子供のウィジェットを渡してください。
///
/// ```dart
/// final appRef = AppRef();
///
/// void main() {
///   runApp(const MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   const MyApp();
///
///   @override
///   Widget build(BuildContext context){
///     return AppScoped(
///       appRef: appRef,
///       child: MaterialApp(
///         ~~~~~
///       ),
///     );
///   }
/// }
/// ```
@immutable
class AppScoped extends StatefulWidget {
  /// Place it close to the route (e.g., on top of MaterialApp) to use state management in the app.
  ///
  /// Pass the globally defined [AppRef] in [appRef] and the child widget in [child].
  ///
  /// アプリ内で状態管理を利用するためにルートに近い場所（MaterialAppの上など）に置いてください。
  ///
  /// [appRef]にグローバルに定義した[AppRef]、[child]に子供のウィジェットを渡してください。
  ///
  /// ```dart
  /// final appRef = AppRef();
  ///
  /// void main() {
  ///   runApp(const MyApp());
  /// }
  ///
  /// class MyApp extends StatelessWidget {
  ///   const MyApp();
  ///
  ///   @override
  ///   Widget build(BuildContext context){
  ///     return AppScoped(
  ///       appRef: appRef,
  ///       child: MaterialApp(
  ///         ~~~~~
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const AppScoped({
    super.key,
    required this.appRef,
    required this.child,
  });

  /// Reference for managing the state of the app scope.
  ///
  /// アプリスコープの状態を管理するためのリファレンス。
  final AppRef appRef;

  /// Widgets to be placed below, such as MaterialApp.
  ///
  /// 下に配置されるウィジェット。MaterialApp等。
  final Widget child;

  /// By passing [context], the [AppRef] set in [AppScoped] can be obtained.
  ///
  /// If the ancestor does not have [AppScoped], an error will occur.
  ///
  /// [context]を渡すことにより[AppScoped]で設定された[AppRef]を取得することができます。
  ///
  /// 祖先に[AppScoped]がない場合はエラーになります。
  static AppRef? of(BuildContext context) {
    final state = context.findRootAncestorStateOfType<_AppScopedState>();
    assert(
      state != null,
      "AppScoped is not found. Place [AppScoped] widget closer to the root.",
    );
    return state?.widget.appRef;
  }

  @override
  State<StatefulWidget> createState() => _AppScopedState();
}

class _AppScopedState extends State<AppScoped> {
  @override
  Widget build(BuildContext context) {
    return _AppScopedScope(
      state: this,
      child: widget.child,
    );
  }
}

/// Test scope for [AppScoped].
///
/// [AppScoped]のテスト用スコープ。
class TestAppScoped {
  const TestAppScoped._();

  /// Set the [ScopedValueContainer] for testing.
  ///
  /// テスト用に[ScopedValueContainer]を設定します。
  static void setTestContainer(ScopedValueContainer container) {
    ScopedValueContainer._test = container;
  }
}
