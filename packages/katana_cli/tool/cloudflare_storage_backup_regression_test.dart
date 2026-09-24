import "dart:io";

import "package:katana_cli/action/cloudflare/storage.dart";
import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main(List<String> arguments) async {
  await _testStorageManagedState();
  if (arguments.contains("--storage-managed-state-only")) {
    stdout.writeln("All Cloudflare Storage managed state checks passed.");
    return;
  }
  await _testWranglerResponseHandling();
  await _testSharedBackupQueueConsumerOwnership();
  await _testCustomBackupWorkerPreserved();

  final template = katanaYamlCode(true);
  _expectCount(template, "    backup:", 1);
  _expectCount(template, "      consumer_flavor:", 1);
  _expectCount(template, "      binding: R2_BACKUP_BUCKET", 0);
  _expectCount(template, "      max_concurrency:", 0);
  _expectCount(template, "      max_batch_size: 10", 0);
  _expectCount(template, "      dead_letter_queue:", 0);
  _expectCount(template, "    bucket_name:", 2);
  _expectCount(template, "    public_base_url:", 1);

  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_storage_backup_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src").create(recursive: true);
    await File("cloudflare/.gitignore").writeAsString("node_modules\n");
    await File("cloudflare/src/index.ts").writeAsString("""
import * as m from "@mathrunet/masamune_cloudflare";

export default m.deploy([
]);
""");
    await File("cloudflare/wrangler.jsonc").writeAsString("""
{
  "name": "test-worker",
  "main": "src/index.ts",
  "upload_source_maps": true,
  "r2_buckets": [
    {
      "binding": "EXTRA_BUCKET",
      "bucket_name": "extra-bucket"
    }
  ],
  "queues": {
    "producers": [
      {
        "binding": "EXTRA_QUEUE",
        "queue": "extra-queue"
      }
    ]
  }
}

""");
    await File("pubspec.yaml").writeAsString("""
name: test_app
dependencies:
  masamune_storage_cloudflare: any
""");
    final npm = File("${temporary.path}/fake-npm.sh");
    await npm.writeAsString("""
#!/bin/sh
exit 0
""");
    final wrangler = File("${temporary.path}/fake-wrangler.sh");
    await wrangler.writeAsString(r"""
#!/bin/sh
STATE="${0}.notification"
CREATE_COUNT="${0}.notification-create-count"
QUEUE_STATE="${0}.queues"
if [ "$1" = "queues" ] && [ "$2" = "create" ]; then
  if [ -f "$QUEUE_STATE" ] && grep -Fqx "$3" "$QUEUE_STATE"; then
    printf "\033[31mQueue name '%s' is already taken. [code: 11009]\033[0m\n" "$3" >&2
    exit 1
  fi
  echo "$3" >> "$QUEUE_STATE"
  exit 0
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "list" ]; then
  if [ -f "${0}.fatal-list" ]; then
    echo "Authentication failed. [code: 10000]" >&2
    exit 1
  fi
  if [ -f "$STATE" ]; then
    echo "rule_id: rule-1"
    echo "queue_name: my-app-storage-backup"
    echo "event_type: PutObject, CompleteMultipartUpload, CopyObject"
    exit 0
  fi
  printf "\033[31mNo event notification config found for bucket 'my-app-bucket': no configurations found for bucket. [code: 11015]\033[0m\n" >&2
  exit 1
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "create" ]; then
  touch "$STATE"
  echo created >> "$CREATE_COUNT"
  exit 0
fi
exit 0
""");
    await Process.run("chmod", ["+x", npm.path, wrangler.path]);

    final context = ExecContext(
      yaml: {
        "bin": {
          "npm": npm.path,
          "wrangler": wrangler.path,
        },
        "cloudflare": {
          "storage": {
            "enable": true,
            "binding": "R2_BUCKET",
            "bucket_name": "my-app-bucket",
            "public_base_url": "https://assets.example.com",
            "backup": {
              "enable": true,
              "binding": "R2_BACKUP_BUCKET",
              "bucket_name": "my-app-bucket-backup",
              "queue_name": "my-app-storage-backup",
            },
          },
        },
      },
      args: const [],
    );
    const action = CloudflareStorageCliAction();
    await action.exec(context);
    final firstStorageState =
        await File(storageManagedStatePath).readAsString();
    await action.exec(context);

    final secondStorageState =
        await File(storageManagedStatePath).readAsString();
    _expect(
      firstStorageState == secondStorageState &&
          firstStorageState.contains("download_url_secret:"),
      "the generated download URL secret must be reused from storage.yaml",
    );
    final ignored = await File("cloudflare/.gitignore").readAsLines();
    _expect(
      ignored.where((line) => line == "storage.yaml").length == 1,
      "storage.yaml must be ignored exactly once",
    );

    final notificationCreates = await File(
      "${wrangler.path}.notification-create-count",
    ).readAsLines();
    _expect(
      notificationCreates.length == 1,
      "The R2 object-create notification must be created exactly once.",
    );
    final createdQueues = await File("${wrangler.path}.queues").readAsLines();
    _expect(
      createdQueues.toSet().length == 2 && createdQueues.length == 2,
      "The backup Queue and DLQ must be reused on repeated apply runs.",
    );

    await File("${wrangler.path}.fatal-list").create();
    var rejectedUnexpectedListError = false;
    try {
      await action.exec(context);
    } on Exception catch (error) {
      rejectedUnexpectedListError = error.toString().contains(
            "Failed to list Cloudflare R2 notifications",
          );
    }
    _expect(
      rejectedUnexpectedListError,
      "Only Cloudflare API code 11015 may be treated as an empty list.",
    );

    final index = await File("cloudflare/src/index.ts").readAsString();
    _expectCount(index, "storage.Functions.storageCloudflare(", 1);
    _expectCount(index, "storage.Functions.storageCloudflareBackup(", 1);

    final wranglerSource =
        await File("cloudflare/wrangler.jsonc").readAsString();
    _expectCount(wranglerSource, '"binding": "EXTRA_BUCKET"', 1);
    _expectCount(wranglerSource, '"binding": "R2_BUCKET"', 1);
    _expectCount(wranglerSource, '"binding": "R2_BACKUP_BUCKET"', 1);
    _expectCount(wranglerSource, '"binding": "EXTRA_QUEUE"', 1);
    _expectCount(wranglerSource, '"queue": "my-app-storage-backup"', 1);
    _expectCount(wranglerSource, '"max_concurrency": 1', 1);
  } finally {
    Directory.current = originalDirectory;
    await temporary.delete(recursive: true);
  }
}

