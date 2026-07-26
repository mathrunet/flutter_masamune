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
    this.extraColumns = const [],
    this.additionalTables = const [],
    this.customEndpoints = const [],
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

  /// Server-owned columns that are not exposed by the Flutter model.
  final List<TidbDataServiceColumn> extraColumns;

  /// Server-owned tables that do not have a Flutter model.
  final List<TidbDataServiceTable> additionalTables;

  /// Server-only custom SQL endpoints generated into Data Service CaC.
  final List<TidbDataServiceCustomEndpoint> customEndpoints;
}

/// Column definition for a server-owned Data Service schema.
class TidbDataServiceColumn {
  /// Creates a column definition.
  const TidbDataServiceColumn(
    this.name,
    this.sqlType, {
    this.required = false,
  });

  /// SQL column name.
  final String name;

  /// TiDB SQL type.
  final String sqlType;

  /// Whether the column is required by the schema.
  final bool required;
}

/// Table definition that is owned only by backend workers.
class TidbDataServiceTable {
  /// Creates a server-owned table definition.
  const TidbDataServiceTable({
    required this.database,
    required this.table,
    required this.columns,
  });

  /// TiDB database name.
  final String database;

  /// TiDB table name.
  final String table;

  /// Table columns.
  final List<TidbDataServiceColumn> columns;
}

/// Parameter definition for a custom Data Service endpoint.
class TidbDataServiceParameter {
  /// Creates an endpoint parameter.
  const TidbDataServiceParameter(
    this.name, {
    this.type = "string",
    this.required = true,
    this.defaultValue = "",
  });

  /// Parameter name.
  final String name;

  /// Data Service parameter type.
  final String type;

  /// Whether callers must provide the parameter.
  final bool required;

  /// Default value used by Data Service.
  final String defaultValue;
}

/// Custom server-only SQL endpoint generated into Data Service CaC.
class TidbDataServiceCustomEndpoint {
  /// Creates a custom endpoint.
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
  final String name;

  /// Data Service endpoint path.
  final String path;

  /// SQL executed by the endpoint.
  final String sql;

  /// HTTP method.
  final String method;

  /// Endpoint parameters.
  final List<TidbDataServiceParameter> parameters;

  /// Endpoint timeout.
  final int timeoutMilliseconds;

  /// Maximum returned or affected rows.
  final int rowLimit;
}
