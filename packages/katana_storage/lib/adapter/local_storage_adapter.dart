part of katana_storage;

class LocalStorageAdapter extends StorageAdapter {
  const LocalStorageAdapter();

  /// Designated storage.
  ///
  /// 指定のストレージ。
  FileStorage get storage => sharedStorage;

  /// Common storage throughout the app.
  ///
  /// アプリ内全体での共通のストレージ。
  static final FileStorage sharedStorage = FileStorage();

  @override
  Future<void> delete(String path) async {
    await storage.delete("${FileStorage.documentDirectory}/$path");
  }

  @override
  Future<void> download(String fromPath, String toPath) async {
    final from = "${FileStorage.documentDirectory}/$fromPath";
    final to = toPath;
    if (!storage.exists(from)) {
      throw Exception("File could not be found: $from");
    }
    if (storage.exists(to)) {
      await storage.delete(to);
    }
    await storage.write(to, await storage.read(from));
  }

  @override
  Future<String> fetchDownloadURI(String path) async => fetchPublicURI(path);

  @override
  String fetchPublicURI(String path) {
    return "${FileStorage.documentDirectory}/$path";
  }

  @override
  Future<void> upload(String fromPath, String toPath) async {
    final from = fromPath;
    final to = "${FileStorage.documentDirectory}/$toPath";
    if (!storage.exists(from)) {
      throw Exception("File could not be found: $from");
    }
    if (storage.exists(to)) {
      await storage.delete(to);
    }
    await storage.write(to, await storage.read(from));
  }

  @override
  Future<void> uploadWithBytes(Uint8List bytes, String toPath) async {
    final to = "${FileStorage.documentDirectory}/$toPath";
    if (storage.exists(to)) {
      await storage.delete(to);
    }
    await storage.write(to, bytes);
  }
}
