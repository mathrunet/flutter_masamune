part of "others.dart";

/// Provider to load text files from local and display them in widgets, etc.
///
/// ローカルからテキストファイルをロードしてウィジェット等で表示するためのプロバイダー。
///
/// {@macro text_provider}
class FileTextProvider extends TextProvider {
  /// Provider to load text files from local and display them in widgets, etc.
  ///
  /// ローカルからテキストファイルをロードしてウィジェット等で表示するためのプロバイダー。
  ///
  /// {@macro text_provider}
  FileTextProvider(
    this.path, {
    super.defaultValue,
    this.dirType = FileImageDirType.directory,
  }) {
    _load();
  }

  static const _platformInfo = PlatformInfo();

  /// Paths in the asset.
  ///
  /// アセット内のパス。
  final String path;

  /// Directory type.
  ///
  /// ディレクトリのタイプ。
  final FileImageDirType dirType;

  @override
  String? get value => _value ?? defaultValue;
  String? _value;

  Future<void> _load() async {
    _completer = Completer();
    try {
      late File file;
      if (dirType == FileImageDirType.temporary) {
        final cacheDir = await _platformInfo.getTemporaryDirectory();
        final fileName = path.trimString("/");
        file = File("${cacheDir.path}/$fileName");
      } else if (dirType == FileImageDirType.document) {
        final cacheDir = await _platformInfo.getApplicationDocumentsDirectory();
        final fileName = path.trimString("/");
        file = File("${cacheDir.path}/$fileName");
      } else {
        file = File(path);
      }
      if (file.existsSync()) {
        _value = await file.readAsString();
        notifyListeners();
      } else {
        throw Exception("File not found.");
      }
      _completer?.complete(value);
      _completer = null;
    } catch (e) {
      _value = defaultValue;
      debugPrint(e.toString());
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete(value);
      _completer = null;
    }
  }

  @override
  Future<String?>? get future => _completer?.future;

  Completer<String?>? _completer;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => path.hashCode;
}
