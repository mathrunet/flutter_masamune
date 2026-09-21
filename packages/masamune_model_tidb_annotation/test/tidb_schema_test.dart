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
}
