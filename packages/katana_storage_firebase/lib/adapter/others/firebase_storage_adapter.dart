part of katana_storage_firebase.others;

/// StorageAdapter] for handling files in Firebase Storage.
///
/// [download] is not available on the Web platform.
///
/// The `https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media` is available at [fetchPublicURI].
///
/// Firebase Storageでファイルを扱うための[StorageAdapter]。
///
/// Webのプラットフォームでは[download]が利用できません。
///
/// [fetchPublicURI]で`https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media`が利用可能です。
@immutable
class FirebaseStorageAdapter extends StorageAdapter {
  /// StorageAdapter] for handling files in Firebase Storage.
  ///
  /// [download] is not available on the Web platform.
  ///
  /// The `https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media` is available at [fetchPublicURI].
  ///
  /// Firebase Storageでファイルを扱うための[StorageAdapter]。
  ///
  /// Webのプラットフォームでは[download]が利用できません。
  ///
  /// [fetchPublicURI]で`https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media`が利用可能です。
  const FirebaseStorageAdapter();

  /// You can get an instance of Firebase Storage.
  ///
  /// Firebase Storageのインスタンスを取得できます。
  @protected
  FirebaseStorage get storage {
    return FirebaseStorage.instance;
  }

  String get _storageBucket => storage.bucket;

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePath) async {
    return Uri.parse(await reference(remoteRelativePath).getDownloadURL());
  }

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePath) async {
    return Uri.parse(
      "https://firebasestorage.googleapis.com/v0/b/$_storageBucket/o/$remoteRelativePath?alt=media",
    );
  }

  /// You can get [Reference] of Firebase Storage by passing [path].
  ///
  /// [path]を渡すことでFirebase Storageの[Reference]を取得できます。
  @protected
  Reference reference(String path) {
    return storage.ref().child(path);
  }

  @override
  Future<void> delete(String relativePath) async {
    await reference(relativePath).delete();
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePath, [
    String? localRelativePath,
  ]) async {
    try {
      if (localRelativePath.isNotEmpty) {
        final localFullPath = await _fetchURI(localRelativePath!);
        final localFile = File(localFullPath);
        if (localFile.existsSync()) {
          final meta = await reference(remoteRelativePath).getMetadata();
          if (localFile.lastModifiedSync().millisecondsSinceEpoch >=
              (meta.updated?.millisecondsSinceEpoch ??
                  DateTime.now().millisecondsSinceEpoch)) {
            debugPrint("The latest data in the cache: $remoteRelativePath");
            return LocalFile(
              path: Uri.parse(localFullPath),
              bytes: await localFile.readAsBytes(),
            );
          }
        }
        final downloadTask =
            reference(remoteRelativePath).writeToFile(localFile);
        await Future.value(downloadTask);
        return LocalFile(
          path: Uri.parse(localFullPath),
          bytes: await localFile.readAsBytes(),
        );
      } else {
        final bytes = await reference(remoteRelativePath).getData();
        return LocalFile(bytes: bytes);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePath,
  ) async {
    try {
      assert(localFullPath.isNotEmpty, "Path is empty.");
      if (localFullPath.startsWith("http")) {
        return RemoteFile(path: Uri.parse(localFullPath));
      }
      final file = File(localFullPath);
      if (!file.existsSync()) {
        throw Exception("File is not found.");
      }
      final uploadTask = reference(remoteRelativePath).putFile(file);
      await Future.value(uploadTask);
      return RemoteFile(path: await fetchPublicURI(remoteRelativePath));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RemoteFile> uploadWithBytes(
    Uint8List uploadFileByte,
    String remoteRelativePath,
  ) async {
    try {
      assert(uploadFileByte.isNotEmpty, "Bytes is empty.");
      final uploadTask = reference(remoteRelativePath).putData(uploadFileByte);
      await Future.value(uploadTask);
      return RemoteFile(path: await fetchPublicURI(remoteRelativePath));
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _fetchURI(String fileRelativePath) async =>
      "${await _documentDirectory}/$fileRelativePath";

  static Future<String?> get _documentDirectory async {
    if (Platform.isIOS) {
      return (await getLibraryDirectory()).path;
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }
}
