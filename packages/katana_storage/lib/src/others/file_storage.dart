part of "others.dart";

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

  static const _platformInfo = PlatformInfo();

  @override
  Future<Uint8List> read(String fileFullPath) async {
    return await File(fileFullPath).readAsBytes();
  }

  @override
  Future<void> write(String fileFullPath, Uint8List bytes) async {
    await File(fileFullPath).writeAsBytes(bytes);
  }

  @override
  Future<void> delete(String fileFullPath) async {
    await File(fileFullPath).delete();
  }

  @override
  Future<bool> exists(String fileFullPath) async {
    return File(fileFullPath).existsSync();
  }

  @override
  Future<String> fetchURI(String fileRelativePath) async =>
      "${await documentDirectory}/$fileRelativePath";

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
    if (_platformInfo.isIOS) {
      return (await _platformInfo.getLibraryDirectory())
          .path
          .replaceAll("//", "/");
    } else {
      return (await _platformInfo.getApplicationDocumentsDirectory())
          .path
          .replaceAll("//", "/");
    }
  }
}
