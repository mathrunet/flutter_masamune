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
    required this.action,
    required this.method,
    this.data,
  });

  /// Data for Post and Put.
  ///
  /// PostやPutのデータ。
  final Map<String, DynamicMap>? data;

  @override
  final ApiMethod method;

  @override
  final String action;

  @override
  DynamicMap? toMap() {
    assert(
        method == ApiMethod.get ||
            method == ApiMethod.delete ||
            data.isNotEmpty,
        "If the method is POST or PUT, data is required.");
    return {
      "method": method.name,
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
