part of "/masamune_model_do_annotation.dart";

/// Workerとmigrationが共有するスキーマをモデルから生成する。
const doSchema = DurableObjectSchema();

/// DurableObject共通スキーマの生成設定。
class DurableObjectSchema {
  /// 生成設定。
  const DurableObjectSchema(
      {this.database = "main",
      this.schemaDirPath = "do/schema",
      this.prefixes = const [],
      this.extraColumns = const [],
      this.additionalTables = const [],
      this.indexes = const {}});

  /// 論理データベース名。
  final String database;

  /// 共通schema.jsonの出力ディレクトリ。
  final String schemaDirPath;

  /// 追加生成する物理DBプレフィックス。
  final List<String> prefixes;

  /// モデルに公開しないカラム。
  final List<DurableObjectSchemaColumn> extraColumns;

  /// サーバーだけで使用するテーブル。
  final List<DurableObjectSchemaTable> additionalTables;

  /// 非UNIQUE indexの名前とカラム。
  final Map<String, List<String>> indexes;
}

/// サーバー所有カラム。
class DurableObjectSchemaColumn {
  /// カラム定義。requiredはモデル構築要件で、SQLのNOT NULLとは別。
  const DurableObjectSchemaColumn(this.name, this.sqlType,
      {this.required = false});

  /// カラム名。
  final String name;

  /// SQL型。
  final String sqlType;

  /// モデル構築で必須か。
  final bool required;
}

/// サーバー所有テーブル。
class DurableObjectSchemaTable {
  /// テーブル定義。
  const DurableObjectSchemaTable(
      {required this.database,
      required this.table,
      required this.columns,
      this.indexes = const {}});

  /// DB名。
  final String database;

  /// テーブル名。
  final String table;

  /// カラム一覧。
  final List<DurableObjectSchemaColumn> columns;

  /// 非UNIQUE index。
  final Map<String, List<String>> indexes;
}
