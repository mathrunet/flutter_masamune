part of "web.dart";

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
    throw UnsupportedError("FileTextProvider is not supported on web.");
  }

  /// Paths in the asset.
  ///
  /// アセット内のパス。
  final String path;

  @override
  String? get value => _value ?? defaultValue;
  String? _value;

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
