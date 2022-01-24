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
  static ImageProvider image(
    String uri, [
    String defaultURI = "assets/default.png",
    ImageSize size = ImageSize.full,
  ]) {
    if (uri.isEmpty) {
      return _MemoizedAssetImage(defaultURI);
    }
    if (uri.startsWith("http") || uri.startsWith("blob:")) {
      return _MemoizedCachedNetworkImageProvider(
        uri,
        cacheKey: "$uri${size.key}",
        maxHeight: size.limit,
        maxWidth: size.limit,
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
    _setCache(
      remoteUrl,
      MultiFrameImageStreamCompleter(
        codec: _loadAsync(
          localUrl,
          cache_manager.DefaultCacheManager(),
        ),
        scale: scale,
        debugLabel: localUrl,
      ),
    );
  }

  static Future<ui.Codec> _loadAsync(
    String url,
    cache_manager.BaseCacheManager cacheManager,
  ) async {
    if (cacheManager is cache_manager.ImageCacheManager) {
      cacheManager.getImageFile(
        url,
        withProgress: true,
        key: url,
      );
    } else {
      cacheManager.getFileStream(
        url,
        withProgress: true,
        key: url,
      );
    }
    final file = File(url);

    final Uint8List bytes = await file.readAsBytes();

    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance!.imageCache!.evict(url);
      throw StateError('$file is empty and cannot be loaded as an image.');
    }

    return PaintingBinding.instance!.instantiateImageCodec(bytes);
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
    final cache = ImageMemoryCache._getCache(key.cacheKey);
    if (cache != null) {
      return cache;
    }
    return ImageMemoryCache._setCache(key.cacheKey, super.load(key, decode));
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
    final cache = ImageMemoryCache._getCache(key.file.path);
    if (cache != null) {
      return cache;
    }
    return ImageMemoryCache._setCache(key.file.path, super.load(key, decode));
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

  String get key {
    switch (this) {
      case ImageSize.thumbnail:
        return "#thumb";
      case ImageSize.small:
        return "#small";
      case ImageSize.medium:
        return "#medium";
      case ImageSize.large:
        return "#large";
      case ImageSize.full:
        return "";
    }
  }
}
