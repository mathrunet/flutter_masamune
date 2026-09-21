part of "/masamune_model_d1_annotation.dart";

/// Workerとmigrationが共有するスキーマをモデルから生成する。
const d1Schema = D1Schema();

/// D1共通スキーマの生成設定。
class D1Schema {
  /// 生成設定。
  const D1Schema(
      {this.database = "main",
      this.schemaDirPath = "d1/schema",
      this.prefixes = const [],
      this.extraColumns = const [],
      this.additionalTables = const [],
      this.indexes = const {},
      this.vectors = const []});

  /// 論理データベース名。
  final String database;

  /// 共通schema.jsonの出力ディレクトリ。
  final String schemaDirPath;

  /// 追加生成する物理DBプレフィックス。
  final List<String> prefixes;

  /// モデルに公開しないカラム。
  final List<D1SchemaColumn> extraColumns;

  /// サーバーだけで使用するテーブル。
  final List<D1SchemaTable> additionalTables;

  /// 非UNIQUE indexの名前とカラム。
  final Map<String, List<String>> indexes;

  /// JSONカラムをVectorizeへ同期する設定。
  final List<D1VectorField> vectors;
}

/// サーバー所有カラム。
class D1SchemaColumn {
  /// カラム定義。requiredはモデル構築要件で、SQLのNOT NULLとは別。
  const D1SchemaColumn(this.name, this.sqlType, {this.required = false});

  /// カラム名。
  final String name;

  /// SQL型。
  final String sqlType;

  /// モデル構築で必須か。
  final bool required;
}

/// サーバー所有テーブル。
class D1SchemaTable {
  /// テーブル定義。
  const D1SchemaTable(
      {required this.database,
      required this.table,
      required this.columns,
      this.indexes = const {},
      this.vectors = const []});

  /// DB名。
  final String database;

  /// テーブル名。
  final String table;

  /// カラム一覧。
  final List<D1SchemaColumn> columns;

  /// 非UNIQUE index。
  final Map<String, List<String>> indexes;

  /// JSONカラムをVectorizeへ同期する設定。
  final List<D1VectorField> vectors;
}

/// ベクトルの正本はD1 JSON、検索indexはVectorize。
class D1VectorField {
  /// bindingは環境別katana.yamlのVectorize設定に一致させる。
  const D1VectorField(this.field,
      {required this.dimensions,
      required this.binding,
      this.metric = "cosine"});

  /// JSONカラム名。
  final String field;

  /// 次元数（32〜1536）。
  final int dimensions;

  /// Worker binding名。
  final String binding;

  /// cosine / euclidean / dot-product。
  final String metric;
}
