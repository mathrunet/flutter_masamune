import "package:masamune_model_tidb_annotation/masamune_model_tidb_annotation.dart";
import "package:test/test.dart";

void main() {
  test("uses stable Data Service defaults", () {
    expect(tidbDataService.database, "main");
    expect(tidbDataService.dataServiceDirPath, "tidb/data_service");
    expect(tidbDataService.rulesJsonPath, "cloudflare/src/rules.json");
  });
}
