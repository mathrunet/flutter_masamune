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
class TextProvider extends ChangeNotifier implements ValueListenable<String?> {
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
  TextProvider({this.defaultValue});

  /// You can wait when loading.
  ///
  /// The text retrieved when [Future] finishes is returned.
  ///
  /// ロードを行っている際に待つことができます。
  ///
  /// [Future]が終了した際に取得したテキストが返されます。
  Future<String?>? get future => null;

  /// Default value if read fails.
  ///
  /// 読み込みに失敗した場合のデフォルトの値。
  final String? defaultValue;

  @override
  String? get value => defaultValue;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => defaultValue.hashCode;
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
  AssetTextProvider(
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
      _value = await rootBundle.loadString(path);
      notifyListeners();
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

/// Provider to load text files from the network and display them in widgets, etc.
///
/// ネットワークからテキストファイルをロードしてウィジェット等で表示するためのプロバイダー。
///
/// {@macro text_provider}
class NetworkTextProvider extends TextProvider {
  /// Provider to load text files from the network and display them in widgets, etc.
  ///
  /// ネットワークからテキストファイルをロードしてウィジェット等で表示するためのプロバイダー。
  ///
  /// {@macro text_provider}
  NetworkTextProvider(
    this.path, {
    this.headers,
    super.defaultValue,
  }) {
    _load();
  }

  /// Paths in the asset.
  ///
  /// アセット内のパス。
  final String path;

  /// Header at request.
  ///
  /// リクエスト時のヘッダ。
  final Map<String, String>? headers;

  @override
  String? get value => _value ?? defaultValue;
  String? _value;

  Future<void> _load() async {
    _completer = Completer();
    try {
      final res = await Api.get(path, headers: headers);
      if (res.statusCode == 200) {
        _value = res.body;
        notifyListeners();
      } else {
        throw Exception("Failed to load text from network.");
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
