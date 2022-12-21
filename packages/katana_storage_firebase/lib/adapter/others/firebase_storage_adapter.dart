part of katana_storage_firebase.others;

@immutable
class FirebaseStorageAdapter extends StorageAdapter {
  const FirebaseStorageAdapter();

  @protected
  FirebaseStorage get storage {
    return FirebaseStorage.instance;
  }

  String get _storageBucket => storage.bucket;

  @override
  Future<String> fetchDownloadURI(String path) {
    return reference(path).getDownloadURL();
  }

  @override
  Future<String> fetchPublicURI(String path) async {
    return "https://firebasestorage.googleapis.com/v0/b/$_storageBucket/o/$path?alt=media";
  }

  @protected
  Reference reference(String path) {
    return storage.ref().child(path);
  }

  @override
  Future<void> delete(String path) async {
    await reference(path).delete();
  }

  @override
  Future<void> download(String fromPath, String toPath) async {
    try {
      final toFile = File(toPath);
      if (toFile.existsSync()) {
        final meta = await reference(fromPath).getMetadata();
        if (toFile.lastModifiedSync().millisecondsSinceEpoch >=
            (meta.updated?.millisecondsSinceEpoch ??
                DateTime.now().millisecondsSinceEpoch)) {
          debugPrint("The latest data in the cache: $fromPath");
          return;
        }
      }
      final downloadTask = reference(fromPath).writeToFile(toFile);
      await Future.value(downloadTask);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> upload(String fromPath, String toPath) async {
    try {
      assert(fromPath.isNotEmpty, "Path is empty.");
      if (fromPath.startsWith("http")) {
        return;
      }
      final file = File(fromPath);
      if (!file.existsSync()) {
        throw Exception("File is not found.");
      }
      final uploadTask = reference(toPath).putFile(file);
      await Future.value(uploadTask);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> uploadWithBytes(Uint8List bytes, String toPath) async {
    try {
      assert(bytes.isNotEmpty, "Bytes is empty.");
      final uploadTask = reference(toPath).putData(bytes);
      await Future.value(uploadTask);
    } catch (e) {
      rethrow;
    }
  }
}
