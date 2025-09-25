part of "/masamune_painter.dart";

/// Controller for [FormPainterField].
///
/// By passing this, you can integrate with [FormPainterToolbar] tools.
///
/// [FormPainterField]用のコントローラー。
///
/// これを渡すことで[FormPainterToolbar]のツールと連携することができます。
class PainterController extends MasamuneControllerBase<List<PaintingValue>,
    PainterMasamuneAdapter> {
  /// Controller for [FormPainterField].
  ///
  /// By passing this, you can integrate with [FormPainterToolbar] tools.
  ///
  /// [FormPainterField]用のコントローラー。
  ///
  /// これを渡すことで[FormPainterToolbar]のツールと連携することができます。
  PainterController({super.adapter, Size? canvasSize})
      : _canvasSize = canvasSize;

  /// Query for PainterController.
  ///
  /// ```dart
  /// appRef.controller(PainterController.query(parameters));     // Get from application scope.
  /// ref.app.controller(PainterController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(PainterController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$PainterControllerQuery();

  void _registerState(FormPainterFieldState state) {
    _currentState = state;
  }

  void _unregisterState(FormPainterFieldState state) {
    if (_currentState == state) {
      _currentState = null;
    }
  }

  FormPainterFieldState? _currentState;

  /// The size of the canvas.
  ///
  /// キャンバスのサイズ。
  Size get canvasSize => _canvasSize ?? adapter.defaultCanvasSize;
  final Size? _canvasSize;

  /// The tool currently in use.
  ///
  /// 現在使用しているツール。
  PainterTools? get currentTool => _currentTool;
  PainterTools? _currentTool;

  @override
  PainterMasamuneAdapter get primaryAdapter => PainterMasamuneAdapter.primary;

  @override
  List<PaintingValue> get value {
    if (_currentValue == null) {
      return _values;
    }
    var updating = false;
    final res = <PaintingValue>[];
    for (final value in _values) {
      if (_currentValue != null && value.id == _currentValue?.id) {
        updating = true;
        res.add(_currentValue!);
      } else {
        res.add(value);
      }
    }
    if (!updating) {
      res.add(_currentValue!);
    }
    return res;
  }

  PaintingValue? _currentValue;
  final List<PaintingValue> _values = [];

  /// Clear the current value.
  ///
  /// 現在の値をクリアします。
  void clear() {
    _values.clear();
    notifyListeners();
  }

  /// Update the current value for editing.
  ///
  /// 編集用の現在値を更新します。
  void updateCurrentValue(PaintingValue? value) {
    _currentValue = value;
    notifyListeners();
  }
}

@immutable
class _$PainterControllerQuery {
  const _$PainterControllerQuery();

  @useResult
  _$_PainterControllerQuery call({PainterMasamuneAdapter? adapter}) =>
      _$_PainterControllerQuery(
        hashCode.toString(),
        adapter: adapter,
      );
}

@immutable
class _$_PainterControllerQuery extends ControllerQueryBase<PainterController> {
  const _$_PainterControllerQuery(this._name, {this.adapter});

  final String _name;

  final PainterMasamuneAdapter? adapter;

  @override
  PainterController Function() call(Ref ref) {
    return () => PainterController(adapter: adapter);
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
