part of "others.dart";

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
  static TextProvider text(
    String? uri, {
    Map<String, String>? headers,
    String defaultValue = "",
  }) {
    if (uri.isEmpty) {
      return TextProvider(defaultValue: defaultValue);
    }
    try {
      if (uri!.startsWith("http")) {
        return NetworkTextProvider(
          uri,
          headers: headers,
          defaultValue: defaultValue,
        );
      } else if (uri.startsWith("/") || uri.startsWith("file:")) {
        return FileTextProvider(
          uri.replaceAll(RegExp(r"^file:(//)?"), ""),
          defaultValue: defaultValue,
        );
      } else if (uri.startsWith("resource:")) {
        return AssetTextProvider(
          uri.replaceAll(RegExp(r"^resource:(//)?"), ""),
          defaultValue: defaultValue,
        );
      } else {
        return AssetTextProvider(
          uri,
          defaultValue: defaultValue,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return TextProvider(defaultValue: defaultValue);
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
  /// If [uri] is empty, or the text cannot be retrieved for some reason, the image file located at [defaultAssetURI] in Flutter's assets folder will be returned. The default is `assets/image.png`.
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
  /// [uri]が空の場合、もしくはテキストがなにかしらの原因で取得出来なかった場合はFlutterのアセットフォルダ内の[defaultAssetURI]に存在する画像ファイルが返されます。デフォルトは`assets/image.png`。
  static ImageProvider image(
    String? uri, [
    String defaultAssetURI = "assets/image.png",
  ]) {
    if (uri.isEmpty) {
      return _MemoizedAssetImage(defaultAssetURI);
    }
    try {
      if (uri!.startsWith("blob:")) {
        final blob = uri.replaceAll(RegExp(r"^blob:(//)?"), "");
        return MemoryImage(base64Url.decode(blob));
      } else if (uri.startsWith("http")) {
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
    super.url);

  static final HttpClient _sharedHttpClient = HttpClient()
    ..autoUncompress = false;

  static HttpClient get _httpClient {
    HttpClient? client;
    assert(() {
      if (debugNetworkImageHttpClientProvider != null) {
        client = debugNetworkImageHttpClientProvider!();
      }
      return true;
    }());
    return client ?? _sharedHttpClient;
  }

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

  @override
  ImageStreamCompleter loadImage(
      NetworkImage key, ImageDecoderCallback decode) {
    if (key.url.isEmpty) {
      return _loadImage(key, decode);
    }
    final cache = _ImageMemoryCache._getCache(key.url);
    if (cache != null) {
      return cache;
    }
    return _ImageMemoryCache._setCache(key.url, _loadImage(key, decode));
  }

  ImageStreamCompleter _loadImage(
      NetworkImage key, ImageDecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadNetworkAsync(key, chunkEvents, decode: decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>("Image provider", this),
        DiagnosticsProperty<NetworkImage>("Image key", key),
      ],
    );
  }

  Future<ui.Codec> _loadNetworkAsync(
    NetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents, {
    required ImageDecoderCallback decode,
  }) async {
    try {
      assert(key == this);
      final file = await _getLocalFile(key);
      if (file.existsSync()) {
        return _loadFileAsync(key, file: file, decode: decode);
      }

      final Uri resolved = Uri.base.resolve(key.url);

      final HttpClientRequest request = await _httpClient.getUrl(resolved);

      headers?.forEach((String name, String value) {
        request.headers.add(name, value);
      });
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        await response.drain<List<int>>(<int>[]);
        throw NetworkImageLoadException(
            statusCode: response.statusCode, uri: resolved);
      }

      final Uint8List bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (int cumulative, int? total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: cumulative,
            expectedTotalBytes: total,
          ));
        },
      );
      if (bytes.lengthInBytes == 0) {
        throw Exception("NetworkImage is an empty file: $resolved");
      }
      await file.writeAsBytes(bytes);

      final ui.ImmutableBuffer buffer =
          await ui.ImmutableBuffer.fromUint8List(bytes);
      return decode(buffer);
    } catch (e) {
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  Future<ui.Codec> _loadFileAsync(
    NetworkImage key, {
    required File file,
    required ImageDecoderCallback decode,
  }) async {
    final int lengthInBytes = await file.length();
    if (lengthInBytes == 0) {
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError("$file is empty and cannot be loaded as an image.");
    }
    if (file.runtimeType == File) {
      return decode(await ui.ImmutableBuffer.fromFilePath(file.path));
    }
    return decode(
        await ui.ImmutableBuffer.fromUint8List(await file.readAsBytes()));
  }

  Future<File> _getLocalFile(NetworkImage key) async {
    final cacheDir = await getTemporaryDirectory();
    final fileName = key.url.last();
    final ext = fileName.contains(".") ? fileName.last(separator: ".") : null;
    return File(
      "${cacheDir.path}/${fileName.toSHA1()}${ext != null ? ".$ext" : ""}",
    );
  }
}

class _MemoizedFileImage extends FileImage {
  const _MemoizedFileImage(super.file);

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

  @override
  ImageStreamCompleter loadImage(FileImage key, ImageDecoderCallback decode) {
    if (key.file.path.isEmpty) {
      return super.loadImage(key, decode);
    }
    final cache = _ImageMemoryCache._getCache(key.file.path);
    if (cache != null) {
      return cache;
    }
    return _ImageMemoryCache._setCache(
        key.file.path, super.loadImage(key, decode));
  }
}

class _MemoizedAssetImage extends AssetImage {
  const _MemoizedAssetImage(
    super.assetName);

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

  @override
  ImageStreamCompleter loadImage(
      AssetBundleImageKey key, ImageDecoderCallback decode) {
    if (key.name.isEmpty) {
      return super.loadImage(key, decode);
    }
    final cache = _ImageMemoryCache._getCache(key.name);
    if (cache != null) {
      return cache;
    }
    return _ImageMemoryCache._setCache(key.name, super.loadImage(key, decode));
  }
}
