part of "code.dart";

/// Start Dart's build_runner to automatically generate code.
///
/// Dartのbuild_runnerを起動してコードを自動生成します。
class CodeGenerateCliCommand extends CliCommand {
  /// Start Dart's build_runner to automatically generate code.
  ///
  /// Dartのbuild_runnerを起動してコードを自動生成します。
  const CodeGenerateCliCommand();

  @override
  String get description =>
      "Start Dart's build_runner to automatically generate code. Dartのbuild_runnerを起動してコードを自動生成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final melos = bin.get("melos", "melos");
    final isClean = context.args.get(2, "");
    if (File("melos.yaml").existsSync()) {
      if (isClean.isNotEmpty) {
        await command(
          "Delete the cache before running code generation.",
          [
            melos,
            "exec",
            "--",
            "$flutter packages pub run build_runner clean",
          ],
        );
      }
      await command(
        "Run build_runner for all packages to generate code.",
        [
          melos,
          "exec",
          "--",
          "$flutter packages pub run build_runner build --delete-conflicting-outputs",
        ],
      );
    } else {
      if (isClean.isNotEmpty) {
        await command(
          "Delete the cache before running code generation.",
          [
            flutter,
            "packages",
            "pub",
            "run",
            "build_runner",
            "clean",
          ],
        );
      }
      await command(
        "Run the project's build_runner to generate code.",
        [
          flutter,
          "packages",
          "pub",
          "run",
          "build_runner",
          "build",
          "--delete-conflicting-outputs",
        ],
      );
    }
  }
}
