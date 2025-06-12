part of "test.dart";

/// This command will update the golden test images.
///
/// ゴールデンテストの画像更新を行います。
class TestUpdateCliCommand extends CliCommand {
  /// This command will update the golden test images.
  ///
  /// ゴールデンテストの画像更新を行います。
  const TestUpdateCliCommand();

  @override
  String get description =>
      "Update the golden test images. ゴールデンテストの画像更新を行います。";

  @override
  String? get example => "katana test update";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final target = context.args.get(2, "");
    final isLinux = Platform.isLinux;
    if (isLinux) {
      await command(
        "Update the golden test images.",
        [
          flutter,
          "test",
          "--update-goldens",
          "--dart-define=CI=true",
          "--dart-define=FLAVOR=dev",
          if (target.isNotEmpty) ...[
            "--plain-name",
            target,
          ]
        ],
        catchError: true,
      );
    } else {
      final docker = bin.get("docker", "docker");
      await const TestDockerfileCliCode().generateFile("Dockerfile");
      final flutterVersionSource = await command(
        "Get Flutter version.",
        [
          flutter,
          "--version",
          "--machine",
        ],
        catchError: true,
      );
      final json = jsonDecodeAsMap(flutterVersionSource);
      final flutterVersion = json.get("frameworkVersion", "");
      label("Flutter version: $flutterVersion");
      await command(
        "Build the docker image.",
        [
          docker,
          "buildx",
          "build",
          "--platform",
          "linux/x86_64",
          "--build-arg",
          "FLUTTER_VERSION=$flutterVersion",
          "-t",
          "flutter_golden_test",
          ".",
        ],
        workingDirectory: "docker",
      );
      await command(
        "Create the docker volume.",
        [
          docker,
          "volume",
          "create",
          "flutter_golden_test_dart_tool",
        ],
        workingDirectory: "docker",
      );
      await command(
        "Update the golden test images.",
        [
          docker,
          "run",
          "--rm",
          "-v",
          "${Directory.current.path}:/app",
          "-v",
          "flutter_golden_test_dart_tool:/app/.dart_tool",
          "--platform",
          "linux/x86_64",
          "-w",
          "/app",
          "flutter_golden_test",
          flutter,
          "test",
          "--update-goldens",
          "--dart-define=CI=true",
          "--dart-define=FLAVOR=dev",
          if (target.isNotEmpty) ...[
            "--plain-name",
            target,
          ]
        ],
        workingDirectory: "docker",
      );
    }
  }
}
