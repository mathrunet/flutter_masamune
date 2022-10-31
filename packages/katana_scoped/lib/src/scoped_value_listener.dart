part of katana_scoped;

/// [ScopedValueListener] that targets the app.
///
/// アプリを対象にしている[ScopedValueListener]。
class AppScopedValueListener extends ScopedValueListener {
  AppScopedValueListener._({
    required BuildContext context,
    required VoidCallback callback,
  }) : super._(context: context, callback: callback);

  @override
  ScopedValueContainer get container {
    final appRef = _AppScopedScope.of(_context).widget.appRef;
    return appRef._scopedValueContainer;
  }
}

/// [ScopedValueListener] that targets the page.
///
/// ページを対象にしている[ScopedValueListener]。
class PageScopedValueListener extends ScopedValueListener {
  PageScopedValueListener._({
    required BuildContext context,
    required VoidCallback callback,
  }) : super._(context: context, callback: callback);

  @override
  ScopedValueContainer get container {
    return _PageScopedScope.of(_context)._container;
  }
}

/// An object to monitor [ScopedValue] in the widget.
///
/// [container] to obtain a [ScopedValueContainer] and pass the change notification sent from the [ScopedValue] stored in the container to the associated widget.
///
/// [getScopedValueResult] associates [ScopedValue] and reads the result.
///
/// [ScopedValue]をウィジェット中で監視するためのオブジェクト。
///
/// [container]で[ScopedValueContainer]を取得しそこに保存されている[ScopedValue]から送られた変更通知を関連付けれられたウィジェットに渡します。
///
/// [getScopedValueResult]で[ScopedValue]の関連付けと結果の読み取りを行ないます。
class ScopedValueListener {
  ScopedValueListener._({
    required BuildContext context,
    required VoidCallback callback,
    ScopedValueContainer? container,
  })  : _context = context,
        _callback = callback,
        _container = container;

  final BuildContext _context;
  final VoidCallback _callback;
  final ScopedValueContainer? _container;
  final Set<ScopedValueState> _watched = {};

  /// [ScopedValueContainer] that stores [ScopedValue].
  ///
  /// [ScopedValue]を保存している[ScopedValueContainer]。
  ScopedValueContainer get container {
    assert(_container != null, "[ScopedValueContainer] is not passed.");
    return _container!;
  }

  /// [TScopedValue] by passing [provider] and returns the result.
  ///
  /// If [listen] is `true`, then it should be associated with the widget to notify it of changes.
  ///
  /// [name] so that they can be recognized as different objects even if they have the same type.
  ///
  /// [provider]を渡すことにより[TScopedValue]を取得し、その結果を返します。
  ///
  /// [listen]が`true`の場合、ウィジェットに関連付けて変更を通知するようにします。
  ///
  /// [name]を指定すると型が同じ場合でも別のオブジェクトとして認識できるようにすることが可能です。
  TResult
      getScopedValueResult<TResult, TScopedValue extends ScopedValue<TResult>>(
    TScopedValue Function() provider, {
    bool listen = false,
    String? name,
  }) {
    final state = container.getScopedValueState<TResult, TScopedValue>(
      provider,
      onInitOrUpdate: (state) {
        if (listen) {
          state._addListener(_callback);
        }
      },
      name: name,
    );
    return state.build();
  }

  /// Executed just before the widget is destroyed.
  ///
  /// ScopedValueState.deactivate] is executed for the monitored [ScopedValue] and the retained [ScopedValueContainer].
  ///
  /// ウィジェットが破棄される直前に実行します。
  ///
  /// 監視している[ScopedValue]と保持している[ScopedValueContainer]を対象に[ScopedValueState.deactivate]が実行されます。
  void diactivate() {
    for (final watched in _watched) {
      watched.deactivate();
    }
    if (_container != null) {
      _container!.diactivate();
    }
  }

  /// Executed when the widget is destroyed.
  ///
  /// ScopedValueState.dispose] is executed on the monitored [ScopedValue] and the retained [ScopedValueContainer].
  ///
  /// ウィジェットが破棄される際に実行します。
  ///
  /// 監視している[ScopedValue]と保持している[ScopedValueContainer]を対象に[ScopedValueState.dispose]が実行されます。
  void dispose() {
    for (final watched in _watched) {
      watched.dispose();
      watched._removeListener(_callback);
    }
    _watched.clear();
    if (_container != null) {
      _container!.dispose();
    }
  }
}
