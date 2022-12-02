part of katana_scoped;

/// {@template scoped_query}
/// [ScopedQuery] makes it possible to define values globally and manage state individually and safely.
///
/// Specify in [provider] a callback that returns the value you wish to manage.
///
/// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [name].
///
/// [ScopedQuery]を利用してグローバルに値を定義して個別に安全に状態を管理することが可能になります。
///
/// [provider]に管理したい値を返すコールバックを指定してください。
///
/// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[name]を指定してください。
///
/// ```dart
/// final stateQuery = ScopedQuery(
///   () => "state",
/// );
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, PageRef ref) {
///     final state = ref.page.query(stateQuery);
///
///     return Scaffold(
///       body: Center(child: Text("${state}")), // `state`
///     );
///   }
/// }
/// ```
/// {@endtemplate}
@immutable
class ScopedQuery<Result> {
  /// {@template scoped_query}
  /// [ScopedQuery] makes it possible to define values globally and manage state individually and safely.
  ///
  /// Specify in [provider] a callback that returns the value you wish to manage.
  ///
  /// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [name].
  ///
  /// [ScopedQuery]を利用してグローバルに値を定義して個別に安全に状態を管理することが可能になります。
  ///
  /// [provider]に管理したい値を返すコールバックを指定してください。
  ///
  /// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[name]を指定してください。
  ///
  /// ```dart
  /// final stateQuery = ScopedQuery(
  ///   () => "state",
  /// );
  ///
  /// class TestPage extends PageScopedWidget {
  ///   @override
  ///   Widget build(BuildContext context, PageRef ref) {
  ///     final state = ref.page.query(stateQuery);
  ///
  ///     return Scaffold(
  ///       body: Center(child: Text("${state}")), // `state`
  ///     );
  ///   }
  /// }
  /// ```
  /// {@endtemplate}
  const ScopedQuery(
    this.provider, {
    String? name,
  }) : _name = name;

  final String? _name;

  /// A callback that returns the value you want to manage.
  ///
  /// 管理したい値を返すコールバック。
  final Result Function() provider;

  /// Returns `true` if the value is monitored for update notification.
  ///
  /// 値を監視して更新通知を行う場合`true`を返します。
  bool get listen => false;

  /// Returns a callback that returns the value you want to manage.
  ///
  /// 管理したい値を返すコールバックを返します。
  Result Function() call() => provider;

  /// Returns a name to identify the state.
  ///
  /// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [name].
  ///
  /// 状態を識別するための名前を返します。
  ///
  /// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[name]を指定してください。
  String get name => _name ?? hashCode.toString();
}

/// {@template change_notifier_scoped_query}
/// [ChangeNotifierScopedQuery] makes it possible to define values globally and manage states individually and safely.
///
/// Only [ChangeNotifier] can be managed as a value. It is possible to monitor the status and send change notifications to the widget.
///
/// Specify in [provider] a callback that returns the value you wish to manage.
///
/// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [name].
///
/// [ChangeNotifierScopedQuery]を利用してグローバルに値を定義して個別に安全に状態を管理することが可能になります。
///
/// [ChangeNotifier]のみを値として管理できます。状態を監視し、変更通知をウィジェットに送信することが可能です。
///
/// [provider]に管理したい値を返すコールバックを指定してください。
///
/// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[name]を指定してください。
///
/// ```dart
/// final valueNotifierQuery = ChangeNotifierScopedQuery(
///   () => ValueNotifier(0),
/// );
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, PageRef ref) {
///     final valueNotifier = ref.page.query(valueNotifierQuery);
///
///     return Scaffold(
///       body: Center(child: Text("${valueNotifier.value}")),
///     );
///   }
/// }
/// ```
/// {@endtemplate}
@immutable
class ChangeNotifierScopedQuery<Result extends Listenable?>
    extends ScopedQuery<Result> {
  /// {@template change_notifier_scoped_query}
  /// [ChangeNotifierScopedQuery] makes it possible to define values globally and manage states individually and safely.
  ///
  /// Only [ChangeNotifier] can be managed as a value. It is possible to monitor the status and send change notifications to the widget.
  ///
  /// Specify in [provider] a callback that returns the value you wish to manage.
  ///
  /// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [name].
  ///
  /// [ChangeNotifierScopedQuery]を利用してグローバルに値を定義して個別に安全に状態を管理することが可能になります。
  ///
  /// [ChangeNotifier]のみを値として管理できます。状態を監視し、変更通知をウィジェットに送信することが可能です。
  ///
  /// [provider]に管理したい値を返すコールバックを指定してください。
  ///
  /// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[name]を指定してください。
  ///
  /// ```dart
  /// final valueNotifierQuery = ChangeNotifierScopedQuery(
  ///   () => ValueNotifier(0),
  /// );
  ///
  /// class TestPage extends PageScopedWidget {
  ///   @override
  ///   Widget build(BuildContext context, PageRef ref) {
  ///     final valueNotifier = ref.page.query(valueNotifierQuery);
  ///
  ///     return Scaffold(
  ///       body: Center(child: Text("${valueNotifier.value}")),
  ///     );
  ///   }
  /// }
  /// ```
  /// {@endtemplate}
  const ChangeNotifierScopedQuery(
    super.provider, {
    super.name,
  });

  @override
  bool get listen => true;

  @override
  Result Function() call() => provider;
}

/// You can pass one parameter [ScopedQuery].
///
/// パラメーターを一つ渡すことができる[ScopedQuery]。
///
/// {@macro scoped_query}
@immutable
class ScopedQueryFamily<Result, Param> {
  /// You can pass one parameter [ScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[ScopedQuery]。
  ///
  /// {@macro scoped_query}
  const ScopedQueryFamily(
    this.provider, {
    String? name,
  }) : _name = name;

  final String? _name;

  /// Returns a callback that returns the value you want to manage.
  ///
  /// 管理したい値を返すコールバックを返します。
  final Result Function(Param param) provider;

  /// By passing [param], the corresponding [ScopedQuery] is returned.
  ///
  /// [param]を渡すことで対応した[ScopedQuery]を返します。
  ScopedQuery<Result> call(Param param) => ScopedQuery(
        () => provider(param),
        name: "${_name ?? hashCode}#${param.hashCode}",
      );
}

/// You can pass one parameter [ChangeNotifierScopedQuery].
///
/// パラメーターを一つ渡すことができる[ChangeNotifierScopedQuery]。
///
/// {@macro change_notifier_scoped_query}
@immutable
class ChangeNotifierScopedQueryFamily<Result extends Listenable?, Param>
    extends ScopedQueryFamily<Result, Param> {
  /// You can pass one parameter [ChangeNotifierScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[ChangeNotifierScopedQuery]。
  ///
  /// {@macro change_notifier_scoped_query}
  const ChangeNotifierScopedQueryFamily(
    super.provider, {
    super.name,
  });

  @override
  ChangeNotifierScopedQuery<Result> call(Param param) =>
      ChangeNotifierScopedQuery<Result>(
        () => provider(param),
        name: "${_name ?? hashCode}#${param.hashCode}",
      );
}
