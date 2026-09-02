// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Diagnoses and optionally migrates legacy Katana environment configuration.
class FixCliCommand extends CliCommand {
  /// Diagnoses and optionally migrates legacy Katana environment configuration.
  const FixCliCommand();

  @override
  String get description =>
      "Diagnose or migrate legacy Katana environment configuration. "
      "旧Katana環境設定を診断・移行します。";

  @override
  String? get example => "katana fix --apply";

  @override
  Future<void> exec(ExecContext context) async {
    final apply = context.args.contains("--apply");
    if (apply && context.args.contains("--dry-run")) {
      throw ArgumentError("--apply and --dry-run cannot be used together.");
    }
    final plan = KatanaEnvironmentFixPlan.inspect();
    // ignore: avoid_print
    print(plan.describe());
    if (!apply) {
      // ignore: avoid_print
      print("Diagnostic only. Run `katana fix --apply` to migrate.");
      return;
    }
    await plan.apply(
      flavor: context.flavorContext?.flavor.name ?? "prod",
      firebaseProjectId:
          context.yaml.getAsMap("firebase").get("project_id", ""),
    );
    // ignore: avoid_print
    print("Katana environment migration completed.");
  }
}

/// A deterministic, idempotent migration plan for one Flutter project.
class KatanaEnvironmentFixPlan {
  KatanaEnvironmentFixPlan._({required this.operations});

  /// Planned operations.
  final List<String> operations;

  /// Inspects the current directory without changing it.
  factory KatanaEnvironmentFixPlan.inspect() {
    final operations = <String>[];
    for (final flavor in ["dev", "prod"]) {
      final file = File("dart_defines/$flavor.env");
      if (!file.existsSync() ||
          !_isCurrentDefine(file.readAsStringSync(), flavor)) {
        operations.add("normalize ${file.path}");
      }
    }
    final gradle = _androidGradleFile();
    if (gradle != null &&
        !gradle.readAsStringSync().contains(
              AndroidNativeEnvironmentSynchronizer.beginMarker,
            )) {
      operations.add("configure ${gradle.path}");
    }
    for (final path in _appleProjectPaths) {
      final file = File(path);
      if (file.existsSync() &&
          !file.readAsStringSync().contains(
                AppleFirebaseEnvironmentSynchronizer.buildPhaseName,
              )) {
        operations.add("configure $path");
      }
    }
    for (final legacy in [
      "android/env.properties",
      "ios/Flutter/DartDefine.xcconfig",
    ]) {
      if (File(legacy).existsSync()) {
        operations.add("retire legacy $legacy");
      }
    }
    for (final legacy in _legacyFirebaseFiles.keys) {
      if (File(legacy).existsSync()) {
        operations.add("inspect legacy Firebase file $legacy");
      }
    }
    return KatanaEnvironmentFixPlan._(operations: operations);
  }

  /// Human-readable diagnostic output.
  String describe() => operations.isEmpty
      ? "No Katana environment migration is required."
      : operations.map((operation) => "- $operation").join("\n");

