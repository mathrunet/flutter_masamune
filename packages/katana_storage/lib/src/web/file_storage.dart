part of katana_storage.web;

class FileStorage {
  FileStorage();

  Future<Uint8List> read(String filePath) async {
    throw UnsupportedError("This feature is not available on the Web.");
  }

  Future<void> write(String filePath, Uint8List bytes) async {
    throw UnsupportedError("This feature is not available on the Web.");
  }

  Future<void> delete(String filePath) async {
    throw UnsupportedError("This feature is not available on the Web.");
  }

  bool exists(String filePath) {
    throw UnsupportedError("This feature is not available on the Web.");
  }

  /// Obtains the document path where the file can be placed by determining the platform.
  ///
  /// Use [getLibraryDirectory] for `iOS` and [getApplicationDocumentsDirectory] for others.
  ///
  /// `Web` returns [Null].
  ///
  /// ファイルを置けるドキュメントパスをプラットフォームを判別して取得します。
  ///
  /// `iOS`は[getLibraryDirectory]、その他は[getApplicationDocumentsDirectory]を利用します。
  ///
  /// `Web`は[Null]を返します。
  static Future<String?> get documentDirectory async {
    return null;
  }

  /// Obtains the temporary path where the file can be placed by determining the platform.
  ///
  /// [getTemporaryDirectory].
  ///
  /// `Web` returns [Null].
  ///
  /// ファイルを置けるテンポラリパスをプラットフォームを判別して取得します。
  ///
  /// [getTemporaryDirectory]を利用します。
  ///
  /// `Web`は[Null]を返します。
  static Future<String?> get temporaryDirectory async {
    return null;
  }
}
