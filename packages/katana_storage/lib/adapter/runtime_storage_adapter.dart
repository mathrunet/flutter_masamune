part of katana_storage;

/// [StorageAdapter] for handling files at runtime.
///
/// Only available for file uploads and downloads.
///
/// It is not possible to issue URLs, etc. for displaying images.
///
/// MemoryStorage] can be used in the test by passing [MemoryStorage] to [storage].
///
/// You can specify a list of data to be initially retained in [rawData].
///
/// ランタイム上でファイルを扱うための[StorageAdapter]。
///
/// ファイルのアップロードとダウンロードでのみ利用可能です。
///
/// 画像の表示用のURL等を発行することはできません。
///
/// [storage]に[MemoryStorage]を渡すことでテストで利用することができます。
///
/// [rawData]に最初に保持しておくデータのリストを指定することができます。
class RuntimeStorageAdapter extends StorageAdapter {
  /// [StorageAdapter] for handling files at runtime.
  ///
  /// Only available for file uploads and downloads.
  ///
  /// It is not possible to issue URLs, etc. for displaying images.
  ///
  /// MemoryStorage] can be used in the test by passing [MemoryStorage] to [storage].
  ///
  /// You can specify a list of data to be initially retained in [rawData].
  ///
  /// ランタイム上でファイルを扱うための[StorageAdapter]。
  ///
  /// ファイルのアップロードとダウンロードでのみ利用可能です。
  ///
  /// 画像の表示用のURL等を発行することはできません。
  ///
  /// [storage]に[MemoryStorage]を渡すことでテストで利用することができます。
  ///
  /// [rawData]に最初に保持しておくデータのリストを指定することができます。
  const RuntimeStorageAdapter({
    MemoryStorage? storage,
    this.rawData = const {},
  }) : _storage = storage;

  /// List of data to be retained initially.
  ///
  /// 最初に保持しておくデータのリスト。
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
  static final MemoryStorage localStorage = MemoryStorage();

  @override
  Future<void> delete(String relativePath) async {
    await remoteStorage.delete(relativePath);
  }

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePath) async =>
      fetchPublicURI(remoteRelativePath);

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePath) async {
    final bytes = await remoteStorage.read(remoteRelativePath);
    return Uri.parse("blob:${base64Url.encode(bytes)}");
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePath, [
    String? localRelativePath,
  ]) async {
    if (!await remoteStorage.exists(remoteRelativePath)) {
      throw Exception("File could not be found: $remoteRelativePath");
    }
    final bytes = await remoteStorage.read(remoteRelativePath);
    if (localRelativePath.isNotEmpty) {
      final localFullPath = await localStorage.fetchURI(localRelativePath!);
      if (await localStorage.exists(localFullPath)) {
        await localStorage.delete(localFullPath);
      }
      await localStorage.write(localFullPath, bytes);
      return LocalFile(path: Uri.parse(localFullPath), bytes: bytes);
    } else {
      return LocalFile(bytes: bytes);
    }
  }

  @override
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePath,
  ) async {
    if (!await localStorage.exists(localFullPath)) {
      throw Exception("File could not be found: $localFullPath");
    }
    final bytes = await localStorage.read(localFullPath);
    final remoteFullPath = await remoteStorage.fetchURI(remoteRelativePath);
    if (await remoteStorage.exists(remoteFullPath)) {
      await remoteStorage.delete(remoteFullPath);
    }
    await remoteStorage.write(remoteFullPath, bytes);
    return RemoteFile(
      path: await fetchPublicURI(remoteRelativePath),
      bytes: bytes,
    );
  }

  @override
  Future<RemoteFile> uploadWithBytes(
    Uint8List uploadFileByte,
    String remoteRelativePath,
  ) async {
    final remoteFullPath = await remoteStorage.fetchURI(remoteRelativePath);
    if (await remoteStorage.exists(remoteFullPath)) {
      await remoteStorage.delete(remoteFullPath);
    }
    await remoteStorage.write(remoteFullPath, uploadFileByte);
    return RemoteFile(
      path: await fetchPublicURI(remoteRelativePath),
      bytes: uploadFileByte,
    );
  }
}
