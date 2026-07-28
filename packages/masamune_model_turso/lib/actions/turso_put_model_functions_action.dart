part of "/masamune_model_turso.dart";

/// FunctionsAction for updating Turso rows.
///
/// Tursoの行を更新するためのFunctionsAction。
class TursoPutModelFunctionsAction
    extends FunctionsAction<TursoPutModelFunctionsActionResponse> {
  /// FunctionsAction for updating Turso rows.
  ///
  /// Tursoの行を更新するためのFunctionsAction。
  const TursoPutModelFunctionsAction({
    required this.database,
    required this.table,
    required this.value,
    String? prefix,
    this.indexKey,
    this.where = const [],
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
      if (where.isNotEmpty) "where": _normalizeTursoWhere(where),
      "value": _sanitizeTursoSaveValue(value),
    };
  }

  @override
  TursoPutModelFunctionsActionResponse toResponse(DynamicMap map) {
    return TursoPutModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [TursoPutModelFunctionsAction].
///
/// [TursoPutModelFunctionsAction]のレスポンス。
class TursoPutModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TursoPutModelFunctionsAction].
  ///
  /// [TursoPutModelFunctionsAction]のレスポンス。
  const TursoPutModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
