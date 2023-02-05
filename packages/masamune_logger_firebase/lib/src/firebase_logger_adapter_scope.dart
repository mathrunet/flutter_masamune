part of masamune_logger_firebase;

/// [FirebaseLoggerMasamuneAdapter] for the entire app by placing it on top of [MaterialApp], etc.
///
/// Pass [FirebaseLoggerMasamuneAdapter] to [adapter].
///
/// Also, by using [FirebaseLoggerMasamuneAdapterScope.of] in a descendant widget, you can retrieve the [FirebaseLoggerMasamuneAdapter] set in the [FirebaseLoggerMasamuneAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[FirebaseLoggerMasamuneAdapter]を設定します。
///
/// [adapter]に[FirebaseLoggerMasamuneAdapter]を渡してください。
///
/// また[FirebaseLoggerMasamuneAdapterScope.of]を子孫のウィジェット内で利用することにより[FirebaseLoggerMasamuneAdapterScope]で設定された[FirebaseLoggerMasamuneAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return FirebaseLoggerMasamuneAdapterScope(
///       adapter: const FirebaseLoggerMasamuneAdapter(),
///       child: MaterialApp(
///         home: const PickerPage(),
///       ),
///     );
///   }
/// }
/// ```
class FirebaseLoggerMasamuneAdapterScope extends StatefulWidget {
  /// [FirebaseLoggerMasamuneAdapter] for the entire app by placing it on top of [MaterialApp], etc.
  ///
  /// Pass [FirebaseLoggerMasamuneAdapter] to [adapter].
  ///
  /// Also, by using [FirebaseLoggerMasamuneAdapterScope.of] in a descendant widget, you can retrieve the [FirebaseLoggerMasamuneAdapter] set in the [FirebaseLoggerMasamuneAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[FirebaseLoggerMasamuneAdapter]を設定します。
  ///
  /// [adapter]に[FirebaseLoggerMasamuneAdapter]を渡してください。
  ///
  /// また[FirebaseLoggerMasamuneAdapterScope.of]を子孫のウィジェット内で利用することにより[FirebaseLoggerMasamuneAdapterScope]で設定された[FirebaseLoggerMasamuneAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return FirebaseLoggerMasamuneAdapterScope(
  ///       adapter: const FirebaseLoggerMasamuneAdapter(),
  ///       child: MaterialApp(
  ///         home: const PickerPage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const FirebaseLoggerMasamuneAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [FirebaseLoggerMasamuneAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[FirebaseLoggerMasamuneAdapter]。
  final FirebaseLoggerMasamuneAdapter adapter;

  /// By passing [context], the [FirebaseLoggerMasamuneAdapter] set in [FirebaseLoggerMasamuneAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [FirebaseLoggerMasamuneAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[FirebaseLoggerMasamuneAdapterScope]で設定された[FirebaseLoggerMasamuneAdapter]を取得することができます。
  ///
  /// 祖先に[FirebaseLoggerMasamuneAdapterScope]がない場合はエラーになります。
  static FirebaseLoggerMasamuneAdapter? of(BuildContext context) {
    final scope = context.getElementForInheritedWidgetOfExactType<
        _FirebaseLoggerMasamuneAdapterScope>();
    assert(
      scope != null,
      "FirebaseLoggerMasamuneAdapter is not found. Place [FirebaseLoggerMasamuneAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _FirebaseLoggerMasamuneAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() =>
      _FirebaseLoggerMasamuneAdapterScopeState();
}

class _FirebaseLoggerMasamuneAdapterScopeState
    extends State<FirebaseLoggerMasamuneAdapterScope> {
  @override
  void initState() {
    super.initState();
    FirebaseLoggerMasamuneAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _FirebaseLoggerMasamuneAdapterScope(
        adapter: widget.adapter, child: widget.child);
  }
}

class _FirebaseLoggerMasamuneAdapterScope extends InheritedWidget {
  const _FirebaseLoggerMasamuneAdapterScope({
    required super.child,
    required this.adapter,
  });

  final FirebaseLoggerMasamuneAdapter adapter;

  @override
  bool updateShouldNotify(
          covariant _FirebaseLoggerMasamuneAdapterScope oldWidget) =>
      false;
}
