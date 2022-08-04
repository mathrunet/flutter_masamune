part of masamune_cli;

class InitCliCommand extends CliCommand {
  const InitCliCommand();

  @override
  String get description => "アプリ制作のための初期設定を行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final file = File("pubspec_overrides.yaml.template");
    if (file.existsSync()) {
      file.copySync("pubspec_overrides.yaml");
    }
  }
}
