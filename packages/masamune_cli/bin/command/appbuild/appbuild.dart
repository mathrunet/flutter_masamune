part of masamune_cli;

class AppBuildCliCommand extends CliCommandGroup {
  const AppBuildCliCommand();

  @override
  String get groupDescription => "Buildの設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "aab": AppBuildAabCliCommand(),
        "apk": AppBuildApkCliCommand(),
        "ios": AppBuildIOSCliCommand(),
      };
}
