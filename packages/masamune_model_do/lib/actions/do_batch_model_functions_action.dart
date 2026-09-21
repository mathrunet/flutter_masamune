part of "/masamune_model_do.dart";

/// 同一DBへの複数書き込みを原子的に適用するAction。
class DurableObjectBatchModelFunctionsAction
    extends DurableObjectDatabaseAction<
        DurableObjectPostModelFunctionsActionResponse> {
  /// 1〜100操作。同一DBのPOST/PUT/DELETEだけを受け付ける。
  const DurableObjectBatchModelFunctionsAction(
      {required this.database, required this.operations, this.prefix});
  @override
  final String database;

  /// 操作一覧。
  final List<DynamicMap> operations;

  /// 環境内の追加prefix。
  final String? prefix;
  @override
  String get action => "do";
  @override
  String get path => _buildDurableObjectActionPath(action, ["batch", database]);
  @override
  ApiMethod get method => ApiMethod.post;
  @override
  DynamicMap toMap() =>
      {"operations": operations, if (prefix != null) "prefix": prefix};
  @override
  DurableObjectPostModelFunctionsActionResponse toResponse(DynamicMap map) =>
      DurableObjectPostModelFunctionsActionResponse(data: map["data"]);
}
