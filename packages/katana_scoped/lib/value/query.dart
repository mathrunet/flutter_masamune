part of 'value.dart';

/// Provides an extension method for [AppScopedValueOrAppRef] to manage state using [ScopedQuery].
///
/// [ScopedQuery]を用いた状態管理を行うための[AppScopedValueOrAppRef]用の拡張メソッドを提供します。
extension AppScopedValueRefQueryExtensions on AppScopedValueOrAppRef {
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
  ///     final valueNotifier = ref.app.query(valueNotifierQuery);
  ///
  ///     return Scaffold(
  ///       body: Center(child: Text("${valueNotifier.value}")),
  ///     );
  ///   }
  /// }
  /// ```
  T query<T>(
    ScopedQueryBase<T, AppScopedValueOrAppRef> query, {
    bool? autoDisposeWhenUnreferenced,
  }) {
    return getScopedValue<T, _QueryValue<T, AppScopedValueOrAppRef>>(
      (ref) => _QueryValue<T, AppScopedValueOrAppRef>(
        query: query,
        ref: this,
        listen: query.listen,
        autoDisposeWhenUnreferenced:
            autoDisposeWhenUnreferenced ?? query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

/// Provides an extension method for [QueryScopedValueRef] to manage state using [ScopedQuery].
///
/// [ScopedQuery]を用いた状態管理を行うための[QueryScopedValueRef]用の拡張メソッドを提供します。
extension QueryScopedValueRefAppScopedValueRefQueryExtensions
    on QueryScopedValueRef<AppScopedValueOrAppRef> {
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
  ///     final valueNotifier = ref.app.query(valueNotifierQuery);
  ///
  ///     return Scaffold(
  ///       body: Center(child: Text("${valueNotifier.value}")),
  ///     );
  ///   }
  /// }
  /// ```
  T query<T>(
    ScopedQueryBase<T, AppScopedValueOrAppRef> query, {
    bool? autoDisposeWhenUnreferenced,
  }) {
    return getScopedValue<T, _QueryValue<T, AppScopedValueOrAppRef>>(
      (ref) => _QueryValue<T, AppScopedValueOrAppRef>(
        query: query,
        ref: this.ref,
        listen: query.listen,
        autoDisposeWhenUnreferenced:
            autoDisposeWhenUnreferenced ?? query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

/// Provides an extension method for [PageScopedValueRef] to manage state using [ScopedQuery].
///
/// [ScopedQuery]を用いた状態管理を行うための[PageScopedValueRef]用の拡張メソッドを提供します。
extension PageScopedValueRefQueryExtensions on PageScopedValueRef {
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
  T query<T>(
    ScopedQueryBase<T, PageScopedValueRef> query, {
    bool? autoDisposeWhenUnreferenced,
  }) {
    return getScopedValue<T, _QueryValue<T, PageScopedValueRef>>(
      (ref) => _QueryValue<T, PageScopedValueRef>(
        query: query,
        ref: this,
        listen: query.listen,
        autoDisposeWhenUnreferenced:
            autoDisposeWhenUnreferenced ?? query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

/// Provides an extension method for [QueryScopedValueRef] to manage state using [ScopedQuery].
///
/// [ScopedQuery]を用いた状態管理を行うための[QueryScopedValueRef]用の拡張メソッドを提供します。
extension QueryScopedValueRefPageScopedValueRefQueryExtensions
    on QueryScopedValueRef<PageScopedValueRef> {
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
  T query<T>(
    ScopedQueryBase<T, PageScopedValueRef> query, {
    bool? autoDisposeWhenUnreferenced,
  }) {
    return getScopedValue<T, _QueryValue<T, PageScopedValueRef>>(
      (ref) => _QueryValue<T, PageScopedValueRef>(
        query: query,
        ref: this.ref,
        listen: query.listen,
        autoDisposeWhenUnreferenced:
            autoDisposeWhenUnreferenced ?? query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

/// Provides an extension method for [WidgetScopedValueRef] to manage state using [ScopedQuery].
///
/// [ScopedQuery]を用いた状態管理を行うための[WidgetScopedValueRef]用の拡張メソッドを提供します。
extension WidgetScopedValueRefQueryExtensions on WidgetScopedValueRef {
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
  T query<T>(
    ScopedQueryBase<T, WidgetScopedValueRef> query, {
    bool? autoDisposeWhenUnreferenced,
  }) {
    return getScopedValue<T, _QueryValue<T, WidgetScopedValueRef>>(
      (ref) => _QueryValue<T, WidgetScopedValueRef>(
        query: query,
        ref: this,
        listen: query.listen,
        autoDisposeWhenUnreferenced:
            autoDisposeWhenUnreferenced ?? query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

/// Provides an extension method for [QueryScopedValueRef] to manage state using [ScopedQuery].
///
/// [ScopedQuery]を用いた状態管理を行うための[QueryScopedValueRef]用の拡張メソッドを提供します。
extension QueryScopedValueRefWidgetScopedValueRefQueryExtensions
    on QueryScopedValueRef<WidgetScopedValueRef> {
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
  T query<T>(
    ScopedQueryBase<T, WidgetScopedValueRef> query, {
    bool? autoDisposeWhenUnreferenced,
  }) {
    return getScopedValue<T, _QueryValue<T, WidgetScopedValueRef>>(
      (ref) => _QueryValue<T, WidgetScopedValueRef>(
        query: query,
        ref: this.ref,
        listen: query.listen,
        autoDisposeWhenUnreferenced:
            autoDisposeWhenUnreferenced ?? query.autoDisposeWhenUnreferenced,
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
  @Deprecated(
    "It is no longer possible to use [query] by directly specifying [PageRef] or [WidgetRef]. Instead, use [ref.app.query] to specify the scope. [PageRef]や[WidgetRef]を直接指定しての[query]の利用はできなくなります。代わりに[ref.app.query]でスコープを指定しての利用を行ってください。",
  )
  T query<T>(
    ScopedQueryBase<T, AppScopedValueRef> query, {
    bool? autoDisposeWhenUnreferenced,
  }) {
    return app.getScopedValue<T, _QueryValue<T, AppScopedValueOrAppRef>>(
      (ref) => _QueryValue<T, AppScopedValueOrAppRef>(
        query: query,
        ref: app,
        listen: query.listen,
        autoDisposeWhenUnreferenced:
            autoDisposeWhenUnreferenced ?? query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

@immutable
class _QueryValue<T, TRef extends Ref> extends QueryScopedValue<T, TRef> {
  const _QueryValue({
    required this.query,
    required TRef ref,
    this.listen = false,
    this.autoDisposeWhenUnreferenced = false,
  }) : super(ref: ref);

  final ScopedQueryBase<T, TRef> query;
  final bool listen;
  final bool autoDisposeWhenUnreferenced;

  @override
  QueryScopedValueState<T, TRef, QueryScopedValue<T, TRef>> createState() =>
      _QueryValueState<T, TRef>();
}

class _QueryValueState<T, TRef extends Ref>
    extends QueryScopedValueState<T, TRef, _QueryValue<T, TRef>> {
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
    if (!value.query.listen) {
      return;
    }
    final val = _value;
    if (val is Listenable) {
      val.addListener(_handledOnUpdate);
    }
  }

  @override
  void didUpdateDescendant() {
    super.didUpdateDescendant();
    final oldVal = _value;
    if (value.query.listen && oldVal is Listenable) {
      oldVal.removeListener(_handledOnUpdate);
    }
    _value = _callback();
    final newVal = _value;
    if (value.query.listen && newVal is Listenable) {
      newVal.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (!value.query.listen) {
      return;
    }
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
