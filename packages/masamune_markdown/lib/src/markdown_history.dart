part of "/masamune_markdown.dart";

/// Controller for history.
///
/// 履歴のコントローラー。
class MarkdownHistory {
  MarkdownHistory._(this._controller);

  final MarkdownController _controller;

  MarkdownFieldState? get _field => _controller._field;

  /// Maximum number of history entries to keep.
  ///
  /// 保持する履歴エントリの最大数。
  static const int _maxHistorySize = 100;

  /// Duration to wait before saving history.
  ///
  /// 履歴を保存するまでの待機時間。
  static const Duration _historyDebounceDuration = Duration(milliseconds: 500);

  /// Undo history stack (stored as deep copied MarkdownFieldValue objects and cursor positions).
  ///
  /// 元に戻す履歴スタック（ディープコピーされたMarkdownFieldValueオブジェクトとカーソル位置として保存）。
  List<_HistorySnapshot> get undoStack => List.from(_undoStack);
  final List<_HistorySnapshot> _undoStack = [];

  /// Redo history stack (stored as deep copied MarkdownFieldValue objects and cursor positions).
  ///
  /// やり直す履歴スタック（ディープコピーされたMarkdownFieldValueオブジェクトとカーソル位置として保存）。
  List<_HistorySnapshot> get redoStack => List.from(_redoStack);
  final List<_HistorySnapshot> _redoStack = [];

  /// Timer for debouncing history saves.
  ///
  /// 履歴保存のデバウンス用タイマー。
  Timer? _historyDebounceTimer;

  /// Tracks if we have pending changes to save.
  ///
  /// 保存待ちの変更があるかどうかを追跡します。
  bool _hasPendingHistorySave = false;

  /// Flag to prevent saving history during undo/redo operations.
  ///
  /// Undo/Redo操作中に履歴保存を防ぐフラグ。
  bool get inProgress => _isUndoRedoInProgress;
  bool _isUndoRedoInProgress = false;

  /// Checks if the document can be redone.
  ///
  /// ドキュメントがやり直し可能かどうかを確認します。
  bool get canRedo => _redoStack.isNotEmpty;

  /// Checks if the document can be undone.
  ///
  /// ドキュメントが元に戻し可能かどうかを確認します。
  bool get canUndo => _undoStack.isNotEmpty;

  /// Redoes the document.
  ///
  /// ドキュメントをやり直します。
  void redo() {
    if (!canRedo) {
      return;
    }

    // Set flag to prevent history saves during redo
    _isUndoRedoInProgress = true;

    try {
      // Cancel any pending history saves
      _historyDebounceTimer?.cancel();
      _hasPendingHistorySave = false;

      // Save current state to undo stack (deep copy with cursor position)
      final currentFieldValuesCopy = _controller._value.clone();
      final currentCursorPosition = _field?._selection.baseOffset ?? 0;
      final currentSnapshot = _HistorySnapshot(
        fieldValues: currentFieldValuesCopy,
        cursorPosition: currentCursorPosition,
      );
      _undoStack.add(currentSnapshot);

      // Restore from redo stack
      final snapshot = _redoStack.removeLast();
      _controller._value.clear();
      _controller._value.addAll(snapshot.fieldValues);

      // Restore cursor position from snapshot and clear IME state
      if (_field != null) {
        final restoredPosition =
            snapshot.cursorPosition.clamp(0, _controller.getPlainText().length);
        _field!._selection = TextSelection.collapsed(offset: restoredPosition);
        _field!.clearComposingState(); // Clear IME composing state
        _field!._updateRemoteEditingValue();
      }

      _controller._notifyListeners();
    } finally {
      // Reset flag
      _isUndoRedoInProgress = false;
    }
  }

