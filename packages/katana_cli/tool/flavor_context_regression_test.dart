import "package:katana_cli/katana_cli.dart";

void main() {
  final tidb = FlavorContext.resolve(yaml: {
    "cloudflare": {
      "tidb": {
        "host": {"dev": "dev.invalid", "prod": "prod.invalid"},
        "database": {"dev": "dev_main", "prod": "main"},
      }
    },
  }, secrets: {
    "cloudflare": {
      "tidb": {
        "username": {"dev": "runtime_dev", "prod": "runtime_prod"},
        "migration_username": {"dev": "admin_dev", "prod": "admin_prod"},
        "migration_password": {"dev": "fixture_dev", "prod": "fixture_prod"},
      }
    }
  }, arguments: const [
    "migrate",
    "status",
    "--flavor",
    "dev"
  ]);
  final tidbConfig = (tidb.yaml["cloudflare"] as Map)["tidb"] as Map;
  final tidbSecrets = (tidb.secrets["cloudflare"] as Map)["tidb"] as Map;
  _expect(
      tidbConfig["host"] == "dev.invalid" &&
          tidbConfig["database"] == "dev_main",
      "TiDBの接続先がdevへ解決されませんでした。");
  _expect(
      tidbSecrets["username"] == "runtime_dev" &&
          tidbSecrets["migration_username"] == "admin_dev" &&
          tidbSecrets["migration_password"] == "fixture_dev",
      "TiDBのruntime/migration資格情報の環境解決に失敗しました。");

  final inferred = FlavorContext.resolve(
    yaml: {
      "firebase": {
        "project_id": {"dev": "app-dev", "prod": "app-prod"},
      },
    },
    secrets: const {},
    arguments: const ["apply"],
  );
  _expect(inferred.flavor == KatanaFlavor.dev, "Map must default to dev.");
  _expect(
    (inferred.yaml["firebase"] as Map)["project_id"] == "app-dev",
    "The dev value was not resolved.",
  );
  _expect(
    inferred.yamlValue(
          const ["firebase", "project_id"],
          flavor: KatanaFlavor.prod,
        ) ==
        "app-prod",
    "The prod value must remain available while dev is selected.",
  );

  final explicit = FlavorContext.resolve(
    yaml: {
      "firebase": {
        "project_id": {"dev": "app-dev", "prod": "app-prod"},
      },
    },
    secrets: {
      "cloudflare": {
        "turso": {
          "platform_api_token": {"dev": "secret-dev", "prod": "secret-prod"},
        },
      },
    },
    arguments: const ["apply", "--flavor=prod"],
  );
  _expect(explicit.flavor == KatanaFlavor.prod, "Explicit prod must win.");
  _expect(
    ((explicit.secrets["cloudflare"] as Map)["turso"]
            as Map)["platform_api_token"] ==
        "secret-prod",
    "The prod secret was not resolved.",
  );

  final scalar = FlavorContext.resolve(
    yaml: const {
      "firebase": {"project_id": "app-prod"},
    },
    secrets: const {},
    arguments: const ["deploy"],
  );
  _expect(scalar.flavor == KatanaFlavor.prod, "Scalars must default to prod.");

  _expectThrows(
    () => FlavorContext.resolve(
      yaml: {
        "firebase": {
          "project_id": {"dev": "app-dev", "stg": "app-stg"},
        },
      },
      secrets: const {},
      arguments: const ["apply"],
    ),
    "Unknown environment keys must fail.",
  );
  _expectThrows(
    () => FlavorContext.resolve(
      yaml: {
        "firebase": {
          "project_id": {"prod": "app-prod"},
        },
      },
      secrets: const {},
      arguments: const ["apply"],
    ),
    "A missing inferred dev value must fail.",
  );
  _expectThrows(
    () => FlavorContext.resolve(
      yaml: const {},
      secrets: const {},
      arguments: const ["apply", "--flavor=stg"],
    ),
    "An unknown explicit flavor must fail.",
  );
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void _expectThrows(void Function() callback, String message) {
  try {
    callback();
  } on Object {
    return;
  }
  throw StateError(message);
}
