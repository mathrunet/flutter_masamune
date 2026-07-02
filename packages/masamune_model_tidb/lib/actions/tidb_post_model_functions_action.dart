part of "/masamune_model_tidb.dart";

/// FunctionsAction for creating a Tidb row.
///
/// Tidbの行を作成するためのFunctionsAction。
class TidbPostModelFunctionsAction
    extends FunctionsAction<TidbPostModelFunctionsActionResponse> {
  /// FunctionsAction for creating a Tidb row.
  ///
  /// Tidbの行を作成するためのFunctionsAction。
  const TidbPostModelFunctionsAction({
    required this.database,
    required this.table,
    required this.value,
    this.indexKey,
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

  /// Value to save.
  ///
  /// 保存する値。
  final DynamicMap value;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.post;

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
      "value": _sanitizeTidbSaveValue(value),
    };
  }

  @override
  TidbPostModelFunctionsActionResponse toResponse(DynamicMap map) {
    return TidbPostModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [TidbPostModelFunctionsAction].
///
/// [TidbPostModelFunctionsAction]のレスポンス。
class TidbPostModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TidbPostModelFunctionsAction].
  ///
  /// [TidbPostModelFunctionsAction]のレスポンス。
  const TidbPostModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
