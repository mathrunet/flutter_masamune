part of masamune_cli;

class AppBuildIOSCliCommand extends CliCommand {
  const AppBuildIOSCliCommand();

  @override
  String get description =>
      "masamune.yamlで指定したbuildの情報をIOS用のビルドを行います。TestFlightの配信まで行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final build = yaml["build"] as YamlMap;
    final ios = build["ios"] as YamlMap;
    final teamId = ios["team_id"] as String?;
    final bin = yaml["bin"] as YamlMap;
    final flutter = bin["flutter"] as String?;
    if (teamId.isEmpty) {
      print("Build IOS information is missing.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("<!-- TODO_REPLACE_APPLE_TEAM_ID -->", teamId!);
      File(file.path).writeAsStringSync(text);
    });
    final generateProcess = await Process.start(
      flutter!,
      [
        "build",
        "ipa",
        "--dart-define=FLAVOR=prod",
        "--release",
        "--export-options-plist=ios/Runner/ExportOptions.plist"
      ],
      runInShell: true,
    );
    await generateProcess.print();
  }
}
