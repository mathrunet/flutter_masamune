part of katana_storage;

class MemoryStorage {
  MemoryStorage();

  final DynamicMap _data = {};

  void setRawData(Map<String, Uint8List> rawData) {
    _data.addAll(rawData);
  }

  Future<Uint8List> read(String filePath) async {
    filePath = filePath.trimQuery().trimString("/");
    if (!_data.containsKey(filePath)) {
      throw Exception("Data not found: $filePath");
    }
    return _data[filePath];
  }

  Future<void> write(String filePath, Uint8List bytes) async {
    filePath = filePath.trimQuery().trimString("/");
    _data[filePath] = bytes;
  }

  Future<void> delete(String filePath) async {
    filePath = filePath.trimQuery().trimString("/");
    _data.remove(filePath);
  }

  bool exists(String filePath) {
    filePath = filePath.trimQuery().trimString("/");
    return _data.containsKey(filePath);
  }
}
