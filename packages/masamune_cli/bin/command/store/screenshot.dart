part of masamune_cli;

const resolution = <String, Map<String, _Size>>{
  "portrait": {
    "iphone5.5": _Size(1242, 2208),
    "iphone6.5": _Size(1284, 2778),
    "ipad": _Size(2048, 2732),
    "purchase": _Size(640, 920),
  },
  "landscape": {
    "iphone5.5": _Size(2208, 1242),
    "iphone6.5": _Size(2778, 1284),
    "ipad": _Size(2732, 2048),
    "purchase": _Size(920, 640),
  },
};

class _Size {
  const _Size(this.width, this.height);

  final int width;
  final int height;
}

class StoreScreenshotCliCommand extends CliCommand {
  const StoreScreenshotCliCommand();

  @override
  String get description => "ストア用のスクリーンショット画像等の作成を行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final store = yaml.getAsMap("store");
    final exportDir = store.get("export_dir", "");
    final screenshot = store.getAsMap("screenshot");
    final colorCode = screenshot.get("color", "");
    final orientation = screenshot.get("orientation", "");
    final sourceDir = screenshot.get("source_dir", "");
    if (exportDir.isEmpty || sourceDir.isEmpty || colorCode.isEmpty) {
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
    final _sourceDir = Directory(sourceDir);
    if (!_sourceDir.existsSync()) {
      _sourceDir.createSync();
    }
    final root = _sourceDir.path.replaceAll(r"\", "/");
    final sources = _sourceDir.listSync().where((file) {
      final path = file.path.replaceAll(r"\", "/").replaceAll("$root/", "");
      if (path.startsWith(".") || path.contains("/.")) {
        return false;
      }
      return true;
    }).toList();
    final featureImage = File("document/feature_image.png");
    if (!featureImage.existsSync()) {
      final image = Image(1024, 500)..fill(color);
      File("document/feature_image.png").writeAsBytesSync(encodePng(image));
    }
    if (sources.isEmpty) {
      for (final tmp in resolution.entries) {
        if (tmp.key != orientation) {
          continue;
        }
        for (final val in tmp.value.entries) {
          final key = val.key;
          final size = val.value;
          if (key == "purchase") {
            final file = File("document/${key}_0.png");
            if (file.existsSync()) {
              continue;
            }
            final image = Image(size.width, size.height)..fill(color);
            file.writeAsBytesSync(encodePng(image));
          } else {
            for (int i = 0; i < 2; i++) {
              final file = File("document/${key}_$i.png");
              if (file.existsSync()) {
                continue;
              }
              final image = Image(size.width, size.height)..fill(color);
              file.writeAsBytesSync(encodePng(image));
            }
          }
        }
      }
    } else {
      for (final tmp in resolution.entries) {
        if (tmp.key != orientation) {
          continue;
        }
        for (final val in tmp.value.entries) {
          final key = val.key;
          final size = val.value;
          for (int i = 0; i < sources.length; i++) {
            if (key == "purchase") {
              final file = File(sources[i].path);
              final image = decodeImage(file.readAsBytesSync())!;
              if (orientation == "portrait") {
                final resized = copyResize(image, width: size.width);
                final cropped = copyCrop(
                  resized,
                  0,
                  ((resized.height - size.height) / 2.0).floor(),
                  resized.width,
                  size.height,
                );
                File("document/${key}_$i.png")
                    .writeAsBytesSync(encodePng(cropped));
              } else {
                final resized = copyResize(image, height: size.height);
                final cropped = copyCrop(
                  resized,
                  ((resized.width - size.width) / 2.0).floor(),
                  0,
                  size.width,
                  resized.height,
                );
                File("document/${key}_$i.png")
                    .writeAsBytesSync(encodePng(cropped));
              }
            } else {
              final file = File(sources[i].path);
              final image = Image(size.width, size.height)..fill(color);
              final sourceImage = dropShadow(
                _resize(
                  _crop(
                    decodeImage(file.readAsBytesSync())!,
                    76,
                    48,
                  ),
                  image,
                  64,
                  64,
                  64,
                  64,
                ),
                16,
                16,
                16,
              );
              final merged = drawImage(
                image,
                sourceImage,
                dstX: ((image.width / 2) - (sourceImage.width / 2)).round(),
                dstY: ((image.height / 2) - (sourceImage.height / 2)).round(),
              );
              File("document/${key}_$i.png")
                  .writeAsBytesSync(encodePng(merged));
            }
          }
        }
      }
    }
  }

  Image _crop(
    Image source,
    double top,
    double bottom,
  ) {
    return copyCrop(
      source,
      0,
      top.round(),
      source.width,
      source.height - (top + bottom).round(),
    );
  }

  Image _resize(
    Image source,
    Image container,
    double left,
    double top,
    double right,
    double bottom,
  ) {
    final width = container.width - (left + right);
    final height = container.height - (top + bottom);
    final wRatio = source.width / width;
    final hRatio = source.height / height;
    if (wRatio >= hRatio) {
      return copyResize(source, width: width.floor());
    } else {
      return copyResize(source, height: height.floor());
    }
  }
}
