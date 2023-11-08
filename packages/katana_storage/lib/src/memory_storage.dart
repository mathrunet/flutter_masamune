part of '/katana_storage.dart';

/// Class for using storage functions on runtime memory.
///
/// Basically, it is stored as a map of paths and real data [Uint8List].
///
/// ランタイムメモリ上でストレージ機能を利用するためのクラス。
///
/// 基本的にはパスと実データ[Uint8List]のマップとして保管されます。
class MemoryStorage extends StorageBase {
  /// Class for using storage functions on runtime memory.
  ///
  /// Basically, it is stored as a map of paths and real data [Uint8List].
  ///
  /// ランタイムメモリ上でストレージ機能を利用するためのクラス。
  ///
  /// 基本的にはパスと実データ[Uint8List]のマップとして保管されます。
  MemoryStorage();

  final DynamicMap _data = {};

  /// You can input data directly by passing [rawData].
  ///
  /// [rawData]を渡すことで直接データを入力することができます。
  void setRawData(Map<String, Uint8List> rawData) {
    _data.addAll(rawData);
  }

  @override
  Future<Uint8List> read(String fileFullPath) async {
    fileFullPath = fileFullPath.trimQuery().trimString("/");
    if (!_data.containsKey(fileFullPath)) {
      throw Exception("Data not found: $fileFullPath");
    }
    return _data[fileFullPath];
  }

  @override
  Future<void> write(String fileFullPath, Uint8List bytes) async {
    fileFullPath = fileFullPath.trimQuery().trimString("/");
    _data[fileFullPath] = bytes;
  }

  @override
  Future<void> delete(String fileFullPath) async {
    fileFullPath = fileFullPath.trimQuery().trimString("/");
    _data.remove(fileFullPath);
  }

  @override
  Future<bool> exists(String fileFullPath) async {
    fileFullPath = fileFullPath.trimQuery().trimString("/");
    return _data.containsKey(fileFullPath);
  }

  @override
  Future<String> fetchURI(String fileRelativePath) async => fileRelativePath;
}
