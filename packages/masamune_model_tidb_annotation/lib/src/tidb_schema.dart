part of "/masamune_model_tidb_annotation.dart";

/// Workerとmigrationが共有するスキーマをモデルから生成する。
const tidbSchema = TidbSchema();

/// TiDB共通スキーマの生成設定。
class TidbSchema {
  /// 生成設定。
  const TidbSchema(
      {this.database = "main",
      this.schemaDirPath = "tidb/schema",
      this.prefixes = const [],
      this.extraColumns = const [],
      this.additionalTables = const [],
      this.indexes = const {},
      this.uniqueIndexes = const {}});

  /// 論理データベース名。
  final String database;

  /// 共通schema.jsonの出力ディレクトリ。
  final String schemaDirPath;

  /// 追加生成する物理DBプレフィックス。
  final List<String> prefixes;

  /// モデルに公開しないカラム。
  final List<TidbSchemaColumn> extraColumns;

  /// サーバーだけで使用するテーブル。
  final List<TidbSchemaTable> additionalTables;

  /// Names and columns of non-unique indexes.
  final Map<String, List<String>> indexes;

  /// Names and columns of independent unique indexes.
  final Map<String, List<String>> uniqueIndexes;
}

/// サーバー所有カラム。
class TidbSchemaColumn {
  /// カラム定義。requiredはモデル構築要件で、SQLのNOT NULLとは別。
  const TidbSchemaColumn(this.name, this.sqlType,
      {this.required = false, this.vectorMetric});

  /// カラム名。
  final String name;

  /// SQL型。
  final String sqlType;

  /// VECTOR列の距離指標（cosineまたはeuclidean）。省略時はcosine。
  final String? vectorMetric;

  /// モデル構築で必須か。
  final bool required;
}

/// サーバー所有テーブル。
class TidbSchemaTable {
  /// テーブル定義。
  const TidbSchemaTable(
      {required this.database,
      required this.table,
      required this.columns,
      this.indexes = const {},
      this.uniqueIndexes = const {}});

  /// DB名。
  final String database;

  /// テーブル名。
  final String table;

  /// カラム一覧。
  final List<TidbSchemaColumn> columns;

  /// Non-unique indexes.
  final Map<String, List<String>> indexes;

  /// Independent unique indexes.
  final Map<String, List<String>> uniqueIndexes;
}
