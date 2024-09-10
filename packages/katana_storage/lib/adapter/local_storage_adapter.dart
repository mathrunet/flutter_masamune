part of '/katana_storage.dart';

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
  Future<void> delete(String remoteRelativePathOrId) async {
    await remoteStorage.delete(remoteRelativePathOrId);
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePathOrId, [
    String? localRelativePath,
  ]) async {
    final remoteFullPath = await remoteStorage.fetchURI(remoteRelativePathOrId);
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
      return LocalFile(path: Uri.parse(localFullPath), bytes: bytes);
    } else {
      return LocalFile(bytes: bytes);
    }
  }

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePathOrId) async =>
      fetchPublicURI(remoteRelativePathOrId);

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePathOrId) async {
    return Uri.parse(await remoteStorage.fetchURI(remoteRelativePathOrId));
  }

  @override
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePathOrId, {
    String? mimeType,
  }) async {
    if (!await localStorage.exists(localFullPath)) {
      throw Exception("File could not be found: $localFullPath");
    }
    final bytes = await localStorage.read(localFullPath);
    final remoteFullPath = await remoteStorage.fetchURI(remoteRelativePathOrId);
    if (await remoteStorage.exists(remoteFullPath)) {
      await remoteStorage.delete(remoteFullPath);
    }
    await remoteStorage.write(remoteFullPath, bytes);
    return RemoteFile(
      path: await fetchPublicURI(remoteRelativePathOrId),
      bytes: bytes,
      mimeType: mimeType,
    );
  }

  @override
  Future<RemoteFile> uploadWithBytes(
    Uint8List uploadFileByte,
    String remoteRelativePathOrId, {
    String? mimeType,
  }) async {
    final remoteFullPath = await remoteStorage.fetchURI(remoteRelativePathOrId);
    if (await remoteStorage.exists(remoteFullPath)) {
      await remoteStorage.delete(remoteFullPath);
    }
    await remoteStorage.write(remoteFullPath, uploadFileByte);
    return RemoteFile(
      path: await fetchPublicURI(remoteFullPath),
      bytes: uploadFileByte,
      mimeType: mimeType,
    );
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
