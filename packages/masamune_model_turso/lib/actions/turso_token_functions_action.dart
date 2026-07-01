part of "/masamune_model_turso.dart";

/// FunctionsAction for issuing a scoped Turso token.
///
/// スコープされたTursoトークンを発行するためのFunctionsAction。
class TursoTokenFunctionsAction
    extends FunctionsAction<TursoTokenFunctionsActionResponse> {
  /// FunctionsAction for issuing a scoped Turso token.
  ///
  /// スコープされたTursoトークンを発行するためのFunctionsAction。
  const TursoTokenFunctionsAction({
    required this.database,
    required this.targets,
    this.operations = const [],
    this.ttlSeconds = 600,
    this.action = "turso/token",
  });

  /// Database ID.
  ///
  /// データベースID。
  final String database;

  /// Requested database-level operations.
  ///
  /// 要求するデータベース単位の操作。
  final List<String> operations;

  /// Requested rule targets.
  ///
  /// 要求するルール判定ターゲット。
  final List<TursoTokenScope> targets;

  /// Token TTL in seconds.
  ///
  /// トークンの有効秒数。
  final int ttlSeconds;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.post;

  @override
  String get path {
    return _buildTursoActionPath(action, ["database", database]);
  }

  @override
  DynamicMap? toMap() {
    return {
      if (operations.isNotEmpty) "operations": operations,
      if (targets.isNotEmpty)
        "targets": targets.map((item) => item.toMap()).toList(),
      "ttlSeconds": ttlSeconds,
    };
  }

  @override
  TursoTokenFunctionsActionResponse toResponse(DynamicMap map) {
    return TursoTokenFunctionsActionResponse(
      token: map.get("token", ""),
      expiresAt: map.getAsInt("expiresAt"),
      url: map.get("url", ""),
      readMode: map.get("readMode", "direct"),
      writeMode: map.get("writeMode", "direct"),
      scopes: TursoTokenScopeResponse.fromList(map["targets"] ?? map["scopes"]),
    );
  }
}

/// Token scope for [TursoTokenFunctionsAction].
///
/// [TursoTokenFunctionsAction]のトークンスコープ。
@immutable
class TursoTokenScope {
  /// Token scope for [TursoTokenFunctionsAction].
  ///
  /// [TursoTokenFunctionsAction]のトークンスコープ。
  const TursoTokenScope({
    required this.table,
    required this.operations,
  });

  /// Table name.
  ///
  /// テーブル名。
  final String table;

  /// Operations.
  ///
  /// 操作。
  final List<String> operations;

  /// Convert to map.
  ///
  /// Mapに変換します。
  DynamicMap toMap() {
    return {
      "table": table,
      "operations": operations,
    };
  }
}

/// Response for [TursoTokenFunctionsAction].
///
/// [TursoTokenFunctionsAction]のレスポンス。
class TursoTokenFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TursoTokenFunctionsAction].
  ///
  /// [TursoTokenFunctionsAction]のレスポンス。
  const TursoTokenFunctionsActionResponse({
    required this.token,
    required this.expiresAt,
    this.url = "",
    this.readMode = "direct",
    this.writeMode = "direct",
    this.scopes = const [],
  });

  /// Issued token.
  ///
  /// 発行されたトークン。
  final String token;

  /// Expiration epoch seconds.
  ///
  /// 有効期限のUnix秒。
  final int expiresAt;

  /// Turso/libSQL URL resolved by the Workers backend.
  ///
  /// Workersバックエンドで解決されたTurso/libSQLのURL。
  final String url;

  /// Read mode resolved by the Workers backend.
  ///
  /// Workersバックエンドで解決された読み込みモード。
  final String readMode;

  /// Write mode resolved by the Workers backend.
  ///
  /// Workersバックエンドで解決された書き込みモード。
  final String writeMode;

  /// Scope modes resolved by the Workers backend.
  ///
  /// Workersバックエンドで解決されたスコープごとのモード。
  final List<TursoTokenScopeResponse> scopes;
}

/// Resolved token scope for [TursoTokenFunctionsActionResponse].
///
/// [TursoTokenFunctionsActionResponse]の解決済みトークンスコープ。
@immutable
class TursoTokenScopeResponse {
  /// Resolved token scope for [TursoTokenFunctionsActionResponse].
  ///
  /// [TursoTokenFunctionsActionResponse]の解決済みトークンスコープ。
  const TursoTokenScopeResponse({
    required this.table,
    required this.operations,
    this.readMode,
    this.writeMode,
  });

  /// Table name.
  ///
  /// テーブル名。
  final String table;

  /// Operations.
  ///
  /// 操作。
  final List<String> operations;

  /// Read mode.
  ///
  /// 読み込みモード。
  final String? readMode;

  /// Write mode.
  ///
  /// 書き込みモード。
  final String? writeMode;

  /// Build a list from response value.
  ///
  /// レスポンス値からリストを構築します。
  static List<TursoTokenScopeResponse> fromList(Object? value) {
    if (value is! List) {
      return const [];
    }
    return value.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      final operations = map["operations"];
      return TursoTokenScopeResponse(
        table: map.get("table", ""),
        operations: operations is List
            ? operations.map((operation) => "$operation").toList()
            : const [],
        readMode: map["readMode"] == null ? null : "${map["readMode"]}",
        writeMode: map["writeMode"] == null ? null : "${map["writeMode"]}",
      );
    }).toList();
  }
}
