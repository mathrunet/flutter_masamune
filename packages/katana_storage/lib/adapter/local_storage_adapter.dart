part of katana_storage;

/// [StorageAdapter] for handling files in local storage.
///
/// Not available on the Web platform.
///
/// The root folder is [getLibraryDirectory] for IOS and [getApplicationDocumentsDirectory] for others.
///
/// ローカルストレージでファイルを扱うための[StorageAdapter]。
///
/// Webのプラットフォームでは利用できません。
///
/// ルートフォルダはIOSの場合、[getLibraryDirectory]がそれ以外は[getApplicationDocumentsDirectory]が用いられます。
class LocalStorageAdapter extends StorageAdapter {
  /// [StorageAdapter] for handling files in local storage.
  ///
  /// Not available on the Web platform.
  ///
  /// The root folder is [getLibraryDirectory] for IOS and [getApplicationDocumentsDirectory] for others.
  ///
  /// ローカルストレージでファイルを扱うための[StorageAdapter]。
  ///
  /// Webのプラットフォームでは利用できません。
  ///
  /// ルートフォルダはIOSの場合、[getLibraryDirectory]がそれ以外は[getApplicationDocumentsDirectory]が用いられます。
  const LocalStorageAdapter();

  /// Designated remote storage.
  ///
  /// 指定のリモートストレージ。
  FileStorage get remoteStorage => sharedRemoteStorage;

  /// Common remote storage throughout the app.
  ///
  /// アプリ内全体での共通のリモートストレージ。
  static const FileStorage sharedRemoteStorage = FileStorage();

  /// Local Storage.
  ///
  /// ローカルストレージ。
  static const FileStorage localStorage = sharedRemoteStorage;

  @override
  Future<void> delete(String relativePath) async {
    await remoteStorage.delete(relativePath);
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePath, [
    String? localRelativePath,
  ]) async {
    final remoteFullPath = await remoteStorage.fetchURI(remoteRelativePath);
    if (!await remoteStorage.exists(remoteFullPath)) {
      throw Exception("File could not be found: $remoteFullPath");
    }
    final bytes = await remoteStorage.read(remoteFullPath);
    if (localRelativePath.isNotEmpty) {
      final localFullPath = await localStorage.fetchURI(localRelativePath!);
      if (await localStorage.exists(localFullPath)) {
        await localStorage.delete(localFullPath);
      }
      await localStorage.write(localFullPath, bytes);
      return LocalFile._(path: Uri.parse(localFullPath), bytes: bytes);
    } else {
      return LocalFile._(bytes: bytes);
    }
  }

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePath) async =>
      fetchPublicURI(remoteRelativePath);

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePath) async {
    return Uri.parse(await remoteStorage.fetchURI(remoteRelativePath));
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
    if (await remoteStorage.exists(remoteRelativePath)) {
      await remoteStorage.delete(remoteRelativePath);
    }
    await remoteStorage.write(remoteRelativePath, bytes);
    return RemoteFile._(
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
    return RemoteFile._(
      path: await fetchPublicURI(remoteFullPath),
      bytes: uploadFileByte,
    );
  }
}
