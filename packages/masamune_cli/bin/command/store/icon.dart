part of masamune_cli;

class StoreIconCliCommand extends CliCommand {
  const StoreIconCliCommand();

  @override
  String get description => "ストア用のアイコン画像の作成を行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final store = yaml.getAsMap("store");
    final icon = store.getAsMap("icon");
    final colorCode = icon.get("color", "");
    final exportDir = store.get("export_dir", "");
    final path = icon.get("path", "");
    if (path.isEmpty ||
        exportDir.isEmpty ||
        flutter.isEmpty ||
        colorCode.isEmpty) {
      print("Screenshot data could not be found.");
      return;
    }
    // 色の変換
    final color = Color.fromRgb(
      int.parse(colorCode.substring(1, 3), radix: 16),
      int.parse(colorCode.substring(3, 5), radix: 16),
      int.parse(colorCode.substring(5, 7), radix: 16),
    );
    final document = Directory("document");
    if (!document.existsSync()) {
      document.createSync();
    }
    final file = File(path);
    if (!file.existsSync()) {
      final image = Image(512, 512)..fill(color);
      file.writeAsBytesSync(encodePng(image));
    }
    final resized = copyResize(
      decodeImage(file.readAsBytesSync())!,
      width: 512,
      height: 512,
    );
    final sizeAndroid = (512 * 66 / 108).round();
    final resizedAndroid = copyResize(
      decodeImage(file.readAsBytesSync())!,
      width: sizeAndroid,
      height: sizeAndroid,
    );
    final imageAndroid = drawImage(
      Image(512, 512)..fill(color),
      resizedAndroid,
      dstX: ((512 / 2) - (sizeAndroid / 2)).round(),
      dstY: ((512 / 2) - (sizeAndroid / 2)).round(),
    );
    File("document/icon.png").writeAsBytesSync(encodePng(resized));
    File("assets/icon_ios.png").writeAsBytesSync(encodePng(resized));
    File("assets/icon_android.png").writeAsBytesSync(encodePng(imageAndroid));
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll(
        "# adaptive_icon_background: \"#ffffff\"",
        "adaptive_icon_background: \"$colorCode\"",
      );
      text = text.replaceAll(
        "# adaptive_icon_foreground: \"assets/icon_android.png\"",
        "adaptive_icon_foreground: \"assets/icon_android.png\"",
      );
      File(file.path).writeAsStringSync(text);
    });
    final process = await Process.start(
      flutter,
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
