part of "/masamune_painter.dart";

const _kColorHistoryKey = "colorHistory";

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
      : _canvasSize = canvasSize {
    // Initialize history with empty state
    _history.add(<PaintingValue>[]);
    _historyIndex = 0;
  }

  /// Query for PainterController.
  ///
  /// ```dart
  /// appRef.controller(PainterController.query(parameters));     // Get from application scope.
  /// ref.app.controller(PainterController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(PainterController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$PainterControllerQuery();

  /// Maximum number of history entries to keep.
  ///
  /// 保持する履歴エントリの最大数。
  static const int _maxHistorySize = 50;

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
  Size? _canvasSize;

  /// The tool currently in use.
  ///
  /// 現在使用しているツール。
  PainterTools? get currentTool => _currentTool;
  PainterTools? _currentTool;
  PainterTools? _prevTool;

  /// Set the canvas size.
  ///
  /// キャンバスサイズを設定します。
  void setCanvasSize(Size size) {
    if (_canvasSize == size) {
      return;
    }
    _canvasSize = size;
    notifyListeners();
  }

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

  final List<PaintingValue> _values = [];

  /// The background color of the current tool.
  ///
  /// 現在のツールの背景色。
  Color get currentToolBackgroundColor =>
      _currentToolBackgroundColor ?? adapter.defaultBackgroundColor;
  Color? _currentToolBackgroundColor;

  /// The foreground color of the current tool.
  ///
  /// 現在のツールの前景色。
  Color get currentToolForegroundColor =>
      _currentToolForegroundColor ?? adapter.defaultForegroundColor;
  Color? _currentToolForegroundColor;

  /// The line block tools of the current tool.
  ///
  /// 現在のツールの線ブロックツール。
  PainterLineBlockTools get currentToolLine =>
      _currentToolLine ?? adapter.defaultLine;
  PainterLineBlockTools? _currentToolLine;

  /// The background color of the current value.
  ///
  /// 現在の値の背景色。
  Color? get currentValueBackgroundColor {
    var different = false;
    final colors = <Color?>[];
    for (final value in currentValues) {
      final color = value.backgroundColor;
      if (colors.any((e) => e != color)) {
        different = true;
      }
      colors.add(color);
    }
    if (different) {
      return null;
    }
    return colors.first ?? Colors.transparent;
  }

  /// The foreground color of the current value.
  ///
  /// 現在の値の前景色。
  Color? get currentValueForegroundColor {
    var different = false;
    final colors = <Color?>[];
    for (final value in currentValues) {
      final color = value.foregroundColor;
      if (colors.any((e) => e != color)) {
        different = true;
      }
      colors.add(color);
    }
    if (different) {
      return null;
    }
    return colors.first ?? Colors.transparent;
  }

  /// The line block tools of the current value.
  ///
  /// 現在の値の線ブロックツール。
  PainterLineBlockTools? get currentValueLine {
    var different = false;
    final tools = <PainterLineBlockTools?>[];
    for (final value in currentValues) {
      final tool = value.tool;
      if (tools.any((e) => e?.id != tool?.id)) {
        different = true;
      }
      tools.add(tool);
    }
    if (different) {
      return null;
    }
    return tools.first ?? PainterMasamuneAdapter.primary.defaultLine;
  }

  bool _loaded = false;
  Completer<void>? _loadCompleter;
  SharedPreferencesWithCache? _cachedSharedPreferences;

  /// Load color history.
  ///
  /// 色履歴を読み込みます。
  Future<void> load() async {
    if (_loadCompleter != null) {
      return _loadCompleter!.future;
    }
    if (_loaded) {
      return;
    }
    _loadCompleter = Completer<void>();
    try {
      _cachedSharedPreferences = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
          allowList: {
            _kColorHistoryKey.toSHA1(),
          },
        ),
      );
      _loaded = true;
      notifyListeners();
      _loadCompleter?.complete();
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
  }

  /// Get the color history.
  ///
  /// 色履歴を取得します。
  List<Color> get colorHistory =>
      _cachedSharedPreferences
          ?.getStringList(_kColorHistoryKey.toSHA1())
          ?.mapAndRemoveEmpty((e) {
        final colorInt = int.tryParse("0x$e");
        if (colorInt == null) {
          return null;
        }
        return Color(colorInt);
      }) ??
      [];

  /// Add a color to the color history.
  ///
  /// 色履歴に色を追加します。
  Future<void> addColorToHistory(Color color) async {
    final history = colorHistory.clone(growable: true);
    var removed = false;
    history.removeWhere((e) {
      if (e == color) {
        removed = true;
        return true;
      }
      return false;
    });
    if (!removed && history.length >= adapter.maxColorHistory) {
      history.removeLast();
    }
    history.insertFirst(color);
    await _cachedSharedPreferences?.setStringList(
      _kColorHistoryKey.toSHA1(),
      history.map((e) => e.toHexString()).toList(),
    );
  }

  /// Sets the properties of the current tool.
  ///
  /// 現在のツールのプロパティを設定します。
  void setToolProperty({
    Color? backgroundColor,
    Color? foregroundColor,
    PainterLineBlockTools? tool,
  }) {
    var changed = false;
    if (backgroundColor != null &&
        backgroundColor != _currentToolBackgroundColor) {
      _currentToolBackgroundColor = backgroundColor;
      changed = true;
    }
    if (foregroundColor != null &&
        foregroundColor != _currentToolForegroundColor) {
      _currentToolForegroundColor = foregroundColor;
      changed = true;
    }
    if (tool != null && tool != _currentToolLine) {
      _currentToolLine = tool;
      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
  }

  /// Sets the properties of the current values.
  ///
  /// 現在の値のプロパティを設定します。
  void setValueProperty({
    Color? backgroundColor,
    Color? foregroundColor,
    PainterLineBlockTools? tool,
  }) {
    var changed = false;
    for (var i = 0; i < _currentValues.length; i++) {
      if (backgroundColor != null) {
        changed = true;
        _currentValues[i] = _currentValues[i].copyWith(
          backgroundColor: backgroundColor,
        );
      }
      if (foregroundColor != null) {
        changed = true;
        _currentValues[i] = _currentValues[i].copyWith(
          foregroundColor: foregroundColor,
        );
      }
      if (tool != null) {
        changed = true;
        _currentValues[i] = _currentValues[i].copyWith(
          tool: tool,
        );
      }
    }
    if (changed) {
      saveCurrentValue(saveToHistory: true);
      notifyListeners();
    }
  }

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

  /// Check if there is data in the clipboard that can be pasted.
  ///
  /// ペースト可能なデータがクリップボードにあるかチェック。
  bool get canPaste => _clipboardData != null && _clipboardData!.isNotEmpty;

  /// Check if undo is available.
  ///
  /// Undoが利用可能かチェック。
  bool get canUndo => _historyIndex > 0;

  /// Check if redo is available.
  ///
  /// Redoが利用可能かチェック。
  bool get canRedo => _historyIndex < _history.length - 1;

  int _historyIndex = -1;
  Rect? _dragSelectionRect;
  List<PaintingValue>? _clipboardData;

  final List<List<PaintingValue>> _history = [];

  /// Save the current editing values to values list.
  ///
  /// 現在編集中の値を値リストに保存。
  void saveCurrentValue({bool saveToHistory = false}) {
    for (final currentValue in _currentValues) {
      final existingIndex = _values.indexWhere((v) => v.id == currentValue.id);
      if (existingIndex >= 0) {
        _values[existingIndex] = currentValue;
      } else {
        _values.add(currentValue);
      }
    }

    if (saveToHistory) {
      _saveToHistory();
    }
  }

  void _saveToHistory() {
    // Remove any history after the current index (when we're in the middle of history)
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    // Add current state to history
    _history.add(List<PaintingValue>.from(_values));
    _historyIndex = _history.length - 1;

    // Limit history size
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  /// Deselect all.
  ///
  /// 全選択解除。
  void unselect() {
    // 選択解除前に編集中の値を保存
    saveCurrentValue();
    if (_currentTool?.unselectOnDone ?? true) {
      _currentTool = null;
    }
    _currentValues.clear();
    _dragSelectionRect = null;
    notifyListeners();
  }

  /// Clear the current value.
  ///
  /// 現在の値をクリアします。
  void clear() {
    // Save current values first
    saveCurrentValue();

    _values.clear();
    _currentValues.clear();
    _dragSelectionRect = null;

    // Save to history after clearing
    _saveToHistory();

    notifyListeners();
  }

  /// Undo the last action.
  ///
  /// 最後のアクションを元に戻す。
  void undo() {
    if (!canUndo) {
      return;
    }

    _historyIndex--;
    _values.clear();
    _values.addAll(List<PaintingValue>.from(_history[_historyIndex]));
    _currentValues.clear();
    _dragSelectionRect = null;
    notifyListeners();
  }

  /// Redo the last undone action.
  ///
  /// 最後に元に戻したアクションをやり直す。
  void redo() {
    if (!canRedo) {
      return;
    }

    _historyIndex++;
    _values.clear();
    _values.addAll(List<PaintingValue>.from(_history[_historyIndex]));
    _currentValues.clear();
    _dragSelectionRect = null;
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
    _dragSelectionRect = null;
    notifyListeners();
  }

  /// Update the current values for editing (multiple selection).
  ///
  /// 編集用の現在値を更新します（複数選択）。
  void updateCurrentValues(List<PaintingValue> values) {
    _currentValues.clear();
    _currentValues.addAll(values);
    _dragSelectionRect = null;
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
    _dragSelectionRect = rect;
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

    // Calculate new bounds after scaling
    late final Rect newBounds;
    switch (direction) {
      case PainterResizeDirection.topLeft:
        newBounds = Rect.fromLTRB(
          currentPoint.dx,
          currentPoint.dy,
          bounds.right,
          bounds.bottom,
        );
        break;
      case PainterResizeDirection.topRight:
        newBounds = Rect.fromLTRB(
          bounds.left,
          currentPoint.dy,
          currentPoint.dx,
          bounds.bottom,
        );
        break;
      case PainterResizeDirection.bottomLeft:
        newBounds = Rect.fromLTRB(
          currentPoint.dx,
          bounds.top,
          bounds.right,
          currentPoint.dy,
        );
        break;
      case PainterResizeDirection.bottomRight:
        newBounds = Rect.fromLTRB(
          bounds.left,
          bounds.top,
          currentPoint.dx,
          currentPoint.dy,
        );
        break;
      case PainterResizeDirection.left:
        newBounds = Rect.fromLTRB(
          currentPoint.dx,
          bounds.top,
          bounds.right,
          bounds.bottom,
        );
        break;
      case PainterResizeDirection.right:
        newBounds = Rect.fromLTRB(
          bounds.left,
          bounds.top,
          currentPoint.dx,
          bounds.bottom,
        );
        break;
      case PainterResizeDirection.top:
        newBounds = Rect.fromLTRB(
          bounds.left,
          currentPoint.dy,
          bounds.right,
          bounds.bottom,
        );
        break;
      case PainterResizeDirection.bottom:
        newBounds = Rect.fromLTRB(
          bounds.left,
          bounds.top,
          bounds.right,
          currentPoint.dy,
        );
        break;
    }

    // Apply resize to each selected value
    final updatedValues = <PaintingValue>[];
    for (final value in _currentValues) {
      // Calculate relative position within original bounds
      final valueRect = value.rect;
      final relativeX = (valueRect.left - bounds.left) / bounds.width;
      final relativeY = (valueRect.top - bounds.top) / bounds.height;
      final relativeWidth = valueRect.width / bounds.width;
      final relativeHeight = valueRect.height / bounds.height;

      // Calculate new position and size based on new bounds
      final newLeft = newBounds.left + relativeX * newBounds.width;
      final newTop = newBounds.top + relativeY * newBounds.height;
      final newWidth = relativeWidth * newBounds.width;
      final newHeight = relativeHeight * newBounds.height;

      final newStartPoint = Offset(newLeft, newTop);
      final newEndPoint = Offset(newLeft + newWidth, newTop + newHeight);

      updatedValues.add(value.updateOnResizing(
        currentPoint: newEndPoint,
        startPoint: newStartPoint,
        endPoint: newEndPoint,
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
    for (int i = _values.length - 1; i >= 0; i--) {
      final value = _values[i];
      if (value.rect.contains(point)) {
        return value;
      }
    }
    return null;
  }

  /// Copy the selected values to clipboard.
  ///
  /// 選択した値をクリップボードにコピー。
  Future<void> copy() async {
    if (_currentValues.isEmpty) {
      return;
    }

    // Save current editing values first (without history)
    saveCurrentValue();

    // Copy to internal clipboard
    _clipboardData = List<PaintingValue>.from(_currentValues);

    // Try to copy to system clipboard as both JSON and image
    try {
      // Copy as JSON for internal use
      final jsonData = _currentValues.map((v) => v.toJson()).toList();
      final jsonString = jsonEncode({
        "type": "masamune_painter_data",
        "version": "1.0",
        "data": jsonData,
      });

      // Copy as image for external use
      final imageData = await _captureSelectionAsImage();
      if (imageData != null) {
        // Set both text and image data
        await Clipboard.setData(ClipboardData(text: jsonString));
        // Note: Flutter doesn't support setting image data directly to clipboard
        // This would require platform-specific implementation
      } else {
        // Fallback to JSON only
        await Clipboard.setData(ClipboardData(text: jsonString));
      }
    } catch (e) {
      // Ignore errors for system clipboard
    }

    notifyListeners();
  }

  /// Cut the selected values to clipboard.
  ///
  /// 選択した値をクリップボードにカット。
  Future<void> cut() async {
    if (_currentValues.isEmpty) {
      return;
    }

    // Save current values first
    saveCurrentValue();

    // Copy to clipboard (without additional history save)
    await copy();

    // Remove cut values from the main list
    final cutIds = _currentValues.map((v) => v.id).toSet();
    _values.removeWhere((v) => cutIds.contains(v.id));

    // Clear selection
    _currentValues.clear();
    _dragSelectionRect = null;

    // Save to history after cutting
    _saveToHistory();

    notifyListeners();
  }

  /// Paste values from clipboard.
  ///
  /// クリップボードから値をペースト。
  Future<void> paste() async {
    // First try to get data from system clipboard
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData != null && clipboardData.text != null) {
        final jsonData = jsonDecode(clipboardData.text!);
        if (jsonData is Map &&
            jsonData.get("type", "") == "masamune_painter_data") {
          final dataList = jsonData.getAsList<DynamicMap>("data");
          _clipboardData = dataList
              .map(_createPaintingValueFromJson)
              .whereType<PaintingValue>()
              .toList();
        }
      }
    } catch (e) {
      // Ignore errors and use internal clipboard
    }

    // Paste from internal clipboard
    if (_clipboardData == null || _clipboardData!.isEmpty) {
      return;
    }

    // Save current values first
    saveCurrentValue();

    // Calculate paste offset (slightly offset from original position)
    const pasteOffset = Offset(20, 20);

    // Create new instances with new IDs and offset positions
    final newValues = <PaintingValue>[];
    for (final value in _clipboardData!) {
      final newValue = _createPastedValue(value, pasteOffset);
      newValues.add(newValue);
      _values.add(newValue);
    }

    // Select the pasted values
    _currentValues.clear();
    _currentValues.addAll(newValues);

    // Save to history after pasting
    _saveToHistory();

    notifyListeners();
  }

  /// Delete selected values.
  ///
  /// 選択した値を削除。
  void deleteSelected() {
    if (_currentValues.isEmpty) {
      return;
    }

    // Save current values first
    saveCurrentValue();

    // Remove selected values from the main list
    final selectedIds = _currentValues.map((v) => v.id).toSet();
    _values.removeWhere((v) => selectedIds.contains(v.id));

    // Clear selection
    _currentValues.clear();
    _dragSelectionRect = null;

    // Save to history after deleting
    _saveToHistory();

    notifyListeners();
  }

  /// Create a PaintingValue from JSON data.
  ///
  /// JSONデータからPaintingValueを作成。
  PaintingValue? _createPaintingValueFromJson(DynamicMap json) {
    final type = json.get("type", nullOfString);

    if (type == null) {
      return null;
    }

    final tools = adapter.defaultPrimaryTools
        .expand((e) => e.inlineTools ?? <PainterInlineTools>[])
        .toList();

    for (final tool in tools) {
      if (tool is! PainterVariableInlineTools) {
        continue;
      }
      final value = tool.convertFromJson(json);
      if (value != null) {
        return value;
      }
    }

    return null;
  }

  /// Create a new PaintingValue with a new ID and offset.
  ///
  /// 新しいIDとオフセットで新しいPaintingValueを作成。
  PaintingValue _createPastedValue(PaintingValue value, Offset offset) {
    return value.copyWith(offset: offset, id: uuid());
  }

  /// Capture the selected objects as an image.
  ///
  /// 選択されたオブジェクトを画像としてキャプチャ。
  Future<Uint8List?> _captureSelectionAsImage() async {
    if (_currentValues.isEmpty) {
      return null;
    }

    try {
      // Get the bounding rectangle of all selected objects
      final bounds = selectionBounds;
      if (bounds == null || bounds.width <= 0 || bounds.height <= 0) {
        return null;
      }

      // Add some padding around the selection
      const padding = 10.0;
      final paddedBounds = Rect.fromLTRB(
        bounds.left - padding,
        bounds.top - padding,
        bounds.right + padding,
        bounds.bottom + padding,
      );

      // Create a picture recorder to capture the drawing
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, paddedBounds);

      // Fill background with transparent color
      canvas.drawRect(paddedBounds, Paint()..color = Colors.transparent);

      // Translate canvas to center the selection
      canvas.translate(-paddedBounds.left, -paddedBounds.top);

      // Draw only the selected objects
      for (final value in _currentValues) {
        value.paint(canvas);
      }

      // End recording and create image
      final picture = recorder.endRecording();
      final image = await picture.toImage(
        paddedBounds.width.ceil(),
        paddedBounds.height.ceil(),
      );

      // Convert to PNG bytes
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      picture.dispose();
      image.dispose();

      return byteData?.buffer.asUint8List();
    } catch (e) {
      // Return null if image capture fails
      return null;
    }
  }

  /// Get the captured image data of selected objects.
  ///
  /// 選択されたオブジェクトの画像データを取得。
  Future<Uint8List?> captureSelectionAsImage() async {
    return await _captureSelectionAsImage();
  }

  /// Export selected objects as image file.
  ///
  /// 選択されたオブジェクトを画像ファイルとしてエクスポート。
  Future<Uint8List?> exportSelectionAsImage({
    double scale = 1.0,
    Color? backgroundColor,
  }) async {
    if (_currentValues.isEmpty) {
      return null;
    }

    try {
      // Get the bounding rectangle of all selected objects
      final bounds = selectionBounds;
      if (bounds == null || bounds.width <= 0 || bounds.height <= 0) {
        return null;
      }

      // Add some padding around the selection
      const padding = 10.0;
      final paddedBounds = Rect.fromLTRB(
        bounds.left - padding,
        bounds.top - padding,
        bounds.right + padding,
        bounds.bottom + padding,
      );

      // Create a picture recorder to capture the drawing
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, paddedBounds);

      // Fill background with specified color or transparent
      final bgColor = backgroundColor ?? Colors.transparent;
      canvas.drawRect(paddedBounds, Paint()..color = bgColor);

      // Translate canvas to center the selection
      canvas.translate(-paddedBounds.left, -paddedBounds.top);

      // Draw only the selected objects
      for (final value in _currentValues) {
        value.paint(canvas);
      }

      // End recording and create image with scaling
      final picture = recorder.endRecording();
      final image = await picture.toImage(
        (paddedBounds.width * scale).ceil(),
        (paddedBounds.height * scale).ceil(),
      );

      // Convert to PNG bytes
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      picture.dispose();
      image.dispose();

      return byteData?.buffer.asUint8List();
    } catch (e) {
      // Return null if image capture fails
      return null;
    }
  }

  /// Copy selected objects as image only.
  ///
  /// 選択されたオブジェクトを画像のみでコピー。
  Future<void> copyAsImage() async {
    if (_currentValues.isEmpty) {
      return;
    }

    // Save current editing values first (without history)
    saveCurrentValue();

    // Copy to internal clipboard
    _clipboardData = List<PaintingValue>.from(_currentValues);

    // Try to capture and save as image
    try {
      final imageData = await _captureSelectionAsImage();
      if (imageData != null) {
        // For now, we'll save as base64 text since Flutter doesn't support
        // direct image clipboard on all platforms
        final base64Image = base64Encode(imageData);
        final imageText = "data:image/png;base64,$base64Image";
        await Clipboard.setData(ClipboardData(text: imageText));
      }
    } catch (e) {
      // Ignore errors for system clipboard
    }

    notifyListeners();
  }

  /// Save selected objects as image file data.
  ///
  /// 選択されたオブジェクトを画像ファイルデータとして保存。
  Future<Map<String, dynamic>?> saveSelectionAsImageData({
    double scale = 1.0,
    Color? backgroundColor,
  }) async {
    final imageData = await exportSelectionAsImage(
      scale: scale,
      backgroundColor: backgroundColor,
    );

    if (imageData == null) {
      return null;
    }

    return {
      "imageData": imageData,
      "width": (selectionBounds?.width ?? 0) * scale,
      "height": (selectionBounds?.height ?? 0) * scale,
      "format": "png",
      "mimeType": "image/png",
    };
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
