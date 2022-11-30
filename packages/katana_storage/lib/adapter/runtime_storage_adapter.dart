part of katana_storage;

class RuntimeStorageAdapter extends StorageAdapter {
  const RuntimeStorageAdapter();

  @override
  Future<void> delete(String path) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> download(String fromPath, String toPath) {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  Future<String> fetchDownloadURL() {
    // TODO: implement fetchDownloadURL
    throw UnimplementedError();
  }

  @override
  // TODO: implement publicURL
  String get publicURL => throw UnimplementedError();

  @override
  Future<void> upload(String fromPath, String toPath) {
    // TODO: implement upload
    throw UnimplementedError();
  }

  @override
  Future<void> uploadWithBytes(Uint8List bytes, String toPath) {
    // TODO: implement uploadWithBytes
    throw UnimplementedError();
  }
}
