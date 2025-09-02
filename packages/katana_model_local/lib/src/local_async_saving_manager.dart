part of "/katana_model_local.dart";

const _kAsyncSavingManagerId = "asyncSavingManager://";

/// Manages asynchronous saving operations with a queue system.
///
/// This class handles save and delete operations asynchronously using a queue,
/// processing them one by one with a timer.
///
/// 非同期保存操作をキューシステムで管理します。
///
/// このクラスは保存と削除の操作を非同期でキューを使用して処理し、
/// タイマーで1つずつ処理します。
class LocalRestApiModelAsyncSavingManager extends AsyncSavingManager {
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
  LocalRestApiModelAsyncSavingManager({
    required this.adapter,
    super.timerInterval = const Duration(milliseconds: 1000),
  });

  /// The adapter to use for saving and deleting documents.
  ///
  /// ドキュメントの保存と削除に使用するアダプター。
  final RestApiModelAdapter adapter;

  @override
  NoSqlDatabase get database => adapter.database;

  @override
  Future<void> onSave(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    for (final builder in adapter.builders) {
      final documentBuilder = builder.document;
      final saveBuilder = documentBuilder?.save;
      if (documentBuilder == null ||
          saveBuilder == null ||
          !await documentBuilder.match(query)) {
        continue;
      }
      return await saveBuilder.process(
        query.copyWith(asyncOnSave: true),
        value,
        adapter,
      );
    }
    throw UnimplementedError("Endpoint is not found: ${query.query.path}");
  }

  @override
  Future<void> onDelete(ModelAdapterDocumentQuery query) async {
    for (final builder in adapter.builders) {
      final documentBuilder = builder.document;
      final deleteBuilder = documentBuilder?.delete;
      if (documentBuilder == null ||
          deleteBuilder == null ||
          !await documentBuilder.match(query)) {
        continue;
      }
      return await deleteBuilder.process(
        query.copyWith(asyncOnSave: true),
        adapter,
      );
    }
    throw UnimplementedError("Endpoint is not found: ${query.query.path}");
  }

  @override
  Future<List<ModelAdapterDocumentQuery>> onQueueChanged(
      List<ModelAdapterDocumentQuery> queue) async {
    var priority = 0;
    final distinctQueue = queue.distinct((e) => e.query.path);
    await DatabaseExporter.export(
      "${await DatabaseExporter.documentDirectory}/${_kAsyncSavingManagerId.toSHA1()}",
      distinctQueue.toMap((e) {
        return MapEntry(e.query.path, {
          "method": e.method,
          "path": e.query.path,
          "priority": priority++,
          "retryCount": e.retryCount,
        });
      }),
    );
    return distinctQueue;
  }

  @override
  Future<List<ModelAdapterDocumentQuery>> onLoad() async {
    try {
      final data = (await DatabaseExporter.import(
        "${await DatabaseExporter.documentDirectory}/${_kAsyncSavingManagerId.toSHA1()}",
      ))
          .cast<String, DynamicMap>();
      return data.entries
          .toList()
          .sortTo(
            (a, b) => a.value.get("priority", 0).compareTo(
                  b.value.get("priority", 0),
                ),
          )
          .map(
        (e) {
          return ModelAdapterDocumentQuery(
            query: DocumentModelQuery(
              e.key,
              adapter: adapter,
            ),
            method: e.value.get("method", ""),
            retryCount: e.value.get("retryCount", 0),
          );
        },
      ).toList();
    } catch (e) {
      debugPrint("Error loading initial queue items: $e");
      return [];
    }
  }
}
