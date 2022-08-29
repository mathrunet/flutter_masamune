part of masamune_cli;

class AppBuildAabCliCommand extends CliCommand {
  const AppBuildAabCliCommand();

  @override
  String get description => "masamune.yamlで指定したbuildの情報をAndroid用のAABビルドを行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final build = yaml["build"] as YamlMap;
    final bin = yaml["bin"] as YamlMap;
    final flutter = bin["flutter"] as String?;
    final generateProcess = await Process.start(
      flutter!,
      [
        "build",
        "aab",
        "--dart-define=FLAVOR=prod",
        "--release",
      ],
      runInShell: true,
    );
    await generateProcess.print();
  }
}
