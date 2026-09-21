// Dart imports:
import "dart:convert";

/// A column generated from a Masamune model field.
///
/// Masamuneモデルのフィールドから生成するカラム。
class TidbColumnSpec {
  /// Creates a column specification.
  ///
  /// カラム仕様を作成します。
  const TidbColumnSpec({
    required this.name,
    required this.sqlType,
    this.required = false,
    this.vectorMetric,
  });

  /// Column name.
  ///
  /// カラム名。
  final String name;

  /// TiDB SQL type.
  ///
  /// TiDBのSQL型。
  final String sqlType;

  /// VECTOR列の距離指標。
  final String? vectorMetric;

  /// Whether model construction requires this field.
  ///
  /// モデルの構築時にこのフィールドが必須かどうか。
  final bool required;
}

/// A table generated from one annotated Masamune model.
///
/// アノテーションが付与された1つのMasamuneモデルから生成するテーブル。
class TidbTableSpec {
  /// Creates a table specification.
  ///
  /// テーブル仕様を作成します。
  const TidbTableSpec({
    required this.database,
    required this.table,
    required this.columns,
    this.indexes = const {},
  });

  /// Database name.
  ///
  /// データベース名。
  final String database;

  /// Table name.
  ///
  /// テーブル名。
  final String table;

  /// Columns including Masamune reserved columns.
  ///
  /// Masamuneの予約カラムを含むカラム一覧。
  final List<TidbColumnSpec> columns;

  /// 通常indexの名前とカラム。UNIQUE制約は自動追加しない。
  final Map<String, List<String>> indexes;
}

/// Workerとmigrationの共通スキーマ仕様。
class TidbSchemaSpec {
  /// Workerとmigrationで共有する、順序を正規化したスキーマを生成する。
  /// 必須コンストラクター引数とSQLのNOT NULL制約は区別する。
  static Map<String, dynamic> schemaManifest(List<TidbTableSpec> tables) {
    final sorted = [...tables]..sort((a, b) => "${a.database}\u0000${a.table}"
        .compareTo("${b.database}\u0000${b.table}"));
    final seen = <String>{};
    final manifest = <String, dynamic>{
      "version": "1",
      "tables": sorted.map((table) {
        _validateIdentifier(table.database, "database");
        _validateIdentifier(table.table, "table");
        if (!seen.add("${table.database}\u0000${table.table}")) {
          throw ArgumentError("Duplicate schema table.");
        }
        final columns = _mergeReservedColumns(table.columns)
          ..sort((a, b) => a.name.compareTo(b.name));
        for (final column in columns) {
          _validateIdentifier(column.name, "column");
          if (!RegExp(
                  r"^(?:TEXT|JSON|BIGINT|INT|INTEGER|DOUBLE|FLOAT|BOOLEAN|BOOL|DATE|DATETIME|TIMESTAMP|TINYINT\(1\)|VARCHAR\([1-9][0-9]*\)|DECIMAL\([1-9][0-9]*,[0-9]+\)|VECTOR\([1-9][0-9]*\))$")
              .hasMatch(column.sqlType.toUpperCase())) {
            throw ArgumentError("Unsupported schema SQL type.");
          }
          final vector = RegExp(r"^VECTOR\(([1-9][0-9]*)\)$")
              .firstMatch(column.sqlType.toUpperCase());
          if (vector != null && int.parse(vector.group(1)!) > 16383) {
            throw ArgumentError("VECTOR dimensionsは1〜16383です。");
          }
          if (column.vectorMetric != null &&
              (vector == null ||
                  !["cosine", "euclidean"].contains(column.vectorMetric))) {
            throw ArgumentError("VECTOR metricが不正です。");
          }
          if (column.name == "id" &&
              column.sqlType.toUpperCase() != "VARCHAR(255)") {
            throw ArgumentError("Reserved id must be VARCHAR(255).");
          }
        }
        final indexNames = table.indexes.keys.toList()..sort();
        for (final name in indexNames) {
          _validateIdentifier(name, "index");
          final fields = table.indexes[name]!;
          if (name.toUpperCase() == "PRIMARY" ||
              fields.isEmpty ||
              fields.toSet().length != fields.length ||
              fields.any((field) => !columns.any((c) => c.name == field))) {
            throw ArgumentError("Invalid schema index.");
          }
        }
        return {
          "database": table.database,
          "table": table.table,
          "columns": columns
              .map((column) => {
                    "name": column.name,
                    "sqlType": column.sqlType.toUpperCase(),
                    "nullable": column.name != "id",
                    if (column.vectorMetric != null)
                      "vectorMetric": column.vectorMetric,
                  })
              .toList(),
          "primaryKey": ["id"],
          "indexes": [
            for (final name in indexNames)
              {"name": name, "columns": table.indexes[name], "unique": false},
          ],
          "vectorFields": columns
              .where((c) => c.sqlType.toUpperCase().startsWith("VECTOR("))
              .map((c) => c.name)
              .toList(),
        };
      }).toList(),
    };
    // 生成内容の識別用。適用SQLの改ざん検出にはmigration側でSHA-256を使う。
    var hash = BigInt.parse("cbf29ce484222325", radix: 16);
    for (final byte in utf8.encode(jsonEncode(manifest))) {
      hash = ((hash ^ BigInt.from(byte)) *
              BigInt.parse("100000001b3", radix: 16)) &
          BigInt.parse("ffffffffffffffff", radix: 16);
    }
    manifest["sourceHash"] =
        "fnv1a64:${hash.toRadixString(16).padLeft(16, "0")}";
    return manifest;
  }

  static List<TidbColumnSpec> _mergeReservedColumns(
    List<TidbColumnSpec> values,
  ) {
    final columns = <String, TidbColumnSpec>{
      "id": const TidbColumnSpec(
        name: "id",
        sqlType: "VARCHAR(255)",
        required: true,
      ),
      "parent_id":
          const TidbColumnSpec(name: "parent_id", sqlType: "VARCHAR(255)"),
      "created_at": const TidbColumnSpec(name: "created_at", sqlType: "BIGINT"),
      "updated_at": const TidbColumnSpec(name: "updated_at", sqlType: "BIGINT"),
    };
    for (final value in values) {
      _validateIdentifier(value.name, "column");
      columns[value.name] = value;
    }
    return columns.values.toList();
  }

  static void _validateIdentifier(String value, String label) {
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(value)) {
      throw ArgumentError("Invalid TiDB $label: $value");
    }
  }
}
