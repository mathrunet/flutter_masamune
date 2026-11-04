import "package:katana_cli/action/cloudflare/tidb.dart";

void main() {
  final shared = validateTidbEnvironmentLayout(
    devCluster: "shared-cluster",
    prodCluster: "shared-cluster",
    devDatabase: "dev_app",
    prodDatabase: "app",
  );
  _expect(shared.warnings.isEmpty && shared.error == null,
      "共有clusterの標準構成で警告またはエラーが出ました。");

  final separated = validateTidbEnvironmentLayout(
    devCluster: "dev-cluster",
    prodCluster: "prod-cluster",
    devDatabase: "app",
    prodDatabase: "app",
  );
  _expect(separated.warnings.length == 1 && separated.error == null,
      "別clusterの既存構成は警告のみで続行する必要があります。");

  final collided = validateTidbEnvironmentLayout(
    devCluster: "shared-cluster",
    prodCluster: "shared-cluster",
    devDatabase: "app",
    prodDatabase: "app",
  );
  _expect(collided.error != null, "同一cluster・同一databaseを拒否しませんでした。");

  final mismatched = validateTidbEnvironmentLayout(
    devCluster: "shared-cluster",
    prodCluster: "shared-cluster",
    devDatabase: "app_dev",
    prodDatabase: "app",
  );
  _expect(mismatched.warnings.length == 1 && mismatched.error == null,
      "dev_の付け方が異なる場合は警告する必要があります。");

  final incomplete = validateTidbEnvironmentLayout(
    devCluster: "dev-cluster",
    prodCluster: "",
    devDatabase: "app",
    prodDatabase: "",
  );
  _expect(incomplete.warnings.isEmpty && incomplete.error == null,
      "未設定の環境があるときは検査しない必要があります。");

  _testAdditionalGrants();
}

void _testAdditionalGrants() {
  const manifest = [
    {"database": "dev_shared", "table": "landmarks"}
  ];
  final grants = resolveTidbAdditionalGrants(
    [
      {
        "table": "google_subscription_notification",
        "privileges": ["delete", "SELECT", "Insert", "SELECT"],
      },
      {
        "table": "audit_log",
        "database": {"dev": "dev_audit", "prod": "audit"},
        "privileges": ["SELECT"],
      },
    ],
    environment: "dev",
    database: "dev_shared",
    manifestTables: manifest,
  );
  _expect(
    grants.length == 2 &&
        grants[0]["database"] == "dev_shared" &&
        (grants[0]["privileges"] as List).join(",") == "SELECT,INSERT,DELETE" &&
        grants[1]["database"] == "dev_audit",
    "additional_grantsのdatabase解決またはprivileges正規化が不正です。",
  );
  _expect(
    resolveTidbAdditionalGrants(null,
            environment: "dev", database: "dev_shared")
        .isEmpty,
    "additional_grants未指定時は空である必要があります。",
  );
  final byEnvironment = resolveTidbAdditionalGrants(
    {
      "prod": [
        {
          "table": "cache",
          "privileges": ["SELECT"]
        }
      ]
    },
    environment: "prod",
    database: "shared",
  );
  _expect(byEnvironment.single["database"] == "shared",
      "環境別のadditional_grantsを解決できません。");
  for (final invalid in <Object>[
    {
      "table": "cache",
      "privileges": ["SELECT"]
    },
    [
      {
        "table": "landmarks",
        "privileges": ["SELECT"]
      }
    ],
    [
      {"table": "cache", "privileges": <String>[]}
    ],
    [
      {
        "table": "cache",
        "privileges": ["DROP"]
      }
    ],
    [
      {
        "table": "cache; DROP USER x",
        "privileges": ["SELECT"]
      }
    ],
    [
      {
        "table": "cache",
        "privilege": ["SELECT"]
      }
    ],
    [
      {
        "table": "cache",
        "privileges": ["SELECT"]
      },
      {
        "table": "CACHE",
        "privileges": ["INSERT"]
      },
    ],
  ]) {
    var rejected = false;
    try {
      resolveTidbAdditionalGrants(invalid,
          environment: "dev", database: "dev_shared", manifestTables: manifest);
    } on FormatException {
      rejected = true;
    }
    _expect(rejected, "不正なadditional_grantsを拒否しませんでした: $invalid");
  }
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}
