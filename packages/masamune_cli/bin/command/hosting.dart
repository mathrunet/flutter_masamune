part of masamune_cli;

class HostingCliCommand extends CliCommand {
  const HostingCliCommand();

  @override
  String get description =>
      "Firebaseホスティングのデプロイを行います。Firebaseでの登録とHostingの初期設定が必要です。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final firebase = bin["firebase"] as String?;
    final process = await Process.run(
      firebase!,
      [
        "deploy",
        "--only",
        "hosting",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    print(process.stdout);
  }
}
