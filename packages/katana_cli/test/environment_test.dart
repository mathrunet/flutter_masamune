import "dart:io";
import "package:katana_cli/command/apply.dart";
import "package:katana_cli/katana_cli.dart";

const _environment = {
  "TOKEN": "secret-token",
  "HOST": "api.example.com",
  "EMPTY": "",
};

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

Future<void> main() async {
  await _scopedLocalApply();
  await _nativeTargetApply();
  final yaml = loadKatanaYaml(
    r"""
whole: ${TOKEN}
partial: https://${HOST}/v1
fallback: ${UNDEFINED:-default}
empty_fallback: ${EMPTY:-default}
defined_fallback: ${TOKEN:-default}
escaped: $${TOKEN}
plain: $TOKEN
number: 10
flag: true
nested:
  list:
    - ${TOKEN}
    - value: ${HOST}
${TOKEN}: key
""",
    environment: _environment,
  ) as Map;
  _check(yaml["whole"] == "secret-token", "whole value");
  _check(yaml["partial"] == "https://api.example.com/v1", "partial value");
  _check(yaml["fallback"] == "default", "default for undefined");
  _check(yaml["empty_fallback"] == "default", "default for empty");
  _check(yaml["defined_fallback"] == "secret-token", "defined over default");
  _check(yaml["escaped"] == r"${TOKEN}", "escape");
  _check(yaml["plain"] == r"$TOKEN", "braces required");
  _check(yaml["number"] == 10, "number kept");
  _check(yaml["flag"] == true, "bool kept");
  final list = (yaml["nested"] as Map)["list"] as List;
  _check(list[0] == "secret-token", "list value");
  _check((list[1] as Map)["value"] == "api.example.com", "nested map value");
  _check(yaml[r"${TOKEN}"] == "key", "keys are not expanded");
  yaml["added"] = "modifiable";

  final raw = {"value": r"${TOKEN}"};
  expandEnvironmentVariables(raw, environment: _environment);
  _check(raw["value"] == r"${TOKEN}", "input is not mutated");

  try {
    expandEnvironmentVariables(
      {"a": r"${MISSING_A}", "b": r"${MISSING_B}", "c": r"${TOKEN}"},
      environment: _environment,
      source: "katana_secrets.yaml",
    );
    throw StateError("undefined variables must throw");
  } on KatanaEnvironmentVariableException catch (e) {
    final message = e.toString();
    _check(
      e.names.length == 2 &&
          e.names.contains("MISSING_A") &&
          e.names.contains("MISSING_B"),
      "all undefined names are reported",
    );
    _check(message.contains("katana_secrets.yaml"), "source is reported");
    _check(!message.contains("secret-token"), "values are not reported");
  }

  // ignore: avoid_print
  print("environment_test: OK");
}

Future<void> _scopedLocalApply() async {
  final previous = Directory.current;
  final fixture = Directory.systemTemp.createTempSync("katana-scoped-apply-");
  try {
    Directory.current = fixture;
    var failedAtFirebase = false;
    try {
      await const ApplyCliCommand().exec(ExecContext(
        yaml: {
          "cloudflare": {
            "workers": {"enable": true}
          },
          "firebase": {
            "project_id": "fixture-project",
            "authentication": {"enable": true}
          },
        },
        args: ["--local", "--only", "firebaseinit"],
      ));
    } on StateError catch (error) {
      failedAtFirebase = error.toString().contains("Firebase") &&
          !error.toString().contains("cloudflare/wrangler");
    }
    _check(failedAtFirebase,
        "Firebase-only local apply must validate Firebase, not unrelated Cloudflare settings.");
    _check(!Directory("cloudflare").existsSync(),
        "Scoped local validation must not initialize Cloudflare.");
  } finally {
    Directory.current = previous;
    fixture.deleteSync(recursive: true);
  }
}

