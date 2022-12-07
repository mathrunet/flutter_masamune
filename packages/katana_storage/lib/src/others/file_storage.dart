part of katana_storage.others;

class FileStorage {
  FileStorage();

  Future<Uint8List> read(String filePath) async {
    return await File(filePath).readAsBytes();
  }

  Future<void> write(String filePath, Uint8List bytes) async {
    await File(filePath).writeAsBytes(bytes);
  }

  Future<void> delete(String filePath) async {
    await File(filePath).delete();
  }

  bool exists(String filePath) {
    return File(filePath).existsSync();
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
    if (Platform.isIOS) {
      return (await getLibraryDirectory()).path;
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
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
    return (await getTemporaryDirectory()).path;
  }
}
