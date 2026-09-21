part of "/masamune_model_d1.dart";

/// FunctionsAction for creating a D1 row.
///
/// D1の行を作成するためのFunctionsAction。
class D1PostModelFunctionsAction
    extends D1DatabaseAction<D1PostModelFunctionsActionResponse> {
  /// FunctionsAction for creating a D1 row.
  ///
  /// D1の行を作成するためのFunctionsAction。
  const D1PostModelFunctionsAction({
    required this.database,
    required this.table,
    required this.value,
    String? prefix,
    this.indexKey,
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
      "value": _sanitizeD1SaveValue(value),
    };
  }

  @override
  D1PostModelFunctionsActionResponse toResponse(DynamicMap map) {
    return D1PostModelFunctionsActionResponse(data: map["data"]);
  }
}

/// Response for [D1PostModelFunctionsAction].
///
/// [D1PostModelFunctionsAction]のレスポンス。
class D1PostModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [D1PostModelFunctionsAction].
  ///
  /// [D1PostModelFunctionsAction]のレスポンス。
  const D1PostModelFunctionsActionResponse({this.data});

  /// Response data.
  ///
  /// レスポンスデータ。
  final Object? data;
}
