part of masamune_cli;

class GenerateCliCommand extends CliCommand {
  const GenerateCliCommand();

  @override
  String get description => "Dartのbuild_runnerを起動してコードを自動生成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final melos = bin.get("melos", "melos");
    if (File("melos.yaml").existsSync()) {
      final clean = await Process.start(
        melos,
        [
          "exec",
          "--",
          "$flutter packages pub run build_runner clean",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      );
      await clean.print();
      final process = await Process.start(
        melos,
        [
          "exec",
          "--",
          "$flutter packages pub run build_runner build --delete-conflicting-outputs",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      );
      await process.print();
    } else {
      final clean = await Process.start(
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
      );
      await clean.print();
      final process = await Process.start(
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
      );
      await process.print();
    }
  }
}
