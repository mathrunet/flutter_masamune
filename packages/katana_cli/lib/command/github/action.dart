part of katana_cli.github;

/// Output yaml for Github Actions.
///
/// Github Actions用のyamlを出力します。
class GithubActionCliCommand extends CliCommand {
  /// Output yaml for Github Actions.
  ///
  /// Github Actions用のyamlを出力します。
  const GithubActionCliCommand();

  @override
  String get description =>
      "Output yaml for Github Actions. Pass the platform you want to support as a parameter, like `katana github action android ios web`. Available platforms are `android`, `ios`, `web`, `windows`, `macos`, and `linux`. Github Actions用のyamlを出力します。`katana github action android ios web`のように対応したいプラットフォームをパラメーターとして渡してください。使用できるプラットフォームは`android`、`ios`、`web`、`windows`、`macos`、`linux`です。";

  @override
  Future<void> exec(ExecContext context) async {
    final platforms = context.args.sublist(2);
    if (platforms.isEmpty) {
      print(
        "Platform is not specified. Please pass the platform you want to support as a parameter, like `katana github action android ios web`. Supported platforms are `android`, `ios`, `web`, `windows`, `macos`, and `linux`.",
      );
      return;
    }
    final bin = context.yaml.getAsMap("bin");
    final gh = bin.get("gh", "gh");
    for (final platform in platforms) {
      label("Create build.yaml for $platform");
      switch (platform) {
        case "android":
          await buildAndroid(context, gh: gh);
          break;
        case "ios":
          await buildIOS(context, gh: gh);
          break;
        case "web":
          await buildWeb(context, gh: gh);
          break;
      }
    }
  }
}
