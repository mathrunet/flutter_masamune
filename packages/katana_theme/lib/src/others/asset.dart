part of katana_theme.others;

/// A class that provides utilities for handling assets without much awareness of their source location (on the network, on the terminal, in the asset folder).
///
/// [Asset.text] allows you to retrieve text from a text file on the network, terminal, or asset.
///
/// [Asset.image] allows you to retrieve image files on the network, terminal, or asset as [ImageProvider].
///
/// アセットのソースの場所（ネットワーク上、端末上、アセットフォルダ内）をあまり意識せず取扱うためのユーティリティを提供するクラス。
///
/// [Asset.text]でネットワーク上や端末、アセット上のテキストファイルからテキストを取り出すことができます。
///
/// [Asset.image]でネットワーク上や端末、アセット上の画像ファイルを[ImageProvider]として取り出すことができます。
class Asset {
  const Asset._();

  /// Obtains text from a text file that exists in [uri].
  ///
  /// If [uri] starts with `http://` or `https://`, a request is made to the network with `GET` to retrieve the text.
  /// In this case, request headers can be added at [headers].
  ///
  /// If [uri] starts with an absolute path of `file://` or `/`, a search is performed on the terminal file path to obtain the text within the file if it exists.
  /// (Not available on the Web)
  ///
  /// If the file is not found, or [uri] starts with `resource://`, search for the file in Flutter's assets folder and retrieve the text in the file.
  ///
  /// If [uri] is empty or the text cannot be retrieved for some reason, [defaultValue] is returned.
  ///
  /// [uri]に存在するテキストファイルからテキストを取得します。
  ///
  /// [uri]が`http://`、`https://`から始まる場合、ネットワークに対して`GET`でリクエストを行いテキストを取得します。
  /// その際[headers]でリクエストヘッダを付与することが可能です。
  ///
  /// [uri]が`file://`、または`/`の絶対パスで始まる場合、端末のファイルパスに対して検索を行い、ファイルが存在するときそのファイル内のテキストを取得します。
  /// （Webでは利用できません）
  ///
  /// ファイルが見つからない場合、もしくは[uri]が`resource://`で始まる場合はFlutterのアセットフォルダからファイルを検索し、そのファイル内のテキストを取得します。
  ///
  /// [uri]が空の場合、もしくはテキストがなにかしらの原因で取得出来なかった場合は[defaultValue]が返されます。
  static Future<String> text(
    String uri, {
    Map<String, String>? headers,
    String defaultValue = "",
  }) async {
    if (uri.isEmpty) {
      return defaultValue;
    }
    try {
      if (uri.startsWith("http")) {
        final res = await Api.get(uri, headers: headers);
        if (res.statusCode != 200) {
          return defaultValue;
        }
        return res.body;
      } else if (uri.startsWith("/") || uri.startsWith("file:")) {
        final file = File(uri.replaceAll(RegExp(r"^file:(//)?"), ""));
        if (file.existsSync()) {
          return await file.readAsString();
        } else {
          return await rootBundle.loadString(uri);
        }
      } else if (uri.startsWith("resource:")) {
        return await rootBundle
            .loadString(uri.replaceAll(RegExp(r"^resource:(//)?"), ""));
      } else {
        return await rootBundle.loadString(uri);
      }
    } catch (e) {
      debugPrint(e.toString());
      return defaultValue;
    }
  }

