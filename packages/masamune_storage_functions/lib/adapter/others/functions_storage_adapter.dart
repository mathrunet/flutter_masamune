part of "others.dart";

const String _kDownloadUriKey = "downloadUri";
const String _kPublicUriKey = "publicUri";

/// An adapter that performs file uploads to storage via Firebase Functions.
///
/// It interacts with Functions by executing [StorageFunctionsAction].
///
/// Firebase Functionsを経由してストレージにファイルアップロードを行うアダプター。
///
/// [StorageFunctionsAction]を実行することによりFunctionsとのやりとりを行います。
class FunctionsStorageAdapter extends StorageAdapter {
  /// An adapter that performs file uploads to storage via Firebase Functions.
  ///
  /// It interacts with Functions by executing [StorageFunctionsAction].
  ///
  /// Firebase Functionsを経由してストレージにファイルアップロードを行うアダプター。
  ///
  /// [StorageFunctionsAction]を実行することによりFunctionsとのやりとりを行います。
  const FunctionsStorageAdapter({
    required this.functionsAdapter,
    required this.action,
    FunctionsStorageDatabase? cachedDatabase,
  }) : _cachedDatabase = cachedDatabase;

  static const _platformInfo = PlatformInfo();

  /// Functions adapter.
  ///
  /// Functionsアダプター。
  final FunctionsAdapter functionsAdapter;

  /// Action name.
  ///
  /// アクション名。
  final String action;

  /// Cached database.
  ///
  /// キャッシュデータベース。
  FunctionsStorageDatabase get cachedDatabase {
    final database = _cachedDatabase ?? sharedCachedDatabase;
    return database;
  }

  final FunctionsStorageDatabase? _cachedDatabase;

  /// Shared cached database.
  ///
  /// 共有キャッシュデータベース。
  static final FunctionsStorageDatabase sharedCachedDatabase =
      FunctionsStorageDatabase();

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePathOrId) async {
    final item = cachedDatabase.get(remoteRelativePathOrId);
    final downloadUri = item?.meta?.get(_kDownloadUriKey, nullOfString);
    if (downloadUri != null) {
      return Uri.parse(downloadUri);
    }
    throw Exception("Download URI is not found.");
  }

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePathOrId) async {
    final item = cachedDatabase.get(remoteRelativePathOrId);
    final publicUri = item?.meta?.get(_kPublicUriKey, nullOfString);
    if (publicUri != null) {
      return Uri.parse(publicUri);
    }
    throw Exception("Public URI is not found.");
  }

  @override
  Future<void> delete(String remoteRelativePathOrId) async {
    final res = await functionsAdapter.execute(StorageFunctionsAction(
      action: action,
      path: remoteRelativePathOrId,
      method: ApiMethod.delete,
    ));
    if (!res.status.toString().startsWith("2")) {
      throw Exception("Delete failed.");
    }
    cachedDatabase.remove(remoteRelativePathOrId);
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePathOrId, [
    String? localRelativePath,
  ]) async {
    try {
      final item = cachedDatabase.get(remoteRelativePathOrId);
      if (item != null && item.data != null) {
        if (localRelativePath.isNotEmpty) {
          final localFullPath = await _fetchURI(localRelativePath!);
          final localFile = File(localFullPath);
          await localFile.writeAsBytes(item.data!);
          return LocalFile(
            path: Uri.parse(localFullPath),
            bytes: item.data!,
          );
        }
        return LocalFile(
          bytes: item.data!,
        );
      }
      if (localRelativePath.isNotEmpty) {
        final localFullPath = await _fetchURI(localRelativePath!);
        final localFile = File(localFullPath);
        if (localFile.existsSync()) {
          return LocalFile(
            path: Uri.parse(localFullPath),
            bytes: await localFile.readAsBytes(),
          );
        }
        final res = await functionsAdapter.execute(StorageFunctionsAction(
          action: action,
          path: remoteRelativePathOrId,
          method: ApiMethod.get,
        ));
        if (!res.status.toString().startsWith("2") || res.binary == null) {
          throw Exception("Download failed.");
        }
        cachedDatabase.add(
          remoteRelativePathOrId,
          data: res.binary,
          meta: res.meta,
        );
        await localFile.writeAsBytes(res.binary!);
        return LocalFile(
          path: Uri.parse(localFullPath),
          bytes: res.binary!,
        );
      } else {
        final res = await functionsAdapter.execute(StorageFunctionsAction(
          action: action,
          path: remoteRelativePathOrId,
          method: ApiMethod.get,
        ));
        if (!res.status.toString().startsWith("2") || res.binary == null) {
          throw Exception("Download failed.");
        }
        cachedDatabase.add(
          remoteRelativePathOrId,
          data: res.binary,
          meta: res.meta,
        );
        return LocalFile(
          bytes: res.binary!,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePathOrId, {
    String? mimeType,
  }) async {
    try {
      assert(localFullPath.isNotEmpty, "Path is empty.");
      if (localFullPath.startsWith("http")) {
        return RemoteFile(path: Uri.parse(localFullPath));
      }
      final file = File(localFullPath);
      if (!file.existsSync()) {
        throw Exception("File is not found.");
      }
      final res = await functionsAdapter.execute(StorageFunctionsAction(
        action: action,
        path: remoteRelativePathOrId,
        method: ApiMethod.post,
        meta: mimeType != null ? {"contentType": mimeType} : null,
        binary: await file.readAsBytes(),
      ));
      if (!res.status.toString().startsWith("2")) {
        throw Exception("Upload failed.");
      }
      cachedDatabase.add(
        remoteRelativePathOrId,
        data: res.binary,
        meta: res.meta,
      );
      return RemoteFile(path: await fetchPublicURI(remoteRelativePathOrId));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RemoteFile> uploadWithBytes(
    Uint8List uploadFileByte,
    String remoteRelativePathOrId, {
    String? mimeType,
  }) async {
    try {
      assert(uploadFileByte.isNotEmpty, "Bytes is empty.");
      final res = await functionsAdapter.execute(StorageFunctionsAction(
        action: action,
        path: remoteRelativePathOrId,
        method: ApiMethod.post,
        meta: mimeType != null ? {"contentType": mimeType} : null,
        binary: uploadFileByte,
      ));
      if (!res.status.toString().startsWith("2")) {
        throw Exception("Upload failed.");
      }
      cachedDatabase.add(
        remoteRelativePathOrId,
        data: res.binary,
        meta: res.meta,
      );
      return RemoteFile(path: await fetchPublicURI(remoteRelativePathOrId));
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _fetchURI(String fileRelativePath) async =>
      "${await _documentDirectory}/$fileRelativePath";

  static Future<String?> get _documentDirectory async {
    if (_platformInfo.isIOS) {
      return (await _platformInfo.getLibraryDirectory()).path;
    } else {
      return (await _platformInfo.getApplicationDocumentsDirectory()).path;
    }
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode ^ action.hashCode ^ functionsAdapter.hashCode;
  }
}
