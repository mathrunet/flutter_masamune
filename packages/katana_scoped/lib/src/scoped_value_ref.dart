part of katana_scoped;

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
class AppScopedValueRef extends ScopedValueRef {
  const AppScopedValueRef._({
    required ScopedValueListener listener,
    required BuildContext context,
  }) : super._(context: context, listener: listener);
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
    implements PageOrWidgetScopedValueRef {
  const PageScopedValueRef._({
    required ScopedValueListener listener,
    required BuildContext context,
  }) : super._(context: context, listener: listener);
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
    required ScopedValueListener listener,
    required BuildContext context,
  }) : super._(context: context, listener: listener);
}

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

/// Ref] associated with the widget.
///
/// ウィジェットに関連する[Ref]。
///
/// {@macro ref}
@immutable
class ScopedValueRef implements Ref {
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
    TScopedValue Function() provider, {
    bool listen = false,
    String? name,
  }) {
    return _listener.getScopedValueResult<TResult, TScopedValue>(
      provider,
      listen: listen,
      name: name,
    );
  }

  @override
  String toString() => "$runtimeType#${_listener.hashCode}";

  @override
  int get hashCode => _listener.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

class FutureValue<T> extends ScopedValue<Future<T>> {
  const FutureValue(this.future);

  final Future<T> future;

  @override
  ScopedValueState<Future<T>, ScopedValue<Future<T>>> createState() =>
      FutureValueState<T>();
}

class FutureValueState<T> extends ScopedValueState<Future<T>, FutureValue<T>> {
  late final Future<T> _future;

  @override
  void initValue() {
    super.initValue();
    _future = value.future;
    _future.then(
      (value) => setState(() {}),
    );
  }

  @override
  Future<T> build() => _future;
}

extension FutureValueRefExtension on Ref {
  Future<T> useFuture<T>(Future<T> Function() callback) {
    return getScopedValue(
      () => FutureValue(callback.call()),
      listen: true,
    );
  }
}