Future<void> _testCustomBackupWorkerPreserved() async {
  final previous = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_custom_backup_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src/workers").create(recursive: true);
    await File("cloudflare/src/workers/custom_backup.ts").writeAsString("""
export class CustomBackupWorker extends mc.QueueProcessWorkdersBase {
  process(batch, env) {
    const source = env.R2_BUCKET;
    const backup = env.R2_BACKUP_BUCKET;
  }
}
""");
    await File("cloudflare/src/index.ts").writeAsString("""
import * as m from "@mathrunet/masamune_cloudflare";
import * as storage from "@mathrunet/masamune_cloudflare_storage";
import { CustomBackupWorker } from "./workers/custom_backup";
export default m.deploy([
  new CustomBackupWorker(),
  storage.Functions.storageCloudflare({
    bucketBindingName: "R2_BUCKET",
    publicBaseUrl: "https://assets.example.com",
  }),
  storage.Functions.storageCloudflareBackup({
    sourceBucketBindingName: "R2_BUCKET",
    backupBucketBindingName: "R2_BACKUP_BUCKET",
    sourceBucketName: "fixture",
  }),
]);
""");
    await File("cloudflare/wrangler.jsonc").writeAsString(
      '{"name":"fixture","main":"src/index.ts"}',
    );
    await File("cloudflare/.gitignore").writeAsString("node_modules\n");
    await File("cloudflare/package.json").writeAsString(
      '{"dependencies":{"@mathrunet/masamune_cloudflare_storage":"1.0.0"}}',
    );
    await File("pubspec.yaml").writeAsString(
      "name: fixture\ndependencies:\n  masamune_storage_cloudflare: any\n",
    );
    final wrangler = File("${temporary.path}/fake-wrangler.sh");
    await wrangler.writeAsString("""
#!/bin/sh
if [ "\$1" = "secret" ]; then cat >/dev/null; fi
exit 0
""");
    await Process.run("chmod", ["+x", wrangler.path]);
    final context = ExecContext(yaml: {
      "bin": {"npm": wrangler.path, "wrangler": wrangler.path},
      "cloudflare": {
        "project_id": "fixture",
        "workers": {"enable": true},
        "storage": {
          "enable": true,
          "bucket_name": "fixture",
          "public_base_url": "https://assets.example.com",
          "backup": {"enable": true, "bucket_name": "fixture-backup"},
        },
      },
    }, args: const []);
    const action = CloudflareStorageCliAction();
    await action.exec(context);
    final first = await File("cloudflare/src/index.ts").readAsString();
    _expectCount(first, "new CustomBackupWorker()", 1);
    _expectCount(first, "storage.Functions.storageCloudflareBackup(", 0);
    await action.exec(context);
    _expect(
      await File("cloudflare/src/index.ts").readAsString() == first,
      "Custom Queue backup Worker must remain stable on repeated apply.",
    );
    await File("cloudflare/src/workers/maintenance.ts").writeAsString("""
export class MaintenanceWorker extends mc.QueueProcessWorkdersBase {
  process(batch, env) {
    const source = env.R2_BUCKET;
    const backup = env.R2_BACKUP_BUCKET;
  }
}
""");
    await File("cloudflare/src/index.ts").writeAsString(
      first
          .replaceAll("CustomBackupWorker", "MaintenanceWorker")
          .replaceAll("./workers/custom_backup", "./workers/maintenance"),
    );
    await action.exec(context);
    final unrelated = await File("cloudflare/src/index.ts").readAsString();
    _expectCount(unrelated, "new MaintenanceWorker()", 1);
    _expectCount(unrelated, "storage.Functions.storageCloudflareBackup(", 1);
  } finally {
    Directory.current = previous;
    await temporary.delete(recursive: true);
  }
}

