part of '/masamune_camera.dart';

/// Extension methods of Storage system related to CameraValue.
///
/// CameraValueに関連するStorage系の拡張メソッド。
extension MasamuneCameraUploaderAppRefExtensions on CameraValue {
  /// Upload the captured files directly to storage.
  ///
  /// Pass [relativeDirPath] the relative path of the folder where you want to upload the file.
  ///
  /// After uploading, the public URL is returned after the upload.
  ///
  /// 撮影したファイルを直接ストレージにアップロードします。
  ///
  /// [relativeDirPath]にファイルをアップロードしたいフォルダの相対パスを渡してください。
  ///
  /// アップロードした後、アップロード後の公開URLが返されます。
  Future<Uri> upload({String relativeDirPath = ""}) async {
    final path = uri.toString();
    if (kIsWeb) {
      if (bytes == null) {
        throw Exception("Upload data was not found.");
      }
      final extension = format.extension;
      final storage = Storage(
        StorageQuery(
          "$relativeDirPath/${uuid()}.$extension"
              .trimQuery()
              .trimStringLeft("/"),
        ),
      );
      await storage.uploadWithBytes(bytes!);
      return await storage.fetchPublicURI();
    } else {
      if (path.isEmpty) {
        throw Exception("Upload data was not found.");
      }
      final extension = format.extension;
      final storage = Storage(
        StorageQuery(
          "$relativeDirPath/${uuid()}.$extension"
              .trimQuery()
              .trimStringLeft("/"),
        ),
      );
      await storage.upload(uri.toString().replaceAll(RegExp("file://"), ""));
      return await storage.fetchPublicURI();
    }
  }
}