  /// Applies the inspected migration idempotently.
  Future<void> apply({String? flavor, String? firebaseProjectId}) async {
    final definesDirectory = Directory("dart_defines");
    if (!definesDirectory.existsSync()) {
      await definesDirectory.create(recursive: true);
    }
    for (final flavor in ["dev", "prod"]) {
      final file = File("dart_defines/$flavor.env");
      final current = file.existsSync() ? await file.readAsString() : "";
      await file.writeAsString(_normalizeDefine(current, flavor));
    }
    final gradle = _androidGradleFile();
    if (gradle != null) {
      var source = await gradle.readAsString();
      if (!source.contains(AndroidNativeEnvironmentSynchronizer.beginMarker)) {
        source = _restoreLegacyApplicationId(source);
        source = AndroidNativeEnvironmentSynchronizer.synchronize(
          source,
          isKotlin: gradle.path.endsWith(".kts"),
        );
        await gradle.writeAsString(source);
      }
    }
    for (final path in _appleProjectPaths) {
      final file = File(path);
      if (!file.existsSync()) {
        continue;
      }
      await file.writeAsString(
        AppleFirebaseEnvironmentSynchronizer.synchronizeProject(
          await file.readAsString(),
        ),
      );
    }
    for (final path in [
      "ios/Flutter/Debug.xcconfig",
      "ios/Flutter/Release.xcconfig",
    ]) {
      final file = File(path);
      if (!file.existsSync()) {
        continue;
      }
      final lines = await file.readAsLines();
      await file.writeAsString(
        lines.where((line) => !line.contains("DartDefine.xcconfig")).join("\n"),
      );
    }
    for (final path in [
      "android/env.properties",
      "ios/Flutter/DartDefine.xcconfig",
    ]) {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    if (flavor != null && (firebaseProjectId?.isNotEmpty ?? false)) {
      await _migrateLegacyFirebase(flavor, firebaseProjectId!);
    }
  }

  static Future<void> _migrateLegacyFirebase(
    String flavor,
    String projectId,
  ) async {
    for (final entry in _legacyFirebaseFiles.entries) {
      final source = File(entry.key);
      if (!source.existsSync()) {
        continue;
      }
      final contents = await source.readAsString();
      if (!_firebaseFileMatchesProject(contents, projectId)) {
        continue;
      }
      final destination = File(entry.value.replaceAll("{flavor}", flavor));
      if (destination.existsSync()) {
        continue;
      }
      await destination.parent.create(recursive: true);
      await source.rename(destination.path);
    }
  }

  static bool _firebaseFileMatchesProject(String source, String projectId) {
    final escaped = RegExp.escape(projectId);
    return RegExp("""["']project_id["']\\s*:\\s*["']$escaped["']""")
            .hasMatch(source) ||
        RegExp(
          """<key>PROJECT_ID</key>\\s*<string>$escaped</string>""",
        ).hasMatch(source) ||
        RegExp("""projectId:\\s*["']$escaped["']""").hasMatch(source);
  }

  static bool _isCurrentDefine(String source, String flavor) =>
      RegExp("^FLAVOR=${RegExp.escape(flavor)}\\s*\$", multiLine: true)
          .hasMatch(source) &&
      !RegExp(r"^flavor=", multiLine: true).hasMatch(source);

  static String _normalizeDefine(String source, String flavor) {
    final values = <String, String>{};
    for (final line in source.split("\n")) {
      final separator = line.indexOf("=");
      if (separator <= 0) {
        continue;
      }
      final key = line.substring(0, separator).trim();
      final value = line.substring(separator + 1).trim();
      if (key == "applicationId" && value.isNotEmpty) {
        values["ANDROID_APPLICATION_ID"] = value;
      } else if (key != "flavor" && key != "FLAVOR" && value.isNotEmpty) {
        values[key] = value;
      }
    }
    return [
      "FLAVOR=$flavor",
      ...values.entries.map((entry) => "${entry.key}=${entry.value}"),
      "",
    ].join("\n");
  }

  static String _restoreLegacyApplicationId(String source) {
    final legacy = File("android/env.properties");
    if (!legacy.existsSync()) {
      return source;
    }
    final applicationId = RegExp(r"^applicationId=(.+)$", multiLine: true)
        .firstMatch(legacy.readAsStringSync())
        ?.group(1)
        ?.trim();
    if (applicationId == null || applicationId.isEmpty) {
      return source;
    }
    return source.replaceFirst(
      RegExp(r"applicationId\s*(?:=\s*)?[^\n]+"),
      'applicationId = "$applicationId"',
    );
  }

  static File? _androidGradleFile() {
    for (final path in [
      "android/app/build.gradle.kts",
      "android/app/build.gradle",
    ]) {
      final file = File(path);
      if (file.existsSync()) {
        return file;
      }
    }
    return null;
  }
}

const _appleProjectPaths = [
  "ios/Runner.xcodeproj/project.pbxproj",
  "macos/Runner.xcodeproj/project.pbxproj",
];

const _legacyFirebaseFiles = {
  "android/app/google-services.json":
      "android/app/src/katanaFirebase/{flavor}/google-services.json",
  "ios/Runner/GoogleService-Info.plist":
      "ios/Runner/Firebase/{flavor}/GoogleService-Info.plist",
  "macos/Runner/GoogleService-Info.plist":
      "macos/Runner/Firebase/{flavor}/GoogleService-Info.plist",
  "lib/firebase_options.dart":
      "lib/katana/firebase/{flavor}/firebase_options.dart",
};
