part of "/masamune_model_d1.dart";

/// 同一DBへの複数書き込みを原子的に適用するAction。
class D1BatchModelFunctionsAction
    extends D1DatabaseAction<D1PostModelFunctionsActionResponse> {
  /// 1〜100操作。同一DBのPOST/PUT/DELETEだけを受け付ける。
  const D1BatchModelFunctionsAction(
      {required this.database, required this.operations, this.prefix});
  @override
  final String database;

  /// 操作一覧。
  final List<DynamicMap> operations;

  /// 環境内の追加prefix。
  final String? prefix;
  @override
  String get action => "d1";
  @override
  String get path => _buildD1ActionPath(action, ["batch", database]);
  @override
  ApiMethod get method => ApiMethod.post;
  @override
  DynamicMap toMap() =>
      {"operations": operations, if (prefix != null) "prefix": prefix};
  @override
  D1PostModelFunctionsActionResponse toResponse(DynamicMap map) =>
      D1PostModelFunctionsActionResponse(data: map["data"]);
}
