part of masamune_cli;

class GenerateCliCommand extends CliCommand {
  const GenerateCliCommand();

  @override
  String get description => "Dartのbuild_runnerを起動してコードを自動生成します。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final flutter = bin["flutter"] as String?;
    final melos = bin["melos"] as String?;
    if (File("melos.yaml").existsSync()) {
      final process = await Process.start(
        melos!,
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
      final process = await Process.start(
        flutter!,
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