Future<void> _nativeTargetApply() async {
  final previous = Directory.current;
  final executable = File("bin/katana.dart").absolute.path;
  final packages = File(".dart_tool/package_config.json").absolute.path;
  final fixture = Directory.systemTemp.createTempSync("katana-native-target-");
  try {
    Directory.current = fixture;
    Directory("lib").createSync();
    File("lib/main_play.dart").writeAsStringSync("void main() {}\n");
    File("lib/main_staff.dart").writeAsStringSync("void main() {}\n");
    File("katana.yaml").writeAsStringSync("app: {}\n");
    Directory("ios/Flutter").createSync(recursive: true);
    for (final mode in ["Debug", "Release"]) {
      File("ios/Flutter/$mode.xcconfig")
          .writeAsStringSync("#include \"Generated.xcconfig\"\n");
    }
    Directory("ios/Runner.xcodeproj").createSync();
    final project = File("ios/Runner.xcodeproj/project.pbxproj");
    project.writeAsStringSync(r"""
/* Begin XCBuildConfiguration section */
ABC /* Debug */ = {
  isa = XCBuildConfiguration;
  buildSettings = {
    INFOPLIST_FILE = Runner/Info.plist;
    PRODUCT_BUNDLE_IDENTIFIER = com.example.original;
    CUSTOM_SETTING = keep;
  };
  name = Debug;
};
DEF /* Debug */ = {
  isa = XCBuildConfiguration;
  buildSettings = {
    INFOPLIST_FILE = RunnerTests/Info.plist;
    PRODUCT_BUNDLE_IDENTIFIER = com.example.original.RunnerTests;
  };
  name = Debug;
};
/* End XCBuildConfiguration section */
""");
    final podfile = File("ios/Podfile");
    podfile.writeAsStringSync(
        "# platform :ios, '15.0'\ntarget 'Runner' do\nend\n");
    final originalPodfile = podfile.readAsStringSync();
    Directory("android/app").createSync(recursive: true);
    final gradle = File("android/app/build.gradle.kts");
    gradle.writeAsStringSync(
        'android {\n defaultConfig { applicationId = "com.example.original" }\n}\n');
    final yaml = {
      "cloudflare": {
        "workers": {"enable": true}
      },
      "app": {
        "targets": {
          "play": <String, Object>{
            "entrypoint": "lib/main_play.dart",
            "application_id": "com.example.play",
            "ios_minimum_version": "15.5"
          },
          "staff": {
            "entrypoint": "lib/main_staff.dart",
            "application_id": "com.example.staff"
          },
        }
      },
    };
    Future<void> apply(String target) =>
        const ApplyCliCommand().exec(ExecContext(
          yaml: yaml,
          args: ["--local", "--only", "nativetarget", "--target", target],
        ));
    await apply("play");
    final play = project.readAsStringSync();
    _check(
        play.contains("KATANA_APPLICATION_ID") &&
            play.contains("CUSTOM_SETTING = keep;"),
        "Native target must preserve custom settings.");
    _check(
        play.contains(
            "PRODUCT_BUNDLE_IDENTIFIER = com.example.original.RunnerTests;"),
        "RunnerTests must not be changed.");
    final config = File("ios/Flutter/KatanaTarget.xcconfig");
    _check(config.readAsStringSync().contains("com.example.play"),
        "Play ID must be selected.");
    _check(
        config.readAsStringSync().contains("IPHONEOS_DEPLOYMENT_TARGET = 15.5"),
        "Play must use its explicitly configured minimum iOS version.");
    _check(podfile.readAsStringSync().contains("platform :ios, '15.5'"),
        "CocoaPods must use the selected target minimum.");
    await apply("play");
    _check(project.readAsStringSync() == play,
        "Minimum iOS generation must preserve project-level and test settings.");
    await apply("staff");
    _check(!config.readAsStringSync().contains("IPHONEOS_DEPLOYMENT_TARGET"),
        "An undeclared staff minimum must inherit its original value.");
    _check(podfile.readAsStringSync() == originalPodfile,
        "Switching targets must remove the previous target CocoaPods override.");
    _check(
        config.readAsStringSync().contains("com.example.staff") &&
            !config.readAsStringSync().contains("com.example.play"),
        "Target switching must replace the selected ID.");
    _check(
        gradle
            .readAsStringSync()
            .contains('katanaAndroidApplicationId ?: "com.example.staff"'),
        "Android must select the same native target.");
    _check(gradle.readAsStringSync().contains('setOf("test", "dev", "prod")'),
        "Runtime test builds must be supported.");
    final once = config.readAsStringSync();
    await apply("staff");
    _check(
        config.readAsStringSync() == once && project.readAsStringSync() == play,
        "Native target application must be idempotent.");
    // Exercise the public CLI parser, not only ApplyCliCommand directly.
    File("katana.yaml").writeAsStringSync("""
app:
  targets:
    staff:
      entrypoint: lib/main_staff.dart
      application_id: com.example.staff
""");
    for (final selection in [
      ["--target", "staff"],
      ["--target=staff"],
    ]) {
      final result = await Process.run(Platform.resolvedExecutable, [
        "--packages=$packages",
        executable,
        "apply",
        "--local",
        "--only",
        "nativetarget",
        ...selection,
      ]);
      _check(result.exitCode == 0,
          "Public target selection must succeed: ${result.stderr}");
    }
    for (final selection in [
      ["--target"],
      ["--target="],
      ["--target", "staff", "--target=staff"],
      ["--target=../staff"],
    ]) {
      final result = await Process.run(Platform.resolvedExecutable, [
        "--packages=$packages",
        executable,
        "apply",
        "--local",
        "--only",
        "nativetarget",
        ...selection,
      ]);
      _check(result.exitCode != 0, "Malformed target selection must fail.");
      _check(config.readAsStringSync() == once,
          "Rejected CLI arguments must not mutate native configuration.");
    }
    for (final invalid in ["15.5; injected", "15", "../15.5", 15.5]) {
      final target = ((yaml["app"] as Map)["targets"] as Map)["play"] as Map;
      target["ios_minimum_version"] = invalid;
      var rejectedVersion = false;
      try {
        await apply("play");
      } on FormatException {
        rejectedVersion = true;
      }
      _check(rejectedVersion, "Malformed or non-string iOS minimum must fail.");
      _check(
          config.readAsStringSync() == once &&
              podfile.readAsStringSync() == originalPodfile,
          "Invalid iOS minimum must fail before any native writes.");
    }
    var rejected = false;
    try {
      await apply("../play");
    } on FormatException {
      rejected = true;
    }
    _check(rejected, "Invalid targets must be rejected.");
    _check(config.readAsStringSync() == once,
        "Rejected selection must not modify native settings.");
  } finally {
    Directory.current = previous;
    fixture.deleteSync(recursive: true);
  }
}
