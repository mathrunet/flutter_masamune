part of masamune_cli;

class InstallCliCommand extends CliCommand {
  const InstallCliCommand();

  @override
  String get description => "必要なコマンドをインストールします。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final curl = bin["curl"] as String?;
    final dart = bin["dart"] as String?;
    final process = await Process.start(
      curl!,
      [
        "-sL",
        "https://firebase.tools",
        "|",
        "bash",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await process.print();
    final processFlutterFire = await Process.start(
      dart!,
      [
        "pub",
        "global",
        "activate",
        "flutterfire_cli",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await processFlutterFire.print();
  }
}
