part of "/masamune_model_d1.dart";

/// FunctionsAction for deleting D1 rows.
///
/// D1の行を削除するためのFunctionsAction。
class D1DeleteModelFunctionsAction
    extends D1DatabaseAction<D1DeleteModelFunctionsActionResponse> {
  /// FunctionsAction for deleting D1 rows.
  ///
  /// D1の行を削除するためのFunctionsAction。
  const D1DeleteModelFunctionsAction({
    required this.database,
    required this.table,
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

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.delete;

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
      if (where.isNotEmpty) "where": where,
    };
  }

  @override
  D1DeleteModelFunctionsActionResponse toResponse(DynamicMap map) {
    return D1DeleteModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [D1DeleteModelFunctionsAction].
///
/// [D1DeleteModelFunctionsAction]のレスポンス。
class D1DeleteModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [D1DeleteModelFunctionsAction].
  ///
  /// [D1DeleteModelFunctionsAction]のレスポンス。
  const D1DeleteModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
