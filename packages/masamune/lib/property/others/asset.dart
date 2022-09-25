part of masamune.property.others;

/// Providing the right provider by choosing between in-network and assets.
class Asset {
  const Asset._();

  /// Load from network or local files or Flutter assets.
  ///
  /// Obtains text data.
  ///
  /// The [uri] is used to identify the file. If the uri starts with "http(s)://", it loads the file from the network.
  ///
  /// If the file starts with "resource://", it is loaded from the asset; otherwise, it is loaded from the asset.
  ///
  /// Request headers can be given when loading from the network by specifying [headers].
  ///
  /// [defaultValue] is the value when [uri] is empty.
  static Future<String> text(
    String uri, {
    Map<String, String>? headers,
    String defaultValue = "",
  }) async {
    if (uri.isEmpty) {
      return defaultValue;
    }
    if (uri.startsWith("http")) {
      final res = await Api.get(uri, headers: headers);
      if (res.statusCode != 200) {
        return defaultValue;
      }
      return res.body;
    } else if (uri.startsWith("resource:")) {
      return await rootBundle
          .loadString(uri.replaceAll(RegExp(r"resource:(//)?"), ""));
    } else {
      return await rootBundle.loadString(uri);
    }
  }

  /// Load from network or local files or Flutter assets.
  ///
  /// Obtains image data.
  ///
  /// The [uri] is used to identify the file. If the uri starts with "http(s)://", it loads the file from the network.
  ///
  /// If the file starts with "resource://", it is loaded from the asset; otherwise, it is loaded from the asset.
  ///
  /// You can select the size to cache by specifying [size].
  ///
  /// [defaultURI] is the path to be read from the asset when [uri] is empty.
  static ImageProvider image(
    String uri, [
    ImageSize size = ImageSize.full,
    String defaultURI = "assets/default.png",
  ]) {
    if (uri.isEmpty) {
      return _MemoizedAssetImage(defaultURI);
    }
    if (uri.startsWith("http") || uri.startsWith("blob:")) {
      return _MemoizedNetworkImage(uri);
    } else if (uri.startsWith("resource:")) {
      return _MemoizedAssetImage(uri.replaceAll(RegExp(r"resource:(//)?"), ""));
    } else {
      return _MemoizedAssetImage(uri);
    }
  }

  /// Load from network or local files or Flutter assets.
  ///
  /// Obtains video data.
  ///
  /// The [uri] is used to identify the file. If the uri starts with "http(s)://", it loads the file from the network.
  ///
  /// If the file starts with "resource://", it is loaded from the asset; otherwise, it is loaded from the asset.
  ///
  /// [defaultURI] is the path to be read from the asset when [uri] is empty.
  static VideoProvider video(
    String uri, [
    String defaultURI = "assets/default.mp4",
  ]) {
    if (uri.isEmpty) {
      return AssetVideoProvider(defaultURI);
    }
    if (uri.startsWith("http") || uri.startsWith("blob:")) {
      return NetworkVideoProvider(uri);
    } else if (uri.startsWith("resource:")) {
      return AssetVideoProvider(uri.replaceAll(RegExp(r"resource:(//)?"), ""));
    } else {
      return AssetVideoProvider(uri);
    }
  }
}

/// Manages the memory cache for images.
class ImageMemoryCache {
  const ImageMemoryCache._();
  static final Map<String, ImageStreamCompleter> _manager = {};
  static final Map<String, ImageStreamCompleterHandle> _managerHandles = {};
  static final List<String> _savedImages = [];

  /// Caches the image of [localUrl] as the image of [remoteUrl].
  static void cacheLocalImageAsRemote({
    required String localUrl,
    required String remoteUrl,
    double scale = 1.0,
  }) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    _setCache(
      remoteUrl,
      MultiFrameImageStreamCompleter(
        chunkEvents: chunkEvents.stream,
        codec: _loadAsync(localUrl, chunkEvents),
        scale: scale,
        debugLabel: localUrl,
      ),
    );
  }

  static Future<ui.Codec> _loadAsync(
    String url,
    StreamController<ImageChunkEvent> chunkEvents,
  ) {
    final Uri resolved = Uri.base.resolve(url);
    // ignore: undefined_function, avoid_dynamic_calls
    return ui.webOnlyInstantiateImageCodecFromUrl(
      resolved,
      chunkCallback: (bytes, total) {
        chunkEvents.add(
          ImageChunkEvent(
            cumulativeBytesLoaded: bytes,
            expectedTotalBytes: total,
          ),
        );
      },
    ) as Future<ui.Codec>;
  }

  static ImageStreamCompleter? _getCache(String? key) {
    if (!Config.isInitialized || key.isEmpty) {
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
    if (!Config.isInitialized || key.isEmpty) {
      return completer;
    }
    if (_savedImages.length == Config.maxCacheImage) {
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
    final cache = ImageMemoryCache._getCache(key.url);
    if (cache != null) {
      return cache;
    }
    return ImageMemoryCache._setCache(key.url, super.load(key, decode));
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
    final cache = ImageMemoryCache._getCache(key.name);
    if (cache != null) {
      return cache;
    }
    return ImageMemoryCache._setCache(key.name, super.load(key, decode));
  }
}

enum ImageSize {
  thumbnail,
  small,
  medium,
  large,
  full,
}

extension ImageSizeExtensions on ImageSize {
  int get limit {
    switch (this) {
      case ImageSize.thumbnail:
        return 128;
      case ImageSize.small:
        return 256;
      case ImageSize.medium:
        return 512;
      case ImageSize.large:
        return 1024;
      case ImageSize.full:
        return 2048;
    }
  }
}
