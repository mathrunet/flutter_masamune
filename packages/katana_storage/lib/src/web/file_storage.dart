part of "web.dart";

/// Class for using storage functions in local storage.
///
/// The root folder is [getLibraryDirectory] for IOS and [getApplicationDocumentsDirectory] for others.
///
/// ローカルストレージでストレージ機能を利用するためのクラス。
///
/// ルートフォルダはIOSの場合、[getLibraryDirectory]がそれ以外は[getApplicationDocumentsDirectory]が用いられます。
class FileStorage extends StorageBase {
  /// Class for using storage functions in local storage.
  ///
  /// The root folder is [getLibraryDirectory] for IOS and [getApplicationDocumentsDirectory] for others.
  ///
  /// ローカルストレージでストレージ機能を利用するためのクラス。
  ///
  /// ルートフォルダはIOSの場合、[getLibraryDirectory]がそれ以外は[getApplicationDocumentsDirectory]が用いられます。
  const FileStorage();

  @override
  Future<Uint8List> read(String fileFullPath) {
    throw UnsupportedError("This feature is not available on the Web.");
  }

  @override
  Future<void> write(String fileFullPath, Uint8List bytes) {
    throw UnsupportedError("This feature is not available on the Web.");
  }

  @override
  Future<void> delete(String fileFullPath) {
    throw UnsupportedError("This feature is not available on the Web.");
  }

  @override
  Future<bool> exists(String fileFullPath) {
    throw UnsupportedError("This feature is not available on the Web.");
  }

  @override
  Future<String> fetchURI(String fileRelativePath) {
    throw UnsupportedError("This feature is not available on the Web.");
  }
}
