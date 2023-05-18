part of katana_theme.others;

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
  }) {
    _load();
  }

  /// Paths in the asset.
  ///
  /// アセット内のパス。
  final String path;

  @override
  String? get value => _value ?? defaultValue;
  String? _value;

  Future<void> _load() async {
    _completer = Completer();
    try {
      final file = File(path);
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
