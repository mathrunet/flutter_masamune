part of "pub.dart";


/// Deploy the Dart package to the pub.
///
/// Dartパッケージのpubへのデプロイを行います。
class PubPublishCliCommand extends CliCommand {
  /// Deploy the Dart package to the pub.
  ///
  /// Dartパッケージのpubへのデプロイを行います。
  const PubPublishCliCommand();

  @override
  String get description =>
      "Deploy the Dart package to the pub. Dartパッケージのpubへのデプロイを行います。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final melos = bin.get("melos", "melos");
    if (!File("melos.yaml").existsSync()) {
      error("The melos.yaml file does not exist.\r\nmelos.yamlのファイルが存在しません。");
      return;
    }
    await command(
      "Deploy all Dart packages to pub.",
      [
        melos,
        "publish",
        "--no-dry-run",
        "-y",
      ],
    );
  }
}
