part of "store.dart";

/// Create assets for the store.
///
/// ストア向けのアセットを作成します。
class StoreAssetCliCommand extends CliCommand {
  /// Create assets for the store.
  ///
  /// ストア向けのアセットを作成します。
  const StoreAssetCliCommand();

  @override
  String get description => "Create assets for the store. ストア向けのアセットを作成します。";

  @override
  String? get example => "katana store asset";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final katanaAsset = bin.get("katanaasset", "katanaasset");
    final storeYamlFile = File("${Directory.current.path}/store.yaml");
    if (storeYamlFile.existsSync()) {
      await const StoreYamlCliCode().generateFile("store.yaml");
    }
    await command(
      "Create assets for the store.",
      [
        katanaAsset,
      ],
    );
  }
}
