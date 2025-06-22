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
abstract class AsyncSavingManager {
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
    Duration timerInterval = const Duration(milliseconds: 1000),
  }) : _timerInterval = timerInterval {
    initialize();
  }

  /// The database instance for loading documents.
  ///
  /// ドキュメント読み込み用のデータベースインスタンス。
  NoSqlDatabase get database;

  /// Callback for saving documents.
  ///
  /// ドキュメント保存用のコールバック。
  Future<void> onSave(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  );

  /// Callback for deleting documents.
  ///
  /// ドキュメント削除用のコールバック。
  Future<void> onDelete(ModelAdapterDocumentQuery query);

  /// Callback when queue is updated.
  ///
  /// キューが更新された時のコールバック。
  Future<List<ModelAdapterDocumentQuery>> onQueueChanged(
      List<ModelAdapterDocumentQuery> queue);

  /// Callback for loading initial queue items.
  ///
  /// 初期キューアイテム読み込み用のコールバック。
  Future<List<ModelAdapterDocumentQuery>> onLoad();

  final Duration _timerInterval;
  List<ModelAdapterDocumentQuery> _queue = [];
  Timer? _timer;
  bool _isProcessing = false;

  /// Initialize the manager and start the timer.
  ///
  /// マネージャーを初期化し、タイマーを開始します。
  Future<void> initialize() async {
    // Load initial queue items
    try {
      _queue = await onLoad();
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
  Future<void> enqueueOnSave(ModelAdapterDocumentQuery query) async {
    _queue.add(query.copyWith(method: ApiMethod.post.name));
    _queue = await onQueueChanged(_queue);
  }

  /// Add a delete operation to the queue.
  ///
  /// 削除操作をキューに追加します。
  Future<void> enqueueOnDelete(ModelAdapterDocumentQuery query) async {
    _queue.add(query.copyWith(method: ApiMethod.delete.name));
    _queue = await onQueueChanged(_queue);
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
    final query = _queue.removeAt(0);

    try {
      final method = ApiMethod.values.firstWhere(
        (e) => e.name == query.method,
        orElse: () => ApiMethod.post,
      );
      switch (method) {
        case ApiMethod.post:
          // Load the document data
          final data = await database.loadDocument(query);

          // Only save if data exists and is not empty
          if (data != null && data.isNotEmpty) {
            await onSave(query, data);
          }
          break;

        case ApiMethod.delete:
          // Execute delete operation
          await onDelete(query);
          break;
        default:
          break;
      }

      // Notify about the updated queue
      _queue = await onQueueChanged(_queue);
    } catch (e) {
      // On error, re-add the item to the queue
      _queue.add(query);
      _queue = await onQueueChanged(_queue);
      debugPrint("Error processing queue item: $e");
    } finally {
      _isProcessing = false;
    }
  }

  /// Dispose the manager and clean up resources.
  ///
  /// マネージャーを破棄し、リソースをクリーンアップします。
  void dispose() {
    _queue.clear();
    _timer?.cancel();
    _timer = null;
  }
}
