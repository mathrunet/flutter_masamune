part of "/masamune_model_tidb.dart";

/// FunctionsAction for updating Tidb rows.
///
/// Tidbの行を更新するためのFunctionsAction。
class TidbPutModelFunctionsAction
    extends FunctionsAction<TidbPutModelFunctionsActionResponse> {
  /// FunctionsAction for updating Tidb rows.
  ///
  /// Tidbの行を更新するためのFunctionsAction。
  const TidbPutModelFunctionsAction({
    required this.database,
    required this.table,
    required this.value,
    this.indexKey,
    this.where = const [],
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

  /// Value to save.
  ///
  /// 保存する値。
  final DynamicMap value;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.put;

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
      if (where.isNotEmpty) "where": _normalizeTidbWhere(where),
      "value": _sanitizeTidbSaveValue(value),
    };
  }

  @override
  TidbPutModelFunctionsActionResponse toResponse(DynamicMap map) {
    return TidbPutModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [TidbPutModelFunctionsAction].
///
/// [TidbPutModelFunctionsAction]のレスポンス。
class TidbPutModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TidbPutModelFunctionsAction].
  ///
  /// [TidbPutModelFunctionsAction]のレスポンス。
  const TidbPutModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
