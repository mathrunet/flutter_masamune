part of katana_storage;

class LocalStorageAdapter extends StorageAdapter {
  const LocalStorageAdapter();

  /// Designated remote storage.
  ///
  /// 指定のリモートストレージ。
  FileStorage get remoteStorage => sharedRemoteStorage;

  /// Common remote storage throughout the app.
  ///
  /// アプリ内全体での共通のリモートストレージ。
  static final FileStorage sharedRemoteStorage = FileStorage();

  /// Local Storage.
  ///
  /// ローカルストレージ。
  static final FileStorage localStorage = sharedRemoteStorage;

  @override
  Future<void> delete(String path) async {
    await remoteStorage.delete("${await FileStorage.documentDirectory}/$path");
  }

  @override
  Future<void> download(String fromPath, String toPath) async {
    final from = "${await FileStorage.documentDirectory}/$fromPath";
    final to = toPath;
    if (!remoteStorage.exists(from)) {
      throw Exception("File could not be found: $from");
    }
    if (localStorage.exists(to)) {
      await localStorage.delete(to);
    }
    await localStorage.write(to, await remoteStorage.read(from));
  }

  @override
  Future<String> fetchDownloadURI(String path) async => fetchPublicURI(path);

  @override
  Future<String> fetchPublicURI(String path) async {
    return "${await FileStorage.documentDirectory}/$path";
  }

  @override
  Future<void> upload(String fromPath, String toPath) async {
    final from = fromPath;
    final to = "${await FileStorage.documentDirectory}/$toPath";
    if (!localStorage.exists(from)) {
      throw Exception("File could not be found: $from");
    }
    if (remoteStorage.exists(to)) {
      await remoteStorage.delete(to);
    }
    await remoteStorage.write(to, await localStorage.read(from));
  }

  @override
  Future<void> uploadWithBytes(Uint8List bytes, String toPath) async {
    final to = "${await FileStorage.documentDirectory}/$toPath";
    if (remoteStorage.exists(to)) {
      await remoteStorage.delete(to);
    }
    await remoteStorage.write(to, bytes);
  }
}
