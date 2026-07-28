part of "/masamune_model_turso.dart";

/// FunctionsAction for creating a Turso row.
///
/// Tursoの行を作成するためのFunctionsAction。
class TursoPostModelFunctionsAction
    extends FunctionsAction<TursoPostModelFunctionsActionResponse> {
  /// FunctionsAction for creating a Turso row.
  ///
  /// Tursoの行を作成するためのFunctionsAction。
  const TursoPostModelFunctionsAction({
    required this.database,
    required this.table,
    required this.value,
    String? prefix,
    this.indexKey,
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
  String? get prefix => _normalizeTursoDatabasePrefix(_prefix);

  final String? _prefix;

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
      if (prefix != null) "prefix": prefix,
      "value": _sanitizeTursoSaveValue(value),
    };
  }

  @override
  TursoPostModelFunctionsActionResponse toResponse(DynamicMap map) {
    return TursoPostModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [TursoPostModelFunctionsAction].
///
/// [TursoPostModelFunctionsAction]のレスポンス。
class TursoPostModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TursoPostModelFunctionsAction].
  ///
  /// [TursoPostModelFunctionsAction]のレスポンス。
  const TursoPostModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
