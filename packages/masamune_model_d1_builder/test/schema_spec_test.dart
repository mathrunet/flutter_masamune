import "package:masamune_model_d1_builder/masamune_model_d1_builder.dart";
import "package:test/test.dart";

void main() {
  test("JSONベクトル定義・次元・bindingをmanifestへ保持する", () {
    const table = D1TableSpec(database: "main", table: "items", columns: [
      D1ColumnSpec(name: "embedding", sqlType: "JSON")
    ], vectors: [
      {
        "field": "embedding",
        "binding": "VECTORS",
        "dimensions": 32,
        "metric": "cosine"
      }
    ]);
    final value =
        (D1SchemaSpec.schemaManifest([table])["tables"] as List).single as Map;
    expect(value["vectorFields"], ["embedding"]);
    expect((value["vectors"] as List).single["dimensions"], 32);
    expect(
        () => D1SchemaSpec.schemaManifest([
              const D1TableSpec(
                  database: "main",
                  table: "items",
                  columns: [],
                  vectors: [
                    {
                      "field": "missing",
                      "binding": "V",
                      "dimensions": 0,
                      "metric": "cosine"
                    }
                  ])
            ]),
        throwsArgumentError);
  });

  test("Vectorizeの実API次元範囲を検証する", () {
    for (final dimensions in [1, 3, 31, 1537]) {
      expect(() => D1SchemaSpec.schemaManifest([
        D1TableSpec(database: "main", table: "items", columns: const [D1ColumnSpec(name: "embedding", sqlType: "JSON")], vectors: [{"field": "embedding", "binding": "VECTORS", "dimensions": dimensions, "metric": "cosine"}])
      ]), throwsArgumentError);
    }
  });

  test("SQLiteの型・予約カラム・indexと安定hashを生成する", () {
    const table = D1TableSpec(database: "main", table: "items", columns: [
      D1ColumnSpec(name: "flag", sqlType: "BOOLEAN"),
      D1ColumnSpec(name: "tags", sqlType: "JSON")
    ], indexes: {
      "by_flag": ["flag"]
    });
    final schema = D1SchemaSpec.schemaManifest([table]);
    expect(schema["dialect"], "sqlite");
    expect(schema["sourceHash"],
        D1SchemaSpec.schemaManifest([table])["sourceHash"]);
    final t = (schema["tables"] as List).single as Map;
    expect(
        (t["columns"] as List)
            .where((c) => c["name"] == "id")
            .single["sqlType"],
        "TEXT");
  });
  test("SQL混入・重複テーブル・非SQLite型・未知indexカラムを拒否する", () {
    for (final column in [
      const D1ColumnSpec(name: "bad;", sqlType: "TEXT"),
      const D1ColumnSpec(name: "x", sqlType: "VARCHAR(255)"),
      const D1ColumnSpec(name: "x", sqlType: "VECTOR(3)")
    ]) {
      expect(
          () => D1SchemaSpec.schemaManifest([
                D1TableSpec(database: "main", table: "items", columns: [column])
              ]),
          throwsArgumentError);
    }
    const table = D1TableSpec(database: "main", table: "items", columns: []);
    expect(
        () => D1SchemaSpec.schemaManifest([table, table]), throwsArgumentError);
    expect(
        () => D1SchemaSpec.schemaManifest([
              const D1TableSpec(
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
