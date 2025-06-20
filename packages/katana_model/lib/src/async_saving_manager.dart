part of "/katana_model.dart";

/// Manages asynchronous saving operations with a queue system.
/// 
/// This class handles save and delete operations asynchronously using a queue,
/// processing them one by one with a timer.
/// 
/// 非同期保存操作をキューシステムで管理します。
/// 
/// このクラスは保存と削除の操作を非同期でキューを使用して処理し、
/// タイマーで1つずつ処理します。
class AsyncSavingManager {
  /// Creates a new [AsyncSavingManager].
  /// 
  /// Requires [database] for data storage, [onSave] for save operations,
  /// [onDelete] for delete operations, [onEnqueue] for queue updates,
  /// and [onLoad] for loading initial queue items.
  /// 
  /// 新しい[AsyncSavingManager]を作成します。
  /// 
  /// データ保存用の[database]、保存操作用の[onSave]、
  /// 削除操作用の[onDelete]、キュー更新用の[onEnqueue]、
  /// 初期キューアイテム読み込み用の[onLoad]が必要です。
  AsyncSavingManager({
    required this.database,
    required this.onSave,
    required this.onDelete,
    required this.onEnqueue,
    required this.onLoad,
    Duration timerInterval = const Duration(milliseconds: 100),
  }) : _timerInterval = timerInterval {
    _initialize();
  }

  /// The database instance for loading documents.
  /// 
  /// ドキュメント読み込み用のデータベースインスタンス。
  final NoSqlDatabase database;

  /// Callback for saving documents.
  /// 
  /// ドキュメント保存用のコールバック。
  final Future<void> Function(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) onSave;

  /// Callback for deleting documents.
  /// 
  /// ドキュメント削除用のコールバック。
  final Future<void> Function(ModelAdapterDocumentQuery query) onDelete;

  /// Callback when queue is updated.
  /// 
  /// キューが更新された時のコールバック。
  final Future<void> Function(List<ModelAdapterDocumentQuery> queue) onEnqueue;

  /// Callback for loading initial queue items.
  /// 
  /// 初期キューアイテム読み込み用のコールバック。
  final Future<List<ModelAdapterDocumentQuery>> Function() onLoad;

  final Duration _timerInterval;
  final Queue<_QueueItem> _queue = Queue<_QueueItem>();
  Timer? _timer;
  bool _isProcessing = false;

  /// Initialize the manager and start the timer.
  /// 
  /// マネージャーを初期化し、タイマーを開始します。
  Future<void> _initialize() async {
    // Load initial queue items
    try {
      final initialItems = await onLoad();
      for (final item in initialItems) {
        _queue.add(_QueueItem(
          query: item,
          type: _QueueItemType.save,
        ));
      }
      
      // Notify about the initial queue
      if (_queue.isNotEmpty) {
        await onEnqueue(_queue.map((e) => e.query).toList());
      }
    } catch (e) {
      // Handle initialization error
      debugPrint("Error loading initial queue items: $e");
    }

    // Start the timer
    _timer = Timer.periodic(_timerInterval, (_) {
      _processQueue();
    });
  }

  /// Add a save operation to the queue.
  /// 
  /// 保存操作をキューに追加します。
  Future<void> enqueueSave(ModelAdapterDocumentQuery query) async {
    _queue.add(_QueueItem(
      query: query,
      type: _QueueItemType.save,
    ));
    await onEnqueue(_queue.map((e) => e.query).toList());
  }

  /// Add a delete operation to the queue.
  /// 
  /// 削除操作をキューに追加します。
  Future<void> enqueueDelete(ModelAdapterDocumentQuery query) async {
    _queue.add(_QueueItem(
      query: query,
      type: _QueueItemType.delete,
    ));
    await onEnqueue(_queue.map((e) => e.query).toList());
  }

  /// Process items in the queue one by one.
  /// 
  /// キューのアイテムを1つずつ処理します。
  Future<void> _processQueue() async {
    // Skip if already processing or queue is empty
    if (_isProcessing || _queue.isEmpty) {
      return;
    }

    _isProcessing = true;
    final item = _queue.removeFirst();

    try {
      switch (item.type) {
        case _QueueItemType.save:
          // Load the document data
          final data = await database.loadDocument(item.query);
          
          // Only save if data exists and is not empty
          if (data != null && data.isNotEmpty) {
            await onSave(item.query, data);
          }
          break;
          
        case _QueueItemType.delete:
          // Execute delete operation
          await onDelete(item.query);
          break;
      }

      // Notify about the updated queue
      await onEnqueue(_queue.map((e) => e.query).toList());
    } catch (e) {
      // On error, re-add the item to the queue
      _queue.add(item);
      debugPrint("Error processing queue item: $e");
    } finally {
      _isProcessing = false;
    }
  }

  /// Dispose the manager and clean up resources.
  /// 
  /// マネージャーを破棄し、リソースをクリーンアップします。
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Represents the type of operation in the queue.
/// 
/// キュー内の操作タイプを表します。
enum _QueueItemType {
  /// Save operation.
  /// 
  /// 保存操作。
  save,

  /// Delete operation.
  /// 
  /// 削除操作。
  delete,
}

/// Represents an item in the queue.
/// 
/// キュー内のアイテムを表します。
class _QueueItem {
  /// Creates a new queue item.
  /// 
  /// 新しいキューアイテムを作成します。
  const _QueueItem({
    required this.query,
    required this.type,
  });

  /// The document query.
  /// 
  /// ドキュメントクエリ。
  final ModelAdapterDocumentQuery query;

  /// The operation type.
  /// 
  /// 操作タイプ。
  final _QueueItemType type;
}

