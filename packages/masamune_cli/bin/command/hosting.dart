part of masamune_cli;

class HostingCliCommand extends CliCommand {
  const HostingCliCommand();

  @override
  String get description =>
      "Firebaseホスティングのデプロイを行います。Firebaseでの登録とHostingの初期設定が必要です。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final firebase = bin.get("firebase", "firebase");
    final process = await Process.start(
      firebase,
      [
        "deploy",
        "--only",
        "hosting",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    await process.print();
  }
}
