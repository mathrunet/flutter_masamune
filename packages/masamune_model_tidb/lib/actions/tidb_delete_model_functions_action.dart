part of "/masamune_model_tidb.dart";

/// FunctionsAction for deleting Tidb rows.
///
/// Tidbの行を削除するためのFunctionsAction。
class TidbDeleteModelFunctionsAction
    extends FunctionsAction<TidbDeleteModelFunctionsActionResponse> {
  /// FunctionsAction for deleting Tidb rows.
  ///
  /// Tidbの行を削除するためのFunctionsAction。
  const TidbDeleteModelFunctionsAction({
    required this.database,
    required this.table,
    String? prefix,
    this.indexKey,
    this.where = const [],
    this.action = "tidb",
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
  String? get prefix => _normalizeTidbDatabasePrefix(_prefix);

  final String? _prefix;

  /// Document ID.
  ///
  /// ドキュメントID。
  final String? indexKey;

  /// Where conditions.
  ///
  /// Where条件。
  final List<DynamicMap> where;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.delete;

  @override
  String get path {
    return _buildTidbActionPath(
      action,
      [
        "database",
        database,
        table,
        if (indexKey.isNotEmpty) indexKey!,
      ],
    );
  }

  @override
  DynamicMap? toMap() {
    return {
      if (prefix != null) "prefix": prefix,
      if (where.isNotEmpty) "where": where,
    };
  }

  @override
  TidbDeleteModelFunctionsActionResponse toResponse(DynamicMap map) {
    return TidbDeleteModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [TidbDeleteModelFunctionsAction].
///
/// [TidbDeleteModelFunctionsAction]のレスポンス。
class TidbDeleteModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TidbDeleteModelFunctionsAction].
  ///
  /// [TidbDeleteModelFunctionsAction]のレスポンス。
  const TidbDeleteModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
