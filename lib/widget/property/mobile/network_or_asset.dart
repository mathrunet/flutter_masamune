part of masamune.property.mobile;

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
      return _MemoizedCachedNetworkImageProvider(
        uri,
        cacheKey: uri,
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HtmlImage,
      );
    } else if (uri.startsWith("/")) {
      final file = File(uri);
      if (file.existsSync()) {
        return _MemoizedFileImage(file);
      } else {
        return _MemoizedAssetImage(uri.trimString("/"));
      }
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
    } else if (uri.startsWith("/")) {
      final file = File(uri);
      if (file.existsSync()) {
        return FileVideoProvider(file);
      } else {
        return AssetVideoProvider(uri.trimString("/"));
      }
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

class _MemoizedCachedNetworkImageProvider
    extends provider.CachedNetworkImageProvider {
  const _MemoizedCachedNetworkImageProvider(
    String url, {
    int? maxHeight,
    int? maxWidth,
    double scale = 1.0,
    Map<String, String>? headers,
    cache_manager.BaseCacheManager? cacheManager,
    String? cacheKey,
    ImageRenderMethodForWeb imageRenderMethodForWeb =
        ImageRenderMethodForWeb.HtmlImage,
  }) : super(
          url,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          scale: scale,
          headers: headers,
          cacheManager: cacheManager,
          cacheKey: cacheKey,
          imageRenderMethodForWeb: imageRenderMethodForWeb,
        );

  @override
  ImageStreamCompleter load(
      CachedNetworkImageProvider key, DecoderCallback decode) {
    final cache = _ImageMomoryCache.getCache(key.cacheKey);
    if (cache != null) {
      return cache;
    }
    return _ImageMomoryCache.setCache(key.cacheKey, super.load(key, decode));
  }
}

class _MemoizedFileImage extends FileImage {
  const _MemoizedFileImage(File file, {double scale = 1.0})
      : super(file, scale: scale);

  @override
  ImageStreamCompleter load(FileImage key, DecoderCallback decode) {
    if (key.file.path.isEmpty) {
      return super.load(key, decode);
    }
    final cache = _ImageMomoryCache.getCache(key.file.path);
    if (cache != null) {
      return cache;
    }
    return _ImageMomoryCache.setCache(key.file.path, super.load(key, decode));
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
