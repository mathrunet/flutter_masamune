// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/config.dart";

/// Cloudflare npm依存の版指定（通知依存 `^3.1.4` など）の回帰テスト。
///
/// 版指定なしの `npm install <name>` は `min-release-age` 等で `latest` が
/// 除外されると古い版へ解決されるため、Katanaが要求版を渡すことを確認する。
Future<void> main() async {
  _testParseSpec();
  _testSatisfies();
  await _testMessagingPassesVersionedSpec();
  await _testMissingPackageInstallsVersionedSpec();
  await _testOutdatedDeclaredPackageIsReinstalled();
  await _testSatisfiedPackageIsNotReinstalled();
  await _testUnversionedDeclaredPackageIsNotReinstalled();
  await _testFailedInstallThrows();
  stdout.writeln("Cloudflare package version regression checks passed");
}

const _notification = "@mathrunet/masamune_cloudflare_notification";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void _testParseSpec() {
  final scoped = parseCloudflarePackageSpec("$_notification@^3.1.4");
  _check(scoped.name == _notification && scoped.range == "^3.1.4",
      "A scoped versioned spec must be split into name and range.");
  final plain = parseCloudflarePackageSpec(_notification);
  _check(plain.name == _notification && plain.range == null,
      "A scoped name without a version must not be treated as versioned.");
  final unscoped = parseCloudflarePackageSpec("hono@^4.0.0");
  _check(unscoped.name == "hono" && unscoped.range == "^4.0.0",
      "An unscoped versioned spec must be split into name and range.");
}

void _testSatisfies() {
  const cases = {
    ("3.1.4", "^3.1.4"): true,
    ("3.2.0", "^3.1.4"): true,
    ("3.1.3", "^3.1.4"): false,
    ("3.1.0", "^3.1.4"): false,
    ("4.0.0", "^3.1.4"): false,
    ("3.1.5-beta.1", "^3.1.4"): false,
    ("0.2.5", "^0.2.3"): true,
    ("0.3.0", "^0.2.3"): false,
    ("0.0.3", "^0.0.3"): true,
    ("0.0.4", "^0.0.3"): false,
    ("3.1.4", "3.1.4"): true,
    ("3.1.5", "3.1.4"): false,
  };
  for (final entry in cases.entries) {
    final (version, range) = entry.key;
    _check(cloudflarePackageVersionSatisfies(version, range) == entry.value,
        "$version must ${entry.value ? "" : "not "}satisfy $range.");
  }
}

Future<void> _testMessagingPassesVersionedSpec() async {
  _check(Config.cloudflareNotificationVersion == "^3.1.4",
      "The notification package must require the approved ^3.1.4 range.");
  final source =
      await File("lib/action/firebase/messaging.dart").readAsString();
  final start = source.indexOf("await installMissingCloudflarePackages(");
  _check(start >= 0, "The messaging action must install Cloudflare packages.");
  final call = source.substring(start, source.indexOf(");", start));
  _check(
    call.contains(
        "\"$_notification@\${Config.cloudflareNotificationVersion}\""),
    "The messaging action must pass the versioned notification spec.",
  );
  _check(!call.contains("\"$_notification\","),
      "The messaging action must not pass an unversioned notification spec.");
}

