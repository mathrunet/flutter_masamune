part of "/masamune_painter.dart";

/// A database for caching media, such as images, to be loaded by a painter.
///
/// Retrieves media with [get] and loads media with [load].
///
/// ペインターで読み込む画像等のメディアをキャッシュするためのデータベース。
///
/// [get] でメディアを取得し、[load] でメディアを読み込みます。
class PainterMediaDatabase extends ChangeNotifier {
  /// A database for caching media, such as images, to be loaded by a painter.
  ///
  /// Retrieves media with [get] and loads media with [load].
  ///
  /// ペインターで読み込む画像等のメディアをキャッシュするためのデータベース。
  ///
  /// [get] でメディアを取得し、[load] でメディアを読み込みます。
  PainterMediaDatabase({
    this.placeholderImagePath = "assets/image.png",
  }) {
    initialize();
  }

  /// Image path for a placeholder when an image is not found.
  ///
  /// 画像が見つからないときのプレースホルダーの画像パス。
  final String placeholderImagePath;

  final Map<String, ui.Image> _values = {};
  final Map<String, Completer<ui.Image?>> _loadingCompleters = {};

  /// Return `true` if the database is initialized.
  ///
  /// データベースが初期化された場合`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  Completer<void>? _initializeCompleter;

  static const PlatformInfo _platformInfo = PlatformInfo();

  /// Initialization will be performed.
  ///
  /// 初期化を行います。
  Future<void> initialize() async {
    if (_initializeCompleter != null) {
      return _initializeCompleter?.future;
    }
    if (initialized) {
      return;
    }
    _initializeCompleter = Completer<void>();
    try {
      await load(placeholderImagePath);
      _initialized = true;
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    } catch (e) {
      _initializeCompleter?.completeError(e);
      _initializeCompleter = null;
      rethrow;
    } finally {
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    }
  }

  /// Get the media from the database.
  ///
  /// データベースからメディアを取得します。
  ui.Image? get(String path, {bool loadWhenNotExists = true}) {
    if (path.isEmpty || !_values.containsKey(path)) {
      return _values[placeholderImagePath];
    }
    if (loadWhenNotExists) {
      load(path);
    }
    return _values[path] ?? _values[placeholderImagePath];
  }

  /// Load the media from the database.
  ///
  /// データベースからメディアを読み込みます。
  Future<ui.Image?> load(String path) async {
    if (path.isEmpty || _values.containsKey(path)) {
      return _values[path] ?? _values[placeholderImagePath];
    }
    final completer = _loadingCompleters[path];
    if (completer != null) {
      return completer.future;
    }

    _loadingCompleters[path] = Completer<ui.Image?>();

    try {
      final Uint8List bytes;
      path = path.trimStringRight("/");
      if (path.startsWith("http")) {
        final res = await Api.get(path);
        bytes = res.bodyBytes;
      } else if (path.startsWith("/") || path.startsWith("file:")) {
        final file = File(path);
        bytes = await file.readAsBytes();
      } else if (path.startsWith("document:")) {
        final documentDir =
            await _platformInfo.getApplicationDocumentsDirectory();
        final file = File(
            "${documentDir.path}/${path.replaceAll(RegExp(r"^document:(//)?"), "").trimStringLeft("/")}");
        bytes = await file.readAsBytes();
      } else if (path.startsWith("temp:")) {
        final tempDir = await _platformInfo.getTemporaryDirectory();
        final file = File(
            "${tempDir.path}/${path.replaceAll(RegExp(r"^temp:(//)?"), "").trimStringLeft("/")}");
        bytes = await file.readAsBytes();
      } else if (path.startsWith("temporary:")) {
        final tempDir = await _platformInfo.getTemporaryDirectory();
        final file = File(
            "${tempDir.path}/${path.replaceAll(RegExp(r"^temporary:(//)?"), "").trimStringLeft("/")}");
        bytes = await file.readAsBytes();
      } else if (path.startsWith("resource:")) {
        final bundle = await rootBundle.load(path
            .replaceAll(RegExp(r"^resource:(//)?"), "")
            .trimStringLeft("/"));
        bytes = bundle.buffer.asUint8List();
      } else {
        final bundle = await rootBundle.load(path
            .replaceAll(RegExp(r"^resource:(//)?"), "")
            .trimStringLeft("/"));
        bytes = bundle.buffer.asUint8List();
      }
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      _values[path] = frame.image;
      codec.dispose();
      notifyListeners();
      _loadingCompleters[path]?.complete(frame.image);
      _loadingCompleters.remove(path);
      return frame.image;
    } catch (e) {
      debugPrint(e.toString());
      _loadingCompleters[path]?.completeError(e);
      _loadingCompleters.remove(path);
      return null;
    } finally {
      _loadingCompleters[path]?.complete(null);
      _loadingCompleters.remove(path);
    }
  }
}