  /// Undoes the document.
  ///
  /// ドキュメントを元に戻します。
  void undo() {
    // If there are pending changes, save them first
    if (_hasPendingHistorySave) {
      _historyDebounceTimer?.cancel();
      _saveToUndoStackImmediate();
    }

    if (!canUndo) {
      return;
    }

    // Set flag to prevent history saves during undo
    _isUndoRedoInProgress = true;

    try {
      // Cancel any pending history saves
      _historyDebounceTimer?.cancel();
      _hasPendingHistorySave = false;

      final currentCursorPosition = _field?._selection.baseOffset ?? 0;

      // Save current state to redo stack (deep copy with cursor position)
      final currentFieldValuesCopy = _controller._value.clone();
      final currentSnapshot = _HistorySnapshot(
        fieldValues: currentFieldValuesCopy,
        cursorPosition: currentCursorPosition,
      );
      _redoStack.add(currentSnapshot);

      // Restore from undo stack
      final snapshot = _undoStack.removeLast();
      _controller._value.clear();
      _controller._value.addAll(snapshot.fieldValues);

      // Restore cursor position from snapshot and clear IME state
      if (_field != null) {
        final textLength = _controller.getPlainText().length;
        final restoredPosition = snapshot.cursorPosition.clamp(0, textLength);
        _field!._selection = TextSelection.collapsed(offset: restoredPosition);
        _field!.clearComposingState(); // Clear IME composing state
        _field!._updateRemoteEditingValue();
      }

      _controller._notifyListeners();
    } finally {
      // Reset flag
      _isUndoRedoInProgress = false;
    }
  }

  /// Saves current state to undo stack (may be debounced).
  ///
  /// 現在の状態を元に戻すスタックに保存します（デバウンスされる場合があります）。
  void saveToUndoStack({bool immediate = false}) {
    if (immediate) {
      _historyDebounceTimer?.cancel();
      _saveToUndoStackImmediate();
    } else {
      _scheduleHistorySave();
    }
  }

  /// Saves current state to undo stack immediately.
  ///
  /// 現在の状態を元に戻すスタックに即座に保存します。
  void _saveToUndoStackImmediate() {
    // Create a deep copy of current state
    final fieldValuesCopy = _controller._value.clone();

    // Get current cursor position
    final cursorPosition = _field?._selection.baseOffset ?? 0;

    final snapshot = _HistorySnapshot(
      fieldValues: fieldValuesCopy,
      cursorPosition: cursorPosition,
    );

    _undoStack.add(snapshot);

    // Limit stack size
    if (_undoStack.length > _maxHistorySize) {
      _undoStack.removeAt(0);
    }

    // Clear redo stack when new action is performed
    if (_redoStack.isNotEmpty) {
      _redoStack.clear();
    }
    _hasPendingHistorySave = false;
  }

  /// Schedules a history save with debouncing.
  ///
  /// デバウンスを使用して履歴保存をスケジュールします。
  void _scheduleHistorySave() {
    // Cancel existing timer if any
    _historyDebounceTimer?.cancel();

    // Mark that we have pending changes
    _hasPendingHistorySave = true;

    // Schedule a new save
    _historyDebounceTimer = Timer(_historyDebounceDuration, () {
      if (_hasPendingHistorySave) {
        _saveToUndoStackImmediate();
        // Notify listeners to update UI (e.g., undo/redo button states)
        _controller._notifyListeners();
      }
    });
  }

  /// Disposes the history.
  ///
  /// 履歴を破棄します。
  void dispose() {
    // Cancel any pending history saves
    _historyDebounceTimer?.cancel();
    _historyDebounceTimer = null;
    _hasPendingHistorySave = false;
  }
}

/// Represents a snapshot of document state and cursor position for undo/redo.
///
/// Undo/Redo用のドキュメント状態とカーソル位置のスナップショット。
class _HistorySnapshot {
  const _HistorySnapshot({
    required this.fieldValues,
    required this.cursorPosition,
  });

  final List<MarkdownFieldValue> fieldValues;
  final int cursorPosition;
}
