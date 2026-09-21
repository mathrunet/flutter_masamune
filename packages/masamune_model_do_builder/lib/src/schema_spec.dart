// Dart imports:
import "dart:convert";

/// A column generated from a Masamune model field.
///
/// Masamuneモデルのフィールドから生成するカラム。
class DurableObjectColumnSpec {
  /// Creates a column specification.
  ///
  /// カラム仕様を作成します。
  const DurableObjectColumnSpec({
    required this.name,
    required this.sqlType,
    this.required = false,
  });

  /// Column name.
  ///
  /// カラム名。
  final String name;

  /// DurableObject SQL type.
  ///
  /// DurableObjectのSQL型。
  final String sqlType;

  /// Whether model construction requires this field.
  ///
  /// モデルの構築時にこのフィールドが必須かどうか。
  final bool required;
}

/// A table generated from one annotated Masamune model.
///
/// アノテーションが付与された1つのMasamuneモデルから生成するテーブル。
class DurableObjectTableSpec {
  /// Creates a table specification.
  ///
  /// テーブル仕様を作成します。
  const DurableObjectTableSpec({
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
  final List<DurableObjectColumnSpec> columns;

  /// 通常indexの名前とカラム。UNIQUE制約は自動追加しない。
  final Map<String, List<String>> indexes;
}

/// Workerとmigrationの共通スキーマ仕様。
class DurableObjectSchemaSpec {
  /// Workerとmigrationで共有する、順序を正規化したスキーマを生成する。
  /// 必須コンストラクター引数とSQLのNOT NULL制約は区別する。
  static Map<String, dynamic> schemaManifest(
      List<DurableObjectTableSpec> tables) {
    final sorted = [...tables]..sort((a, b) => "${a.database}\u0000${a.table}"
        .compareTo("${b.database}\u0000${b.table}"));
    final seen = <String>{};
    final manifest = <String, dynamic>{
      "version": "1",
      "dialect": "sqlite",
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
          if (!RegExp(r"^(?:TEXT|INTEGER|REAL|BOOLEAN|JSON)$")
              .hasMatch(column.sqlType.toUpperCase())) {
            throw ArgumentError("Unsupported schema SQL type.");
          }
          if (column.name == "id" && column.sqlType.toUpperCase() != "TEXT") {
            throw ArgumentError("Reserved id must be TEXT.");
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
                  })
              .toList(),
          "primaryKey": ["id"],
          "indexes": [
            for (final name in indexNames)
              {"name": name, "columns": table.indexes[name], "unique": false},
          ],
          "vectorFields": <String>[],
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

  static List<DurableObjectColumnSpec> _mergeReservedColumns(
    List<DurableObjectColumnSpec> values,
  ) {
    final columns = <String, DurableObjectColumnSpec>{
      "id": const DurableObjectColumnSpec(
        name: "id",
        sqlType: "TEXT",
        required: true,
      ),
      "parent_id":
          const DurableObjectColumnSpec(name: "parent_id", sqlType: "TEXT"),
      "created_at":
          const DurableObjectColumnSpec(name: "created_at", sqlType: "INTEGER"),
      "updated_at":
          const DurableObjectColumnSpec(name: "updated_at", sqlType: "INTEGER"),
    };
    for (final value in values) {
      _validateIdentifier(value.name, "column");
      columns[value.name] = value;
    }
    return columns.values.toList();
  }

  static void _validateIdentifier(String value, String label) {
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(value)) {
      throw ArgumentError("Invalid DurableObject $label: $value");
    }
  }
}
