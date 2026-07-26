// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_tidb_annotation/masamune_model_tidb_annotation.dart";

void main() {
  test("uses stable Data Service defaults", () {
    expect(tidbDataService.database, "main");
    expect(tidbDataService.dataServiceDirPath, "tidb/data_service");
    expect(tidbDataService.rulesJsonPath, "cloudflare/src/rules.json");
    expect(tidbDataService.extraColumns, isEmpty);
    expect(tidbDataService.additionalTables, isEmpty);
    expect(tidbDataService.customEndpoints, isEmpty);
  });

  test("accepts server-owned schema and endpoint declarations", () {
    const value = TidbDataService(
      extraColumns: [TidbDataServiceColumn("ownerId", "VARCHAR(255)")],
      additionalTables: [
        TidbDataServiceTable(
          database: "app",
          table: "outbox",
          columns: [TidbDataServiceColumn("status", "VARCHAR(32)")],
        ),
      ],
      customEndpoints: [
        TidbDataServiceCustomEndpoint(
          name: "claim_outbox",
          path: "/internal/claim-outbox",
          sql: r"UPDATE `app`.`outbox` SET `status` = 'claimed' "
              r"WHERE `id` = ${id};",
          parameters: [TidbDataServiceParameter("id")],
        ),
      ],
    );

    expect(value.extraColumns.single.name, "ownerId");
    expect(value.additionalTables.single.table, "outbox");
    expect(value.customEndpoints.single.name, "claim_outbox");
  });
}
