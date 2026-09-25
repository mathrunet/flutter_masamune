// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_tidb_builder/masamune_model_tidb_builder.dart";

void main() {
  test("vector列の次元・metricと未変更再生成を検証する", () {
    const table = TidbTableSpec(database: "main", table: "items", columns: [
      TidbColumnSpec(
          name: "embedding", sqlType: "VECTOR(3)", vectorMetric: "euclidean")
    ]);
    final schema = TidbSchemaSpec.schemaManifest([table]);
    expect(schema, TidbSchemaSpec.schemaManifest([table]));
    final t = (schema["tables"] as List).single;
    expect(t["vectorFields"], ["embedding"]);
    expect(
        (t["columns"] as List)
            .firstWhere((c) => c["name"] == "embedding")["vectorMetric"],
        "euclidean");
    expect(
        () => TidbSchemaSpec.schemaManifest([
              const TidbTableSpec(database: "main", table: "items", columns: [
                TidbColumnSpec(name: "embedding", sqlType: "VECTOR(16384)")
              ])
            ]),
        throwsArgumentError);
  });

  test("通常生成に直結用manifestと安定した生成元hashを含める", () {
    const table = TidbTableSpec(database: "main", table: "items", columns: []);
    final schema = TidbSchemaSpec.schemaManifest([table]);
    expect(schema["sourceHash"], matches(r"^fnv1a64:[0-9a-f]{16}$"));
    expect((schema["tables"] as List).single["indexes"], isEmpty);
  });

  test("emits independent unique indexes alongside regular indexes", () {
    const table = TidbTableSpec(
      database: "main",
      table: "jobs",
      columns: [
        TidbColumnSpec(name: "job_id", sqlType: "VARCHAR(255)"),
        TidbColumnSpec(name: "subject_hash", sqlType: "VARCHAR(255)"),
      ],
      indexes: {
        "by_subject": ["subject_hash"]
      },
      uniqueIndexes: {
        "unique_job": ["job_id"],
        "unique_subject": ["subject_hash"],
      },
    );
    final indexes = (TidbSchemaSpec.schemaManifest([table])["tables"] as List)
        .single["indexes"] as List;
    expect(indexes, [
      {
        "name": "by_subject",
        "columns": ["subject_hash"],
        "unique": false
      },
      {
        "name": "unique_job",
        "columns": ["job_id"],
        "unique": true
      },
      {
        "name": "unique_subject",
        "columns": ["subject_hash"],
        "unique": true
      },
    ]);
  });

  test("rejects invalid unique indexes and duplicate names", () {
    for (final uniqueIndexes in const [
      <String, List<String>>{
        "bad-name": ["job_id"]
      },
      <String, List<String>>{
        "missing": ["unknown"]
      },
      <String, List<String>>{"empty": []},
      <String, List<String>>{
        "duplicate_columns": ["job_id", "job_id"]
      },
      <String, List<String>>{
        "PRIMARY": ["job_id"]
      },
    ]) {
      expect(
        () => TidbSchemaSpec.schemaManifest([
          TidbTableSpec(
            database: "main",
            table: "jobs",
            columns: const [
              TidbColumnSpec(name: "job_id", sqlType: "VARCHAR(255)")
            ],
            uniqueIndexes: uniqueIndexes,
          ),
        ]),
        throwsArgumentError,
      );
    }
    expect(
      () => TidbSchemaSpec.schemaManifest([
        const TidbTableSpec(
          database: "main",
          table: "jobs",
          columns: [TidbColumnSpec(name: "job_id", sqlType: "VARCHAR(255)")],
          indexes: {
            "same": ["job_id"]
          },
          uniqueIndexes: {
            "same": ["job_id"]
          },
        ),
      ]),
      throwsArgumentError,
    );
    expect(
      () => TidbSchemaSpec.schemaManifest([
        const TidbTableSpec(
          database: "main",
          table: "jobs",
          columns: [TidbColumnSpec(name: "job_id", sqlType: "VARCHAR(255)")],
          indexes: {
            "Same": ["job_id"]
          },
          uniqueIndexes: {
            "same": ["job_id"]
          },
        ),
      ]),
      throwsArgumentError,
    );
  });

  test("SQL型への文混入と予約カラムの型変更を拒否する", () {
    for (final column in const [
      TidbColumnSpec(name: "value", sqlType: "TEXT; DROP TABLE items"),
      TidbColumnSpec(name: "id", sqlType: "TEXT"),
    ]) {
      expect(
          () => TidbSchemaSpec.schemaManifest([
                TidbTableSpec(
                    database: "main", table: "items", columns: [column]),
              ]),
          throwsArgumentError);
    }
  });
  test("共通schema manifestは入力順序によらず同じ内容を生成する", () {
    const a = TidbTableSpec(database: "app", table: "a", columns: [
      TidbColumnSpec(name: "name", sqlType: "TEXT", required: true),
    ]);
    const b = TidbTableSpec(database: "app", table: "b", columns: []);
    final first = TidbSchemaSpec.schemaManifest([a, b]);
    expect(first, TidbSchemaSpec.schemaManifest([b, a]));
    final columns = (first["tables"] as List).first["columns"] as List;
    expect(columns.singleWhere((c) => c["name"] == "name")["nullable"], isTrue);
    expect(() => TidbSchemaSpec.schemaManifest([a, a]), throwsArgumentError);
  });
}
