part of "web.dart";

/// Class for storing the results of camera shots.
///
/// カメラの撮影結果を保存するためのクラス。
@immutable
class CameraValue {
  const CameraValue._({
    required this.uri,
    required this.name,
    required this.format,
    this.bytes,
  });

  /// Generate data for mock.
  ///
  /// モック用のデータを生成します。
  static Future<CameraValue> create({
    required MediaFormat format,
    int? width,
    int? height,
  }) async {
    final source = image.Image(width: width ?? 512, height: height ?? 512);
    final exportedFile = "${uuid()}.${format.extension}";
    switch (format) {
      case MediaFormat.jpg:
        final convertedBytes = image.encodeJpg(source);
        return CameraValue._(
          uri: Uri(path: exportedFile),
          name: exportedFile,
          format: format,
          bytes: convertedBytes,
        );
      case MediaFormat.png:
        final convertedBytes = image.encodePng(source);
        return CameraValue._(
          uri: Uri(path: exportedFile),
          name: exportedFile,
          format: format,
          bytes: convertedBytes,
        );
      case MediaFormat.mp4:
        return CameraValue._(
          uri: Uri(path: exportedFile),
          name: exportedFile,
          format: format,
          bytes: null,
        );
    }
  }

  /// Generate [CameraValue] from an [ImageProvider].
  ///
  /// [ImageProvider]から[CameraValue]を生成します。
  static Future<CameraValue?> fromImageProvider({
    required ImageProvider provider,
    required MediaFormat format,
    int? width,
    int? height,
  }) async {
    final bytes = await _resolveImageProvider(provider);
    var source = image.decodeImage(bytes);
    if (source == null) {
      throw StateError("The debug picture could not be decoded.");
    }
    source = _resizeImage(source, width: width, height: height);
    final exportedFile = "${uuid()}.${format.extension}";
    switch (format) {
      case MediaFormat.jpg:
        return CameraValue._(
          uri: Uri(path: exportedFile),
          name: exportedFile,
          format: format,
          bytes: image.encodeJpg(source),
        );
      case MediaFormat.png:
        return CameraValue._(
          uri: Uri(path: exportedFile),
          name: exportedFile,
          format: format,
          bytes: image.encodePng(source),
        );
      case MediaFormat.mp4:
        return null;
    }
  }

  /// Generate [CameraValue] from [XFile].
  ///
  /// [XFile]から[CameraValue]を生成します。
  static Future<CameraValue> fromXFile({
    required camera.XFile file,
    required MediaFormat format,
    int? width,
    int? height,
  }) async {
    final bytes = await file.readAsBytes();
    var source = image.decodeImage(bytes);
    if (source == null) {
      return CameraValue._(
        uri: Uri.parse(file.path),
        name: file.name,
        format: format,
        bytes: bytes,
      );
    }
    source = _resizeImage(source, width: width, height: height);
    switch (format) {
      case MediaFormat.jpg:
        return CameraValue._(
          uri: Uri.parse(file.path),
          name: file.name,
          format: format,
          bytes: image.encodeJpg(source),
        );
      case MediaFormat.png:
        return CameraValue._(
          uri: Uri.parse(file.path),
          name: file.name,
          format: format,
          bytes: image.encodePng(source),
        );
      case MediaFormat.mp4:
        return CameraValue._(
          uri: Uri.parse(file.path),
          name: file.name,
          format: format,
          bytes: bytes,
        );
    }
  }

  /// Path of the file acquired by the camera.
  ///
  /// カメラで取得したファイルのパス。
  final Uri uri;

  /// File name of the file acquired by the camera.
  ///
  /// カメラで取得したファイルのファイル名。
  final String name;

  /// Image format.
  ///
  /// 画像のフォーマット。
  final MediaFormat format;

  /// Byte data.
  ///
  /// バイトデータ。サイズ変換された後のデータが入ります。
  final Uint8List? bytes;
}

image.Image _resizeImage(
  image.Image source, {
  required int? width,
  required int? height,
}) {
  if (width == null && height == null) {
    return source;
  }
  var resized = image.copyResize(source, height: height, width: width);
  if (height == null || width == null) {
    return resized;
  }
  if (height > width) {
    resized = image.copyCrop(
      resized,
      x: ((resized.width - width) / 2.0).floor(),
      y: 0,
      width: width,
      height: resized.height,
    );
  } else {
    resized = image.copyCrop(
      resized,
      x: 0,
      y: ((resized.height - height) / 2.0).floor(),
      width: resized.width,
      height: height,
    );
  }
  return resized;
}

Future<Uint8List> _resolveImageProvider(ImageProvider provider) {
  final completer = Completer<Uint8List>();
  final stream = provider.resolve(ImageConfiguration.empty);
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (imageInfo, synchronousCall) async {
      stream.removeListener(listener);
      try {
        final data =
            await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
        if (data == null) {
          throw StateError("The debug picture could not be converted.");
        }
        completer.complete(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    },
    onError: (Object error, StackTrace? stackTrace) {
      stream.removeListener(listener);
      completer.completeError(error, stackTrace ?? StackTrace.current);
    },
  );
  stream.addListener(listener);
  return completer.future;
}
