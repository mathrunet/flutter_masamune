part of "/masamune_model_d1.dart";

String _buildD1ActionPath(
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

/// FunctionsAction for reading rows from D1.
///
/// D1から行を読み込むためのFunctionsAction。
class D1GetModelFunctionsAction
    extends D1DatabaseAction<D1GetModelFunctionsActionResponse> {
  /// FunctionsAction for reading rows from D1.
  ///
  /// D1から行を読み込むためのFunctionsAction。
  D1GetModelFunctionsAction({
    required this.database,
    required this.table,
    String? prefix,
    this.indexKey,
    this.where = const [],
    this.orderBy = const [],
    this.limit,
    this.count = false,
    this.nearest,
    this.action = "d1",
  }) : _prefix = prefix;

  /// Database ID.
  ///
  /// データベースID。
  @override
  final String database;

  /// Table name.
  ///
  /// テーブル名。
  final String table;

  /// Prefix added to the physical database name.
  ///
  /// 物理データベース名に付加するプレフィックス。
  String? get prefix => _normalizeD1DatabasePrefix(_prefix);

  final String? _prefix;

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

  /// ベクトル検索条件。
  final DynamicMap? nearest;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.get;

  @override
  String get path {
    final params = <String, String>{
      if (prefix != null) "prefix": prefix!,
      if (where.isNotEmpty) "where": jsonEncode(_normalizeD1Where(where)),
      if (orderBy.isNotEmpty)
        "orderBy": jsonEncode(_normalizeD1OrderBy(orderBy)),
      if (limit != null) "limit": limit!.toString(),
      if (count) "count": "true",
      if (nearest != null) "nearest": jsonEncode(nearest),
    };
    return _buildD1ActionPath(
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
  D1GetModelFunctionsActionResponse toResponse(DynamicMap map) {
    return D1GetModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [D1GetModelFunctionsAction].
///
/// [D1GetModelFunctionsAction]のレスポンス。
class D1GetModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [D1GetModelFunctionsAction].
  ///
  /// [D1GetModelFunctionsAction]のレスポンス。
  const D1GetModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
