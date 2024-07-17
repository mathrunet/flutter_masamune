part of 'web.dart';

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
    required ImageFormat format,
    int? width,
    int? height,
  }) async {
    final source = image.Image(width: width ?? 512, height: height ?? 512);
    final exportedFile = "${uuid()}.${format.extension}";
    switch (format) {
      case ImageFormat.jpg:
        final convertedBytes = image.encodeJpg(source);
        return CameraValue._(
          uri: Uri(path: exportedFile),
          name: exportedFile,
          format: format,
          bytes: convertedBytes,
        );
      case ImageFormat.png:
        final convertedBytes = image.encodePng(source);
        return CameraValue._(
          uri: Uri(path: exportedFile),
          name: exportedFile,
          format: format,
          bytes: convertedBytes,
        );
    }
  }

  /// Generate [CameraValue] from [XFile].
  ///
  /// [XFile]から[CameraValue]を生成します。
  static Future<CameraValue> fromXFile({
    required camera.XFile file,
    required ImageFormat format,
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
    if (width != null || height != null) {
      source = image.copyResize(source, height: height, width: width);
      if (height != null && width != null) {
        if (height > width) {
          source = image.copyCrop(
            source,
            x: ((source.width - width) / 2.0).floor(),
            y: 0,
            width: width,
            height: source.height,
          );
        } else {
          source = image.copyCrop(
            source,
            x: 0,
            y: ((source.height - height) / 2.0).floor(),
            width: source.width,
            height: height,
          );
        }
      }
    }
    switch (format) {
      case ImageFormat.jpg:
        return CameraValue._(
          uri: Uri.parse(file.path),
          name: file.name,
          format: format,
          bytes: image.encodeJpg(source),
        );
      case ImageFormat.png:
        return CameraValue._(
          uri: Uri.parse(file.path),
          name: file.name,
          format: format,
          bytes: image.encodePng(source),
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
  final ImageFormat format;

  /// Byte data.
  ///
  /// バイトデータ。サイズ変換された後のデータが入ります。
  final Uint8List? bytes;
}