Future<void> _testSharedBackupQueueConsumerOwnership() async {
  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_shared_backup_queue_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src").create(recursive: true);
    await File("cloudflare/.gitignore").writeAsString("node_modules\n");
    await File("cloudflare/src/index.ts").writeAsString("""
import * as m from "@mathrunet/masamune_cloudflare";

export default m.deploy([
]);
""");
    await File("cloudflare/wrangler.jsonc").writeAsString("""
{
  "name": "shared-backup-worker",
  "main": "src/index.ts",
  "queues": {
    "producers": [
      {
        "binding": "UNRELATED_QUEUE",
        "queue": "unrelated-queue"
      }
    ]
  }
}
""");
    await File("pubspec.yaml").writeAsString("""
name: test_app
dependencies:
  masamune_storage_cloudflare: any
""");
    final npm = File("${temporary.path}/fake-npm.sh");
    await npm.writeAsString("""
#!/bin/sh
exit 0
""");
    final wrangler = File("${temporary.path}/fake-wrangler.sh");
    await wrangler.writeAsString(r"""
#!/bin/sh
if [ "$1" = "queues" ] && [ "$2" = "create" ]; then
  exit 0
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "list" ]; then
  echo "rule_id: rule-1"
  echo "queue_name: shared-backup-queue"
  echo "event_type: PutObject, CompleteMultipartUpload, CopyObject"
  exit 0
fi
exit 0
""");
    await Process.run("chmod", ["+x", npm.path, wrangler.path]);

    final sourceYaml = <dynamic, dynamic>{
      "bin": {
        "npm": npm.path,
        "wrangler": wrangler.path,
      },
      "cloudflare": {
        "project_id": {
          "dev": "shared-backup-worker-dev",
          "prod": "shared-backup-worker",
        },
        "storage": {
          "enable": true,
          "binding": "R2_BUCKET",
          "bucket_name": "shared-bucket",
          "public_base_url": "https://assets.example.com",
          "backup": {
            "enable": true,
            "binding": "R2_BACKUP_BUCKET",
            "bucket_name": "shared-backup-bucket",
            "queue_name": "shared-backup-queue",
            "consumer_flavor": "prod",
          },
        },
      },
    };
    const action = CloudflareStorageCliAction();
    Future<void> applyFlavors(List<String> flavors) async {
      for (final flavor in flavors) {
        final flavorContext = FlavorContext.resolve(
          yaml: sourceYaml,
          secrets: const {},
          arguments: ["--flavor", flavor],
        );
        await action.exec(
          ExecContext(
            yaml: flavorContext.yaml,
            secrets: flavorContext.secrets,
            args: ["--flavor", flavor],
            flavorContext: flavorContext,
          ),
        );
      }
    }

    await applyFlavors(["dev", "prod", "dev"]);

    var generated = await File("cloudflare/wrangler.jsonc").readAsString();
    _expectCount(generated, '"queue": "shared-backup-queue"', 1);
    _expectCount(generated, '"binding": "UNRELATED_QUEUE"', 1);
    _expectCount(generated, '"name": "shared-backup-worker-dev"', 1);
    _expectCount(generated, '"name": "shared-backup-worker"', 2);
    final devStart = generated.indexOf('"dev"');
    final prodStart = generated.indexOf('"prod"', devStart + 1);
    _expect(
      devStart >= 0 &&
          prodStart > devStart &&
          !generated
              .substring(devStart, prodStart)
              .contains('"queue": "shared-backup-queue"'),
      "the non-owner dev environment must not declare the shared consumer",
    );
    _expect(
      prodStart >= 0 &&
          generated
              .substring(prodStart)
              .contains('"queue": "shared-backup-queue"'),
      "the configured prod environment must own the shared consumer",
    );

    final backup =
        ((sourceYaml["cloudflare"] as Map)["storage"] as Map)["backup"] as Map;
    backup["consumer_flavor"] = "dev";
    await applyFlavors(["prod", "dev", "prod"]);
    generated = await File("cloudflare/wrangler.jsonc").readAsString();
    _expectCount(generated, '"queue": "shared-backup-queue"', 1);
    final explicitDevStart = generated.indexOf('"dev"');
    final explicitProdStart = generated.indexOf(
      '"prod"',
      explicitDevStart + 1,
    );
    _expect(
      generated
              .substring(explicitDevStart, explicitProdStart)
              .contains('"queue": "shared-backup-queue"') &&
          !generated
              .substring(explicitProdStart)
              .contains('"queue": "shared-backup-queue"'),
      "consumer_flavor dev must move the declaration to the dev environment",
    );

    backup.remove("consumer_flavor");
    await applyFlavors(["dev", "prod", "dev"]);
    generated = await File("cloudflare/wrangler.jsonc").readAsString();
    _expectCount(generated, '"queue": "shared-backup-queue"', 1);
    final defaultDevStart = generated.indexOf('"dev"');
    final defaultProdStart = generated.indexOf('"prod"', defaultDevStart + 1);
    _expect(
      !generated
              .substring(defaultDevStart, defaultProdStart)
              .contains('"queue": "shared-backup-queue"') &&
          generated
              .substring(defaultProdStart)
              .contains('"queue": "shared-backup-queue"'),
      "prod must own a shared Queue by default when Workers differ",
    );

    backup["queue_name"] = {
      "dev": "shared-backup-queue-dev",
      "prod": "shared-backup-queue-prod",
    };
    await File("cloudflare/wrangler.jsonc").writeAsString("""
{
  "name": "shared-backup-worker",
  "main": "src/index.ts",
  "queues": {
    "producers": [
      {
        "binding": "UNRELATED_QUEUE",
        "queue": "unrelated-queue"
      }
    ]
  }
}
""");
    await applyFlavors(["prod", "dev", "prod"]);
    generated = await File("cloudflare/wrangler.jsonc").readAsString();
    _expectCount(generated, '"queue": "shared-backup-queue-dev"', 1);
    _expectCount(generated, '"queue": "shared-backup-queue-prod"', 1);
    _expectCount(generated, '"binding": "UNRELATED_QUEUE"', 1);
  } finally {
    Directory.current = originalDirectory;
    await temporary.delete(recursive: true);
  }
}

