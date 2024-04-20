part of '/katana_scoped.dart';

/// Base class that can specify the type of the [provider] part of [ScopedQuery].
///
/// Used to create frameworks.
///
/// [ScopedQuery]の[provider]部分の型を指定することができるベースクラス。
///
/// フレームワークの作成に利用します。
///
/// {@macro scoped_query}
@immutable
abstract class ScopedQueryBase<Result, TRef extends Ref> {
  /// Base class that can specify the type of the [provider] part of [ScopedQuery].
  ///
  /// Used to create frameworks.
  ///
  /// [ScopedQuery]の[provider]部分の型を指定することができるベースクラス。
  ///
  /// フレームワークの作成に利用します。
  ///
  /// {@macro scoped_query}
  const ScopedQueryBase(
    this.provider, {
    Object? name,
    this.autoDisposeWhenUnreferenced = false,
  }) : _name = name;

  final Object? _name;

  /// A callback that returns the value you want to manage.
  ///
  /// 管理したい値を返すコールバック。
  final Result Function(QueryScopedValueRef<TRef> ref) provider;

  /// Returns `true` if the value is monitored for update notification.
  ///
  /// 値を監視して更新通知を行う場合`true`を返します。
  bool get listen => false;

  /// Returns a callback that returns the value you want to manage.
  ///
  /// 管理したい値を返すコールバックを返します。
  Result Function() call(QueryScopedValueRef<TRef> ref) =>
      () => provider.call(ref);

  /// Returns a name to identify the state.
  ///
  /// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [queryName].
  ///
  /// 状態を識別するための名前を返します。
  ///
  /// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[queryName]を指定してください。
  Object get queryName => _name ?? hashCode.toString();

  /// Returns `true` if [ScopedQuery] should be automatically discarded when it is no longer referenced by any widget.
  ///
  /// [ScopedQuery]がどのウィジェットにも参照されなくなったときに自動的に破棄する場合`true`を返します。
  final bool autoDisposeWhenUnreferenced;
}

@immutable
class _ScopedQueryImpl<Result, TRef extends Ref>
    extends ScopedQueryBase<Result, TRef> {
  const _ScopedQueryImpl(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced = false,
  });
}

/// {@template scoped_query}
/// [ScopedQuery] makes it possible to define values globally and manage state individually and safely.
///
/// Specify in [provider] a callback that returns the value you wish to manage.
///
/// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [queryName].
///
/// If [autoDisposeWhenUnreferenced] is set to `true`, [ScopedQuery] will be automatically disposed of when it is no longer referenced by any widget.
///
/// [ScopedQuery]を利用してグローバルに値を定義して個別に安全に状態を管理することが可能になります。
///
/// [provider]に管理したい値を返すコールバックを指定してください。
///
/// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[queryName]を指定してください。
///
/// [autoDisposeWhenUnreferenced]を`true`にすると、[ScopedQuery]がどのウィジェットからも参照されなくなった時に自動的に破棄されます。
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
class ScopedQuery<Result>
    extends ScopedQueryBase<Result, AppScopedValueOrAppRef> {
  /// {@template scoped_query}
  /// [ScopedQuery] makes it possible to define values globally and manage state individually and safely.
  ///
  /// Specify in [provider] a callback that returns the value you wish to manage.
  ///
  /// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [name].
  ///
  /// If [autoDisposeWhenUnreferenced] is set to `true`, [ScopedQuery] will be automatically disposed of when it is no longer referenced by any widget.
  ///
  /// [ScopedQuery]を利用してグローバルに値を定義して個別に安全に状態を管理することが可能になります。
  ///
  /// [provider]に管理したい値を返すコールバックを指定してください。
  ///
  /// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[name]を指定してください。
  ///
  /// [autoDisposeWhenUnreferenced]を`true`にすると、[ScopedQuery]がどのウィジェットからも参照されなくなった時に自動的に破棄されます。
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
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced = false,
  });
}

/// [ScopedQuery] available at page scope.
///
/// ページスコープで利用可能な[ScopedQuery]。
///
/// {@macro scoped_query}
class PageScopedQuery<Result>
    extends ScopedQueryBase<Result, PageScopedValueRef> {
  /// [ScopedQuery] available at page scope.
  ///
  /// ページスコープで利用可能な[ScopedQuery]。
  ///
  /// {@macro scoped_query}
  const PageScopedQuery(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced = false,
  });
}

