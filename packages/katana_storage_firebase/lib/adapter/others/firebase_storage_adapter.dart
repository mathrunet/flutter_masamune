part of "others.dart";

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
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.windowsOptions,
    this.macosOptions,
    this.linuxOptions,
    FirebaseStorage? storage,
  })  : _options = options,
        _storage = storage;

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
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePathOrId) async {
    await FirebaseCore.initialize(options: options);
    return Uri.parse(await reference(remoteRelativePathOrId).getDownloadURL());
  }

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePathOrId) async {
    return Uri.parse(
      "https://firebasestorage.googleapis.com/v0/b/$_storageBucket/o/${remoteRelativePathOrId.replaceAll("/", "%2F")}?alt=media",
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
  Future<void> delete(String remoteRelativePathOrId) async {
    await FirebaseCore.initialize(options: options);
    await reference(remoteRelativePathOrId).delete();
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePathOrId, [
    String? localRelativePath,
  ]) async {
    await FirebaseCore.initialize(options: options);
    try {
      if (localRelativePath.isNotEmpty) {
        final localFullPath = await _fetchURI(localRelativePath!);
        final localFile = File(localFullPath);
        if (localFile.existsSync()) {
          final meta = await reference(remoteRelativePathOrId).getMetadata();
          if (localFile.lastModifiedSync().millisecondsSinceEpoch >=
              (meta.updated?.millisecondsSinceEpoch ??
                  Clock.now().millisecondsSinceEpoch)) {
            debugPrint("The latest data in the cache: $remoteRelativePathOrId");
            return LocalFile(
              path: Uri.parse(localFullPath),
              bytes: await localFile.readAsBytes(),
            );
          }
        }
        final downloadTask =
            reference(remoteRelativePathOrId).writeToFile(localFile);
        await Future.value(downloadTask);
        return LocalFile(
          path: Uri.parse(localFullPath),
          bytes: await localFile.readAsBytes(),
        );
      } else {
        final bytes = await reference(remoteRelativePathOrId).getData();
        return LocalFile(bytes: bytes);
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
    await FirebaseCore.initialize(options: options);
    try {
      assert(localFullPath.isNotEmpty, "Path is empty.");
      if (localFullPath.startsWith("http")) {
        return RemoteFile(path: Uri.parse(localFullPath));
      }
      final file = File(localFullPath);
      if (!file.existsSync()) {
        throw Exception("File is not found.");
      }
      final metadata =
          mimeType != null ? SettableMetadata(contentType: mimeType) : null;
      final uploadTask =
          reference(remoteRelativePathOrId).putFile(file, metadata);
      await Future.value(uploadTask);
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
    await FirebaseCore.initialize(options: options);
    try {
      assert(uploadFileByte.isNotEmpty, "Bytes is empty.");
      final metadata =
          mimeType != null ? SettableMetadata(contentType: mimeType) : null;
      final uploadTask =
          reference(remoteRelativePathOrId).putData(uploadFileByte, metadata);
      await Future.value(uploadTask);
      return RemoteFile(path: await fetchPublicURI(remoteRelativePathOrId));
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

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return _storage.hashCode ^ options.hashCode;
  }
}
