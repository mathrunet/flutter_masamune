part of "/masamune_model_do.dart";

/// FunctionsAction for deleting DurableObject rows.
///
/// DurableObjectの行を削除するためのFunctionsAction。
class DurableObjectDeleteModelFunctionsAction
    extends DurableObjectDatabaseAction<
        DurableObjectDeleteModelFunctionsActionResponse> {
  /// FunctionsAction for deleting DurableObject rows.
  ///
  /// DurableObjectの行を削除するためのFunctionsAction。
  const DurableObjectDeleteModelFunctionsAction({
    required this.database,
    required this.table,
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

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.delete;

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
      if (where.isNotEmpty) "where": where,
    };
  }

  @override
  DurableObjectDeleteModelFunctionsActionResponse toResponse(DynamicMap map) {
    return DurableObjectDeleteModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [DurableObjectDeleteModelFunctionsAction].
///
/// [DurableObjectDeleteModelFunctionsAction]のレスポンス。
class DurableObjectDeleteModelFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response for [DurableObjectDeleteModelFunctionsAction].
  ///
  /// [DurableObjectDeleteModelFunctionsAction]のレスポンス。
  const DurableObjectDeleteModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
