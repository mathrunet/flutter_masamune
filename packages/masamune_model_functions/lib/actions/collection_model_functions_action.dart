part of "/masamune_model_functions.dart";

/// FunctionsAction for reading and writing collections.
///
/// コレクションを読み書きするためのFunctionsAction。
class CollectionModelFunctionsAction
    extends FunctionsAction<CollectionModelFunctionsActionResponse> {
  /// FunctionsAction for reading and writing collections.
  ///
  /// コレクションを読み書きするためのFunctionsAction。
  const CollectionModelFunctionsAction({
    required this.path,
    required this.method,
    this.action = "collection_model_firestore",
    this.databaseId,
    this.data,
  });

  /// Data for Post and Put.
  ///
  /// PostやPutのデータ。
  final Map<String, DynamicMap>? data;

  /// Database ID.
  ///
  /// データベースID。
  final String? databaseId;

  @override
  final String path;

  @override
  final ApiMethod method;

  @override
  final String action;

  @override
  DynamicMap? toMap() {
    final path = this.path.trimQuery().trimString("/");
    assert(
        method == ApiMethod.get ||
            method == ApiMethod.delete ||
            data.isNotEmpty,
        "If the method is POST or PUT, data is required.");
    assert(
      !(path.splitLength() <= 0 || path.splitLength() % 2 != 1),
      "The query path hierarchy must be an odd number: $path",
    );
    assert(
      !path.contains("//"),
      "The query path hierarchy must not contain double slashes: $path",
    );
    return {
      "path": path,
      "method": method.name,
      "databaseId": databaseId,
      if (data != null) "data": data,
    };
  }

  @override
  CollectionModelFunctionsActionResponse toResponse(DynamicMap map) {
    final status = map.getAsInt("status");
    final data = map.getAsMap<DynamicMap>("data");
    return CollectionModelFunctionsActionResponse(
      status: status,
      data: data.isEmpty ? null : data,
    );
  }
}

/// Response for [CollectionModelFunctionsAction].
///
/// [CollectionModelFunctionsAction]のレスポンス。
class CollectionModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [CollectionModelFunctionsAction].
  ///
  /// [CollectionModelFunctionsAction]のレスポンス。
  const CollectionModelFunctionsActionResponse({
    required this.status,
    this.data,
  });

  /// Status.
  ///
  /// ステータス。
  final int status;

  /// Data.
  ///
  /// データ。
  final Map<String, DynamicMap>? data;
}
