import "dart:convert";

import "package:masamune_model_tidb_builder/masamune_model_tidb_builder.dart";
import "package:test/test.dart";

void main() {
  const table = TidbTableSpec(
    database: "main",
    table: "users",
    columns: [
      TidbColumnSpec(name: "name", sqlType: "TEXT", required: true),
      TidbColumnSpec(name: "score", sqlType: "BIGINT"),
    ],
  );

  test("generates the official single-config CaC layout", () {
    final output = TidbEndpointSpec.generate(
      tables: [table],
      rules: const TidbRulesReader({}),
      appId: "app-1",
      clusterId: "123",
    );

    expect(output.files, contains("dataapp_config.json"));
    expect(output.files, contains("data_sources/cluster.json"));
    expect(output.files, contains("http_endpoints/config.json"));
    expect(output.files, contains("__masamune/schema.sql"));
    expect(output.files, contains("__generated_manifest.json"));
    final config = jsonDecode(
      output.files["http_endpoints/config.json"]!,
    ) as List<dynamic>;
    expect(config, hasLength(6));
    expect(
      config.where(
        (dynamic item) =>
            (item as Map<String, dynamic>)["endpoint"] == "/main/users/get",
      ),
      hasLength(1),
    );
    expect(
      output.files["http_endpoints/sql/GET-main-users-list.sql"],
      startsWith("USE `main`;"),
    );
    expect(
      output.files["__masamune/schema.sql"],
      contains("`id` VARCHAR(255) PRIMARY KEY"),
    );
  });

  test("omits only operations explicitly denied by rules.json", () {
    final output = TidbEndpointSpec.generate(
      tables: [table],
      rules: const TidbRulesReader({
        "rules": {
          "database": {
            "main/users": {
              "read": "deny",
              "delete": "deny",
              "create": "allow",
              "update": "allow",
            },
          },
        },
      }),
    );
    final config = jsonDecode(
      output.files["http_endpoints/config.json"]!,
    ) as List<dynamic>;
    final operations = config
        .map((dynamic item) =>
            (item as Map<String, dynamic>)["endpoint"] as String)
        .toList();

    expect(operations, isNot(contains("/main/users/get")));
    expect(operations, isNot(contains("/main/users/list")));
    expect(operations, isNot(contains("/main/users/count")));
    expect(operations, isNot(contains("/main/users/delete")));
    expect(operations, contains("/main/users/upsert"));
    expect(operations, contains("/main/users/update"));
  });
}