Future<void> _testStorageManagedState() async {
  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_storage_managed_state_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare").create();
    await File("cloudflare/.gitignore").writeAsString("node_modules\n");
    final secrets = <String, dynamic>{
      "cloudflare": {
        "storage": {"download_url_secret": "legacy-secret"},
      },
    };

    final migrated = await loadAndMigrateStorageManagedState(secrets);
    _expect(migrated.secretsChanged, "legacy secret must be migrated");
    _expect(migrated.stateChanged, "new managed state must be persisted");
    _expect(
      migrated.downloadUrlSecret == "legacy-secret",
      "legacy secret must be preserved during migration",
    );
    _expect(
      !((secrets["cloudflare"] as Map)["storage"] as Map)
          .containsKey("download_url_secret"),
      "legacy secret must be removed from katana_secrets.yaml",
    );
    await saveStorageManagedState(migrated.state);
    await ensureStorageManagedStateIsGitIgnored();
    await ensureStorageManagedStateIsGitIgnored();

    final reloaded = await loadAndMigrateStorageManagedState(secrets);
    _expect(
      !reloaded.secretsChanged &&
          !reloaded.stateChanged &&
          reloaded.downloadUrlSecret == "legacy-secret",
      "stored secret must be reused without rewriting managed state",
    );
    final ignored = await File("cloudflare/.gitignore").readAsLines();
    _expect(
      ignored.where((line) => line == "storage.yaml").length == 1,
      "storage.yaml must be ignored exactly once",
    );

    final conflictingSecrets = <String, dynamic>{
      "cloudflare": {
        "storage": {"download_url_secret": "different-secret"},
      },
    };
    var conflictRejected = false;
    try {
      await loadAndMigrateStorageManagedState(conflictingSecrets);
    } on StateError catch (exception) {
      _expect(
        exception.message.toString().contains("differs"),
        "managed state conflict must explain the mismatch",
      );
      conflictRejected = true;
    }
    _expect(
      conflictRejected,
      "conflicting Storage managed state must be rejected",
    );

    await File(storageManagedStatePath).delete();
    final generated = await loadAndMigrateStorageManagedState(
      <String, dynamic>{},
      generateSecret: () => "generated-secret",
    );
    _expect(
      generated.downloadUrlSecret == "generated-secret",
      "missing download URL secret must be generated",
    );
    await saveStorageManagedState(generated.state);
    final generatedReloaded = await loadAndMigrateStorageManagedState(
      <String, dynamic>{},
      generateSecret: () => "unexpected-replacement",
    );
    _expect(
      generatedReloaded.downloadUrlSecret == "generated-secret" &&
          !generatedReloaded.stateChanged,
      "generated download URL secret must be stable across apply runs",
    );
  } finally {
    Directory.current = originalDirectory;
    await temporary.delete(recursive: true);
  }
}

