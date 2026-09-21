part of "/masamune_model_do.dart";

/// FunctionsAction for creating a DurableObject row.
///
/// DurableObjectの行を作成するためのFunctionsAction。
class DurableObjectPostModelFunctionsAction extends DurableObjectDatabaseAction<
    DurableObjectPostModelFunctionsActionResponse> {
  /// FunctionsAction for creating a DurableObject row.
  ///
  /// DurableObjectの行を作成するためのFunctionsAction。
  const DurableObjectPostModelFunctionsAction({
    required this.database,
    required this.table,
    required this.value,
    String? prefix,
    this.indexKey,
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
      "value": _sanitizeDurableObjectSaveValue(value),
    };
  }

  @override
  DurableObjectPostModelFunctionsActionResponse toResponse(DynamicMap map) {
    return DurableObjectPostModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [DurableObjectPostModelFunctionsAction].
///
/// [DurableObjectPostModelFunctionsAction]のレスポンス。
class DurableObjectPostModelFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response for [DurableObjectPostModelFunctionsAction].
  ///
  /// [DurableObjectPostModelFunctionsAction]のレスポンス。
  const DurableObjectPostModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
