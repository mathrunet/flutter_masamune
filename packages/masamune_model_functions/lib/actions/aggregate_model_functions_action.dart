part of "/masamune_model_functions.dart";

/// FunctionsAction for reading aggregates.
///
/// 集計を読み込むためのFunctionsAction。
class AggregateModelFunctionsAction
    extends FunctionsAction<AggregateModelFunctionsActionResponse> {
  /// FunctionsAction for reading aggregates.
  ///
  /// 集計を読み込むためのFunctionsAction。
  const AggregateModelFunctionsAction({
    required this.path,
    required this.aggregateType,
    this.action = "aggregate_model_firestore",
    this.databaseId,
  });

  /// Database ID.
  ///
  /// データベースID。
  final String? databaseId;

  /// Aggregate type.
  ///
  /// 集計のタイプ。
  final ModelAggregateQueryType aggregateType;

  @override
  final String path;

  @override
  final String action;

  @override
  DynamicMap? toMap() {
    final path = this.path.trimQuery().trimString("/");
    switch (aggregateType) {
      case ModelAggregateQueryType.count:
        assert(
          !(path.splitLength() <= 0 || path.splitLength() % 2 != 1),
          "The query path hierarchy must be an odd number: $path",
        );
        break;
      case ModelAggregateQueryType.sum:
      case ModelAggregateQueryType.average:
        assert(
          !(path.splitLength() <= 0 || path.splitLength() % 2 != 0),
          "The query path hierarchy must be an even number: $path",
        );
    }
    assert(
      !path.contains("//"),
      "The query path hierarchy must not contain double slashes: $path",
    );
    return {
      "path": path,
      "method": aggregateType.name,
      "databaseId": databaseId,
    };
  }

  @override
  AggregateModelFunctionsActionResponse toResponse(DynamicMap map) {
    final status = map.getAsInt("status");
    final data = map.get("data", "");
    final parsed = jsonDecodeAsMap(data);
    return AggregateModelFunctionsActionResponse(
      status: status,
      value: parsed.getAsDouble("value"),
    );
  }
}

/// Response for [AggregateModelFunctionsAction].
///
/// [AggregateModelFunctionsAction]のレスポンス。
class AggregateModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [DocumentModelFunctionsAction].
  ///
  /// [AggregateModelFunctionsAction]のレスポンス。
  const AggregateModelFunctionsActionResponse({
    required this.status,
    required this.value,
  });

  /// Status.
  ///
  /// ステータス。
  final int status;

  /// Data.
  ///
  /// 値。
  final double value;
}
