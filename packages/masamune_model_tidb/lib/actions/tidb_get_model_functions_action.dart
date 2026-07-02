part of "/masamune_model_tidb.dart";

String _buildTidbActionPath(
  String action,
  Iterable<String> segments, {
  Map<String, String>? queryParameters,
}) {
  final actionSegments =
      action.split("/").where((segment) => segment.isNotEmpty);
  final query = queryParameters ?? const <String, String>{};
  return Uri(
    pathSegments: [...actionSegments, ...segments],
    queryParameters: query.isEmpty ? null : query,
  ).toString();
}

/// FunctionsAction for reading rows from Tidb.
///
/// Tidbから行を読み込むためのFunctionsAction。
class TidbGetModelFunctionsAction
    extends FunctionsAction<TidbGetModelFunctionsActionResponse> {
  /// FunctionsAction for reading rows from Tidb.
  ///
  /// Tidbから行を読み込むためのFunctionsAction。
  TidbGetModelFunctionsAction({
    required this.database,
    required this.table,
    this.indexKey,
    this.where = const [],
    this.orderBy = const [],
    this.limit,
    this.count = false,
    this.action = "tidb",
  });

  /// Database ID.
  ///
  /// データベースID。
  final String database;

  /// Table name.
  ///
  /// テーブル名。
  final String table;

  /// Document ID.
  ///
  /// ドキュメントID。
  final String? indexKey;

  /// Where conditions.
  ///
  /// Where条件。
  final List<DynamicMap> where;

  /// Order conditions.
  ///
  /// Order条件。
  final List<DynamicMap> orderBy;

  /// Limit count.
  ///
  /// 取得件数。
  final int? limit;

  /// Whether to count rows.
  ///
  /// 件数を取得するかどうか。
  final bool count;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.get;

  @override
  String get path {
    final params = <String, String>{
      if (where.isNotEmpty) "where": jsonEncode(_normalizeTidbWhere(where)),
      if (orderBy.isNotEmpty)
        "orderBy": jsonEncode(_normalizeTidbOrderBy(orderBy)),
      if (limit != null) "limit": limit!.toString(),
      if (count) "count": "true",
    };
    return _buildTidbActionPath(
      action,
      [
        "database",
        database,
        table,
        if (indexKey.isNotEmpty) indexKey!,
      ],
      queryParameters: params,
    );
  }

  @override
  DynamicMap? toMap() {
    return null;
  }

  @override
  TidbGetModelFunctionsActionResponse toResponse(DynamicMap map) {
    return TidbGetModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [TidbGetModelFunctionsAction].
///
/// [TidbGetModelFunctionsAction]のレスポンス。
class TidbGetModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TidbGetModelFunctionsAction].
  ///
  /// [TidbGetModelFunctionsAction]のレスポンス。
  const TidbGetModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
