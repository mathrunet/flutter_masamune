import "package:masamune_model_do_builder/masamune_model_do_builder.dart";
import "package:test/test.dart";

void main() {
  test("SQLiteの型・予約カラム・indexと安定hashを生成する", () {
    const table =
        DurableObjectTableSpec(database: "main", table: "items", columns: [
      DurableObjectColumnSpec(name: "flag", sqlType: "BOOLEAN"),
      DurableObjectColumnSpec(name: "tags", sqlType: "JSON")
    ], indexes: {
      "by_flag": ["flag"]
    });
    final schema = DurableObjectSchemaSpec.schemaManifest([table]);
    expect(schema["dialect"], "sqlite");
    expect(schema["sourceHash"],
        DurableObjectSchemaSpec.schemaManifest([table])["sourceHash"]);
    final t = (schema["tables"] as List).single as Map;
    expect(
        (t["columns"] as List)
            .where((c) => c["name"] == "id")
            .single["sqlType"],
        "TEXT");
  });
  test("SQL混入・重複テーブル・非SQLite型・未知indexカラムを拒否する", () {
    for (final column in [
      const DurableObjectColumnSpec(name: "bad;", sqlType: "TEXT"),
      const DurableObjectColumnSpec(name: "x", sqlType: "VARCHAR(255)"),
      const DurableObjectColumnSpec(name: "x", sqlType: "VECTOR(3)")
    ]) {
      expect(
          () => DurableObjectSchemaSpec.schemaManifest([
                DurableObjectTableSpec(
                    database: "main", table: "items", columns: [column])
              ]),
          throwsArgumentError);
    }
    const table =
        DurableObjectTableSpec(database: "main", table: "items", columns: []);
    expect(() => DurableObjectSchemaSpec.schemaManifest([table, table]),
        throwsArgumentError);
    expect(
        () => DurableObjectSchemaSpec.schemaManifest([
              const DurableObjectTableSpec(
                  database: "main",
                  table: "items",
                  columns: [],
                  indexes: {
                    "x": ["missing"]
                  })
            ]),
        throwsArgumentError);
  });
}
