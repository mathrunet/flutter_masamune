part of katana_storage_firebase.web;

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
  String fetchPublicURI(String path) {
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
    throw UnsupportedError("This feature is not supported.");
  }

  @override
  Future<void> upload(String fromPath, String toPath) async {
    try {
      assert(fromPath.isNotEmpty, "Path is empty.");
      if (fromPath.startsWith("http")) {
        return;
      }
      final byte = await Api.readBytes(fromPath);
      final uploadTask = reference(toPath).putData(byte);
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
