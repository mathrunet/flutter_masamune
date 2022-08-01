part of masamune_cli;

class FunctionsDeployCliCommand extends CliCommand {
  const FunctionsDeployCliCommand();

  @override
  String get description => "FirebaseFunctionsのデプロイを行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final command = bin["firebase"] as String?;
    applyFunctionsTemplate();
    final resultDeploy = await Process.run(
      command!,
      [
        "deploy",
        "--only",
        "functions",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    print(resultDeploy.stdout);
  }
}
