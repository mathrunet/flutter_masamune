part of katana_cli;

/// Start Dart's build_runner to automatically generate code.
///
/// Dartのbuild_runnerを起動してコードを自動生成します。
class GenerateCliCommand extends CliCommand {
  /// Start Dart's build_runner to automatically generate code.
  ///
  /// Dartのbuild_runnerを起動してコードを自動生成します。
  const GenerateCliCommand();

  @override
  String get description =>
      "Start Dart's build_runner to automatically generate code. Dartのbuild_runnerを起動してコードを自動生成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final melos = bin.get("melos", "melos");
    if (File("melos.yaml").existsSync()) {
      await Process.start(
        melos,
        [
          "exec",
          "--",
          "$flutter packages pub run build_runner clean",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      ).print();
      await Process.start(
        melos,
        [
          "exec",
          "--",
          "$flutter packages pub run build_runner build --delete-conflicting-outputs",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      ).print();
    } else {
      await Process.start(
        flutter,
        [
          "packages",
          "pub",
          "run",
          "build_runner",
          "clean",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      ).print();
      await Process.start(
        flutter,
        [
          "packages",
          "pub",
          "run",
          "build_runner",
          "build",
          "--delete-conflicting-outputs",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      ).print();
    }
  }
}
