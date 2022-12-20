part of katana_storage;

class RuntimeStorageAdapter extends StorageAdapter {
  const RuntimeStorageAdapter({
    MemoryStorage? storage,
    this.rawData = const {},
  }) : _storage = storage;

  final Map<String, Uint8List> rawData;

  /// Designated remote storage.
  ///
  /// 指定のリモートストレージ。
  MemoryStorage get remoteStorage {
    final storage = _storage ?? sharedRemoteStorage;
    if (storage._data.isEmpty && rawData.isNotEmpty) {
      storage.setRawData(rawData);
    }
    return storage;
  }

  final MemoryStorage? _storage;

  /// Common remote storage throughout the app.
  ///
  /// アプリ内全体での共通のリモートストレージ。
  static final MemoryStorage sharedRemoteStorage = MemoryStorage();

  /// Local Storage.
  ///
  /// ローカルストレージ。
  static final FileStorage localStorage = FileStorage();

  @override
  Future<void> delete(String path) async {
    await remoteStorage.delete(path);
  }

  @override
  Future<void> download(String fromPath, String toPath) async {
    final from = fromPath;
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
    return path;
  }

  @override
  Future<void> upload(String fromPath, String toPath) async {
    final from = fromPath;
    final to = toPath;
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
    final to = toPath;
    if (remoteStorage.exists(to)) {
      await remoteStorage.delete(to);
    }
    await remoteStorage.write(to, bytes);
  }
}