/// [ScopedQuery] available in the widget scope.
///
/// ウィジェットスコープで利用可能な[ScopedQuery]。
///
/// {@macro scoped_query}
class WidgetScopedQuery<Result>
    extends ScopedQueryBase<Result, WidgetScopedValueRef> {
  /// [ScopedQuery] available in the widget scope.
  ///
  /// ウィジェットスコープで利用可能な[ScopedQuery]。
  ///
  /// {@macro scoped_query}
  const WidgetScopedQuery(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced = false,
  });
}

/// Base class that can specify the type of the [provider] part of [ScopedQuery].
///
/// Used to create frameworks.
///
/// [ChangeNotifierScopedQuery]の[provider]部分の型を指定することができるベースクラス。
///
/// フレームワークの作成に利用します。
///
/// {@macro change_notifier_scoped_query}
@immutable
abstract class ChangeNotifierScopedQueryBase<Result, TRef extends Ref>
    extends ScopedQueryBase<Result, TRef> {
  /// Base class that can specify the type of the [provider] part of [ScopedQuery].
  ///
  /// Used to create frameworks.
  ///
  /// [ChangeNotifierScopedQuery]の[provider]部分の型を指定することができるベースクラス。
  ///
  /// フレームワークの作成に利用します。
  ///
  /// {@macro change_notifier_scoped_query}
  const ChangeNotifierScopedQueryBase(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced,
  });

  @override
  bool get listen => true;

  @override
  Result Function() call(QueryScopedValueRef<TRef> ref) => () => provider(ref);
}

@immutable
class _ChangeNotifierScopedQueryImpl<Result, TRef extends Ref>
    extends ChangeNotifierScopedQueryBase<Result, TRef> {
  const _ChangeNotifierScopedQueryImpl(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced = false,
  });
}

/// {@template change_notifier_scoped_query}
/// [ChangeNotifierScopedQuery] makes it possible to define values globally and manage states individually and safely.
///
/// Only [ChangeNotifier] can be managed as a value. It is possible to monitor the status and send change notifications to the widget.
///
/// Specify in [provider] a callback that returns the value you wish to manage.
///
/// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [queryName].
///
/// If [autoDisposeWhenUnreferenced] is set to `true`, [ScopedQuery] will be automatically disposed of when it is no longer referenced by any widget.
///
/// [ChangeNotifierScopedQuery]を利用してグローバルに値を定義して個別に安全に状態を管理することが可能になります。
///
/// [ChangeNotifier]のみを値として管理できます。状態を監視し、変更通知をウィジェットに送信することが可能です。
///
/// [provider]に管理したい値を返すコールバックを指定してください。
///
/// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[queryName]を指定してください。
///
/// [autoDisposeWhenUnreferenced]を`true`にすると、[ScopedQuery]がどのウィジェットからも参照されなくなった時に自動的に破棄されます。
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
    extends ChangeNotifierScopedQueryBase<Result, AppScopedValueOrAppRef> {
  /// {@template change_notifier_scoped_query}
  /// [ChangeNotifierScopedQuery] makes it possible to define values globally and manage states individually and safely.
  ///
  /// Only [ChangeNotifier] can be managed as a value. It is possible to monitor the status and send change notifications to the widget.
  ///
  /// Specify in [provider] a callback that returns the value you wish to manage.
  ///
  /// Normally [hashCode] is used to manage state names, but if you want to specify a special name, specify [queryName].
  ///
  /// If [autoDisposeWhenUnreferenced] is set to `true`, [ScopedQuery] will be automatically disposed of when it is no longer referenced by any widget.
  ///
  /// [ChangeNotifierScopedQuery]を利用してグローバルに値を定義して個別に安全に状態を管理することが可能になります。
  ///
  /// [ChangeNotifier]のみを値として管理できます。状態を監視し、変更通知をウィジェットに送信することが可能です。
  ///
  /// [provider]に管理したい値を返すコールバックを指定してください。
  ///
  /// 通常は[hashCode]を用いて状態の名前を管理しますが、特別に名前を指定したい場合は[queryName]を指定してください。
  ///
  /// [autoDisposeWhenUnreferenced]を`true`にすると、[ScopedQuery]がどのウィジェットからも参照されなくなった時に自動的に破棄されます。
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
    super.autoDisposeWhenUnreferenced,
  });
}

/// [ChangeNotifierScopedQuery] available at page scope.
///
/// ページスコープで利用可能な[ChangeNotifierScopedQuery]。
///
/// {@macro change_notifier_scoped_query}
@immutable
class ChangeNotifierPageScopedQuery<Result extends Listenable?>
    extends ChangeNotifierScopedQueryBase<Result, PageScopedValueRef> {
  /// [ChangeNotifierScopedQuery] available at page scope.
  ///
  /// ページスコープで利用可能な[ChangeNotifierScopedQuery]。
  ///
  /// {@macro change_notifier_scoped_query}
  const ChangeNotifierPageScopedQuery(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced,
  });
}

