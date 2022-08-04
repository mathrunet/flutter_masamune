part of masamune_cli;

class StoreIconCliCommand extends CliCommand {
  const StoreIconCliCommand();

  @override
  String get description => "ストア用のアイコン画像の作成を行います。";

  @override
  Future<void> exec(YamlMap yaml, List<String> args) async {
    final bin = yaml["bin"] as YamlMap;
    final flutter = bin["flutter"] as String?;
    final store = yaml["store"] as YamlMap;
    final colorCode = store["color"] as String?;
    final exportDir = store["export_dir"] as String?;
    final icon = store["icon"] as String?;
    if (icon.isEmpty ||
        exportDir.isEmpty ||
        flutter.isEmpty ||
        colorCode.isEmpty) {
      print("Screenshot data could not be found.");
      return;
    }
    // 色の変換
    final color = Color.fromRgb(
      int.parse(colorCode!.substring(0, 2), radix: 16),
      int.parse(colorCode.substring(2, 4), radix: 16),
      int.parse(colorCode.substring(4, 6), radix: 16),
    );
    final document = Directory("document");
    if (!document.existsSync()) {
      document.createSync();
    }
    final file = File(icon!);
    if (!file.existsSync()) {
      final image = Image(512, 512)..fill(color);
      file.writeAsBytesSync(encodePng(image));
    }
    final resized = copyResize(
      decodeImage(file.readAsBytesSync())!,
      width: 512,
      height: 512,
    );
    File("document/icon.png").writeAsBytesSync(encodePng(resized));
    final process = await Process.start(
      flutter!,
      [
        "pub",
        "pub",
        "run",
        "flutter_launcher_icons:main",
      ],
      runInShell: true,
    );
    await process.print();
  }
}
