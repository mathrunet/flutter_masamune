part of '/masamune_camera.dart';

/// Class for storing the results of camera shots.
///
/// カメラの撮影結果を保存するためのクラス。
@immutable
class CameraValue {
  const CameraValue._({
    required this.path,
    required this.name,
    this.mimeType,
    this.bytes,
  });

  static Future<CameraValue> _fromXFile(camera.XFile file) async {
    return CameraValue._(
      path: file.path,
      name: file.name,
      mimeType: file.mimeType,
      bytes: await file.readAsBytes(),
    );
  }

  /// Path of the file acquired by the camera.
  ///
  /// カメラで取得したファイルのパス。
  final String path;

  /// File name of the file acquired by the camera.
  ///
  /// カメラで取得したファイルのファイル名。
  final String name;

  /// For Web, the MIME type of the file.
  ///
  /// Webの場合、ファイルのMIMEタイプ。
  final String? mimeType;

  /// Byte data.
  ///
  /// バイトデータ。
  final Uint8List? bytes;
}
