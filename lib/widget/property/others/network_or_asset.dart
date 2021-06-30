part of masamune.property.others;

/// Providing the right provider by choosing between in-network and assets.
class NetworkOrAsset {
  const NetworkOrAsset._();

  /// Providing the right provider by choosing between in-network and assets.
  ///
  /// Get the provider for the image.
  ///
  /// [uri] is if it starts with http, get a network image,
  /// otherwise get an asset image.
  /// [defaultURI] is the path to be read from the asset when [uri] is empty.
  static ImageProvider image(String uri,
      [String defaultURI = "assets/default.png"]) {
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

  /// Providing the right provider by choosing between in-network and assets.
  ///
  /// Get the provider for the video.
  ///
  /// [uri] is if it starts with http, get a network video,
  /// otherwise get an asset image.
  /// [defaultURI] is the path to be read from the asset when [uri] is empty.
  static VideoProvider video(String uri,
      [String defaultURI = "assets/default.mp4"]) {
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

class _ImageMomoryCache {
  const _ImageMomoryCache();
  static final Map<String, ImageStreamCompleter> _manager = {};
  static final Map<String, ImageStreamCompleterHandle> _managerHandles = {};
  static final List<String> _savedImages = [];

  static ImageStreamCompleter? getCache(String? key) {
    if (!Config.isInitialized || key.isEmpty) {
      return null;
    }
    if (_manager.containsKey(key)) {
      return _manager[key]!;
    }
    return null;
  }

  static ImageStreamCompleter setCache(
      String? key, ImageStreamCompleter completer) {
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
  ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
    if (key.url.isEmpty) {
      return super.load(key, decode);
    }
    final cache = _ImageMomoryCache.getCache(key.url);
    if (cache != null) {
      return cache;
    }
    return _ImageMomoryCache.setCache(key.url, super.load(key, decode));
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
  ImageStreamCompleter load(AssetBundleImageKey key, DecoderCallback decode) {
    if (key.name.isEmpty) {
      return super.load(key, decode);
    }
    final cache = _ImageMomoryCache.getCache(key.name);
    if (cache != null) {
      return cache;
    }
    return _ImageMomoryCache.setCache(key.name, super.load(key, decode));
  }
}
