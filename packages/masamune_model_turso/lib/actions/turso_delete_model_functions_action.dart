part of "/masamune_model_turso.dart";

/// FunctionsAction for deleting Turso rows.
///
/// Tursoの行を削除するためのFunctionsAction。
class TursoDeleteModelFunctionsAction
    extends FunctionsAction<TursoDeleteModelFunctionsActionResponse> {
  /// FunctionsAction for deleting Turso rows.
  ///
  /// Tursoの行を削除するためのFunctionsAction。
  const TursoDeleteModelFunctionsAction({
    required this.database,
    required this.table,
    this.indexKey,
    this.where = const [],
    this.action = "turso",
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

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.delete;

  @override
  String get path {
    return _buildTursoActionPath(
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
      if (where.isNotEmpty) "where": where,
    };
  }

  @override
  TursoDeleteModelFunctionsActionResponse toResponse(DynamicMap map) {
    return TursoDeleteModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [TursoDeleteModelFunctionsAction].
///
/// [TursoDeleteModelFunctionsAction]のレスポンス。
class TursoDeleteModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TursoDeleteModelFunctionsAction].
  ///
  /// [TursoDeleteModelFunctionsAction]のレスポンス。
  const TursoDeleteModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
