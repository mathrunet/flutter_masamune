import "dart:io";

import "package:katana_cli/action/cloudflare/storage.dart";
import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  final template = katanaYamlCode(true);
  _expectCount(template, "    backup:", 1);
  _expectCount(template, "      binding: R2_BACKUP_BUCKET", 1);
  _expectCount(template, "      max_concurrency:", 0);
  _expectCount(template, "      max_batch_size: 10", 1);
  _expectCount(template, "      dead_letter_queue:", 1);

  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_storage_backup_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src").create(recursive: true);
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
    await wrangler.writeAsString("""
#!/bin/sh
STATE="\${0}.notification"
if [ "\$1" = "r2" ] && [ "\$2" = "bucket" ] && [ "\$3" = "notification" ] && [ "\$4" = "list" ]; then
  if [ -f "\$STATE" ]; then
    echo "my-app-storage-backup object-create Managed by katana: R2 backup"
  fi
  exit 0
fi
if [ "\$1" = "r2" ] && [ "\$2" = "bucket" ] && [ "\$3" = "notification" ] && [ "\$4" = "create" ]; then
  touch "\$STATE"
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
    await action.exec(context);

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

void _expectCount(String source, String pattern, int expected) {
  final actual = RegExp(RegExp.escape(pattern)).allMatches(source).length;
  if (actual != expected) {
    throw StateError(
      "Expected `$pattern` $expected time(s), but found $actual.\n$source",
    );
  }
}
