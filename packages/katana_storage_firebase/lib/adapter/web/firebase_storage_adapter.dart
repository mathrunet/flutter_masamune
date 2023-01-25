part of katana_storage_firebase.web;

/// [StorageAdapter] for handling files in Firebase Storage.
///
/// [download] is not available on the Web platform.
///
/// The `https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media` is available at [fetchPublicURI].
///
/// Basically, the default [FirebaseStorage.instance] is used, but it is possible to use a specified authentication database by passing [storage] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// Firebase Storageでファイルを扱うための[StorageAdapter]。
///
/// Webのプラットフォームでは[download]が利用できません。
///
/// [fetchPublicURI]で`https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media`が利用可能です。
///
/// 基本的にデフォルトの[FirebaseStorage.instance]が利用されますが、アダプターの作成時に[storage]を渡すことで指定された認証データベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
@immutable
class FirebaseStorageAdapter extends StorageAdapter {
  /// [StorageAdapter] for handling files in Firebase Storage.
  ///
  /// [download] is not available on the Web platform.
  ///
  /// The `https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media` is available at [fetchPublicURI].
  ///
  /// Basically, the default [FirebaseStorage.instance] is used, but it is possible to use a specified authentication database by passing [storage] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// Firebase Storageでファイルを扱うための[StorageAdapter]。
  ///
  /// Webのプラットフォームでは[download]が利用できません。
  ///
  /// [fetchPublicURI]で`https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media`が利用可能です。
  ///
  /// 基本的にデフォルトの[FirebaseStorage.instance]が利用されますが、アダプターの作成時に[storage]を渡すことで指定された認証データベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  const FirebaseStorageAdapter({
    this.options,
    FirebaseStorage? storage,
  }) : _storage = storage;

  /// You can get an instance of Firebase Storage.
  ///
  /// Firebase Storageのインスタンスを取得できます。
  @protected
  FirebaseStorage get storage {
    return _storage ?? FirebaseStorage.instance;
  }

  final FirebaseStorage? _storage;

  String get _storageBucket => storage.bucket;

  /// Options for initializing Firebase.
  ///
  /// Firebaseを初期化する際のオプション。
  final FirebaseOptions? options;

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePath) async {
    await FirebaseCore.initialize(options: options);
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
    await FirebaseCore.initialize(options: options);
    await reference(relativePath).delete();
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePath, [
    String? localRelativePath,
  ]) async {
    throw UnsupportedError("This feature is not supported.");
  }

  @override
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePath,
  ) async {
    await FirebaseCore.initialize(options: options);
    try {
      assert(localFullPath.isNotEmpty, "Path is empty.");
      if (localFullPath.startsWith("http")) {
        return RemoteFile(path: Uri.parse(localFullPath));
      }
      final byte = await Api.readBytes(localFullPath);
      final uploadTask = reference(remoteRelativePath).putData(byte);
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
    await FirebaseCore.initialize(options: options);
    try {
      assert(uploadFileByte.isNotEmpty, "Bytes is empty.");
      final uploadTask = reference(remoteRelativePath).putData(uploadFileByte);
      await Future.value(uploadTask);
      return RemoteFile(path: await fetchPublicURI(remoteRelativePath));
    } catch (e) {
      rethrow;
    }
  }
}
