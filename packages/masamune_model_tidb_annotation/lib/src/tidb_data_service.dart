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
}
