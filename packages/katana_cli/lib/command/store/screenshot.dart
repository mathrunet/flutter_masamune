part of "store.dart";

const _resolution = <String, Map<String, _Size>>{
  "portrait": {
    "iphone5.5": _Size(1242, 2208),
    "iphone6.5": _Size(1284, 2778),
    "iphone6.9": _Size(1320, 2868),
    "ipad": _Size(2048, 2732),
    "purchase": _Size(640, 920),
  },
  "landscape": {
    "iphone5.5": _Size(2208, 1242),
    "iphone6.5": _Size(2778, 1284),
    "iphone6.9": _Size(2868, 1320),
    "ipad": _Size(2732, 2048),
    "purchase": _Size(920, 640),
  },
};

const _offset = <int, _Offset>{
  2868: _Offset(176, 96),
  2796: _Offset(176, 96),
  2752: _Offset(56, 48),
  2732: _Offset(38, 32),
  2622: _Offset(176, 96),
  2556: _Offset(144, 48),
  2340: _Offset(80, 132),
};
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
  String? get example => "katana store screenshot";

  @override
  Future<void> exec(ExecContext context) async {
    final store = context.yaml.getAsMap("store");
    final screenshot = store.getAsMap("screenshot");
    final exportDir = screenshot.get("export_dir", "").trimStringRight("/");
    final colorCode = screenshot.get("color", "").trimString("#");
    final orientation = screenshot.get("orientation", "");
    final sourceDir = screenshot.get("source_dir", "");
    final featureImageSourcePath = screenshot.get("feature_image", "");
    final title = screenshot.get("title", "");
    final iconSourcePath = screenshot.get("icon", "");
    final purchasePosition = screenshot.get("purchase_position", "center");
    final iconPosition = screenshot.getAsMap("icon_position", {});
    final iconPositionX = iconPosition.getAsInt("x", 12);
    final iconPositionY = iconPosition.getAsInt("y", 12);
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
    final backgroundColor = ColorUint8.rgb(
      int.parse(colorCode.substring(0, 2), radix: 16),
      int.parse(colorCode.substring(2, 4), radix: 16),
      int.parse(colorCode.substring(4, 6), radix: 16),
    );
    final foregroundColor = ColorUint8.rgb(255, 255, 255);

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
    if (featureImageSourcePath.isNotEmpty) {
      final featureImageSource = File(featureImageSourcePath);
      if (featureImageSource.existsSync()) {
        final source = decodeImage(featureImageSource.readAsBytesSync())!;
        final resized = copyResize(source, width: 1024);
        final cropped = copyCrop(
          resized,
          x: 0,
          y: ((resized.height - 500) / 2.0).floor(),
          width: resized.width,
          height: 500,
        );
        featureImage.writeAsBytesSync(encodePng(cropped));
      }
    }
    if (!featureImage.existsSync()) {
      var image = Image(
        width: 1024,
        height: 500,
      )..clear(backgroundColor);
      if (title.isNotEmpty) {
        image = drawString(
          image,
          title,
          font: arial48,
          x: 1008,
          y: 448,
          rightJustify: true,
          color: foregroundColor,
        );
      }
      featureImage.writeAsBytesSync(encodePng(image));
    }
    label("Create a icon.");
    final iconImage = File("$exportDir/icon.png");
    final iconImageAndroid = File("$exportDir/icon_android.png");
    if (iconSourcePath.isNotEmpty) {
      final iconSource = File(iconSourcePath);
      if (iconSource.existsSync()) {
        final source = decodeImage(iconSource.readAsBytesSync())!;
        final resized = copyResize(source, width: 1024);
        final cropped = copyCrop(
          resized,
          x: 0,
          y: ((resized.height - 500) / 2.0).floor(),
          width: resized.width,
          height: 500,
        );
        iconImage.writeAsBytesSync(encodePng(cropped));
      }
    }
    if (!iconImage.existsSync()) {
      if (title.isNotEmpty) {
        var image = Image(
          width: 64,
          height: 64,
        );
        image = drawString(
          image,
          title.substring(0, 1).toUpperCase(),
          font: arial48,
          x: iconPositionX,
          y: iconPositionY,
          color: foregroundColor,
        );
        image = _adjustAlpha(
          copyResize(
            image,
            width: 1024,
            maintainAspect: true,
            interpolation: Interpolation.linear,
          ),
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
        );
        iconImage.writeAsBytesSync(encodePng(image));
      } else {
        final image = Image(
          width: 1024,
          height: 1024,
        )..clear(backgroundColor);
        iconImage.writeAsBytesSync(encodePng(image));
      }
    }
    final iconSource = decodeImage(iconImage.readAsBytesSync())!;
    final resized = copyResize(
      iconSource,
      width: 512,
      height: 512,
      maintainAspect: true,
    );
    iconImageAndroid.writeAsBytesSync(encodePng(resized));
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
              ..clear(backgroundColor);
            file.writeAsBytesSync(encodePng(image));
          } else {
            for (var i = 0; i < 2; i++) {
              final file = File("$exportDir/${key}_$i.png");
              if (file.existsSync()) {
                continue;
              }
              final image = Image(width: size.width, height: size.height)
                ..clear(backgroundColor);
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
          for (var i = 0; i < sources.length; i++) {
            if (key == "icon") {
            } else if (key == "purchase") {
              final file = File(sources[i].path);
              final image = decodeImage(file.readAsBytesSync())!;
              if (orientation == "portrait") {
                final offset = _getOffset(size.height);
                final resized = copyResize(image, width: size.width);
                final cropped = copyCrop(
                  resized,
                  x: 0,
                  y: _purchaseVerticalPosition(
                    sourceHeight: resized.height,
                    targetHeight: size.height,
                    position: purchasePosition,
                    offset: offset,
                  ).floor(),
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
                ..clear(backgroundColor);
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

  Image _adjustAlpha(
    Image image, {
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        if (!(r == 0 && g == 0 && b == 0)) {
          image.setPixel(x, y, foregroundColor);
        } else {
          image.setPixel(x, y, backgroundColor);
        }
      }
    }
    return image;
  }

  double _purchaseVerticalPosition({
    required int sourceHeight,
    required int targetHeight,
    required String position,
    required _Offset offset,
  }) {
    switch (position) {
      case "top":
        return offset.top;
      case "bottom":
        return (sourceHeight - targetHeight).toDouble() - offset.bottom;
      default:
        return (sourceHeight - targetHeight) / 2.0;
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
