part of "/masamune_model_do.dart";

/// FunctionsAction for updating DurableObject rows.
///
/// DurableObjectの行を更新するためのFunctionsAction。
class DurableObjectPutModelFunctionsAction extends DurableObjectDatabaseAction<
    DurableObjectPutModelFunctionsActionResponse> {
  /// FunctionsAction for updating DurableObject rows.
  ///
  /// DurableObjectの行を更新するためのFunctionsAction。
  const DurableObjectPutModelFunctionsAction({
    required this.database,
    required this.table,
    required this.value,
    String? prefix,
    this.indexKey,
    this.where = const [],
    this.action = "do",
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
  String? get prefix => _normalizeDurableObjectDatabasePrefix(_prefix);

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
    return _buildDurableObjectActionPath(
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
      if (where.isNotEmpty) "where": _normalizeDurableObjectWhere(where),
      "value": _sanitizeDurableObjectSaveValue(value),
    };
  }

  @override
  DurableObjectPutModelFunctionsActionResponse toResponse(DynamicMap map) {
    return DurableObjectPutModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [DurableObjectPutModelFunctionsAction].
///
/// [DurableObjectPutModelFunctionsAction]のレスポンス。
class DurableObjectPutModelFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response for [DurableObjectPutModelFunctionsAction].
  ///
  /// [DurableObjectPutModelFunctionsAction]のレスポンス。
  const DurableObjectPutModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