/// [ChangeNotifierScopedQuery] available in the widget scope.
///
/// ウィジェットスコープで利用可能な[ChangeNotifierScopedQuery]。
///
/// {@macro change_notifier_scoped_query}
@immutable
class ChangeNotifierWidgetScopedQuery<Result extends Listenable?>
    extends ChangeNotifierScopedQueryBase<Result, WidgetScopedValueRef> {
  /// [ChangeNotifierScopedQuery] available in the widget scope.
  ///
  /// ウィジェットスコープで利用可能な[ChangeNotifierScopedQuery]。
  ///
  /// {@macro change_notifier_scoped_query}
  const ChangeNotifierWidgetScopedQuery(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced,
  });
}

/// Base class that allows specifying the type of the [provider] part of [ScopedQuery] that allows passing a single parameter.
///
/// Used to create frameworks.
///
/// パラメーターを一つ渡すことができる[ScopedQuery]の[provider]部分の型を指定することができるベースクラス。
///
/// フレームワークの作成に利用します。
///
/// {@macro scoped_query}
@immutable
abstract class ScopedQueryFamilyBase<Result, TRef extends Ref, Param> {
  /// Base class that allows specifying the type of the [provider] part of [ScopedQuery] that allows passing a single parameter.
  ///
  /// Used to create frameworks.
  ///
  /// パラメーターを一つ渡すことができる[ScopedQuery]の[provider]部分の型を指定することができるベースクラス。
  ///
  /// フレームワークの作成に利用します。
  ///
  /// {@macro scoped_query}
  const ScopedQueryFamilyBase(
    this.provider, {
    Object? name,
    this.autoDisposeWhenUnreferenced = false,
  }) : _name = name;

  final Object? _name;

  /// Returns a callback that returns the value you want to manage.
  ///
  /// 管理したい値を返すコールバックを返します。
  final Result Function(QueryScopedValueRef<TRef> ref, Param param) provider;

  /// By passing [param], the corresponding [ScopedQuery] is returned.
  ///
  /// [param]を渡すことで対応した[ScopedQuery]を返します。
  ScopedQueryBase<Result, TRef> call(Param param) => _ScopedQueryImpl(
        (ref) => provider(ref, param),
        name: "${_name ?? hashCode}#${param.hashCode}",
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      );

  /// Returns `true` if [ScopedQueryFamily] should be automatically discarded when it is no longer referenced by any widget.
  ///
  /// [ScopedQueryFamily]がどのウィジェットにも参照されなくなったときに自動的に破棄する場合`true`を返します。
  final bool autoDisposeWhenUnreferenced;
}

/// You can pass one parameter [ScopedQuery].
///
/// パラメーターを一つ渡すことができる[ScopedQuery]。
///
/// {@macro scoped_query}
@immutable
class ScopedQueryFamily<Result, Param>
    extends ScopedQueryFamilyBase<Result, AppScopedValueOrAppRef, Param> {
  /// You can pass one parameter [ScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[ScopedQuery]。
  ///
  /// {@macro scoped_query}
  const ScopedQueryFamily(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced = false,
  });

  /// By passing [param], the corresponding [ScopedQuery] is returned.
  ///
  /// [param]を渡すことで対応した[ScopedQuery]を返します。
  @override
  ScopedQuery<Result> call(Param param) => ScopedQuery(
        (ref) => provider(ref, param),
        name: "${_name ?? hashCode}#${param.hashCode}",
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      );
}

/// You can pass one parameter [PageScopedQuery].
///
/// パラメーターを一つ渡すことができる[PageScopedQuery]。
///
/// {@macro scoped_query}
@immutable
class PageScopedQueryFamily<Result, Param>
    extends ScopedQueryFamilyBase<Result, PageScopedValueRef, Param> {
  /// You can pass one parameter [PageScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[PageScopedQuery]。
  ///
  /// {@macro scoped_query}
  const PageScopedQueryFamily(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced = false,
  });

  /// By passing [param], the corresponding [ScopedQuery] is returned.
  ///
  /// [param]を渡すことで対応した[ScopedQuery]を返します。
  @override
  PageScopedQuery<Result> call(Param param) => PageScopedQuery(
        (ref) => provider(ref, param),
        name: "${_name ?? hashCode}#${param.hashCode}",
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      );
}

