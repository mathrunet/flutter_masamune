part of katana_scoped.value;

/// Provides an extension method for [Ref] to manage state using [ScopedQuery].
///
/// [ScopedQuery]を用いた状態管理を行うための[Ref]用の拡張メソッドを提供します。
extension RefQueryExtensions on Ref {
  /// It is possible to manage the status by passing [query].
  ///
  /// Defining [ScopedQuery] in a global scope allows you to manage state individually and safely.
  ///
  /// [ScopedQuery] allows you to cache all values, while [ChangeNotifierScopedQuery] monitors values and notifies updates when they change.
  ///
  /// [query]を渡して状態を管理することが可能です。
  ///
  /// [ScopedQuery]をグローバルなスコープに定義しておくことで状態を個別に安全に管理することができます。
  ///
  /// [ScopedQuery]を使うとすべての値をキャッシュすることができ、[ChangeNotifierScopedQuery]を使うと値を監視して変更時に更新通知を行います。
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
  T query<T>(ScopedQuery<T> query) {
    return getScopedValue<T, _QueryValue<T>>(
      (ref) => _QueryValue<T>(
        query: query,
        ref: ref,
        listen: query.listen,
        autoDisposeWhenUnreferenced: query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

/// Provides an extension method for [RefHasApp] to manage state using [ScopedQuery].
///
/// [ScopedQuery]を用いた状態管理を行うための[RefHasApp]用の拡張メソッドを提供します。
extension RefHasAppQueryExtensions on RefHasApp {
  /// It is possible to manage the status by passing [query].
  ///
  /// Defining [ScopedQuery] in a global scope allows you to manage state individually and safely.
  ///
  /// [ScopedQuery] allows you to cache all values, while [ChangeNotifierScopedQuery] monitors values and notifies updates when they change.
  ///
  /// [query]を渡して状態を管理することが可能です。
  ///
  /// [ScopedQuery]をグローバルなスコープに定義しておくことで状態を個別に安全に管理することができます。
  ///
  /// [ScopedQuery]を使うとすべての値をキャッシュすることができ、[ChangeNotifierScopedQuery]を使うと値を監視して変更時に更新通知を行います。
  ///
  /// ```dart
  /// final valueNotifierQuery = ChangeNotifierScopedQuery(
  ///   () => ValueNotifier(0),
  /// );
  ///
  /// class TestPage extends PageScopedWidget {
  ///   @override
  ///   Widget build(BuildContext context, PageRef ref) {
  ///     final valueNotifier = ref.query(valueNotifierQuery);
  ///
  ///     return Scaffold(
  ///       body: Center(child: Text("${valueNotifier.value}")),
  ///     );
  ///   }
  /// }
  /// ```
  T query<T>(ScopedQuery<T> query) {
    return app.query(query);
  }
}

@immutable
class _QueryValue<T> extends ScopedValue<T> {
  const _QueryValue({
    required this.query,
    required Ref ref,
    this.listen = false,
    this.autoDisposeWhenUnreferenced = false,
  }) : super(ref: ref);

  final ScopedQuery<T> query;
  final bool listen;
  final bool autoDisposeWhenUnreferenced;

  @override
  ScopedValueState<T, ScopedValue<T>> createState() => _QueryValueState<T>();
}

class _QueryValueState<T> extends ScopedValueState<T, _QueryValue<T>> {
  _QueryValueState();

  late T _value;
  late T Function() _callback;

  @override
  bool get autoDisposeWhenUnreferenced => value.autoDisposeWhenUnreferenced;

  @override
  void initValue() {
    super.initValue();
    _callback = value.query(ref);
    _value = _callback();
    final val = _value;
    if (val is Listenable) {
      val.addListener(_handledOnUpdate);
    }
  }

  @override
  void didUpdateDescendant() {
    super.didUpdateDescendant();
    final oldVal = _value;
    if (oldVal is Listenable) {
      oldVal.removeListener(_handledOnUpdate);
    }
    _value = _callback();
    final newVal = _value;
    if (newVal is Listenable) {
      newVal.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    final val = _value;
    if (val is Listenable) {
      val.removeListener(_handledOnUpdate);
      if (val is ChangeNotifier) {
        val.dispose();
      }
    }
  }

  @override
  T build() => _value;
}
