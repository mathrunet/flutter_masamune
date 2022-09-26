part of masamune_cli;

class FunctionsDeployCliCommand extends CliCommand {
  const FunctionsDeployCliCommand();

  @override
  String get description => "FirebaseFunctionsのデプロイを行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final command = bin.get("firebase", "firebase");
    applyFunctionsTemplate();
    final resultDeploy = await Process.start(
      command,
      [
        "deploy",
        "--only",
        "functions",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    await resultDeploy.print();
  }
}