  /// [ImageProvider] from the image file existing in [uri].
  ///
  /// If [uri] starts with `http://` or `https://`, images existing on the network are downloaded and retrieved.
  /// If you specify the Base64 encoded string of the image binary after `blob://`, you can retrieve the image file as it is.
  ///
  /// If [uri] starts with an absolute path of `file://` or `/`, a search is performed on the terminal file path and the image file is retrieved if the file exists.
  /// (Not available on the Web)
  ///
  /// If the file is not found, or [uri] starts with `resource://`, search for the file in Flutter's assets folder and retrieve the image file.
  ///
  /// If [uri] is empty, or the text cannot be retrieved for some reason, the image file located at [defaultAssetURI] in Flutter's assets folder will be returned. The default is `assets/default.png`.
  ///
  /// [uri]に存在する画像ファイルから[ImageProvider]を取得します。
  ///
  /// [uri]が`http://`、`https://`から始まる場合、ネットワーク上に存在する画像をダウンロードして取得します。
  /// `blob://`の後に画像バイナリのBase64エンコード文字列を指定するとその画像ファイルをそのまま取得することが可能です。
  ///
  /// [uri]が`file://`、または`/`の絶対パスで始まる場合、端末のファイルパスに対して検索を行い、ファイルが存在するときその画像ファイルを取得します。
  /// （Webでは利用できません）
  ///
  /// ファイルが見つからない場合、もしくは[uri]が`resource://`で始まる場合はFlutterのアセットフォルダからファイルを検索し、その画像ファイルを取得します。
  ///
  /// [uri]が空の場合、もしくはテキストがなにかしらの原因で取得出来なかった場合はFlutterのアセットフォルダ内の[defaultAssetURI]に存在する画像ファイルが返されます。デフォルトは`assets/default.png`。
  static ImageProvider image(
    String uri, [
    String defaultAssetURI = "assets/default.png",
  ]) {
    if (uri.isEmpty) {
      return _MemoizedAssetImage(defaultAssetURI);
    }
    try {
      if (uri.startsWith("http") || uri.startsWith("blob:")) {
        return _MemoizedNetworkImage(uri);
      } else if (uri.startsWith("/") || uri.startsWith("file:")) {
        final file = File(uri.replaceAll(RegExp(r"^file:(//)?"), ""));
        if (file.existsSync()) {
          return _MemoizedFileImage(file);
        } else {
          return _MemoizedAssetImage(uri.trimString("/"));
        }
      } else if (uri.startsWith("resource:")) {
        return _MemoizedAssetImage(
            uri.replaceAll(RegExp(r"^resource:(//)?"), ""));
      } else {
        return _MemoizedAssetImage(uri);
      }
    } catch (e) {
      debugPrint(e.toString());
      return _MemoizedAssetImage(defaultAssetURI);
    }
  }
}

class _ImageMemoryCache {
  const _ImageMemoryCache._();

  static int maxCacheImages = 100;
  static final Map<String, ImageStreamCompleter> _manager = {};
  static final Map<String, ImageStreamCompleterHandle> _managerHandles = {};
  static final List<String> _savedImages = [];

  static ImageStreamCompleter? _getCache(String? key) {
    if (key.isEmpty) {
      return null;
    }
    if (_manager.containsKey(key)) {
      return _manager[key]!;
    }
    return null;
  }

  static ImageStreamCompleter _setCache(
    String? key,
    ImageStreamCompleter completer,
  ) {
    if (key.isEmpty) {
      return completer;
    }
    if (_savedImages.length == maxCacheImages) {
      final removedUrl = _savedImages.removeAt(0);
      _manager.remove(removedUrl);
      _managerHandles[removedUrl]?.dispose();
      _managerHandles.remove(removedUrl);
    }
    _savedImages.add(key!);
    _manager[key] = completer;
    _managerHandles[key] = completer.keepAlive();
    return completer;
  }
}

class _MemoizedNetworkImage extends network_image.NetworkImage {
  const _MemoizedNetworkImage(
    String url, {
    double scale = 1.0,
    Map<String, String>? headers,
  }) : super(
          url,
          scale: scale,
          headers: headers,
        );

  @override
  // ignore: deprecated_member_use
  ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
    if (key.url.isEmpty) {
      return super.load(key, decode);
    }
    final cache = _ImageMemoryCache._getCache(key.url);
    if (cache != null) {
      return cache;
    }
    return _ImageMemoryCache._setCache(key.url, super.load(key, decode));
  }
}

class _MemoizedFileImage extends FileImage {
  const _MemoizedFileImage(File file, {double scale = 1.0})
      : super(file, scale: scale);

  @override
  // ignore: deprecated_member_use
  ImageStreamCompleter load(FileImage key, DecoderCallback decode) {
    if (key.file.path.isEmpty) {
      return super.load(key, decode);
    }
    final cache = _ImageMemoryCache._getCache(key.file.path);
    if (cache != null) {
      return cache;
    }
    return _ImageMemoryCache._setCache(key.file.path, super.load(key, decode));
  }
}

class _MemoizedAssetImage extends AssetImage {
  const _MemoizedAssetImage(
    String assetName, {
    AssetBundle? bundle,
    String? package,
  }) : super(
          assetName,
          bundle: bundle,
          package: package,
        );

  @override
  // ignore: deprecated_member_use
  ImageStreamCompleter load(AssetBundleImageKey key, DecoderCallback decode) {
    if (key.name.isEmpty) {
      return super.load(key, decode);
    }
    final cache = _ImageMemoryCache._getCache(key.name);
    if (cache != null) {
      return cache;
    }
    return _ImageMemoryCache._setCache(key.name, super.load(key, decode));
  }
}
