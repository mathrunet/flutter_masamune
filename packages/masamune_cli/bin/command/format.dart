part of masamune_cli;

class FormatCliCommand extends CliCommand {
  const FormatCliCommand();

  @override
  String get description => "Dartファイルのフォーマッティングを行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final dart = bin["dart"] as String?;
    final melos = bin["melos"] as String?;
    if (File("melos.yaml").existsSync()) {
      final process = await Process.start(
        melos!,
        [
          "exec",
          "--",
          "$dart format .",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      );
      await process.print();
      final file = File("README.md");
      final packages = Directory("packages");
      packages.listSync().where((e) => !e.path.startsWith(".")).forEach((e) {
        file.copySync("${e.path}/README.md");
        print("## Copy README.md to ${e.path}");
      });
    } else {
      final process = await Process.start(
        dart!,
        [
          "format",
          ".",
        ],
        runInShell: true,
        workingDirectory: Directory.current.path,
      );
      await process.print();
    }
  }
}
