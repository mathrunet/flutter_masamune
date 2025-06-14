part of "/katana_scoped.dart";

/// [ScopedValueRef] of the application.
///
/// This can be extended with an extension to add a method to handle [ScopedValue] that stores a value per page.
///
/// アプリケーションの[ScopedValueRef]。
///
/// これをextensionで拡張することでページごとに値を保存する[ScopedValue]を扱うメソッドを追加することができます。
///
/// ```dart
/// extension RefWatchExtensions on AppScopedValueRef {
///   T watch<T extends Listenable>(
///     T Function() callback, {
///     List<Object> keys = const [],
///   }) {
///     return getScopedValue<T, _WatchValue<T>>(
///       () => _WatchValue<T>(callback: callback, keys: keys),
///       listen: true,
///     );
///   }
/// }
/// ```
@immutable
class AppScopedValueRef extends ScopedValueRef
    implements AppScopedValueOrAppRef, PageOrAppScopedValueOrAppRef {
  const AppScopedValueRef._({
    required super.listener,
    required super.context,
  }) : super._();
}

/// Page's [ScopedValueRef].
///
/// This can be extended with an extension to add a method to handle [ScopedValue] that stores a value per page.
///
/// Pageの[ScopedValueRef]。
///
/// これをextensionで拡張することでページごとに値を保存する[ScopedValue]を扱うメソッドを追加することができます。
///
/// ```dart
/// extension RefWatchExtensions on PageScopedValueRef {
///   T watch<T extends Listenable>(
///     T Function() callback, {
///     List<Object> keys = const [],
///   }) {
///     return getScopedValue<T, _WatchValue<T>>(
///       () => _WatchValue<T>(callback: callback, keys: keys),
///       listen: true,
///     );
///   }
/// }
/// ```
@immutable
class PageScopedValueRef extends ScopedValueRef
    implements PageOrAppScopedValueOrAppRef, PageOrWidgetScopedValueRef {
  const PageScopedValueRef._({
    required super.listener,
    required super.context,
  }) : super._();
}

/// Widget's [ScopedValueRef].
///
/// This can be extended with an extension to add a method to handle [ScopedValue] that stores a value per page.
///
/// Widgetの[ScopedValueRef]。
///
/// これをextensionで拡張することでページごとに値を保存する[ScopedValue]を扱うメソッドを追加することができます。
///
/// ```dart
/// extension RefWatchExtensions on WidgetScopedValueRef {
///   T watch<T extends Listenable>(
///     T Function() callback, {
///     List<Object> keys = const [],
///   }) {
///     return getScopedValue<T, _WatchValue<T>>(
///       () => _WatchValue<T>(callback: callback, keys: keys),
///       listen: true,
///     );
///   }
/// }
/// ```
@immutable
class WidgetScopedValueRef extends ScopedValueRef
    implements PageOrWidgetScopedValueRef {
  const WidgetScopedValueRef._({
    required super.listener,
    required super.context,
  }) : super._();
}

/// [AppRef] or [AppScopedValueRef] to store state in App scope.
///
/// This can be extended with an extension to add a method to handle [Ref] that stores the value for each app.
///
/// Appスコープで状態を保存する[AppRef]もしくは[AppScopedValueRef]。
///
/// これをextensionで拡張することでアプリごとに値を保存する[Ref]を扱うメソッドを追加することができます。
///
/// ```dart
/// extension RefWatchExtensions on AppScopedValueOrAppRef {
///   T watch<T extends Listenable>(
///     T Function() callback, {
///     List<Object> keys = const [],
///   }) {
///     return getScopedValue<T, _WatchValue<T>>(
///       () => _WatchValue<T>(callback: callback, keys: keys),
///       listen: true,
///     );
///   }
/// }
/// ```
@immutable
abstract class AppScopedValueOrAppRef
    implements PageOrAppScopedValueOrAppRef, Ref {}

/// [AppScopedValueOrAppRef] that stores state in page scope and App scope.
///
/// This can be extended with an extension to add a method to handle [Ref] that stores the value for each app.
///
/// ページスコープおよびAppスコープで状態を保存する[AppScopedValueOrAppRef]。
///
/// これをextensionで拡張することでアプリごとに値を保存する[Ref]を扱うメソッドを追加することができます。
///
/// ```dart
/// extension RefWatchExtensions on PageOrAppScopedValueOrAppRef {
///   T watch<T extends Listenable>(
///     T Function() callback, {
///     List<Object> keys = const [],
///   }) {
///     return getScopedValue<T, _WatchValue<T>>(
///       () => _WatchValue<T>(callback: callback, keys: keys),
///       listen: true,
///     );
///   }
/// }
/// ```
@immutable
abstract class PageOrAppScopedValueOrAppRef implements Ref {}

