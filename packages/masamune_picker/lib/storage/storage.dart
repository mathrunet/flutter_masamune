part of masamune_picker;

/// Extension methods of Storage system related to PickerValue.
///
/// PickerValueに関連するStorage系の拡張メソッド。
extension MasamunePickerUploaderAppRefExtensions on PickerValue {
  /// Upload picked up files directly to storage.
  ///
  /// Pass [relativeDirPath] the relative path of the folder where you want to upload the file.
  ///
  /// After uploading, the public URL is returned after the upload.
  ///
  /// ピックアップしたファイルを直接ストレージにアップロードします。
  ///
  /// [relativeDirPath]にファイルをアップロードしたいフォルダの相対パスを渡してください。
  ///
  /// アップロードした後、アップロード後の公開URLが返されます。
  Future<Uri> upload({String relativeDirPath = ""}) async {
    final path = uri.toString();
    if (kIsWeb) {
      if (path.isEmpty || bytes == null) {
        throw Exception("Upload data was not found.");
      }
      final remoteFile = path.trimQuery().trimStringRight("/").last();
      final extension = remoteFile.last(separator: ".");
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
      if (uri == null || path.isEmpty) {
        throw Exception("Upload data was not found.");
      }
      final remoteFile = path.trimQuery().trimStringRight("/").last();
      final extension = remoteFile.last(separator: ".");
      final storage = Storage(
        StorageQuery(
          "$relativeDirPath/${uuid()}.$extension"
              .trimQuery()
              .trimStringLeft("/"),
        ),
      );
      await storage.upload(uri!.toString());
      return await storage.fetchPublicURI();
    }
  }
}
