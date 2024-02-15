part of 'others.dart';

/// Class that can handle Svg files as [ImageProvider].
///
/// Load Svg from a local file on the terminal.
///
/// Svgファイルを[ImageProvider]として扱えるクラス。
///
/// 端末のローカルファイルからSvgを読み込みます。
class MemoizedFileSvgImageProvider extends _MemoizedSvgImageProvider {
  /// Class that can handle Svg files as [ImageProvider].
  ///
  /// Load Svg from a local file on the terminal.
  ///
  /// Svgファイルを[ImageProvider]として扱えるクラス。
  ///
  /// 端末のローカルファイルからSvgを読み込みます。
  const MemoizedFileSvgImageProvider(
    super.path, {
    super.size,
    super.scale,
    super.color,
    super.dirType,
  }) : super(source: _SvgSource.file);
}

/// Class that can handle Svg files as [ImageProvider].
///
/// Reads Svg from the network.
///
/// Svgファイルを[ImageProvider]として扱えるクラス。
///
/// ネットワークからSvgを読み込みます。
class MemoizedNetworkSvgImageProvider extends _MemoizedSvgImageProvider {
  /// Class that can handle Svg files as [ImageProvider].
  ///
  /// Reads Svg from the network.
  ///
  /// Svgファイルを[ImageProvider]として扱えるクラス。
  ///
  /// ネットワークからSvgを読み込みます。
  const MemoizedNetworkSvgImageProvider(
    super.path, {
    super.size,
    super.scale,
    super.color,
    super.headers,
  }) : super(source: _SvgSource.network);
}

/// Class that can handle Svg files as [ImageProvider].
///
/// Load Svg from appliasset.
///
/// Svgファイルを[ImageProvider]として扱えるクラス。
///
/// アプリアセットからSvgを読み込みます。
class MemoizedAssetSvgImageProvider extends _MemoizedSvgImageProvider {
  const MemoizedAssetSvgImageProvider(
    super.path, {
    super.size,
    super.scale,
    super.color,
  }) : super(source: _SvgSource.asset);
}

enum _SvgSource {
  file,
  asset,
  network,
}

class _MemoizedSvgImageProvider extends ImageProvider<_SvgImageProviderKey> {
  const _MemoizedSvgImageProvider(
    this.path, {
    this.size,
    this.scale,
    this.color,
    this.source = _SvgSource.asset,
    this.headers,
    this.dirType = FileImageDirType.directory,
  });

  final String path;
  final Size? size;
  final Color? color;
  final _SvgSource source;
  final double? scale;
  final Map<String, String>? headers;
  final FileImageDirType dirType;

  static final Map<_SvgImageProviderKey, String> _cache = {};

  @override
  Future<_SvgImageProviderKey> obtainKey(ImageConfiguration configuration) {
    final color = this.color ?? Colors.transparent;
    final scale = this.scale ?? configuration.devicePixelRatio ?? 1.0;
    final logicWidth = size?.width ?? configuration.size?.width ?? 100;
    final logicHeight = size?.height ?? configuration.size?.height ?? 100;

    return SynchronousFuture<_SvgImageProviderKey>(
      _SvgImageProviderKey(
        path: path,
        scale: scale,
        color: color,
        source: source,
        pixelWidth: (logicWidth * scale).round(),
        pixelHeight: (logicHeight * scale).round(),
      ),
    );
  }

  @override
  ImageStreamCompleter loadImage(
      _SvgImageProviderKey key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(
      _loadAsync(key),
    );
  }

  Future<String> _getSvgString(_SvgImageProviderKey key) async {
    if (dirType == FileImageDirType.temporary) {
      final cacheDir = await getTemporaryDirectory();
      final fileName = key.path.trimString("/");
      final file = File("${cacheDir.path}/$fileName");
      key = _SvgImageProviderKey(
        path: file.path,
        scale: key.scale,
        color: key.color,
        pixelWidth: key.pixelWidth,
        pixelHeight: key.pixelHeight,
        source: key.source,
      );
    } else if (dirType == FileImageDirType.document) {
      final cacheDir = await getApplicationDocumentsDirectory();
      final fileName = key.path.trimString("/");
      final file = File("${cacheDir.path}/$fileName");
      key = _SvgImageProviderKey(
        path: file.path,
        scale: key.scale,
        color: key.color,
        pixelWidth: key.pixelWidth,
        pixelHeight: key.pixelHeight,
        source: key.source,
      );
    }
    if (_cache.containsKey(key)) {
      final rawSvg = _cache[key];
      if (rawSvg != null) {
        return rawSvg;
      }
    }
    switch (key.source) {
      case _SvgSource.network:
        final res = await Api.read(key.path, headers: headers);
        _cache[key] = res;
        return res;
      case _SvgSource.asset:
        final res = await rootBundle.loadString(key.path);
        _cache[key] = res;
        return res;
      case _SvgSource.file:
        final res = await File(key.path).readAsString();
        _cache[key] = res;
        return res;
    }
  }

  Future<ImageInfo> _loadAsync(_SvgImageProviderKey key) async {
    final rawSvg = await _getSvgString(key);
    final pictureInfo = await vg.loadPicture(
      SvgStringLoader(rawSvg),
      null,
      clipViewbox: false,
    );
    final image = await pictureInfo.picture.toImage(
      pictureInfo.size.width.round(),
      pictureInfo.size.height.round(),
    );

    return ImageInfo(
      image: image,
      scale: 1.0,
    );
  }

  @override
  String toString() => "$runtimeType(${describeIdentity(path)})";

  // static Color getFilterColor(color) {
  //   if (kIsWeb && color == Colors.transparent) {
  //     return const Color(0x01ffffff);
  //   } else {
  //     return color ?? Colors.transparent;
  //   }
  // }
}

@immutable
class _SvgImageProviderKey {
  const _SvgImageProviderKey({
    required this.path,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.scale,
    required this.source,
    this.color,
  });

  final String path;
  final int pixelWidth;
  final int pixelHeight;
  final Color? color;
  final _SvgSource source;
  final double scale;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is _SvgImageProviderKey &&
        other.path == path &&
        other.pixelWidth == pixelWidth &&
        other.pixelHeight == pixelHeight &&
        other.scale == scale &&
        other.source == source;
  }

  @override
  int get hashCode => Object.hash(path, pixelWidth, pixelHeight, scale, source);

  @override
  String toString() => "${objectRuntimeType(this, "SvgImageKey")}"
      "(path: $path, pixelWidth: $pixelWidth, pixelHeight: $pixelHeight, scale: $scale, source: $source)";
}
