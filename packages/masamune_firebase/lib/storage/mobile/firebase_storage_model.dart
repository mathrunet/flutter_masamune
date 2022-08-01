part of masamune_firebase.storage.mobile;

/// Class for handling Firebase storage.
///
/// Basically, you specify the [path] of the local file in [upload] and
/// receive the URL after the upload.
///
/// You can then use [Image.network] or similar to display that URL.
///
/// ```
/// final firebaseStorageProvider = read(firebaseStorageProvider("remote path"));
/// final media = firebaseStorageProvider.upload("local path");
/// if(media == null) return;
/// Image.network(media.url);
/// ```
final firebaseStorageProvider =
    ChangeNotifierProvider.family<FirebaseStorageModel, String>(
  (_, path) => FirebaseStorageModel(path),
);

/// Class for handling Firebase storage.
///
/// Basically, you specify the [path] of the local file in [upload] and
/// receive the URL after the upload.
///
/// You can then use [Image.network] or similar to display that URL.
class FirebaseStorageModel extends ValueModel<String?> {
  /// Class for handling Firebase storage.
  ///
  /// Basically, you specify the [path] of the local file in [upload] and
  /// receive the URL after the upload.
  ///
  /// You can then use [Image.network] or similar to display that URL.
  FirebaseStorageModel(this.path) : super(null);

  /// The remote file path.
  @protected
  final String path;

  /// Firebase storage instance.
  @protected
  FirebaseStorage get storage {
    return FirebaseStorage.instance;
  }

  /// Firebase Storage bucket domain.
  @protected
  String get storageBucket => storage.bucket;

  /// URL path to the file.
  String get url =>
      "https://firebasestorage.googleapis.com/v0/b/$storageBucket/o/$path?alt=media";

  /// Reference to Firebase storage.
  @protected
  Reference get reference {
    return storage.ref().child(path);
  }

  /// Perform download.
  ///
  /// Download the file and save it locally.
  ///
  /// Specify [cachePath] and save the downloaded file there.
  Future<FirebaseStorageModel> download(
    String cachePath, {
    Duration timeout = const Duration(seconds: 300),
  }) async {
    assert(path.isNotEmpty, "Path is invalid.");
    assert(cachePath.isNotEmpty, "Cache path is invalid.");
    await _download(cachePath, timeout);
    return this;
  }

  /// Perform upload.
  ///
  /// Put the file to be uploaded from [filePath].
  Future<FirebaseStorageModel> upload(
    String filePath, {
    Duration timeout = const Duration(seconds: 300),
  }) async {
    assert(path.isNotEmpty, "Path is invalid.");
    await _upload(filePath, timeout);
    return this;
  }

  /// Perform upload with bytes.
  ///
  /// Put the file to be uploaded from [bytes].
  Future<FirebaseStorageModel> uploadWithBytes(
    Uint8List bytes, {
    Duration timeout = const Duration(seconds: 300),
  }) async {
    assert(bytes.isNotEmpty, "Bytes is invalid.");
    await _uploadWithBytes(bytes, timeout);
    return this;
  }

  /// Download the file again.
  ///
  /// Specify [cachePath] and save the downloaded file there.
  Future<FirebaseStorageModel> retryDownload(
    String cachePath, {
    Duration timeout = const Duration(
      seconds: 300,
    ),
  }) async {
    assert(cachePath.isNotEmpty, "Cache path is invalid.");
    await _download(cachePath, timeout);
    return this;
  }

  /// Upload the file again.
  ///
  /// Put the file to be uploaded from [filePath].
  Future<FirebaseStorageModel> retryUpload(
    String filePath, {
    Duration timeout = const Duration(seconds: 300),
  }) async {
    await _upload(filePath, timeout);
    return this;
  }

  Future<void> _download(String cachePath, Duration timeout) async {
    try {
      if (!isSignedIn) {
        throw Exception("Firebase is not initialized and authenticated.");
      }
      final cacheFile = File(cachePath);
      if (cacheFile.existsSync()) {
        final meta = await reference.getMetadata().timeout(timeout);
        if (cacheFile.lastModifiedSync().millisecondsSinceEpoch >=
            (meta.updated?.millisecondsSinceEpoch ??
                DateTime.now().millisecondsSinceEpoch)) {
          debugPrint("The latest data in the cache: $path");
          return;
        }
      }
      final downloadTask = reference.writeToFile(cacheFile);
      await Future.value(downloadTask).timeout(timeout);
      value = cachePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _upload(String filePath, Duration timeout) async {
    try {
      if (!isSignedIn) {
        throw Exception("Firebase is not initialized and authenticated.");
      }
      assert(filePath.isNotEmpty, "Path is empty.");
      if (filePath.startsWith("http")) {
        return;
      }
      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception("File is not found.");
      }
      final uploadTask = reference.putFile(file);
      await Future.value(uploadTask).timeout(timeout);
      value = filePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _uploadWithBytes(Uint8List bytes, Duration timeout) async {
    try {
      if (!isSignedIn) {
        throw Exception("Firebase is not initialized and authenticated.");
      }
      assert(bytes.isNotEmpty, "Bytes is empty.");
      final uploadTask = reference.putData(bytes);
      await Future.value(uploadTask).timeout(timeout);
      value = "";
    } catch (e) {
      rethrow;
    }
  }
}