Future<void> _testWranglerResponseHandling() async {
  const equivalentRule = """
rule_id: rule-1
queue_name: my-app-storage-backup
event_type: PutObject, CompleteMultipartUpload, CopyObject
""";
  final acceptedQueue = await _runWranglerScenario(
    queueExitCode: 1,
    queueStderr:
        "\u001b[31mQUEUE NAME 'MY-APP-STORAGE-BACKUP' IS ALREADY TAKEN. [ CODE: 11009 ]\u001b[0m",
    listStdout: equivalentRule,
  );
  _expect(
    acceptedQueue.error == null && acceptedQueue.notificationCreates == 0,
    "ANSI/case variants of code 11009 for the target Queue must be reused.",
  );
  final acceptedQueueFromStdout = await _runWranglerScenario(
    queueExitCode: 1,
    queueStdout:
        "Queue name 'my-app-storage-backup' is already taken. [code: 11009]",
    listStdout: equivalentRule,
  );
  _expect(
    acceptedQueueFromStdout.error == null &&
        acceptedQueueFromStdout.notificationCreates == 0,
    "Code 11009 for the target Queue must be reused regardless of the "
    "Wrangler output stream.",
  );
  for (final testCase in const [
    (
      name: "code 11009 for another Queue",
      output: "Queue name 'other-queue' is already taken. [code: 11009]",
    ),
    (
      name: "the target message without code 11009",
      output: "Queue name 'my-app-storage-backup' is already taken.",
    ),
    (
      name: "an authentication failure",
      output: "Authentication failed. [code: 10000]",
    ),
    (
      name: "code 11009 accompanied by another API error",
      output: "Queue name 'my-app-storage-backup' is already taken. "
          "[code: 11009]\nAuthentication failed. [code: 10000]",
    ),
  ]) {
    final result = await _runWranglerScenario(
      queueExitCode: 1,
      queueStderr: testCase.output,
      listStdout: equivalentRule,
    );
    _expect(
      result.error?.contains("Failed to create Cloudflare Queue") ?? false,
      "${testCase.name} must remain fatal.",
    );
  }

  final acceptedUnconfigured = await _runWranglerScenario(
    listExitCode: 1,
    listStderr:
        "\u001b[31mNO EVENT NOTIFICATION CONFIG FOUND for bucket 'my-app-bucket': "
        "NO CONFIGURATIONS FOUND FOR BUCKET. [ CODE: 11015 ]\u001b[0m",
  );
  _expect(
    acceptedUnconfigured.error == null &&
        acceptedUnconfigured.notificationCreates == 1,
    "Only the complete ANSI/case variant of the unconfigured 11015 response "
    "must continue to notification creation.",
  );
  for (final testCase in const [
    (
      name: "code 11015 without the event-config message",
      output: "No configurations found for bucket. [code: 11015]",
    ),
    (
      name: "code 11015 without the bucket-config message",
      output: "No event notification config found. [code: 11015]",
    ),
    (
      name: "an authentication failure",
      output: "Authentication failed. [code: 10000]",
    ),
    (
      name: "a missing bucket",
      output: "The specified bucket does not exist. [code: 10006]",
    ),
    (
      name: "a transport failure",
      output: "Network connection failed while contacting api.cloudflare.com",
    ),
  ]) {
    final result = await _runWranglerScenario(
      listExitCode: 1,
      listStderr: testCase.output,
    );
    _expect(
      (result.error?.contains("Failed to list Cloudflare R2 notifications") ??
              false) &&
          result.notificationCreates == 0,
      "${testCase.name} must remain fatal.",
    );
  }

  for (final testCase in const [
    (name: "canonical rule", output: equivalentRule),
    (
      name: "ANSI/case/space/action-order variants",
      output: "\u001b[36m- RULE_ID : rule-1\u001b[0m\n"
          "  QUEUE_NAME :   MY-APP-STORAGE-BACKUP   \n"
          "  EVENT_TYPE : CopyObject, putobject,  CompleteMultipartUpload\n",
    ),
  ]) {
    final result = await _runWranglerScenario(listStdout: testCase.output);
    _expect(
      result.error == null && result.notificationCreates == 0,
      "${testCase.name} must be recognized as an equivalent notification.",
    );
  }
  for (final testCase in const [
    (
      name: "another Queue",
      output: "rule_id: rule-1\n"
          "queue_name: other-queue\n"
          "event_type: PutObject, CompleteMultipartUpload, CopyObject\n",
    ),
    (
      name: "a missing action",
      output: "rule_id: rule-1\n"
          "queue_name: my-app-storage-backup\n"
          "event_type: PutObject, CopyObject\n",
    ),
    (
      name: "an additional action",
      output: "rule_id: rule-1\n"
          "queue_name: my-app-storage-backup\n"
          "event_type: PutObject, CompleteMultipartUpload, CopyObject, DeleteObject\n",
    ),
    (
      name: "a duplicated action",
      output: "rule_id: rule-1\n"
          "queue_name: my-app-storage-backup\n"
          "event_type: PutObject, CompleteMultipartUpload, CopyObject, CopyObject\n",
    ),
    (
      name: "actions split across different rules",
      output: "rule_id: rule-1\n"
          "queue_name: my-app-storage-backup\n"
          "event_type: PutObject\n"
          "rule_id: rule-2\n"
          "queue_name: other-queue\n"
          "event_type: CompleteMultipartUpload, CopyObject\n",
    ),
    (
      name: "legacy description/object-create text",
      output:
          "my-app-storage-backup object-create Managed by katana: R2 backup\n",
    ),
  ]) {
    final result = await _runWranglerScenario(listStdout: testCase.output);
    _expect(
      result.error == null && result.notificationCreates == 1,
      "${testCase.name} must not be mistaken for an equivalent notification.",
    );
  }
}