/// You can pass one parameter [WidgetScopedQuery].
///
/// パラメーターを一つ渡すことができる[WidgetScopedQuery]。
///
/// {@macro scoped_query}
@immutable
class WidgetScopedQueryFamily<Result, Param>
    extends ScopedQueryFamilyBase<Result, WidgetScopedValueRef, Param> {
  /// You can pass one parameter [WidgetScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[WidgetScopedQuery]。
  ///
  /// {@macro scoped_query}
  const WidgetScopedQueryFamily(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced = false,
  });

  /// By passing [param], the corresponding [ScopedQuery] is returned.
  ///
  /// [param]を渡すことで対応した[ScopedQuery]を返します。
  @override
  WidgetScopedQuery<Result> call(Param param) => WidgetScopedQuery(
        (ref) => provider(ref, param),
        name: "${_name ?? hashCode}#${param.hashCode}",
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      );
}

/// You can pass one parameter [ChangeNotifierScopedQuery].
///
/// パラメーターを一つ渡すことができる[ChangeNotifierScopedQuery]。
///
/// {@macro change_notifier_scoped_query}
@immutable
class ChangeNotifierScopedQueryFamilyBase<
    Result extends Listenable?,
    TRef extends Ref,
    Param> extends ScopedQueryFamilyBase<Result, TRef, Param> {
  /// You can pass one parameter [ChangeNotifierScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[ChangeNotifierScopedQuery]。
  ///
  /// {@macro change_notifier_scoped_query}
  const ChangeNotifierScopedQueryFamilyBase(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced,
  });

  @override
  ChangeNotifierScopedQueryBase<Result, TRef> call(Param param) =>
      _ChangeNotifierScopedQueryImpl<Result, TRef>(
        (ref) => provider(ref, param),
        name: "${_name ?? hashCode}#${param.hashCode}",
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      );
}

/// You can pass one parameter [ChangeNotifierScopedQuery].
///
/// パラメーターを一つ渡すことができる[ChangeNotifierScopedQuery]。
///
/// {@macro change_notifier_scoped_query}
@immutable
class ChangeNotifierScopedQueryFamily<Result extends Listenable?, Param>
    extends ChangeNotifierScopedQueryFamilyBase<Result, AppScopedValueOrAppRef,
        Param> {
  /// You can pass one parameter [ChangeNotifierScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[ChangeNotifierScopedQuery]。
  ///
  /// {@macro change_notifier_scoped_query}
  const ChangeNotifierScopedQueryFamily(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced,
  });

  @override
  ChangeNotifierScopedQuery<Result> call(Param param) =>
      ChangeNotifierScopedQuery<Result>(
        (ref) => provider(ref, param),
        name: "${_name ?? hashCode}#${param.hashCode}",
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      );
}

/// You can pass one parameter [ChangeNotifierPageScopedQuery].
///
/// パラメーターを一つ渡すことができる[ChangeNotifierPageScopedQuery]。
///
/// {@macro change_notifier_scoped_query}
@immutable
class ChangeNotifierPageScopedQueryFamily<Result extends Listenable?, Param>
    extends ChangeNotifierScopedQueryFamilyBase<Result, PageScopedValueRef,
        Param> {
  /// You can pass one parameter [ChangeNotifierPageScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[ChangeNotifierPageScopedQuery]。
  ///
  /// {@macro change_notifier_scoped_query}
  const ChangeNotifierPageScopedQueryFamily(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced,
  });

  @override
  ChangeNotifierPageScopedQuery<Result> call(Param param) =>
      ChangeNotifierPageScopedQuery<Result>(
        (ref) => provider(ref, param),
        name: "${_name ?? hashCode}#${param.hashCode}",
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      );
}

/// You can pass one parameter [ChangeNotifierWidgetScopedQuery].
///
/// パラメーターを一つ渡すことができる[ChangeNotifierWidgetScopedQuery]。
///
/// {@macro change_notifier_scoped_query}
@immutable
class ChangeNotifierWidgetScopedQueryFamily<Result extends Listenable?, Param>
    extends ChangeNotifierScopedQueryFamilyBase<Result, WidgetScopedValueRef,
        Param> {
  /// You can pass one parameter [ChangeNotifierWidgetScopedQuery].
  ///
  /// パラメーターを一つ渡すことができる[ChangeNotifierWidgetScopedQuery]。
  ///
  /// {@macro change_notifier_scoped_query}
  const ChangeNotifierWidgetScopedQueryFamily(
    super.provider, {
    super.name,
    super.autoDisposeWhenUnreferenced,
  });

  @override
  ChangeNotifierWidgetScopedQuery<Result> call(Param param) =>
      ChangeNotifierWidgetScopedQuery<Result>(
        (ref) => provider(ref, param),
        name: "${_name ?? hashCode}#${param.hashCode}",
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      );
}