/// [ScopedValueRef] of the Page or Widget (whose state can be monitored).
///
/// This can be extended with an extension to add a method to handle [ScopedValue] that stores a value per page.
///
/// PageもしくはWidget（状態を監視可能なもの）の[ScopedValueRef]。
///
/// これをextensionで拡張することでページごとに値を保存する[ScopedValue]を扱うメソッドを追加することができます。
///
/// ```dart
/// extension RefWatchExtensions on PageOrWidgetScopedValueRef {
///   T watch<T extends Listenable>(
///     T Function() callback, {
///     List<Object> keys = const [],
///   }) {
///     return getScopedValue<T, _WatchValue<T>>(
///       () => _WatchValue<T>(callback: callback, keys: keys),
///       listen: true,
///     );
///   }
/// }
/// ```
@immutable
abstract class PageOrWidgetScopedValueRef implements ScopedValueRef {}

/// [Ref] associated with the widget.
///
/// ウィジェットに関連する[Ref]。
///
/// {@macro ref}
@immutable
abstract class ScopedValueRef implements Ref {
  const ScopedValueRef._({
    required ScopedValueListener listener,
    required this.context,
  }) : _listener = listener;

  /// [BuildContext] of the associated widget.
  ///
  /// 関連するウィジェットの[BuildContext]。
  final BuildContext context;

  final ScopedValueListener _listener;

  @override
  TResult getScopedValue<TResult, TScopedValue extends ScopedValue<TResult>>(
    TScopedValue Function(Ref ref) provider, {
    void Function(ScopedValueState<TResult, TScopedValue> state)? onInit,
    void Function(ScopedValueState<TResult, TScopedValue> state)? onUpdate,
    bool listen = false,
    Object? name,
  }) {
    return _listener.getScopedValueResult<TResult, TScopedValue>(
      () => provider(this),
      onInit: onInit,
      onUpdate: onUpdate,
      listen: listen,
      name: name,
    );
  }

  @override
  TResult? getAlreadyExistsScopedValue<TResult,
      TScopedValue extends ScopedValue<TResult>>({
    Object? name,
    bool listen = false,
    bool recursive = true,
  }) {
    return _listener.getAlreadtExistsScopedValueResult<TResult, TScopedValue>(
      name: name,
      listen: listen,
    );
  }

  @override
  String toString() => "$runtimeType#${_listener.hashCode}";

  @override
  int get hashCode => _listener.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// [Ref] used inside [ScopedQuery].
///
/// [ScopedQuery]の内部で使用される[Ref]。
///
/// {@macro ref}
@immutable
class QueryScopedValueRef<TRef extends Ref> implements Ref {
  const QueryScopedValueRef._({
    required this.ref,
    required ScopedValueState state,
  }) : _state = state;

  /// [Ref] to be used inside [ScopedQuery].
  ///
  /// [ScopedQuery]の内部で使用される[Ref]。
  ///
  /// {@macro ref}
  final TRef ref;
  final ScopedValueState _state;

  @override
  TResult getScopedValue<TResult, TScopedValue extends ScopedValue<TResult>>(
    TScopedValue Function(Ref ref) provider, {
    void Function(ScopedValueState<TResult, TScopedValue> state)? onInit,
    void Function(ScopedValueState<TResult, TScopedValue> state)? onUpdate,
    bool listen = false,
    Object? name,
  }) {
    return ref.getScopedValue(
      provider,
      onInit: (ScopedValueState<TResult, TScopedValue> state) {
        if (state.disposed) {
          return;
        }
        state._addParent(_state);
        onInit?.call(state);
      },
      onUpdate: (ScopedValueState<TResult, TScopedValue> state) {
        if (state.disposed) {
          return;
        }
        state._addParent(_state);
        onUpdate?.call(state);
      },
      listen: listen,
      name: name,
    );
  }

  @override
  TResult? getAlreadyExistsScopedValue<TResult,
      TScopedValue extends ScopedValue<TResult>>({
    Object? name,
    bool listen = false,
    bool recursive = true,
  }) {
    return ref.getAlreadyExistsScopedValue(
      listen: listen,
      name: name,
      recursive: recursive,
    );
  }

  @override
  String toString() => ref.toString();

  @override
  int get hashCode => ref.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
