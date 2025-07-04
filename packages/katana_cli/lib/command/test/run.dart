part of "test.dart";

/// This command will run the golden test images.
///
/// ゴールデンテストを実行します。
class TestRunCliCommand extends CliCommand {
  /// This command will run the golden test images.
  ///
  /// ゴールデンテストを実行します。
  const TestRunCliCommand();

  @override
  String get description => "Run the golden test images. ゴールデンテストを実行します。";

  @override
  String? get example => "katana test run";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final target = context.args.get(2, "");
    final isLinux = Platform.isLinux;
    final flutterVersion = await getFlutterVersion();
    if (isLinux) {
      await command(
        "Run the golden test images.",
        [
          flutter,
          "test",
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
      await TestDockerfileCliCode(flutterVersion: flutterVersion)
          .generateFile("Dockerfile");
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
        "Run flutter pub get.",
        [
          flutter,
          "pub",
          "get",
        ],
      );
      await command(
        "Run the golden test images.",
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
          "sh",
          "-c",
          "flutter pub get && flutter test --dart-define=CI=true --dart-define=FLAVOR=dev ${target.isNotEmpty ? '--plain-name $target' : ''}",
        ],
        workingDirectory: "docker",
      );
    }
  }
}
