part of katana_cli.code;

/// Start Dart's build_runner to monitor the code and automatically generate code in real time.
///
/// Dartのbuild_runnerを起動してコードを監視しリアルタイムでコードを自動生成します。
class CodeWatchCliCommand extends CliCommand {
  /// Start Dart's build_runner to monitor the code and automatically generate code in real time.
  ///
  /// Dartのbuild_runnerを起動してコードを監視しリアルタイムでコードを自動生成します。
  const CodeWatchCliCommand();

  @override
  String get description =>
      "Start Dart's build_runner to monitor the code and automatically generate code in real time. Dartのbuild_runnerを起動してコードを監視しリアルタイムでコードを自動生成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final melos = bin.get("melos", "melos");
    if (File("melos.yaml").existsSync()) {
      await command(
        "Watch build_runner for all packages to generate code.",
        [
          melos,
          "exec",
          "--",
          "$flutter packages pub run build_runner watch --delete-conflicting-outputs",
        ],
      );
    } else {
      await command(
        "Watch the project's build_runner to generate code.",
        [
          flutter,
          "packages",
          "pub",
          "run",
          "build_runner",
          "watch",
          "--delete-conflicting-outputs",
        ],
      );
    }
  }
}
