part of katana_theme;

/// {@template text_provider}
/// Provider for loading text data and displaying it in widgets, etc.
///
/// Inherits from [ChangeNotifier] and automatically loads text and notifies after loading is complete.
///
/// The loaded text is stored in [value].
///
/// [AssetTextProvider], etc.
///
/// テキストのデータをロードしてウィジェット等で表示するためのプロバイダー。
///
/// [ChangeNotifier]を継承しており、自動でテキストをロードしロード完了後に通知を行います。
///
/// ロードされたテキストは[value]に格納されます。
///
/// [AssetTextProvider]などがあります。
/// {@endtemplate}
abstract class TextProvider extends ChangeNotifier
    implements ValueListenable<String?> {
  /// {@template text_provider}
  /// Provider for loading text data and displaying it in widgets, etc.
  ///
  /// Inherits from [ChangeNotifier] and automatically loads text and notifies after loading is complete.
  ///
  /// The loaded text is stored in [value].
  ///
  /// [AssetTextProvider], etc.
  ///
  /// テキストのデータをロードしてウィジェット等で表示するためのプロバイダー。
  ///
  /// [ChangeNotifier]を継承しており、自動でテキストをロードしロード完了後に通知を行います。
  ///
  /// ロードされたテキストは[value]に格納されます。
  ///
  /// [AssetTextProvider]などがあります。
  /// {@endtemplate}
  TextProvider();

  /// You can wait when loading.
  ///
  /// The text retrieved when [Future] finishes is returned.
  ///
  /// ロードを行っている際に待つことができます。
  ///
  /// [Future]が終了した際に取得したテキストが返されます。
  Future<String?>? get future;
}

/// Provider to load text files from assets and display them in widgets, etc.
///
/// アセットからテキストファイルをロードしてウィジェット等で表示するためのプロバイダー。
///
/// {@macro text_provider}
class AssetTextProvider extends TextProvider {
  /// Provider to load text files from assets and display them in widgets, etc.
  ///
  /// アセットからテキストファイルをロードしてウィジェット等で表示するためのプロバイダー。
  ///
  /// {@macro text_provider}
  AssetTextProvider(this.path) {
    _load();
  }

  /// Paths in the asset.
  ///
  /// アセット内のパス。
  final String path;

  @override
  String? get value => _value;
  String? _value;

  Future<void> _load() async {
    _completer = Completer();
    try {
      _value = await rootBundle.loadString(path);
      _completer?.complete(value);
      _completer = null;
    } catch (e) {
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
