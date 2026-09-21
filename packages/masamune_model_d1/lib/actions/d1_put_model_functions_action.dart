part of "/masamune_model_d1.dart";

/// FunctionsAction for updating D1 rows.
///
/// D1の行を更新するためのFunctionsAction。
class D1PutModelFunctionsAction
    extends D1DatabaseAction<D1PutModelFunctionsActionResponse> {
  /// FunctionsAction for updating D1 rows.
  ///
  /// D1の行を更新するためのFunctionsAction。
  const D1PutModelFunctionsAction({
    required this.database,
    required this.table,
    required this.value,
    String? prefix,
    this.indexKey,
    this.where = const [],
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
    return _buildD1ActionPath(
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
      if (where.isNotEmpty) "where": _normalizeD1Where(where),
      "value": _sanitizeD1SaveValue(value),
    };
  }

  @override
  D1PutModelFunctionsActionResponse toResponse(DynamicMap map) {
    return D1PutModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [D1PutModelFunctionsAction].
///
/// [D1PutModelFunctionsAction]のレスポンス。
class D1PutModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [D1PutModelFunctionsAction].
  ///
  /// [D1PutModelFunctionsAction]のレスポンス。
  const D1PutModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
