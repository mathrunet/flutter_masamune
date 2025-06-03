part of "value.dart";

/// Provides extension methods for [PageOrWidgetScopedValueRef] for processing in the lifecycle.
///
/// ライフサイクルにおける処理を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension PageOrWidgetScopedValueRefOnExtensions on PageOrWidgetScopedValueRef {
  /// Processing in the lifecycle.
  ///
  /// The process passed to [initOrUpdate] is executed the first time and when [keys] is passed a value different from the previous value.
  ///
  /// [initOrUpdate] can return [FutureOr]. In that case, [OnContext] is returned, so the end can be detected by [OnContext.initOrUpdating] there, such as [FutureBuilder].
  ///
  /// If [disposed] is specified, you can pass the process to be executed when the widget is disposed.
  ///
  /// ライフサイクルにおける処理を行います。
  ///
  /// [initOrUpdate]に渡した処理が初回、および[keys]が前の値と違う値が渡されたタイミングで実行されます。
  ///
  /// [initOrUpdate]は[FutureOr]を返すことができます。その場合、[OnContext]が返されるためそこの[OnContext.initOrUpdating]で終了を[FutureBuilder]等で検知することができます。
  ///
  /// [disposed]を指定すると、ウィジェットが破棄される際に実行される処理を渡すことができます。
  OnContext on({
    FutureOr<void> Function()? initOrUpdate,
    VoidCallback? disposed,
    VoidCallback? appResumed,
    VoidCallback? appInactive,
    VoidCallback? appPaused,
    VoidCallback? appDetached,
    VoidCallback? appHidden,
    List<Object> keys = const [],
  }) {
    return getScopedValue<OnContext, _OnValue>(
      (ref) => _OnValue(
        onInitOrUpdate: initOrUpdate,
        onDispose: disposed,
        onAppResumed: appResumed,
        onAppInactive: appInactive,
        onAppPaused: appPaused,
        onAppDetached: appDetached,
        onAppHidden: appHidden,
        keys: keys,
      ),
    );
  }
}

/// Provides extension methods for [RefHasPage] for processing in the lifecycle.
///
/// ライフサイクルにおける処理を行うための[RefHasPage]用の拡張メソッドを提供します。
extension RefHasPageOnExtensions on RefHasPage {
  @Deprecated(
    "It is no longer possible to use [on] by directly specifying [PageRef] or [WidgetRef]. Instead, use [ref.page.on] or [ref.widget.on] to specify the scope. [PageRef]や[WidgetRef]を直接指定しての[on]の利用はできなくなります。代わりに[ref.page.on]や[ref.widget.on]でスコープを指定しての利用を行ってください。",
  )
  OnContext on({
    FutureOr<void> Function()? initOrUpdate,
    VoidCallback? disposed,
    List<Object> keys = const [],
  }) {
    return page.getScopedValue<OnContext, _OnValue>(
      (ref) => _OnValue(
        onInitOrUpdate: initOrUpdate,
        onDispose: disposed,
        keys: keys,
      ),
    );
  }
}

@immutable
class _OnValue extends ScopedValue<OnContext> {
  const _OnValue({
    required this.onInitOrUpdate,
    required this.onDispose,
    this.onAppDetached,
    this.onAppInactive,
    this.onAppPaused,
    this.onAppResumed,
    this.onAppHidden,
    this.keys = const [],
  });
  final FutureOr<void> Function()? onInitOrUpdate;
  final VoidCallback? onDispose;
  final VoidCallback? onAppResumed;
  final VoidCallback? onAppInactive;
  final VoidCallback? onAppPaused;
  final VoidCallback? onAppDetached;
  final VoidCallback? onAppHidden;

  final List<Object> keys;

  @override
  ScopedValueState<OnContext, ScopedValue<OnContext>> createState() {
    if (onAppResumed != null ||
        onAppInactive != null ||
        onAppPaused != null ||
        onAppDetached != null ||
        onAppHidden != null) {
      return _OnValueStateWithWidgetsBindingObserver();
    }
    return _OnValueState();
  }
}

class _OnValueStateWithWidgetsBindingObserver extends _OnValueState
    with WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        value.onAppResumed?.call();
        break;
      case AppLifecycleState.inactive:
        value.onAppInactive?.call();
        break;
      case AppLifecycleState.paused:
        value.onAppPaused?.call();
        break;
      case AppLifecycleState.detached:
        value.onAppDetached?.call();
        break;
      case AppLifecycleState.hidden:
        value.onAppHidden?.call();
        break;
    }
  }

  @override
  Future<void> initValue() async {
    super.initValue();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class _OnValueState extends ScopedValueState<OnContext, _OnValue> {
  final OnContext _context = OnContext._();

  @override
  Future<void> initValue() async {
    super.initValue();
    try {
      _context._completer = Completer();
      await value.onInitOrUpdate?.call();
      _context._completer?.complete();
      _context._completer = null;
    } catch (e) {
      _context._completer?.completeError(e);
      _context._completer = null;
    } finally {
      _context._completer?.complete();
      _context._completer = null;
    }
  }

  @override
  Future<void> didUpdateValue(_OnValue oldValue) async {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      try {
        _context._completer = Completer();
        await value.onInitOrUpdate?.call();
        _context._completer?.complete();
        _context._completer = null;
      } catch (e) {
        _context._completer?.completeError(e);
        _context._completer = null;
      } finally {
        _context._completer?.complete();
        _context._completer = null;
      }
    }
  }

  @override
  void dispose() {
    value.onDispose?.call();
    super.dispose();
  }

  @override
  OnContext build() => _context;
}

/// Object returned when executing [on].
///
/// If the `initOrUpdating` process returns [Future] when it is executed, it can be monitored by [initOrUpdating] until it is finished.
///
/// Use [FutureBuilder], for example.
///
/// [on]を実行する際に返されるオブジェクト。
///
/// `initOrUpdating`の処理を実行した際に[Future]を返すようにした場合、それが終了するまで[initOrUpdating]で監視することができます。
///
/// [FutureBuilder]などで利用してください。
class OnContext {
  OnContext._();
  Completer<void>? _completer;

  /// [Future] to monitor the end of `on` `initOrUpdate` when it is executed.
  ///
  /// `on`の`initOrUpdate`を実行したときにその終了を監視するための[Future]。
  Future<void>? get initOrUpdating => _completer?.future;

  /// Returns `true` if `on` `initOrUpdate` is executed and terminated.
  ///
  /// `on`の`initOrUpdate`を実行したときに終了した場合`true`を返す。
  bool get initOrUpdated => _completer == null;
}
