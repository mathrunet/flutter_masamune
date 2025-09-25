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
    if (_currentValues.isEmpty) {
      return _values;
    }
    final res = <PaintingValue>[];
    final currentIds = _currentValues.map((v) => v.id).toSet();
    
    for (final value in _values) {
      if (currentIds.contains(value.id)) {
        res.add(_currentValues.firstWhere((v) => v.id == value.id));
      } else {
        res.add(value);
      }
    }
    
    // Add new values that don't exist in _values
    for (final current in _currentValues) {
      if (!_values.any((v) => v.id == current.id)) {
        res.add(current);
      }
    }
    
    return res;
  }

  /// Currently selected values (support multiple selection).
  ///
  /// 現在選択中の値（複数選択対応）。
  List<PaintingValue> get currentValues => _currentValues;
  final List<PaintingValue> _currentValues = [];
  
  /// Get the first selected value (for backward compatibility).
  ///
  /// 最初に選択された値を取得（後方互換性のため）。
  PaintingValue? get currentValue => _currentValues.isNotEmpty ? _currentValues.first : null;
  
  final List<PaintingValue> _values = [];
  
  /// The bounding rectangle of all selected elements.
  ///
  /// 全選択要素の境界矩形。
  Rect? get selectionBounds {
    if (_currentValues.isEmpty) {
      return null;
    }
    
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    
    for (final value in _currentValues) {
      final rect = value.rect;
      if (rect.left < minX) {
        minX = rect.left;
      }
      if (rect.top < minY) {
        minY = rect.top;
      }
      if (rect.right > maxX) {
        maxX = rect.right;
      }
      if (rect.bottom > maxY) {
        maxY = rect.bottom;
      }
    }
    
    if (minX == double.infinity) {
      return null;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
  
  /// Check if multiple elements are selected.
  ///
  /// 複数要素が選択されているかチェック。
  bool get hasMultipleSelection => _currentValues.length > 1;
  
  /// The drag selection rectangle.
  ///
  /// ドラッグ選択矩形。
  Rect? dragSelectionRect;

  /// Save the current editing values to values list.
  ///
  /// 現在編集中の値を値リストに保存。
  void saveCurrentValue() {
    for (final currentValue in _currentValues) {
      final existingIndex = _values.indexWhere((v) => v.id == currentValue.id);
      if (existingIndex >= 0) {
        _values[existingIndex] = currentValue;
      } else {
        _values.add(currentValue);
      }
    }
  }

  /// Deselect all.
  ///
  /// 全選択解除。
  void unselect() {
    // 選択解除前に編集中の値を保存
    saveCurrentValue();
    _currentTool = null;
    _currentValues.clear();
    dragSelectionRect = null;
    notifyListeners();
  }

  /// Clear the current value.
  ///
  /// 現在の値をクリアします。
  void clear() {
    _values.clear();
    _currentValues.clear();
    dragSelectionRect = null;
    notifyListeners();
  }

  /// Update the current value for editing (single selection).
  ///
  /// 編集用の現在値を更新します（単一選択）。
  void updateCurrentValue(PaintingValue? value) {
    _currentValues.clear();
    if (value != null) {
      _currentValues.add(value);
    }
    dragSelectionRect = null;
    notifyListeners();
  }
  
  /// Update the current values for editing (multiple selection).
  ///
  /// 編集用の現在値を更新します（複数選択）。
  void updateCurrentValues(List<PaintingValue> values) {
    _currentValues.clear();
    _currentValues.addAll(values);
    dragSelectionRect = null;
    notifyListeners();
  }
  
  /// Add a value to the current selection.
  ///
  /// 現在の選択に値を追加。
  void addToSelection(PaintingValue value) {
    if (!_currentValues.any((v) => v.id == value.id)) {
      _currentValues.add(value);
      notifyListeners();
    }
  }
  
  /// Remove a value from the current selection.
  ///
  /// 現在の選択から値を削除。
  void removeFromSelection(PaintingValue value) {
    _currentValues.removeWhere((v) => v.id == value.id);
    notifyListeners();
  }
  
  /// Toggle a value in the current selection.
  ///
  /// 現在の選択で値を切り替え。
  void toggleSelection(PaintingValue value) {
    final index = _currentValues.indexWhere((v) => v.id == value.id);
    if (index >= 0) {
      _currentValues.removeAt(index);
    } else {
      _currentValues.add(value);
    }
    notifyListeners();
  }
  
  /// Select values within the given rectangle.
  ///
  /// 指定された矩形内の値を選択。
  void selectInRectangle(Rect rect) {
    _currentValues.clear();
    
    for (final value in _values) {
      final valueRect = value.rect;
      // Check if the value's rectangle intersects with the selection rectangle
      if (rect.overlaps(valueRect)) {
        _currentValues.add(value);
      }
    }
    
    notifyListeners();
  }
  
  /// Update drag selection rectangle.
  ///
  /// ドラッグ選択矩形を更新。
  void updateDragSelectionRect(Rect? rect) {
    dragSelectionRect = rect;
    if (rect != null) {
      selectInRectangle(rect);
    }
    notifyListeners();
  }
  
  /// Move all selected values by the given delta.
  ///
  /// 選択された全ての値を指定されたデルタ分移動。
  void moveSelectedValues(Offset delta) {
    final updatedValues = <PaintingValue>[];
    for (final value in _currentValues) {
      updatedValues.add(value.updateOnMoving(delta: delta));
    }
    _currentValues.clear();
    _currentValues.addAll(updatedValues);
    notifyListeners();
  }
  
  /// Resize all selected values.
  ///
  /// 選択された全ての値をリサイズ。
  void resizeSelectedValues({
    required Offset currentPoint,
    required PainterResizeDirection direction,
  }) {
    if (_currentValues.isEmpty) {
      return;
    }
    
    // Calculate the resize ratio based on the selection bounds
    final bounds = selectionBounds;
    if (bounds == null) {
      return;
    }
    
    // For multiple selection, calculate scale factor
    var scaleX = 1.0;
    var scaleY = 1.0;
    
    switch (direction) {
      case PainterResizeDirection.topLeft:
        scaleX = (bounds.right - currentPoint.dx) / bounds.width;
        scaleY = (bounds.bottom - currentPoint.dy) / bounds.height;
        break;
      case PainterResizeDirection.topRight:
        scaleX = (currentPoint.dx - bounds.left) / bounds.width;
        scaleY = (bounds.bottom - currentPoint.dy) / bounds.height;
        break;
      case PainterResizeDirection.bottomLeft:
        scaleX = (bounds.right - currentPoint.dx) / bounds.width;
        scaleY = (currentPoint.dy - bounds.top) / bounds.height;
        break;
      case PainterResizeDirection.bottomRight:
        scaleX = (currentPoint.dx - bounds.left) / bounds.width;
        scaleY = (currentPoint.dy - bounds.top) / bounds.height;
        break;
      case PainterResizeDirection.left:
        scaleX = (bounds.right - currentPoint.dx) / bounds.width;
        break;
      case PainterResizeDirection.right:
        scaleX = (currentPoint.dx - bounds.left) / bounds.width;
        break;
      case PainterResizeDirection.top:
        scaleY = (bounds.bottom - currentPoint.dy) / bounds.height;
        break;
      case PainterResizeDirection.bottom:
        scaleY = (currentPoint.dy - bounds.top) / bounds.height;
        break;
    }
    
    // Apply resize to each selected value
    final updatedValues = <PaintingValue>[];
    for (final value in _currentValues) {
      // Calculate new position for each value based on scale
      final valueRect = value.rect;
      final relativeX = (valueRect.left - bounds.left) / bounds.width;
      final relativeY = (valueRect.top - bounds.top) / bounds.height;
      
      final newLeft = bounds.left + relativeX * bounds.width * scaleX;
      final newTop = bounds.top + relativeY * bounds.height * scaleY;
      final newPoint = Offset(newLeft + valueRect.width * scaleX, newTop + valueRect.height * scaleY);
      
      updatedValues.add(value.updateOnResizing(
        currentPoint: newPoint,
        direction: direction,
      ));
    }
    
    _currentValues.clear();
    _currentValues.addAll(updatedValues);
    notifyListeners();
  }
  
  /// Find a value at the given point.
  ///
  /// 指定された点にある値を見つける。
  PaintingValue? findValueAt(Offset point) {
    // Search from the end (top layer) to the beginning (bottom layer)
    for (int i = _values.length - 1; i >= 0; i--) {
      final value = _values[i];
      if (value.rect.contains(point)) {
        return value;
      }
    }
    return null;
  }
  
  /// Check if the given point is on the selection bounds edge (for resize handles).
  ///
  /// 指定された点が選択境界のエッジ上にあるかチェック（リサイズハンドル用）。
  PainterResizeDirection? getResizeDirectionAt(Offset point, {double tolerance = 8.0}) {
    final bounds = selectionBounds;
    if (bounds == null) {
      return null;
    }
    
    // Check corners first
    if ((point.dx - bounds.left).abs() <= tolerance && 
        (point.dy - bounds.top).abs() <= tolerance) {
      return PainterResizeDirection.topLeft;
    }
    if ((point.dx - bounds.right).abs() <= tolerance && 
        (point.dy - bounds.top).abs() <= tolerance) {
      return PainterResizeDirection.topRight;
    }
    if ((point.dx - bounds.left).abs() <= tolerance && 
        (point.dy - bounds.bottom).abs() <= tolerance) {
      return PainterResizeDirection.bottomLeft;
    }
    if ((point.dx - bounds.right).abs() <= tolerance && 
        (point.dy - bounds.bottom).abs() <= tolerance) {
      return PainterResizeDirection.bottomRight;
    }
    
    // Check edges
    if ((point.dx - bounds.left).abs() <= tolerance && 
        point.dy >= bounds.top && point.dy <= bounds.bottom) {
      return PainterResizeDirection.left;
    }
    if ((point.dx - bounds.right).abs() <= tolerance && 
        point.dy >= bounds.top && point.dy <= bounds.bottom) {
      return PainterResizeDirection.right;
    }
    if ((point.dy - bounds.top).abs() <= tolerance && 
        point.dx >= bounds.left && point.dx <= bounds.right) {
      return PainterResizeDirection.top;
    }
    if ((point.dy - bounds.bottom).abs() <= tolerance && 
        point.dx >= bounds.left && point.dx <= bounds.right) {
      return PainterResizeDirection.bottom;
    }
    
    return null;
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