/// Creates a temporary project with `cloudflare/package.json`, a lock file and
/// a fake npm that records its arguments. When [installVersion] is set, the
/// fake npm locks the notification package at that version; otherwise it fails
/// without changing the lock, like an `ETARGET` from `min-release-age`.
Future<void> _inProject({
  required Map<String, String> dependencies,
  required Map<String, String> locked,
  required String? installVersion,
  required Future<void> Function(String npm, File argsLog) body,
}) async {
  String lock(Map<String, String> versions) => jsonEncode({
        "lockfileVersion": 3,
        "packages": {
          "": {"dependencies": dependencies},
          for (final entry in versions.entries)
            "node_modules/${entry.key}": {"version": entry.value},
        },
      });
  final previous = Directory.current;
  final temp =
      await Directory.systemTemp.createTemp("katana_cf_package_version_");
  try {
    Directory.current = temp;
    Directory("cloudflare").createSync();
    File("cloudflare/package.json").writeAsStringSync(jsonEncode({
      "name": "test",
      "dependencies": dependencies,
    }));
    File("cloudflare/package-lock.json").writeAsStringSync(lock(locked));
    final argsLog = File("${temp.path}/npm_args.txt");
    final lockAfter = File("${temp.path}/lock_after.json");
    if (installVersion != null) {
      lockAfter.writeAsStringSync(
        lock({...locked, _notification: installVersion}),
      );
    }
    final npm = File("${temp.path}/fake_npm.sh");
    final install = installVersion == null
        ? "exit 1"
        : "cp \"${lockAfter.path}\" package-lock.json";
    npm.writeAsStringSync("#!/bin/sh\n"
        "echo \"\$@\" >> \"${argsLog.path}\"\n"
        "$install\n");
    await Process.run("chmod", ["+x", npm.path]);
    await body(npm.path, argsLog);
  } finally {
    Directory.current = previous;
    await temp.delete(recursive: true);
  }
}

Future<void> _testMissingPackageInstallsVersionedSpec() async {
  await _inProject(
    dependencies: {"@mathrunet/masamune_cloudflare": "^3.6.0"},
    locked: {"@mathrunet/masamune_cloudflare": "3.6.0"},
    installVersion: "3.1.4",
    body: (npm, argsLog) async {
      await installMissingCloudflarePackages(
        npm: npm,
        packages: ["$_notification@${Config.cloudflareNotificationVersion}"],
      );
      final args = argsLog.readAsStringSync().trim();
      _check(args == "install $_notification@^3.1.4",
          "A missing package must be installed with its range, got: $args");
    },
  );
}

Future<void> _testOutdatedDeclaredPackageIsReinstalled() async {
  await _inProject(
    dependencies: {
      "@mathrunet/masamune_cloudflare": "^3.6.0",
      _notification: "^3.1.0",
    },
    locked: {
      "@mathrunet/masamune_cloudflare": "3.6.0",
      _notification: "3.1.0",
    },
    installVersion: "3.1.4",
    body: (npm, argsLog) async {
      await installMissingCloudflarePackages(
        npm: npm,
        packages: [
          "$_notification@${Config.cloudflareNotificationVersion}",
          "@mathrunet/masamune_cloudflare",
        ],
      );
      final args = argsLog.readAsStringSync().trim();
      _check(
        args == "install $_notification@^3.1.4",
        "Only the outdated versioned package must be reinstalled, got: $args",
      );
    },
  );
}

Future<void> _testSatisfiedPackageIsNotReinstalled() async {
  await _inProject(
    dependencies: {_notification: "^3.1.4"},
    locked: {_notification: "3.1.4"},
    installVersion: "3.1.4",
    body: (npm, argsLog) async {
      await installMissingCloudflarePackages(
        npm: npm,
        packages: ["$_notification@${Config.cloudflareNotificationVersion}"],
      );
      _check(!argsLog.existsSync(),
          "A package satisfying its range must not be reinstalled.");
    },
  );
}

Future<void> _testUnversionedDeclaredPackageIsNotReinstalled() async {
  await _inProject(
    dependencies: {"@mathrunet/masamune_cloudflare": "^3.6.0"},
    locked: {"@mathrunet/masamune_cloudflare": "3.6.0"},
    installVersion: "3.1.4",
    body: (npm, argsLog) async {
      await installMissingCloudflarePackages(
        npm: npm,
        packages: const ["@mathrunet/masamune_cloudflare"],
      );
      _check(!argsLog.existsSync(),
          "An unversioned declared package must keep its existing version.");
    },
  );
}

Future<void> _testFailedInstallThrows() async {
  await _inProject(
    dependencies: const {},
    locked: const {},
    installVersion: null,
    body: (npm, argsLog) async {
      Object? error;
      try {
        await installMissingCloudflarePackages(
          npm: npm,
          packages: ["$_notification@${Config.cloudflareNotificationVersion}"],
        );
      } on StateError catch (e) {
        error = e;
      }
      _check(error != null,
          "An install that cannot satisfy the range must fail explicitly.");
    },
  );
}
