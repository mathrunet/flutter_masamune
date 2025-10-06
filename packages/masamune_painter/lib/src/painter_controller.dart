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
      : _canvasSize = canvasSize;

  /// Query for PainterController.
  ///
  /// ```dart
  /// appRef.controller(PainterController.query(parameters));     // Get from application scope.
  /// ref.app.controller(PainterController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(PainterController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$PainterControllerQuery();

  @override
  PainterMasamuneAdapter get primaryAdapter => PainterMasamuneAdapter.primary;

  @override
  List<PaintingValue> get value {
    if (_currentValues.isEmpty) {
      return _values;
    }
    final res = <PaintingValue>[];

    for (final value in _values) {
      final found = _currentValues.firstWhereOrNull((v) => v.id == value.id);
      if (found != null) {
        res.add(found);
      } else {
        res.add(value);
      }
    }

    // Add new values that don't exist in _values
    for (final current in _currentValues) {
      if (_values.any((v) => v.id == current.id)) {
        continue;
      }
      res.add(current);
    }

    return res;
  }

  /// Get the values that are not in a group.
  ///
  /// グループに含まれていない値を取得します。
  List<PaintingValue> get ungroupedValues {
    final groupedValues = value
        .expand((v) => v is GroupPaintingValue ? v.children : <PaintingValue>[])
        .toList();
    return value.where((v) => !groupedValues.contains(v)).toList();
  }

  final List<PaintingValue> _values = [];

  /// Currently selected values (support multiple selection).
  ///
  /// 現在選択中の値（複数選択対応）。
  List<PaintingValue> get currentValues => _currentValues;

  /// Get the values that are not in a group.
  ///
  /// グループに含まれていない値を取得します。
  List<PaintingValue> get currentUngroupedValues {
    final groupedValues = currentValues
        .expand((v) => v is GroupPaintingValue ? v.children : <PaintingValue>[])
        .toList();
    return currentValues.where((v) => !groupedValues.contains(v)).toList();
  }

  /// Save the current editing values to values list.
  ///
  /// 現在編集中の値を値リストに保存。
  void saveCurrentValue({bool saveToHistory = false}) {
    // First, update child values in their parent groups
    for (final currentValue in _currentValues) {
      // Check if this value is a child of a group
      final parentGroupIndex = _values.indexWhere((v) {
        if (v is GroupPaintingValue) {
          return v.children.any((child) => child.id == currentValue.id);
        }
        return false;
      });

      if (parentGroupIndex >= 0) {
        final parentGroup = _values[parentGroupIndex] as GroupPaintingValue;

        // Update the child value in the group
        final updatedChildren = parentGroup.children.map((child) {
          if (child.id == currentValue.id) {
            return currentValue;
          }
          return child;
        }).toList();

        // Calculate new bounds for the group based on child values
        final bounds = _calculateBounds(updatedChildren);

        // Update the group with new child values and bounds
        _values[parentGroupIndex] = parentGroup.copyWith(
          children: updatedChildren,
          start: bounds.topLeft,
          end: bounds.bottomRight,
        );
      }
    }

    // Then save all current values normally
    for (final currentValue in _currentValues) {
      final existingIndex = _values.indexWhere((v) => v.id == currentValue.id);
      if (existingIndex >= 0) {
        _values[existingIndex] = currentValue;
      } else {
        _values.add(currentValue);
      }
    }

    if (saveToHistory) {
      history._saveToHistory();
    }
  }

  final List<PaintingValue> _currentValues = [];

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

  /// The tool currently in use.
  ///
  /// 現在使用しているツール。
  PainterTools? get currentTool => _currentTool;
  PainterTools? _currentTool;
  PainterTools? _prevTool;

  void _registerState(FormPainterFieldState state) {
    _currentState = state;
  }

  void _unregisterState(FormPainterFieldState state) {
    if (_currentState == state) {
      _currentState = null;
    }
  }

  FormPainterFieldState? _currentState;

  void _registerToolbar(FormPainterToolbarState state) {
    _currentToolbar = state;
  }

  void _unregisterToolbar(FormPainterToolbarState state) {
    if (_currentToolbar == state) {
      _currentToolbar = null;
    }
  }

  FormPainterToolbarState? _currentToolbar;

  /// The size of the canvas.
  ///
  /// キャンバスのサイズ。
  Size get canvasSize => _canvasSize ?? adapter.defaultCanvasSize;
  Size? _canvasSize;

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

  /// Property of [PainterController].
  ///
  /// [PainterController]のツール等のプロパティ。
  late final PainterControllerProperty property =
      PainterControllerProperty._(this);

  /// History of actions of [PainterController].
  ///
  /// [PainterController]のアクション履歴。
  late final PainterControllerHistory history =
      PainterControllerHistory._(this);

  /// History of colors of [PainterController].
  ///
  /// [PainterController]の色パレット履歴。
  late final PainterControllerColorPalette colorPalette =
      PainterControllerColorPalette._(this);

  /// History of clipboard of [PainterController].
  ///
  /// [PainterController]のクリップボード履歴。
  late final PainterControllerClipboard clipboard =
      PainterControllerClipboard._(this);

  bool _loaded = false;
  Completer<void>? _loadCompleter;
  Rect? _dragSelectionRect;

  final List<VoidCallback> _onDragStartCallback = [];
  final List<VoidCallback> _onDragEndCallback = [];

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
      await colorPalette._initialize();
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

  /// Select a value.
  ///
  /// If the value is a group, all child values are also selected.
  ///
  /// 値を選択します。
  ///
  /// 値がグループの場合、すべての子要素も選択されます。
  void select(PaintingValue value) {
    saveCurrentValue();
    _currentValues.add(value);

    // If selecting a group, also add its children to selection
    if (value is GroupPaintingValue) {
      for (final child in value.children) {
        if (!_currentValues.any((v) => v.id == child.id)) {
          _currentValues.add(child);
        }
      }
    }

    _dragSelectionRect = null;
    notifyListeners();
  }

  /// Select all values.
  ///
  /// 全ての値を選択します。
  void selectAll() {
    saveCurrentValue();
    _currentValues.clear();
    for (final value in _values) {
      _currentValues.add(value);
    }
    _dragSelectionRect = null;
    notifyListeners();
  }

  /// Unselect a value.
  ///
  /// If the value is a group, all child values are also unselected.
  ///
  /// 値を選択解除します。
  ///
  /// 値がグループの場合、すべての子要素も選択解除されます。
  void unselect(PaintingValue value) {
    saveCurrentValue();
    _currentValues.removeWhere((v) => v.id == value.id);

    // If unselecting a group, also remove its children from selection
    if (value is GroupPaintingValue) {
      final children = value.children;
      _currentValues.removeWhere(
        (v) => children.any((e) => e.id == v.id),
      );
    }

    _dragSelectionRect = null;
    notifyListeners();
  }

  /// Deselect all.
  ///
  /// 全選択解除。
  void unselectAll() {
    saveCurrentValue();
    if (_currentTool?.unselectOnDone ?? true) {
      _currentTool = null;
    }
    _currentValues.clear();
    _dragSelectionRect = null;
    notifyListeners();
  }

  /// Update the current value for editing (single selection).
  ///
  /// 編集用の現在値を更新します（単一選択）。
  void updateCurrentValue([PaintingValue? value]) {
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

  /// Create a group from selected values.
  ///
  /// The group will be placed at the position of the frontmost selected item.
  ///
  /// 選択した値からグループを作成します。
  ///
  /// グループは選択したアイテムの中で最も前面にあるものの位置に配置されます。
  GroupPaintingValue? createGroupFromSelection({
    String? groupName,
  }) {
    return createGroup(_currentValues, groupName: groupName);
  }

  /// Create a group from a list of values.
  ///
  /// リスト内の値からグループを作成します。
  GroupPaintingValue? createGroup(
    List<PaintingValue> values, {
    String? groupName,
  }) {
    if (values.length < 2) {
      return null;
    }

    // Save current values before grouping
    saveCurrentValue();

    // Flatten groups: if any selected values are groups, extract their children recursively
    final flattenedValues = <PaintingValue>[];
    final flattenedIds = <String>{};
    final groupIdsToRemove = <String>[];

    void flattenValue(PaintingValue value) {
      if (value is GroupPaintingValue) {
        // If it's a group, recursively flatten all its children
        groupIdsToRemove.add(value.id);
        for (final child in value.children) {
          flattenValue(child);
        }
      } else {
        // If it's a normal value, add it (avoid duplicates)
        if (!flattenedIds.contains(value.id)) {
          flattenedIds.add(value.id);
          flattenedValues.add(value);
        }
      }
    }

    for (final value in values) {
      flattenValue(value);
    }

    // Check if we have enough items after flattening
    if (flattenedValues.length < 2) {
      return null;
    }

    // Get the IDs of all items (including both original items and group IDs to remove)
    final childIds = flattenedValues.map((v) => v.id).toList();
    final allIdsToRemove = <String>[...childIds, ...groupIdsToRemove];

    // Remove selected items and groups from their current locations
    _removeItemsFromCurrentLocations(allIdsToRemove);

    // Find the insertion index based on the first selected item's position
    var insertIndex = _values.length;
    for (var i = 0; i < _values.length; i++) {
      if (allIdsToRemove.contains(_values[i].id)) {
        insertIndex = i;
        break;
      }
    }
    // If no items found at root level, use the end
    if (insertIndex == _values.length) {
      insertIndex = _values.length;
    }

    // Create group with calculated bounds
    final bounds = _calculateBounds(flattenedValues);
    final groupId = uuid();
    final group = GroupPaintingValue(
      id: groupId,
      property: property.currentToolProperty,
      start: bounds.topLeft,
      end: bounds.bottomRight,
      name: groupName ?? "Group",
      children: flattenedValues,
      expanded: true,
    );

    // Insert the group at the calculated position
    _values.insert(insertIndex, group);

    // Clear current selection and select the new group
    _currentValues.clear();
    _currentValues.add(group);

    // Save to history
    history._saveToHistory();

    notifyListeners();
    return group;
  }

  // アイテムを現在の位置から削除（ルートレベルまたはグループ内）
  void _removeItemsFromCurrentLocations(List<String> itemIds) {
    // Remove from root level
    _values.removeWhere((v) => itemIds.contains(v.id));

    // Remove from groups recursively
    for (var i = 0; i < _values.length; i++) {
      if (_values[i] is GroupPaintingValue) {
        final group = _values[i] as GroupPaintingValue;
        final updatedGroup = _removeItemsFromGroup(group, itemIds);
        if (updatedGroup != null) {
          if (updatedGroup.children.isEmpty) {
            // If group becomes empty, remove it
            _values.removeAt(i);
            i--;
          } else {
            _values[i] = updatedGroup;
          }
        }
      }
    }
  }

  // グループから再帰的にアイテムを削除
  GroupPaintingValue? _removeItemsFromGroup(
      GroupPaintingValue group, List<String> itemIds) {
    var updated = false;
    var updatedChildren = List<PaintingValue>.from(group.children);

    // Remove direct children
    updatedChildren.removeWhere((v) {
      if (itemIds.contains(v.id)) {
        return true;
      }
      return false;
    });

    // Process nested groups
    for (var i = 0; i < updatedChildren.length; i++) {
      if (updatedChildren[i] is GroupPaintingValue) {
        final childGroup = updatedChildren[i] as GroupPaintingValue;
        final updatedChildGroup = _removeItemsFromGroup(childGroup, itemIds);
        if (updatedChildGroup != null) {
          if (updatedChildGroup.children.isEmpty) {
            // If nested group becomes empty, remove it
            updatedChildren.removeAt(i);
            i--;
            updated = true;
          } else {
            updatedChildren[i] = updatedChildGroup;
            updated = true;
          }
        }
      }
    }

    if (!updated) {
      return null;
    }

    // Recalculate bounds
    if (updatedChildren.isEmpty) {
      return group.copyWith(
        children: updatedChildren,
      );
    }

    final bounds = _calculateBounds(updatedChildren);
    return group.copyWith(
      children: updatedChildren,
      start: bounds.topLeft,
      end: bounds.bottomRight,
    );
  }

  /// Move an item from one group to another.
  ///
  /// アイテムを別のグループに移動します。
  void moveToGroup(
    String itemId,
    String fromGroupId,
    String toGroupId,
    int toIndex,
  ) {
    // Find the from group
    final fromGroupIndex = _values.indexWhere((v) => v.id == fromGroupId);
    if (fromGroupIndex < 0) {
      return;
    }

    final fromGroup = _values[fromGroupIndex];
    if (fromGroup is! GroupPaintingValue) {
      return;
    }

    // Find the to group
    final toGroupIndex = _values.indexWhere((v) => v.id == toGroupId);
    if (toGroupIndex < 0) {
      return;
    }

    final toGroup = _values[toGroupIndex];
    if (toGroup is! GroupPaintingValue) {
      return;
    }

    // Find the item in from group
    final child = fromGroup.children.firstWhereOrNull((v) => v.id == itemId);
    if (child == null) {
      return;
    }

    // Remove from fromGroup
    final fromUpdatedChildren = List<PaintingValue>.from(fromGroup.children)
      ..removeWhere((v) => v.id == itemId);

    // Add to toGroup
    final toUpdatedChildren = List<PaintingValue>.from(toGroup.children);

    final clampedIndex = toIndex.clamp(0, toUpdatedChildren.length);
    toUpdatedChildren.insert(clampedIndex, child);

    // Update both groups
    if (fromUpdatedChildren.isEmpty) {
      // Remove empty group
      _values.removeAt(fromGroupIndex);

      // Adjust toGroupIndex if needed
      var adjustedToGroupIndex = toGroupIndex;
      if (toGroupIndex > fromGroupIndex) {
        adjustedToGroupIndex -= 1;
      }

      if (adjustedToGroupIndex >= 0 && adjustedToGroupIndex < _values.length) {
        final toGroupBounds = _calculateBounds(toUpdatedChildren);
        _values[adjustedToGroupIndex] = toGroup.copyWith(
          children: toUpdatedChildren,
          start: toGroupBounds.topLeft,
          end: toGroupBounds.bottomRight,
        );
      }
    } else {
      final fromGroupBounds = _calculateBounds(fromUpdatedChildren);
      _values[fromGroupIndex] = fromGroup.copyWith(
        children: fromUpdatedChildren,
        start: fromGroupBounds.topLeft,
        end: fromGroupBounds.bottomRight,
      );

      final toGroupBounds = _calculateBounds(toUpdatedChildren);
      _values[toGroupIndex] = toGroup.copyWith(
        children: toUpdatedChildren,
        start: toGroupBounds.topLeft,
        end: toGroupBounds.bottomRight,
      );
    }

    history._saveToHistory();
    notifyListeners();
  }

  /// Add an item to a group.
  ///
  /// グループにアイテムを追加します。
  void addToGroup(
    String itemId,
    String groupId, {
    int? insertIndex,
  }) {
    final groupIndex = _values.indexWhere((v) => v.id == groupId);
    if (groupIndex < 0) {
      return;
    }

    final group = _values[groupIndex];
    if (group is! GroupPaintingValue) {
      return;
    }

    // Find the item
    final itemIndex = _values.indexWhere((v) => v.id == itemId);
    if (itemIndex < 0) {
      return;
    }

    final item = _values[itemIndex];

    // Remove the item from _values
    _values.removeAt(itemIndex);

    // Add to the group
    final updatedChildren = List<PaintingValue>.from(group.children);

    final clampedIndex = (insertIndex ?? updatedChildren.length)
        .clamp(0, updatedChildren.length);
    updatedChildren.insert(clampedIndex, item);

    // Calculate new bounds
    final bounds = _calculateBounds(updatedChildren);

    // Adjust group index if needed
    var adjustedGroupIndex = groupIndex;
    if (itemIndex < groupIndex) {
      adjustedGroupIndex -= 1;
    }

    _values[adjustedGroupIndex] = group.copyWith(
      children: updatedChildren,
      start: bounds.topLeft,
      end: bounds.bottomRight,
    );

    history._saveToHistory();
    notifyListeners();
  }

  /// Remove an item from its parent group.
  ///
  /// 親グループからアイテムを削除します。
  void removeFromGroup(
    String itemId, {
    int? insertIndex,
  }) {
    final groupIndex = _values.indexWhere((v) {
      if (v is GroupPaintingValue) {
        return v.children.any((child) => child.id == itemId);
      }
      return false;
    });

    if (groupIndex < 0) {
      return;
    }

    final group = _values[groupIndex] as GroupPaintingValue;

    // Find the child
    final child = group.children.firstWhereOrNull((v) => v.id == itemId);
    if (child == null) {
      return;
    }

    // Remove from group
    final updatedChildren = List<PaintingValue>.from(group.children)
      ..removeWhere((v) => v.id == itemId);

    if (updatedChildren.isEmpty) {
      // If the group becomes empty, remove it
      _values.removeAt(groupIndex);

      final clampedIndex = (insertIndex ?? groupIndex).clamp(0, _values.length);
      _values.insert(clampedIndex, child);
    } else {
      // Calculate new bounds
      final bounds = _calculateBounds(updatedChildren);

      _values[groupIndex] = group.copyWith(
        children: updatedChildren,
        start: bounds.topLeft,
        end: bounds.bottomRight,
      );

      // Add the child back to _values
      final clampedIndex =
          (insertIndex ?? groupIndex + 1).clamp(0, _values.length);
      _values.insert(clampedIndex, child);
    }

    history._saveToHistory();
    notifyListeners();
  }

  /// Ungroup a group, moving children back to the layer list.
  ///
  /// グループを解除し、子要素をレイヤーリストに戻します。
  void ungroup(String groupId) {
    final groupIndex = _values.indexWhere((v) => v.id == groupId);
    if (groupIndex < 0) {
      return;
    }

    final group = _values[groupIndex];
    if (group is! GroupPaintingValue) {
      return;
    }

    // Remove group's children from current values to avoid duplicates
    // when saveCurrentValue() is called
    _currentValues.removeWhere((v) {
      return group.children.any((child) => child.id == v.id);
    });

    // Save current values (should only contain the group now)
    saveCurrentValue();

    // Get the children from the group's children.
    final children = List<PaintingValue>.from(group.children);

    // Remove the group
    _values.removeAt(groupIndex);

    // Insert children at the same position
    _values.insertAll(groupIndex, children);

    // Update selection
    _currentValues.clear();
    _currentValues.addAll(children);

    // Save to history
    history._saveToHistory();

    notifyListeners();
  }

  /// Toggle group expansion state.
  ///
  /// グループの展開状態を切り替えます。
  void toggleGroupExpansion(String groupId) {
    final groupIndex = _values.indexWhere((v) => v.id == groupId);
    if (groupIndex < 0) {
      return;
    }

    final group = _values[groupIndex];
    if (group is! GroupPaintingValue) {
      return;
    }

    final updatedGroup = group.copyWith(expanded: !group.expanded);
    _values[groupIndex] = updatedGroup;

    // CurrentValueにも一致するものがあれば更新
    final currentGroupIndex =
        _currentValues.indexWhere((v) => v.id == group.id);
    if (currentGroupIndex >= 0) {
      _currentValues[currentGroupIndex] = updatedGroup;
    }

    notifyListeners();
  }

  /// Reorder values in the list.
  ///
  /// This method supports future group functionality where parent and child
  /// items can be reordered together.
  ///
  /// リスト内の値の順序を変更します。
  ///
  /// このメソッドは将来的なグループ機能をサポートし、親と子のアイテムを
  /// 一緒に並び替えることができます。
  void reorder(
    int oldIndex,
    int newIndex, {
    String? groupId,
  }) {
    // Save current values before reordering
    saveCurrentValue();

    // Ensure indices are within bounds
    if (oldIndex < 0 ||
        oldIndex >= _values.length ||
        newIndex < 0 ||
        newIndex >= _values.length) {
      return;
    }

    // Move the item from oldIndex to newIndex
    final item = _values.removeAt(oldIndex);
    if (_values.length <= newIndex) {
      _values.add(item);
    } else {
      _values.insert(newIndex, item);
    }

    // Save to history
    history._saveToHistory();

    notifyListeners();
  }

  /// Reorder children within a group.
  ///
  /// グループ内の子要素を並び替えます。
  void reorderInGroup(String groupId, int oldIndex, int newIndex) {
    final groupIndex = _values.indexWhere((v) => v.id == groupId);
    if (groupIndex < 0) {
      return;
    }

    final group = _values[groupIndex];
    if (group is! GroupPaintingValue) {
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    if (oldIndex < 0 ||
        oldIndex >= group.children.length ||
        newIndex < 0 ||
        newIndex >= group.children.length ||
        oldIndex == newIndex) {
      return;
    }

    final updatedChildren = List<PaintingValue>.from(group.children);

    final child = updatedChildren.removeAt(oldIndex);

    updatedChildren.insert(newIndex, child);

    _values[groupIndex] = group.copyWith(
      children: updatedChildren,
    );

    history._saveToHistory();
    notifyListeners();
  }

  /// Move selected layers forward (towards front).
  ///
  /// When multiple items are selected, they are moved together by moving
  /// all selected items after the first non-selected item immediately after them.
  /// If selected items are inside a group, they move within that group only.
  ///
  /// 選択したレイヤーを前面に1つ移動します。
  ///
  /// 複数選択時は、選択要素全体をその直後の非選択要素の後ろに移動します。
  /// グループ内の要素の場合、そのグループ内でのみ移動します。
  void moveSelectedLayersForward() {
    if (_currentValues.isEmpty) {
      return;
    }

    saveCurrentValue();

    var changed = false;

    // Group selected items by their parent (null for root level)
    final selectedByParent = <String?, List<PaintingValue>>{};

    for (final currentValue in _currentValues) {
      // Find parent group for this value
      String? parentGroupId;
      for (var i = 0; i < _values.length; i++) {
        if (_values[i] is GroupPaintingValue) {
          final group = _values[i] as GroupPaintingValue;
          if (group.children.any((child) => child.id == currentValue.id)) {
            parentGroupId = group.id;
            break;
          }
        }
      }

      selectedByParent.putIfAbsent(parentGroupId, () => []).add(currentValue);
    }

    // Process each group (including root level)
    for (final entry in selectedByParent.entries) {
      final parentGroupId = entry.key;
      final selectedInGroup = entry.value;

      if (parentGroupId == null) {
        // Root level items
        if (_moveItemsForwardInList(_values, selectedInGroup)) {
          changed = true;
        }
      } else {
        // Items inside a group
        final groupIndex = _values.indexWhere((v) => v.id == parentGroupId);
        if (groupIndex >= 0 && _values[groupIndex] is GroupPaintingValue) {
          final group = _values[groupIndex] as GroupPaintingValue;
          final updatedChildren = List<PaintingValue>.from(group.children);

          if (_moveItemsForwardInList(updatedChildren, selectedInGroup)) {
            final bounds = _calculateBounds(updatedChildren);
            _values[groupIndex] = group.copyWith(
              children: updatedChildren,
              start: bounds.topLeft,
              end: bounds.bottomRight,
            );
            changed = true;
          }
        }
      }
    }

    if (changed) {
      history._saveToHistory();
      notifyListeners();
    }
  }

  /// Helper method to move items forward in a list
  bool _moveItemsForwardInList(
    List<PaintingValue> list,
    List<PaintingValue> itemsToMove,
  ) {
    // Find indices of items to move
    final selectedIndices = <int>[];
    for (final item in itemsToMove) {
      final index = list.indexWhere((v) => v.id == item.id);
      if (index >= 0) {
        selectedIndices.add(index);
      }
    }

    if (selectedIndices.isEmpty) {
      return false;
    }

    // Sort indices in ascending order
    selectedIndices.sort();

    // Find the backmost (lowest index) selected item
    final backmostIndex = selectedIndices.first;

    // Check if there's a non-selected item after selected items
    int? swapTargetIndex;
    for (var i = backmostIndex + 1; i < list.length; i++) {
      if (!selectedIndices.contains(i)) {
        swapTargetIndex = i;
        break;
      }
    }

    // If no non-selected item found after, can't move forward
    if (swapTargetIndex == null) {
      return false;
    }

    // Collect all selected items in their current order
    final selectedItems = <PaintingValue>[];
    for (final index in selectedIndices) {
      selectedItems.add(list[index]);
    }

    // Get the swap target item
    final swapTargetItem = list[swapTargetIndex];

    // Remove all selected items and the swap target from their positions
    final allIndicesToRemove = [...selectedIndices, swapTargetIndex]..sort();
    for (final index in allIndicesToRemove.reversed) {
      list.removeAt(index);
    }

    // Insert swap target first, then all selected items after it
    list.insert(backmostIndex, swapTargetItem);
    list.insertAll(backmostIndex + 1, selectedItems);

    return true;
  }

  /// Move selected layers backward (towards back).
  ///
  /// When multiple items are selected, they are moved together by moving
  /// all selected items before the first non-selected item immediately before them.
  /// If selected items are inside a group, they move within that group only.
  ///
  /// 選択したレイヤーを背面に1つ移動します。
  ///
  /// 複数選択時は、選択要素全体をその直前の非選択要素の前に移動します。
  /// グループ内の要素の場合、そのグループ内でのみ移動します。
  void moveSelectedLayersBackward() {
    if (_currentValues.isEmpty) {
      return;
    }

    saveCurrentValue();

    var changed = false;

    // Group selected items by their parent (null for root level)
    final selectedByParent = <String?, List<PaintingValue>>{};

    for (final currentValue in _currentValues) {
      // Find parent group for this value
      String? parentGroupId;
      for (var i = 0; i < _values.length; i++) {
        if (_values[i] is GroupPaintingValue) {
          final group = _values[i] as GroupPaintingValue;
          if (group.children.any((child) => child.id == currentValue.id)) {
            parentGroupId = group.id;
            break;
          }
        }
      }

      selectedByParent.putIfAbsent(parentGroupId, () => []).add(currentValue);
    }

    // Process each group (including root level)
    for (final entry in selectedByParent.entries) {
      final parentGroupId = entry.key;
      final selectedInGroup = entry.value;

      if (parentGroupId == null) {
        // Root level items
        if (_moveItemsBackwardInList(_values, selectedInGroup)) {
          changed = true;
        }
      } else {
        // Items inside a group
        final groupIndex = _values.indexWhere((v) => v.id == parentGroupId);
        if (groupIndex >= 0 && _values[groupIndex] is GroupPaintingValue) {
          final group = _values[groupIndex] as GroupPaintingValue;
          final updatedChildren = List<PaintingValue>.from(group.children);

          if (_moveItemsBackwardInList(updatedChildren, selectedInGroup)) {
            final bounds = _calculateBounds(updatedChildren);
            _values[groupIndex] = group.copyWith(
              children: updatedChildren,
              start: bounds.topLeft,
              end: bounds.bottomRight,
            );
            changed = true;
          }
        }
      }
    }

    if (changed) {
      history._saveToHistory();
      notifyListeners();
    }
  }

  /// Helper method to move items backward in a list
  bool _moveItemsBackwardInList(
    List<PaintingValue> list,
    List<PaintingValue> itemsToMove,
  ) {
    // Find indices of items to move
    final selectedIndices = <int>[];
    for (final item in itemsToMove) {
      final index = list.indexWhere((v) => v.id == item.id);
      if (index >= 0) {
        selectedIndices.add(index);
      }
    }

    if (selectedIndices.isEmpty) {
      return false;
    }

    // Sort indices in ascending order
    selectedIndices.sort();

    // Find the frontmost (highest index) selected item
    final frontmostIndex = selectedIndices.last;

    // Check if there's a non-selected item before selected items
    int? swapTargetIndex;
    for (var i = frontmostIndex - 1; i >= 0; i--) {
      if (!selectedIndices.contains(i)) {
        swapTargetIndex = i;
        break;
      }
    }

    // If no non-selected item found before, can't move backward
    if (swapTargetIndex == null) {
      return false;
    }

    // Collect all selected items in their current order
    final selectedItems = <PaintingValue>[];
    for (final index in selectedIndices) {
      selectedItems.add(list[index]);
    }

    // Get the swap target item
    final swapTargetItem = list[swapTargetIndex];

    // Remove all selected items and the swap target from their positions
    final allIndicesToRemove = [...selectedIndices, swapTargetIndex]..sort();
    for (final index in allIndicesToRemove.reversed) {
      list.removeAt(index);
    }

    // Insert all selected items first, then swap target after them
    list.insertAll(swapTargetIndex, selectedItems);
    list.insert(swapTargetIndex + selectedItems.length, swapTargetItem);

    return true;
  }

  /// Rename a value.
  ///
  /// 値をリネームします。
  Future<void> rename(PaintingValue value, String name) async {
    for (var i = 0; i < _values.length; i++) {
      final item = _values[i];
      if (value.id == item.id && item.name != name) {
        _values[i] = value.copyWith(name: name);
        saveCurrentValue();
        notifyListeners();
        break;
      }
      if (item is GroupPaintingValue) {
        var changed = false;
        final children = List<PaintingValue>.from(item.children);
        for (var j = 0; j < children.length; j++) {
          if (children[j].id == value.id && children[j].name != name) {
            children[j] = children[j].copyWith(name: name);
            changed = true;
            break;
          }
        }
        if (changed) {
          _values[i] = item.copyWith(children: children);
          saveCurrentValue();
          notifyListeners();
          break;
        }
      }
    }
    for (var i = 0; i < _currentValues.length; i++) {
      final item = _currentValues[i];
      if (value.id == item.id && item.name != name) {
        _currentValues[i] = value.copyWith(name: name);
        saveCurrentValue();
        notifyListeners();
        break;
      }
      if (item is GroupPaintingValue) {
        var changed = false;
        final children = List<PaintingValue>.from(item.children);
        for (var j = 0; j < children.length; j++) {
          if (children[j].id == value.id && children[j].name != name) {
            children[j] = children[j].copyWith(name: name);
            changed = true;
            break;
          }
        }
        if (changed) {
          _currentValues[i] = item.copyWith(children: children);
          saveCurrentValue();
          notifyListeners();
          break;
        }
      }
    }
  }

  /// Insert an image to the canvas.
  ///
  /// キャンバスに画像を挿入します。
  Future<void> insertImage(Uri uri) async {
    // Save current values first
    saveCurrentValue();

    // Find ImagePainterPrimaryTools
    final imageTool = adapter.defaultPrimaryTools
        .whereType<MediaPainterPrimaryTools>()
        .firstOrNull;

    if (imageTool == null) {
      return;
    }

    // Calculate the center of the visible area
    Offset center;
    if (_currentState != null) {
      final scale = _currentState!.currentScale;
      final offset = _currentState!.currentOffset;
      final viewportSize = _currentState!.context.size ?? canvasSize;

      // Calculate the viewport center in screen coordinates
      final screenCenter = Offset(
        viewportSize.width / 2,
        viewportSize.height / 2,
      );

      // Build the transform matrix (same as FormPainterFieldState)
      final transformMatrix = Matrix4.identity();
      transformMatrix.translateByDouble(offset.dx, offset.dy, 0.0, 1.0);
      transformMatrix.scaleByDouble(scale, scale, 1.0, 1.0);

      // Convert screen coordinates to canvas coordinates using inverse matrix
      final invertedMatrix = Matrix4.inverted(transformMatrix);
      final vector = Vector3(screenCenter.dx, screenCenter.dy, 0);
      final transformed = invertedMatrix.transform3(vector);
      center = Offset(transformed.x, transformed.y);
    } else {
      // Fallback to canvas center if state is not available
      center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    }

    const defaultSize = Size(200, 200);
    final startPoint =
        center - Offset(defaultSize.width / 2, defaultSize.height / 2);
    final endPoint =
        center + Offset(defaultSize.width / 2, defaultSize.height / 2);

    final imageValue = MediaPaintingValue(
      id: uuid(),
      property: property.currentToolProperty,
      start: startPoint,
      end: endPoint,
      path: uri,
    );

    // Add to values
    _values.add(imageValue);

    // Select the new image
    _currentValues.clear();
    _currentValues.add(imageValue);

    // Save to history
    history._saveToHistory();

    notifyListeners();
  }

  /// Find a value at the given point on the canvas.
  ///
  /// If a child of a group is clicked, the parent group is returned
  /// so that the entire group can be moved/resized together.
  ///
  /// キャンバス上の指定された点にある値を見つけます。
  ///
  /// グループの子要素がクリックされた場合は、グループ全体を一緒に
  /// 移動・リサイズできるように親グループを返します。
  PaintingValue? findValueAt(Offset point) {
    // First check if we clicked on a group's child
    for (int i = _values.length - 1; i >= 0; i--) {
      final value = _values[i];
      if (value is GroupPaintingValue) {
        // Check if any child contains the point
        for (final child in value.children) {
          if (child.rect.contains(point)) {
            return value; // Return the parent group
          }
        }
      }
    }

    // Then check for direct hits on top-level values
    for (int i = _values.length - 1; i >= 0; i--) {
      final value = _values[i];
      if (value.rect.contains(point)) {
        return value;
      }
    }
    return null;
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
    history._saveToHistory();

    notifyListeners();
  }

  /// Get the captured image data of selected objects.
  ///
  /// 選択されたオブジェクトの画像データを取得。
  Future<Uint8List?> captureSelectionAsImage() async {
    return await _captureSelectionAsImage();
  }

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

  // 描画値のリストの境界矩形を計算します。
  Rect _calculateBounds(List<PaintingValue> values) {
    if (values.isEmpty) {
      return Rect.zero;
    }

    var left = double.infinity;
    var top = double.infinity;
    var right = double.negativeInfinity;
    var bottom = double.negativeInfinity;

    for (final value in values) {
      final rect = value.rect;
      left = math.min(left, rect.left);
      top = math.min(top, rect.top);
      right = math.max(right, rect.right);
      bottom = math.max(bottom, rect.bottom);
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  void _notifyListeners() {
    notifyListeners();
  }
}

/// History of [PainterController].
///
/// [PainterController]の履歴。
class PainterControllerHistory {
  PainterControllerHistory._(this._controller) {
    // Initialize history with empty state
    _history.add(<PaintingValue>[]);
    _historyIndex = 0;
  }

  int _historyIndex = -1;
  final PainterController _controller;
  final List<List<PaintingValue>> _history = [];

  /// Check if undo is available.
  ///
  /// Undoが利用可能かチェック。
  bool get canUndo => _historyIndex > 0;

  /// Check if redo is available.
  ///
  /// Redoが利用可能かチェック。
  bool get canRedo => _historyIndex < _history.length - 1;

  /// Undo the last action.
  ///
  /// 最後のアクションを元に戻す。
  void undo() {
    if (!canUndo) {
      return;
    }

    _historyIndex--;
    _controller._values.clear();
    _controller._values
        .addAll(List<PaintingValue>.from(_history[_historyIndex]));
    _controller._currentValues.clear();
    _controller._dragSelectionRect = null;
    _controller._notifyListeners();
  }

  /// Redo the last undone action.
  ///
  /// 最後に元に戻したアクションをやり直す。
  void redo() {
    if (!canRedo) {
      return;
    }

    _historyIndex++;
    _controller._values.clear();
    _controller._values
        .addAll(List<PaintingValue>.from(_history[_historyIndex]));
    _controller._currentValues.clear();
    _controller._dragSelectionRect = null;
    _controller._notifyListeners();
  }

  void _saveToHistory() {
    // Remove any history after the current index (when we're in the middle of history)
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    // Add current state to history
    _history.add(List<PaintingValue>.from(_controller._values));
    _historyIndex = _history.length - 1;

    // Limit history size
    if (_history.length > _controller.adapter.maxActionHistory) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }
}

/// History of colors of [PainterController].
///
/// [PainterController]の色履歴。
class PainterControllerColorPalette {
  PainterControllerColorPalette._(this._controller);

  final PainterController _controller;
  SharedPreferencesWithCache? _cachedSharedPreferences;

  Future<void> _initialize() async {
    _cachedSharedPreferences = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: {
          _kColorHistoryKey.toSHA1(),
        },
      ),
    );
  }

  /// Get the color history.
  ///
  /// 色履歴を取得します。
  List<Color> get value =>
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
  Future<void> add(Color color) async {
    final history = value.clone(growable: true);
    var removed = false;
    history.removeWhere((e) {
      if (e == color) {
        removed = true;
        return true;
      }
      return false;
    });
    if (!removed && history.length >= _controller.adapter.maxColorHistory) {
      history.removeLast();
    }
    history.insertFirst(color);
    await _cachedSharedPreferences?.setStringList(
      _kColorHistoryKey.toSHA1(),
      history.map((e) => e.toHexString()).toList(),
    );
  }
}

/// History of clipboard of [PainterController].
///
/// [PainterController]のクリップボード履歴。
class PainterControllerClipboard {
  PainterControllerClipboard._(this._controller);

  final PainterController _controller;
  List<PaintingValue>? _clipboardData;
  int _clipboardPasteCount = 0;

  /// Check if there is data in the clipboard that can be pasted.
  ///
  /// ペースト可能なデータがクリップボードにあるかチェック。
  bool get canPaste => _clipboardData != null && _clipboardData!.isNotEmpty;

  /// Copy the selected values to clipboard.
  ///
  /// 選択した値をクリップボードにコピー。
  Future<void> copy() async {
    if (_controller._currentValues.isEmpty) {
      return;
    }

    // Save current editing values first (without history)
    _controller.saveCurrentValue();

    // Copy to internal clipboard
    _clipboardData = List<PaintingValue>.from(_controller._currentValues);

    // Try to copy to system clipboard as both JSON and image
    try {
      // Copy as JSON for internal use
      final jsonData =
          _controller._currentValues.map((v) => v.toJson()).toList();
      final jsonString = jsonEncode({
        "type": "masamune_painter_data",
        "version": "1.0",
        "data": jsonData,
      });

      // Copy as image for external use
      final imageData = await _controller._captureSelectionAsImage();
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

    _clipboardPasteCount = 0;
    _controller._notifyListeners();
  }

  /// Cut the selected values to clipboard.
  ///
  /// 選択した値をクリップボードにカット。
  Future<void> cut() async {
    if (_controller._currentValues.isEmpty) {
      return;
    }

    // Save current values first
    _controller.saveCurrentValue();

    // Copy to clipboard (without additional history save)
    await copy();

    // Remove cut values from the main list
    final cutIds = _controller._currentValues.map((v) => v.id).toSet();
    _controller._values.removeWhere((v) => cutIds.contains(v.id));

    // Clear selection
    _controller._currentValues.clear();
    _controller._dragSelectionRect = null;

    // Save to history after cutting
    _controller.history._saveToHistory();

    _clipboardPasteCount = 0;
    _controller._notifyListeners();
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
    _controller.saveCurrentValue();

    // Calculate paste offset (slightly offset from original position)

    _clipboardPasteCount++;
    final pasteOffset = Offset(
      20.0 * _clipboardPasteCount,
      20.0 * _clipboardPasteCount,
    );

    // Create new instances with new IDs and offset positions
    final newValues = <PaintingValue>[];
    for (final value in _clipboardData!) {
      final newValue = _createPastedValue(value, pasteOffset);
      newValues.add(newValue);
      _controller._values.add(newValue);
    }

    // Select the pasted values
    _controller._currentValues.clear();
    _controller._currentValues.addAll(newValues);

    // Save to history after pasting
    _controller.history._saveToHistory();

    _controller._notifyListeners();
  }

  PaintingValue _createPastedValue(PaintingValue value, Offset offset) {
    return value.copyWith(offset: offset, id: uuid());
  }

  PaintingValue? _createPaintingValueFromJson(DynamicMap json) {
    final type = json.get("type", nullOfString);

    if (type == null) {
      return null;
    }

    // Check primary tools first
    for (final tool in _controller.adapter.defaultPrimaryTools) {
      if (tool is! PainterVariableTools) {
        continue;
      }
      final value = (tool as PainterVariableTools).convertFromJson(json);
      if (value != null) {
        return value;
      }
    }

    // Check inline tools
    final inlineTools = _controller.adapter.defaultPrimaryTools
        .expand((e) => e.inlineTools ?? <PainterInlineTools>[])
        .toList();

    for (final tool in inlineTools) {
      if (tool is! PainterVariableTools) {
        continue;
      }
      final value = (tool as PainterVariableTools).convertFromJson(json);
      if (value != null) {
        return value;
      }
    }

    return null;
  }
}

/// Tool and other properties of [PainterController].
///
/// [PainterController]のツール等のプロパティ。
class PainterControllerProperty {
  PainterControllerProperty._(this._controller);

  final PainterController _controller;

  /// The property of the current tool.
  ///
  /// 現在のツールのプロパティ。
  PaintingProperty get currentToolProperty {
    return PaintingProperty(
      backgroundColor: currentToolBackgroundColor,
      foregroundColor: currentToolForegroundColor,
      line: currentToolLine,
      paragraphAlign: currentToolParagraphAlign,
      fontSize: currentToolFontSize,
      fontStyle: _currentToolFontStyle ?? _controller.adapter.defaultFontStyle,
    );
  }

  /// The background color of the current tool.
  ///
  /// 現在のツールの背景色。
  Color get currentToolBackgroundColor =>
      _currentToolBackgroundColor ?? _controller.adapter.defaultBackgroundColor;
  Color? _currentToolBackgroundColor;

  /// The foreground color of the current tool.
  ///
  /// 現在のツールの前景色。
  Color get currentToolForegroundColor =>
      _currentToolForegroundColor ?? _controller.adapter.defaultForegroundColor;
  Color? _currentToolForegroundColor;

  /// The line block tools of the current tool.
  ///
  /// 現在のツールの線ブロックツール。
  PainterLineBlockTools get currentToolLine =>
      _currentToolLine ?? _controller.adapter.defaultLine;
  PainterLineBlockTools? _currentToolLine;

  /// The paragraph align block tools of the current tool.
  ///
  /// 現在のツールの段落揃えブロックツール。
  PainterParagraphAlignBlockTools? get currentToolParagraphAlign =>
      _currentToolParagraphAlign ?? _controller.adapter.defaultParagraphAlign;
  PainterParagraphAlignBlockTools? _currentToolParagraphAlign;

  /// The font size block tools of the current tool.
  ///
  /// 現在のツールのフォントサイズブロックツール。
  PainterFontSizeBlockTools? get currentToolFontSize =>
      _currentToolFontSize ?? _controller.adapter.defaultFontSize;
  PainterFontSizeBlockTools? _currentToolFontSize;

  /// The font style block tools of the current tool.
  ///
  /// 現在のツールのフォントスタイルブロックツール。
  PainterFontStyleBlockTools? get currentToolFontStyle =>
      _currentToolFontStyle ?? _controller.adapter.defaultFontStyle;
  PainterFontStyleBlockTools? _currentToolFontStyle;

  /// The background color of the current value.
  ///
  /// 現在の値の背景色。
  Color? get currentValueBackgroundColor {
    var different = false;
    final colors = <Color?>[];
    for (final value in _controller.currentValues) {
      final color = value.property.backgroundColor;
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
    for (final value in _controller.currentValues) {
      final color = value.property.foregroundColor;
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
    for (final value in _controller.currentValues) {
      final tool = value.property.line;
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

  /// The paragraph align block tools of the current value.
  ///
  /// 現在の値の段落揃えブロックツール。
  PainterParagraphAlignBlockTools? get currentValueParagraphAlign {
    var different = false;
    final tools = <PainterParagraphAlignBlockTools?>[];
    for (final value in _controller.currentValues) {
      final tool = value.property.paragraphAlign;
      if (tools.any((e) => e?.id != tool?.id)) {
        different = true;
      }
      tools.add(tool);
    }
    if (different) {
      return null;
    }
    return tools.first ?? PainterMasamuneAdapter.primary.defaultParagraphAlign;
  }

  /// The font size block tools of the current value.
  ///
  /// 現在の値のフォントサイズブロックツール。
  PainterFontSizeBlockTools? get currentValueFontSize {
    var different = false;
    final tools = <PainterFontSizeBlockTools?>[];
    for (final value in _controller.currentValues) {
      final tool = value.property.fontSize;
      if (tools.any((e) => e?.id != tool?.id)) {
        different = true;
      }
      tools.add(tool);
    }
    if (different) {
      return null;
    }
    return tools.first ?? PainterMasamuneAdapter.primary.defaultFontSize;
  }

  /// The font style block tools of the current value.
  ///
  /// 現在の値のフォントスタイルブロックツール。
  PainterFontStyleBlockTools? get currentValueFontStyle {
    var different = false;
    final tools = <PainterFontStyleBlockTools?>[];
    for (final value in _controller.currentValues) {
      final tool = value.property.fontStyle;
      if (tools.any((e) => e?.id != tool?.id)) {
        different = true;
      }
      tools.add(tool);
    }
    if (different) {
      return null;
    }
    return tools.first ?? PainterMasamuneAdapter.primary.defaultFontStyle;
  }

  /// Sets the properties of the current tool.
  ///
  /// 現在のツールのプロパティを設定します。
  void setTool({
    Color? backgroundColor,
    Color? foregroundColor,
    PainterLineBlockTools? line,
    PainterParagraphAlignBlockTools? paragraphAlign,
    PainterFontSizeBlockTools? fontSize,
    PainterFontStyleBlockTools? fontStyle,
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
    if (line != null && line != _currentToolLine) {
      _currentToolLine = line;
      changed = true;
    }
    if (paragraphAlign != null &&
        paragraphAlign != _currentToolParagraphAlign) {
      _currentToolParagraphAlign = paragraphAlign;
      changed = true;
    }
    if (fontSize != null && fontSize != _currentToolFontSize) {
      _currentToolFontSize = fontSize;
      changed = true;
    }
    if (fontStyle != null && fontStyle != _currentToolFontStyle) {
      _currentToolFontStyle = fontStyle;
      changed = true;
    }
    if (changed) {
      _controller._notifyListeners();
    }
  }

  /// Sets the properties of the current values.
  ///
  /// 現在の値のプロパティを設定します。
  void setValues({
    Color? backgroundColor,
    Color? foregroundColor,
    PainterLineBlockTools? line,
    PainterParagraphAlignBlockTools? paragraphAlign,
    PainterFontSizeBlockTools? fontSize,
    PainterFontStyleBlockTools? fontStyle,
  }) {
    var changed = false;
    for (var i = 0; i < _controller.currentValues.length; i++) {
      if (backgroundColor != null) {
        changed = true;
        _controller.currentValues[i] = _controller.currentValues[i].copyWith(
          property: _controller.currentValues[i].property.copyWith(
            backgroundColor: backgroundColor,
          ),
        );
      }
      if (foregroundColor != null) {
        changed = true;
        _controller.currentValues[i] = _controller.currentValues[i].copyWith(
          property: _controller.currentValues[i].property.copyWith(
            foregroundColor: foregroundColor,
          ),
        );
      }
      if (line != null) {
        changed = true;
        _controller.currentValues[i] = _controller.currentValues[i].copyWith(
          property: _controller.currentValues[i].property.copyWith(
            line: line,
          ),
        );
      }
      if (paragraphAlign != null) {
        changed = true;
        _controller.currentValues[i] = _controller.currentValues[i].copyWith(
          property: _controller.currentValues[i].property.copyWith(
            paragraphAlign: paragraphAlign,
          ),
        );
      }
      if (fontSize != null) {
        changed = true;
        _controller.currentValues[i] = _controller.currentValues[i].copyWith(
          property: _controller.currentValues[i].property.copyWith(
            fontSize: fontSize,
          ),
        );
      }
      if (fontStyle != null) {
        changed = true;
        _controller.currentValues[i] = _controller.currentValues[i].copyWith(
          property: _controller.currentValues[i].property.copyWith(
            fontStyle: fontStyle,
          ),
        );
      }
    }
    if (changed) {
      _controller.saveCurrentValue(saveToHistory: true);
      _controller._notifyListeners();
    }
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
