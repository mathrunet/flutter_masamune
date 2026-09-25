// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_tidb_annotation/masamune_model_tidb_annotation.dart";

void main() {
  test("uses stable schema defaults", () {
    expect(tidbSchema.database, "main");
    expect(tidbSchema.schemaDirPath, "tidb/schema");
    expect(tidbSchema.extraColumns, isEmpty);
    expect(tidbSchema.additionalTables, isEmpty);
  });

  test("accepts server-owned schema and index declarations", () {
    const value = TidbSchema(
      extraColumns: [TidbSchemaColumn("ownerId", "VARCHAR(255)")],
      additionalTables: [
        TidbSchemaTable(
          database: "app",
          table: "outbox",
          columns: [TidbSchemaColumn("status", "VARCHAR(32)")],
        ),
      ],
    );

    expect(value.extraColumns.single.name, "ownerId");
    expect(value.additionalTables.single.table, "outbox");
  });

  test("accepts independent unique indexes on models and additional tables",
      () {
    const value = TidbSchema(
      indexes: {
        "by_owner": ["owner_id"]
      },
      uniqueIndexes: {
        "unique_job": ["job_id"]
      },
      additionalTables: [
        TidbSchemaTable(
          database: "main",
          table: "transactions",
          columns: [TidbSchemaColumn("transaction_id", "VARCHAR(255)")],
          uniqueIndexes: {
            "unique_transaction": ["transaction_id"]
          },
        ),
      ],
    );
    expect(value.indexes["by_owner"], ["owner_id"]);
    expect(value.uniqueIndexes["unique_job"], ["job_id"]);
    expect(value.additionalTables.single.uniqueIndexes["unique_transaction"],
        ["transaction_id"]);
  });
}
