part of katana_cli.pub;

/// Add packages.
///
/// パッケージの追加を行います。
class PubAddCliCommand extends CliCommand {
  /// Add packages.
  ///
  /// パッケージの追加を行います。
  const PubAddCliCommand();

  @override
  String get description => "Add packages. パッケージの追加を行います。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final packageName = context.args.get(2, "");
    if (packageName.isEmpty) {
      error("Please specify the package name. パッケージ名を指定してください。");
      return;
    }
    await command(
      "Add $packageName package.",
      [
        flutter,
        "pub",
        "add",
        packageName,
      ],
    );
  }
}
