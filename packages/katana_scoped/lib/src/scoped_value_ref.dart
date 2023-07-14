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
    TScopedValue Function(Ref ref) provider, {
    bool listen = false,
    String? name,
  }) {
    return _listener.getScopedValueResult<TResult, TScopedValue>(
      () => provider(_ScopedValueRef(this, listener: _listener)),
      listen: listen,
      name: name,
    );
  }

  @override
  TResult? getAlreadyExistsScopedValue<TResult,
      TScopedValue extends ScopedValue<TResult>>({
    String? name,
    bool listen = false,
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

@immutable
class _ScopedValueRef implements Ref, ListenableRef {
  const _ScopedValueRef(
    this.ref, {
    this.listener,
  });

  final Ref ref;
  final ScopedValueListener? listener;

  @override
  TResult getScopedValue<TResult, TScopedValue extends ScopedValue<TResult>>(
    TScopedValue Function(Ref ref) provider, {
    bool listen = false,
    String? name,
  }) {
    return ref.getScopedValue(
      provider,
      listen: listen,
      name: name,
    );
  }

  @override
  TResult? getAlreadyExistsScopedValue<TResult,
      TScopedValue extends ScopedValue<TResult>>({
    String? name,
    bool listen = false,
  }) {
    return ref.getAlreadyExistsScopedValue(
      listen: listen,
      name: name,
    );
  }

  @override
  void addListener(VoidCallback callback) {
    listener?._addListener(callback);
  }

  @override
  void removeListener(VoidCallback callback) {
    listener?._removeListener(callback);
  }

  @override
  String toString() => ref.toString();

  @override
  int get hashCode => ref.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// Catch and notify updates [Ref].
///
/// You can notify updates by calling [addListener] or [removeListener].
///
/// 更新をキャッチして通知する[Ref]。
///
/// [addListener]や[removeListener]を呼び出すことで更新を通知することができます。
abstract class ListenableRef implements Ref {
  const ListenableRef();

  /// Add [callback] to notify updates.
  ///
  /// 更新を通知する[callback]を追加します。
  void addListener(VoidCallback callback);

  /// Remove [callback] to notify updates.
  ///
  /// 更新を通知する[callback]を削除します。
  void removeListener(VoidCallback callback);
}
