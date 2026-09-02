import "package:katana_cli/katana_cli.dart";

void main() {
  const source = '''
{
  "\$schema": "node_modules/wrangler/config-schema.json",
  "name": "legacy",
  "main": "src/index.ts"
}
''';
  final dev = WranglerEnvironmentSynchronizer.synchronize(
    source,
    flavor: "dev",
    workerName: "app-dev",
    rootWorkerName: "app-prod",
  );
  _expect(
    RegExp(r'''"name"\s*:\s*"([^"]+)"''').firstMatch(dev)?.group(1) ==
        "app-prod",
    "The root Worker name must remain fixed to production.",
  );
  _expect(
    dev.contains('"vars": { "FLAVOR": "dev" }'),
    "The dev Worker must receive immutable FLAVOR=dev.",
  );
  final both = WranglerEnvironmentSynchronizer.synchronize(
    dev,
    flavor: "prod",
    workerName: "app-prod",
    rootWorkerName: "app-prod",
  );
  _expect(
    both.contains('"name": "app-dev"') &&
        both.contains('"name": "app-prod"') &&
        both.contains('"vars": { "FLAVOR": "prod" }'),
    "Updating prod must preserve the dev environment.",
  );
  final bound = WranglerEnvironmentSynchronizer.transformEnvironment(
    both,
    flavor: "dev",
    transform: (environment) => environment.replaceFirst(
      RegExp(r"}\s*$"),
      ',\n      "kv_namespaces": [{ "binding": "CACHE" }]\n    }',
    ),
  );
  final devSection = bound.substring(
    bound.indexOf('"dev"'),
    bound.indexOf('"prod"'),
  );
  _expect(
    devSection.contains("kv_namespaces"),
    "A binding must be written only into the selected environment.",
  );
  _expect(
    !bound.substring(bound.indexOf('"prod"')).contains("kv_namespaces"),
    "A dev binding must not leak into prod.",
  );
  final rebound = WranglerEnvironmentSynchronizer.synchronize(
    bound,
    flavor: "prod",
    workerName: "app-prod-v2",
    rootWorkerName: "app-prod",
  );
  _expect(
    rebound.contains("kv_namespaces") && rebound.contains("app-prod-v2"),
    "Updating an environment name must preserve bindings from the other one.",
  );
  final withVariables = WranglerEnvironmentSynchronizer.upsertVariables(
    rebound,
    flavor: "dev",
    values: const {
      "TURSO_GROUP": "group-dev",
      "TURSO_ORGANIZATION": "org-dev",
    },
  );
  _expect(
    withVariables.contains('"TURSO_GROUP": "group-dev"') &&
        withVariables.contains('"FLAVOR": "dev"'),
    "Public database settings must remain inside the selected Worker env.",
  );
  _expect(
    WranglerEnvironmentSynchronizer.synchronize(
          both,
          flavor: "prod",
          workerName: "app-prod",
          rootWorkerName: "app-prod",
        ) ==
        both,
    "Wrangler environment synchronization must be idempotent.",
  );

  const regeneratedBase = '''
{
  "name": "app-prod",
  "main": "src/index.ts",
  "compatibility_date": "2026-06-29"
}
''';
  final restored = WranglerEnvironmentSynchronizer.restoreEnvironments(
    regeneratedBase,
    from: bound,
  );
  final reappliedProd = WranglerEnvironmentSynchronizer.synchronize(
    restored,
    flavor: "prod",
    workerName: "app-prod-v2",
    rootWorkerName: "app-prod",
  );
  final restoredDevSection = reappliedProd.substring(
    reappliedProd.indexOf('"dev"'),
    reappliedProd.indexOf('"prod"'),
  );
  _expect(
    restoredDevSection.contains('"name": "app-dev"') &&
        restoredDevSection.contains("kv_namespaces"),
    "Regenerating the Wrangler base must preserve the other environment.",
  );
  _expect(
    reappliedProd.contains('"name": "app-prod-v2"'),
    "Regenerating the Wrangler base must still update the selected environment.",
  );
  _expect(
    WranglerEnvironmentSynchronizer.restoreEnvironments(
          regeneratedBase,
          from: restored,
        ) ==
        restored,
    "Restoring Wrangler environments must be idempotent.",
  );
  const customized = '''
{
  "name": "app-prod",
  "main": "src/index.ts",
  "routes": [{ "pattern": "example.com/app/*" }],
  "triggers": { "crons": ["*/1 * * * *"] },
  "ratelimits": [{ "name": "RATE_LIMIT" }],
  "queues": { "consumers": [{ "queue": "backup" }] },
  "r2_buckets": [{ "binding": "R2_BUCKET", "bucket_name": "assets" }]
}
''';
  final customizedDev = WranglerEnvironmentSynchronizer.synchronize(
    customized,
    flavor: "dev",
    workerName: "app-dev",
    rootWorkerName: "app-prod",
  );
  for (final setting in [
    '"routes"',
    '"triggers"',
    '"ratelimits"',
    '"queues"',
    '"r2_buckets"',
  ]) {
    _expect(
      customizedDev.contains(setting),
      "Synchronizing an environment must preserve root setting $setting.",
    );
  }
  _expectThrows(
    () => WranglerEnvironmentSynchronizer.synchronize(
      source,
      flavor: "stg",
      workerName: "app-stg",
    ),
    "Unknown Worker environments must fail.",
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
