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
    // IME入力中の場合は先に確定する
    _controller.finishComposing();

    if (!canRedo) {
      return;
    }

    // やり直し中の履歴保存を防ぐためのフラグを設定
    _isUndoRedoInProgress = true;

    try {
      // 保留中の履歴保存をキャンセル
      _historyDebounceTimer?.cancel();
      _hasPendingHistorySave = false;

      // 現在の状態を元に戻すスタックに保存（カーソル位置付きディープコピー）
      final currentFieldValuesCopy = _controller._value.clone();
      final currentCursorPosition = _field?._selection.baseOffset ?? 0;
      final currentSnapshot = _HistorySnapshot(
        fieldValues: currentFieldValuesCopy,
        cursorPosition: currentCursorPosition,
      );
      _undoStack.add(currentSnapshot);

      // やり直すスタックから復元
      final snapshot = _redoStack.removeLast();
      _controller._value.clear();
      _controller._value.addAll(snapshot.fieldValues);

      // スナップショットからカーソル位置を復元しIME状態をクリア
      if (_field != null) {
        final restoredPosition =
            snapshot.cursorPosition.clamp(0, _controller.rawText.length);
        _field!._selection = TextSelection.collapsed(offset: restoredPosition);
        _field!.clearComposingState(); // IME変換状態をクリア
        _field!._updateRemoteEditingValue();
      }

      _controller._notifyListeners();
    } finally {
      // フラグをリセット
      _isUndoRedoInProgress = false;
    }
  }

  /// Undoes the document.
  ///
  /// ドキュメントを元に戻します。
  void undo() {
    // IME入力中の場合は先に確定する
    _controller.finishComposing();

    // 保留中の変更がある場合は、まず保存
    if (_hasPendingHistorySave) {
      _historyDebounceTimer?.cancel();
      _saveToUndoStackImmediate();
    }

    if (!canUndo) {
      return;
    }

    // 元に戻す中の履歴保存を防ぐためのフラグを設定
    _isUndoRedoInProgress = true;

    try {
      // 保留中の履歴保存をキャンセル
      _historyDebounceTimer?.cancel();
      _hasPendingHistorySave = false;

      final currentCursorPosition = _field?._selection.baseOffset ?? 0;

      // 現在の状態をやり直すスタックに保存（カーソル位置付きディープコピー）
      final currentFieldValuesCopy = _controller._value.clone();
      final currentSnapshot = _HistorySnapshot(
        fieldValues: currentFieldValuesCopy,
        cursorPosition: currentCursorPosition,
      );
      _redoStack.add(currentSnapshot);

      // 元に戻すスタックから復元
      final snapshot = _undoStack.removeLast();
      _controller._value.clear();
      _controller._value.addAll(snapshot.fieldValues);

      // スナップショットからカーソル位置を復元しIME状態をクリア
      if (_field != null) {
        final textLength = _controller.rawText.length;
        final restoredPosition = snapshot.cursorPosition.clamp(0, textLength);
        _field!._selection = TextSelection.collapsed(offset: restoredPosition);
        _field!.clearComposingState(); // IME変換状態をクリア
        _field!._updateRemoteEditingValue();
      }

      _controller._notifyListeners();
    } finally {
      // フラグをリセット
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
    // 現在の状態のディープコピーを作成
    final fieldValuesCopy = _controller._value.clone();

    // 現在のカーソル位置を取得
    final cursorPosition = _field?._selection.baseOffset ?? 0;

    final snapshot = _HistorySnapshot(
      fieldValues: fieldValuesCopy,
      cursorPosition: cursorPosition,
    );

    _undoStack.add(snapshot);

    // スタックサイズを制限
    if (_undoStack.length > _maxHistorySize) {
      _undoStack.removeAt(0);
    }

    // 新しいアクションが実行されたときにやり直すスタックをクリア
    if (_redoStack.isNotEmpty) {
      _redoStack.clear();
    }
    _hasPendingHistorySave = false;
  }

  /// Schedules a history save with debouncing.
  ///
  /// デバウンスを使用して履歴保存をスケジュールします。
  void _scheduleHistorySave() {
    // 既存のタイマーがあればキャンセル
    _historyDebounceTimer?.cancel();

    // 保留中の変更があることをマーク
    _hasPendingHistorySave = true;

    // 新しい保存をスケジュール
    _historyDebounceTimer = Timer(_historyDebounceDuration, () {
      if (_hasPendingHistorySave) {
        _saveToUndoStackImmediate();
        // UIを更新するためにリスナーに通知（例: 元に戻す/やり直すボタンの状態）
        _controller._notifyListeners();
      }
    });
  }

  /// Disposes the history.
  ///
  /// 履歴を破棄します。
  void dispose() {
    // 保留中の履歴保存をキャンセル
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