Future<_WranglerScenarioResult> _runWranglerScenario({
  int queueExitCode = 0,
  String queueStdout = "",
  String queueStderr = "",
  int listExitCode = 0,
  String listStdout = "",
  String listStderr = "",
}) async {
  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_wrangler_response_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src").create(recursive: true);
    await File("cloudflare/.gitignore").writeAsString("node_modules\n");
    await File("cloudflare/src/index.ts").writeAsString("""
import * as m from "@mathrunet/masamune_cloudflare";

export default m.deploy([
]);
""");
    await File("cloudflare/wrangler.jsonc").writeAsString("""
{
  "name": "test-worker",
  "main": "src/index.ts"
}
""");
    await File("pubspec.yaml").writeAsString("""
name: test_app
dependencies:
  masamune_storage_cloudflare: any
""");
    final npm = File("${temporary.path}/fake-npm.sh");
    await npm.writeAsString("""
#!/bin/sh
exit 0
""");
    final wrangler = File("${temporary.path}/fake-wrangler.sh");
    final fixtureBase = "${wrangler.path}.fixture";
    await wrangler.writeAsString(r"""
#!/bin/sh
FIXTURE="${0}.fixture"
if [ "$1" = "queues" ] && [ "$2" = "create" ]; then
  cat "$FIXTURE.queue.stdout"
  cat "$FIXTURE.queue.stderr" >&2
  exit "$(cat "$FIXTURE.queue.exit")"
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "list" ]; then
  cat "$FIXTURE.list.stdout"
  cat "$FIXTURE.list.stderr" >&2
  exit "$(cat "$FIXTURE.list.exit")"
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "create" ]; then
  echo created >> "$FIXTURE.notification-creates"
  exit 0
fi
exit 0
""");
    await Future.wait([
      File("$fixtureBase.queue.stdout").writeAsString(queueStdout),
      File("$fixtureBase.queue.stderr").writeAsString(queueStderr),
      File("$fixtureBase.queue.exit").writeAsString("$queueExitCode"),
      File("$fixtureBase.list.stdout").writeAsString(listStdout),
      File("$fixtureBase.list.stderr").writeAsString(listStderr),
      File("$fixtureBase.list.exit").writeAsString("$listExitCode"),
    ]);
    await Process.run("chmod", ["+x", npm.path, wrangler.path]);

    final context = ExecContext(
      yaml: {
        "bin": {"npm": npm.path, "wrangler": wrangler.path},
        "cloudflare": {
          "storage": {
            "enable": true,
            "binding": "R2_BUCKET",
            "bucket_name": "my-app-bucket",
            "public_base_url": "https://assets.example.com",
            "backup": {
              "enable": true,
              "binding": "R2_BACKUP_BUCKET",
              "bucket_name": "my-app-bucket-backup",
              "queue_name": "my-app-storage-backup",
              "dead_letter_queue": "",
            },
          },
        },
      },
      args: const [],
    );
    String? error;
    try {
      await const CloudflareStorageCliAction().exec(context);
    } on Exception catch (caught) {
      error = caught.toString();
    }
    final createFile = File("$fixtureBase.notification-creates");
    return _WranglerScenarioResult(
      error: error,
      notificationCreates:
          createFile.existsSync() ? (await createFile.readAsLines()).length : 0,
    );
  } finally {
    Directory.current = originalDirectory;
    await temporary.delete(recursive: true);
  }
}

class _WranglerScenarioResult {
  const _WranglerScenarioResult({
    required this.error,
    required this.notificationCreates,
  });

  final String? error;
  final int notificationCreates;
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void _expectCount(String source, String pattern, int expected) {
  final actual = RegExp(RegExp.escape(pattern)).allMatches(source).length;
  if (actual != expected) {
    throw StateError(
      "Expected `$pattern` $expected time(s), but found $actual.\n$source",
    );
  }
}
