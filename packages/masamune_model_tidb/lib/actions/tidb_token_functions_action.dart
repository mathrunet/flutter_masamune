part of "/masamune_model_tidb.dart";

/// FunctionsAction for issuing a scoped Tidb token.
///
/// スコープされたTidbトークンを発行するためのFunctionsAction。
class TidbTokenFunctionsAction
    extends FunctionsAction<TidbTokenFunctionsActionResponse> {
  /// FunctionsAction for issuing a scoped Tidb token.
  ///
  /// スコープされたTidbトークンを発行するためのFunctionsAction。
  const TidbTokenFunctionsAction({
    required this.database,
    required this.targets,
    this.operations = const [],
    this.ttlSeconds = 600,
    this.action = "tidb/token",
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
  final List<TidbTokenScope> targets;

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
    return _buildTidbActionPath(action, ["database", database]);
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
  TidbTokenFunctionsActionResponse toResponse(DynamicMap map) {
    return TidbTokenFunctionsActionResponse(
      token: map.get("token", ""),
      expiresAt: map.getAsInt("expiresAt"),
      host: map.get("host", ""),
      port: map.getAsInt("port", 4000),
      database: map.get("database", database),
      username: map.get("username", ""),
      readMode: map.get("readMode", "direct"),
      writeMode: map.get("writeMode", "direct"),
      scopes: TidbTokenScopeResponse.fromList(map["targets"] ?? map["scopes"]),
    );
  }
}

/// Token scope for [TidbTokenFunctionsAction].
///
/// [TidbTokenFunctionsAction]のトークンスコープ。
@immutable
class TidbTokenScope {
  /// Token scope for [TidbTokenFunctionsAction].
  ///
  /// [TidbTokenFunctionsAction]のトークンスコープ。
  const TidbTokenScope({
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

/// Response for [TidbTokenFunctionsAction].
///
/// [TidbTokenFunctionsAction]のレスポンス。
class TidbTokenFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [TidbTokenFunctionsAction].
  ///
  /// [TidbTokenFunctionsAction]のレスポンス。
  const TidbTokenFunctionsActionResponse({
    required this.token,
    required this.expiresAt,
    this.host = "",
    this.port = 4000,
    this.database = "",
    this.username = "",
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

  /// TiDB host resolved by the Workers backend.
  ///
  /// Workersバックエンドで解決されたTiDBホスト。
  final String host;

  /// TiDB port resolved by the Workers backend.
  ///
  /// Workersバックエンドで解決されたTiDBポート。
  final int port;

  /// TiDB database resolved by the Workers backend.
  ///
  /// Workersバックエンドで解決されたTiDBデータベース。
  final String database;

  /// TiDB username resolved by the Workers backend.
  ///
  /// Workersバックエンドで解決されたTiDBユーザー名。
  final String username;

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
  final List<TidbTokenScopeResponse> scopes;
}

/// Resolved token scope for [TidbTokenFunctionsActionResponse].
///
/// [TidbTokenFunctionsActionResponse]の解決済みトークンスコープ。
@immutable
class TidbTokenScopeResponse {
  /// Resolved token scope for [TidbTokenFunctionsActionResponse].
  ///
  /// [TidbTokenFunctionsActionResponse]の解決済みトークンスコープ。
  const TidbTokenScopeResponse({
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
  static List<TidbTokenScopeResponse> fromList(Object? value) {
    if (value is! List) {
      return const [];
    }
    return value.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      final operations = map["operations"];
      return TidbTokenScopeResponse(
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
