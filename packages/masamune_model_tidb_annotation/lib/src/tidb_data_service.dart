part of "/masamune_model_tidb_annotation.dart";

/// Generates TiDB Data Service Configuration as Code for a Masamune model.
///
/// MasamuneモデルからTiDB Data ServiceのConfiguration as Codeを生成します。
const tidbDataService = TidbDataService();

/// Configuration for TiDB Data Service generation.
///
/// TiDB Data Service生成設定。
class TidbDataService {
  /// Creates a TiDB Data Service generation configuration.
  ///
  /// TiDB Data Service生成設定を作成します。
  const TidbDataService({
    this.database = "main",
    this.dataServiceDirPath = "tidb/data_service",
    this.rulesJsonPath = "cloudflare/src/rules.json",
    this.prefixes = const [],
    this.extraColumns = const [],
    this.additionalTables = const [],
    this.customEndpoints = const [],
    this.readCacheTtlSeconds = 0,
  });

  /// Logical TiDB database name.
  ///
  /// TiDBの論理データベース名。
  final String database;

  /// Output directory for the official Data Service CaC files.
  ///
  /// 公式Data Service CaCファイルの出力先。
  final String dataServiceDirPath;

  /// Path to the Cloudflare rules file.
  ///
  /// Cloudflare rulesファイルのパス。
  final String rulesJsonPath;

  /// Database prefixes generated in addition to the unprefixed database.
  ///
  /// プレフィックスなしのデータベースに加えて生成するDBプレフィックス。
  final List<String> prefixes;

  /// Server-owned columns that are not exposed by the Flutter model.
  ///
  /// Flutterモデルには公開しない、サーバー側で管理するカラム。
  final List<TidbDataServiceColumn> extraColumns;

  /// Server-owned tables that do not have a Flutter model.
  ///
  /// Flutterモデルを持たず、サーバー側で管理するテーブル。
  final List<TidbDataServiceTable> additionalTables;

  /// Server-only custom SQL endpoints generated into Data Service CaC.
  ///
  /// Data Service CaCへ生成するサーバー専用のカスタムSQLエンドポイント。
  final List<TidbDataServiceCustomEndpoint> customEndpoints;

  /// Cache TTL for generated GET endpoints.
  ///
  /// A value of zero disables TiDB Data Service response caching. This setting
  /// applies to get, list, and count endpoints only.
  ///
  /// 生成するGETエンドポイントのキャッシュ有効期間（秒）。
  ///
  /// 0を指定するとTiDB Data Serviceのレスポンスキャッシュを無効にします。
  /// この設定はget、list、countエンドポイントにのみ適用されます。
  final int readCacheTtlSeconds;
}

/// Column definition for a server-owned Data Service schema.
///
/// サーバー側で管理するData Serviceスキーマのカラム定義。
class TidbDataServiceColumn {
  /// Creates a column definition.
  ///
  /// カラム定義を作成します。
  const TidbDataServiceColumn(
    this.name,
    this.sqlType, {
    this.required = false,
  });

  /// SQL column name.
  ///
  /// SQLのカラム名。
  final String name;

  /// TiDB SQL type.
  ///
  /// TiDBのSQL型。
  final String sqlType;

  /// Whether the column is required by the schema.
  ///
  /// スキーマ上で必須のカラムかどうか。
  final bool required;
}

/// Table definition that is owned only by backend workers.
///
/// バックエンドWorkerのみが管理するテーブル定義。
class TidbDataServiceTable {
  /// Creates a server-owned table definition.
  ///
  /// サーバー側で管理するテーブル定義を作成します。
  const TidbDataServiceTable({
    required this.database,
    required this.table,
    required this.columns,
  });

  /// TiDB database name.
  ///
  /// TiDBのデータベース名。
  final String database;

  /// TiDB table name.
  ///
  /// TiDBのテーブル名。
  final String table;

  /// Table columns.
  ///
  /// テーブルのカラム一覧。
  final List<TidbDataServiceColumn> columns;
}

/// Parameter definition for a custom Data Service endpoint.
///
/// カスタムData Serviceエンドポイントのパラメーター定義。
class TidbDataServiceParameter {
  /// Creates an endpoint parameter.
  ///
  /// エンドポイントのパラメーターを作成します。
  const TidbDataServiceParameter(
    this.name, {
    this.type = "string",
    this.required = true,
    this.defaultValue = "",
  });

  /// Parameter name.
  ///
  /// パラメーター名。
  final String name;

  /// Data Service parameter type.
  ///
  /// Data Serviceのパラメーター型。
  final String type;

  /// Whether callers must provide the parameter.
  ///
  /// 呼び出し元がパラメーターを指定する必要があるかどうか。
  final bool required;

  /// Default value used by Data Service.
  ///
  /// Data Serviceで使用するデフォルト値。
  final String defaultValue;
}

/// Custom server-only SQL endpoint generated into Data Service CaC.
///
/// Data Service CaCへ生成するサーバー専用のカスタムSQLエンドポイント。
class TidbDataServiceCustomEndpoint {
  /// Creates a custom endpoint.
  ///
  /// カスタムエンドポイントを作成します。
  const TidbDataServiceCustomEndpoint({
    required this.name,
    required this.path,
    required this.sql,
    this.method = "POST",
    this.parameters = const [],
    this.timeoutMilliseconds = 30000,
    this.rowLimit = 2000,
  });

  /// Stable manifest key used by Workers.
  ///
  /// Workerが使用する固定のマニフェストキー。
  final String name;

  /// Data Service endpoint path.
  ///
  /// Data Serviceのエンドポイントパス。
  final String path;

  /// SQL executed by the endpoint.
  ///
  /// エンドポイントが実行するSQL。
  final String sql;

  /// HTTP method.
  ///
  /// HTTPメソッド。
  final String method;

  /// Endpoint parameters.
  ///
  /// エンドポイントのパラメーター一覧。
  final List<TidbDataServiceParameter> parameters;

  /// Endpoint timeout.
  ///
  /// エンドポイントのタイムアウト時間。
  final int timeoutMilliseconds;

  /// Maximum returned or affected rows.
  ///
  /// 返却または更新する行数の上限。
  final int rowLimit;
}
