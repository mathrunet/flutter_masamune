part of "/masamune_model_turso.dart";

String _buildTursoActionPath(
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

/// FunctionsAction for reading rows from Turso.
///
/// Tursoから行を読み込むためのFunctionsAction。
class TursoGetModelFunctionsAction
    extends FunctionsAction<TursoGetModelFunctionsActionResponse> {
  /// FunctionsAction for reading rows from Turso.
  ///
  /// Tursoから行を読み込むためのFunctionsAction。
  TursoGetModelFunctionsAction({
    required this.database,
    required this.table,
    String? prefix,
    this.group,
    this.indexKey,
    this.where = const [],
    this.orderBy = const [],
    this.limit,
    this.nearest,
    this.count = false,
    this.action = "turso",
  }) : _prefix = prefix;

  /// Database ID.
  ///
  /// データベースID。
  final String database;

  /// Table name.
  ///
  /// テーブル名。
  final String table;

  /// Prefix added to the physical database name.
  ///
  /// 物理データベース名に付加するプレフィックス。
  String? get prefix => _normalizeTursoDatabasePrefix(_prefix);

  final String? _prefix;

  /// 未作成DBの配置希望グループ。省略時はサーバーが自動選択します。
  /// 既存DBの所属先は変更しません。
  final String? group;

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

  /// ネイティブvector近傍検索。
  final DynamicMap? nearest;

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
      if (prefix != null) "prefix": prefix!,
      if (group != null) "group": group!,
      if (where.isNotEmpty) "where": jsonEncode(_normalizeTursoWhere(where)),
      if (orderBy.isNotEmpty)
        "orderBy": jsonEncode(_normalizeTursoOrderBy(orderBy)),
      if (limit != null) "limit": limit!.toString(),
      if (nearest != null) "nearest": jsonEncode(nearest),
      if (count) "count": "true",
    };
    return _buildTursoActionPath(
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
  TursoGetModelFunctionsActionResponse toResponse(DynamicMap map) {
    return TursoGetModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [TursoGetModelFunctionsAction].
///
/// [TursoGetModelFunctionsAction]のレスポンス。
class TursoGetModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TursoGetModelFunctionsAction].
  ///
  /// [TursoGetModelFunctionsAction]のレスポンス。
  const TursoGetModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
