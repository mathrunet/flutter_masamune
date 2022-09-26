part of masamune_cli;

class InstallCliCommand extends CliCommand {
  const InstallCliCommand();

  @override
  String get description => "必要なコマンドをインストールします。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final curl = bin.get("curl", "curl");
    final dart = bin.get("dart", "dart");
    final process = await Process.start(
      curl,
      [
        "-sL",
        "https://firebase.tools",
      ],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    final processPipe = await Process.start(
      "bash",
      [],
      runInShell: true,
      workingDirectory: Directory.current.path,
    );
    await process.stdout.pipe(processPipe.stdin);
    await processPipe.print();
    final processFlutterFire = await Process.start(
      dart,
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
