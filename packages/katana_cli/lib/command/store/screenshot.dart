part of katana_cli.store;

const _resolution = <String, Map<String, _Size>>{
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

const _offset = <int, _Offset>{2732: _Offset(38, 32)};
const _defaultOffset = _Offset(76, 48);

class _Offset {
  const _Offset(this.top, this.bottom);

  final double top;
  final double bottom;
}

class _Size {
  const _Size(this.width, this.height);

  final int width;
  final int height;
}

/// Create screenshot images, etc. for the store based on the images in the `source_dir`.
///
/// The images are stored in `export_dir`.
///
/// The `color` specifies the background color.
///
/// The `orientation` specifies the orientation.
///
/// `source_dir`にある画像を元にストア用のスクリーンショット画像等を作成します。
///
/// `export_dir`に画像が格納されます。
///
/// `color`には背景色を指定します。
///
/// `orientation`には向きを指定します。
class StoreScreenshotCliCommand extends CliCommand {
  /// Create screenshot images, etc. for the store based on the images in the `source_dir`.
  ///
  /// The images are stored in `export_dir`.
  ///
  /// The `color` specifies the background color.
  ///
  /// The `orientation` specifies the orientation.
  ///
  /// `source_dir`にある画像を元にストア用のスクリーンショット画像等を作成します。
  ///
  /// `export_dir`に画像が格納されます。
  ///
  /// `color`には背景色を指定します。
  ///
  /// `orientation`には向きを指定します。
  const StoreScreenshotCliCommand();

  @override
  String get description =>
      "Create screenshot images, etc. for the store. ストア用のスクリーンショット画像等の作成を行います。";

  @override
  Future<void> exec(ExecContext context) async {
    final store = context.yaml.getAsMap("store");
    final screenshot = store.getAsMap("screenshot");
    final exportDir = screenshot.get("export_dir", "").trimStringRight("/");
    final colorCode = screenshot.get("color", "").trimString("#");
    final orientation = screenshot.get("orientation", "");
    final sourceDir = screenshot.get("source_dir", "");
    if (exportDir.isEmpty) {
      error(
        "[store]->[screenshot]->[export_dir] is not found. Fill in the destination folder here.",
      );
      return;
    }
    if (sourceDir.isEmpty) {
      error(
        "[store]->[screenshot]->[source_dir] is not found. Fill in the source folder here.",
      );
      return;
    }
    if (colorCode.isEmpty) {
      error(
        "[store]->[screenshot]->[color] is not found. Enter the color code for the background color here.",
      );
      return;
    }
    label("Retrieve the source.");
    // 色の変換
    final color = ColorUint8.rgb(
      int.parse(colorCode.substring(0, 2), radix: 16),
      int.parse(colorCode.substring(2, 4), radix: 16),
      int.parse(colorCode.substring(4, 6), radix: 16),
    );
    final document = Directory(exportDir);
    if (!document.existsSync()) {
      document.createSync(recursive: true);
    }
    final source = Directory(sourceDir);
    if (!source.existsSync()) {
      source.createSync(recursive: true);
    }
    final root = source.path.replaceAll(r"\", "/");
    final sources = source.listSync().where((file) {
      final path = file.path.replaceAll(r"\", "/").replaceAll("$root/", "");
      if (path.startsWith(".") || path.contains("/.")) {
        return false;
      }
      return true;
    }).toList();
    label("Create a featured image.");
    final featureImage = File("$exportDir/feature_image.png");
    if (!featureImage.existsSync()) {
      final image = Image(
        width: 1024,
        height: 500,
      )..clear(color);
      File("$exportDir/feature_image.png").writeAsBytesSync(encodePng(image));
    }
    label("Create other screenshots.");
    if (sources.isEmpty) {
      for (final tmp in _resolution.entries) {
        if (tmp.key != orientation) {
          continue;
        }
        for (final val in tmp.value.entries) {
          final key = val.key;
          final size = val.value;
          if (key == "purchase") {
            final file = File("$exportDir/${key}_0.png");
            if (file.existsSync()) {
              continue;
            }
            final image = Image(width: size.width, height: size.height)
              ..clear(color);
            file.writeAsBytesSync(encodePng(image));
          } else {
            for (int i = 0; i < 2; i++) {
              final file = File("$exportDir/${key}_$i.png");
              if (file.existsSync()) {
                continue;
              }
              final image = Image(width: size.width, height: size.height)
                ..clear(color);
              file.writeAsBytesSync(encodePng(image));
            }
          }
        }
      }
    } else {
      sources.sort((a, b) {
        return a.path.compareTo(b.path);
      });
      for (final tmp in _resolution.entries) {
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
                  x: 0,
                  y: ((resized.height - size.height) / 2.0).floor(),
                  width: resized.width,
                  height: size.height,
                );
                File("$exportDir/${key}_$i.png")
                    .writeAsBytesSync(encodePng(cropped));
              } else {
                final resized = copyResize(image, height: size.height);
                final cropped = copyCrop(
                  resized,
                  x: ((resized.width - size.width) / 2.0).floor(),
                  y: 0,
                  width: size.width,
                  height: resized.height,
                );
                File("$exportDir/${key}_$i.png")
                    .writeAsBytesSync(encodePng(cropped));
              }
            } else {
              final file = File(sources[i].path);
              final image = Image(width: size.width, height: size.height)
                ..clear(color);
              final sourceFile = decodeImage(file.readAsBytesSync())!;
              final offset = _getOffset(sourceFile.height);
              final sourceImage = dropShadow(
                _resize(
                  _crop(
                    sourceFile,
                    offset.top,
                    offset.bottom,
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
              final merged = compositeImage(
                image,
                sourceImage,
                dstX: ((image.width / 2) - (sourceImage.width / 2)).round(),
                dstY: ((image.height / 2) - (sourceImage.height / 2)).round(),
              );
              File("$exportDir/${key}_$i.png")
                  .writeAsBytesSync(encodePng(merged));
            }
          }
        }
      }
    }
  }

  _Offset _getOffset(num height) {
    final h = height.toInt();
    if (_offset.containsKey(h)) {
      return _offset[h]!;
    }
    return _defaultOffset;
  }

  Image _crop(
    Image source,
    double top,
    double bottom,
  ) {
    return copyCrop(
      source,
      x: 0,
      y: top.round(),
      width: source.width,
      height: source.height - (top + bottom).round(),
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
