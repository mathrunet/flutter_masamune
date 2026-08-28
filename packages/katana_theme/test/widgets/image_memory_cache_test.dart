// Dart imports:
import "dart:async";
import "dart:ui" as ui;

// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana_theme/katana_theme.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
    ImageMemoryCache.maximumSize = 0;
    ImageMemoryCache.maximumSize = 50;
  });

  tearDown(() {
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
    ImageMemoryCache.maximumSize = 0;
    ImageMemoryCache.maximumSize = 50;
  });

  test("AppThemeData defaults the image cache size to 50", () {
    expect(AppThemeData().maximumImageCacheSize, 50);
    expect(AppThemeData.light().maximumImageCacheSize, 50);
    expect(AppThemeData.dark().maximumImageCacheSize, 50);
  });

  test("AppThemeData applies the image cache size", () {
    AppThemeData(maximumImageCacheSize: 20).toThemeData();

    expect(ImageMemoryCache.maximumSize, 20);
  });

  test("ImageMemoryCache evicts the oldest image", () {
    final first = _TestImageStreamCompleter();
    final second = _TestImageStreamCompleter();
    final third = _TestImageStreamCompleter();
    ImageMemoryCache.maximumSize = 2;

    ImageMemoryCache.setCache("first", first);
    ImageMemoryCache.setCache("second", second);
    ImageMemoryCache.setCache("third", third);

    expect(ImageMemoryCache.getCache("first"), isNull);
    expect(ImageMemoryCache.getCache("second"), same(second));
    expect(ImageMemoryCache.getCache("third"), same(third));
    expect(first.isDisposed, isTrue);
    expect(second.isDisposed, isFalse);
    expect(third.isDisposed, isFalse);
  });

  test("ImageMemoryCache immediately trims entries when the limit shrinks", () {
    final first = _TestImageStreamCompleter();
    final second = _TestImageStreamCompleter();
    final third = _TestImageStreamCompleter();
    ImageMemoryCache.maximumSize = 3;
    ImageMemoryCache.setCache("first", first);
    ImageMemoryCache.setCache("second", second);
    ImageMemoryCache.setCache("third", third);

    ImageMemoryCache.maximumSize = 1;

    expect(ImageMemoryCache.getCache("first"), isNull);
    expect(ImageMemoryCache.getCache("second"), isNull);
    expect(ImageMemoryCache.getCache("third"), same(third));
    expect(first.isDisposed, isTrue);
    expect(second.isDisposed, isTrue);
    expect(third.isDisposed, isFalse);
  });

  test("ImageMemoryCache can be disabled", () {
    final completer = _TestImageStreamCompleter();
    ImageMemoryCache.maximumSize = 0;

    ImageMemoryCache.setCache("image", completer);

    expect(ImageMemoryCache.getCache("image"), isNull);
    expect(completer.isDisposed, isFalse);
  });

  test("ImageMemoryCache rejects a negative limit", () {
    expect(
      () => ImageMemoryCache.maximumSize = -1,
      throwsArgumentError,
    );
  });

  test("copyWith and lerp preserve the image cache size", () {
    final theme = AppThemeData(maximumImageCacheSize: 20);
    final other = AppThemeData(maximumImageCacheSize: 30);

    expect(
      (theme.copyWith() as AppThemeData).maximumImageCacheSize,
      20,
    );
    expect(
      (theme.copyWith(maximumImageCacheSize: 10) as AppThemeData)
          .maximumImageCacheSize,
      10,
    );
    expect(
      (theme.lerp(other, 0.4) as AppThemeData).maximumImageCacheSize,
      20,
    );
    expect(
      (theme.lerp(other, 0.6) as AppThemeData).maximumImageCacheSize,
      30,
    );
  });

  test("ImageMemoryCacheProvider applies display size and pixel ratio",
      () async {
    final source = _RecordingImageProvider("display-size");
    final provider = ImageMemoryCacheProvider(source);

    final targetSize = await _captureTargetSize(
      provider,
      source,
      configuration: const ImageConfiguration(
        size: Size(40, 30),
        devicePixelRatio: 2,
      ),
      intrinsicWidth: 400,
      intrinsicHeight: 100,
    );

    expect(targetSize?.width, 240);
    expect(targetSize?.height, 60);
  });

  test("ImageMemoryCacheProvider preserves portrait image aspect ratio",
      () async {
    final source = _RecordingImageProvider("portrait");
    final provider = ImageMemoryCacheProvider(source);

    final targetSize = await _captureTargetSize(
      provider,
      source,
      configuration: const ImageConfiguration(
        size: Size(40, 30),
        devicePixelRatio: 2,
      ),
      intrinsicWidth: 100,
      intrinsicHeight: 400,
    );

    expect(targetSize?.width, 80);
    expect(targetSize?.height, 320);
  });

  test("ImageMemoryCacheProvider does not upscale a small image", () async {
    final source = _RecordingImageProvider("small-image");
    final provider = ImageMemoryCacheProvider(source);

    final targetSize = await _captureTargetSize(
      provider,
      source,
      configuration: const ImageConfiguration(
        size: Size(40, 30),
        devicePixelRatio: 2,
      ),
      intrinsicWidth: 20,
      intrinsicHeight: 10,
    );

    expect(targetSize?.width, 20);
    expect(targetSize?.height, 10);
  });

  test("ImageMemoryCacheProvider keeps the original decode without a size",
      () async {
    final source = _RecordingImageProvider("original-size");
    final provider = ImageMemoryCacheProvider(source);

    final targetSize = await _captureTargetSize(
      provider,
      source,
      configuration: ImageConfiguration.empty,
      intrinsicWidth: 400,
      intrinsicHeight: 100,
    );

    expect(targetSize, isNull);
  });

  test("ImageMemoryCacheProvider ignores an invalid display size", () async {
    final source = _RecordingImageProvider("invalid-size");
    final provider = ImageMemoryCacheProvider(source);

    final targetSize = await _captureTargetSize(
      provider,
      source,
      configuration: const ImageConfiguration(
        size: Size(double.infinity, 30),
        devicePixelRatio: 2,
      ),
      intrinsicWidth: 400,
      intrinsicHeight: 100,
    );

    expect(targetSize, isNull);
  });

  test("ImageMemoryCacheProvider can disable decode resizing", () async {
    final source = _RecordingImageProvider("resize-disabled");
    final provider = ImageMemoryCacheProvider(
      source,
      resizeImage: false,
    );

    final targetSize = await _captureTargetSize(
      provider,
      source,
      configuration: const ImageConfiguration(
        size: Size(40, 30),
        devicePixelRatio: 2,
      ),
      intrinsicWidth: 400,
      intrinsicHeight: 100,
    );

    expect(targetSize, isNull);
  });

  test("Asset.image wraps raster images in ImageMemoryCacheProvider", () {
    expect(Asset.image("blob://AA=="), isA<ImageMemoryCacheProvider>());
    expect(Asset.image("assets/image.png"), isA<ImageMemoryCacheProvider>());
    expect(
      Asset.image("assets/image.svg"),
      isNot(isA<ImageMemoryCacheProvider>()),
    );
  });

  test("ImageMemoryCacheProvider caches each physical size separately",
      () async {
    final source = _RecordingImageProvider("cache-key");
    final provider = ImageMemoryCacheProvider(source);
    const firstConfiguration = ImageConfiguration(
      size: Size(40, 30),
      devicePixelRatio: 2,
    );
    const secondConfiguration = ImageConfiguration(
      size: Size(80, 60),
      devicePixelRatio: 2,
    );

    final firstKey = await provider.obtainKey(firstConfiguration);
    final sameKey = await provider.obtainKey(firstConfiguration);
    final secondKey = await provider.obtainKey(secondConfiguration);

    expect(firstKey, equals(sameKey));
    expect(firstKey, isNot(equals(secondKey)));

    // ignore: invalid_use_of_protected_member
    final firstCompleter = provider.loadImage(firstKey, _pendingDecoder);
    // ignore: invalid_use_of_protected_member
    final cachedCompleter = provider.loadImage(sameKey, _pendingDecoder);
    // ignore: invalid_use_of_protected_member
    final secondCompleter = provider.loadImage(secondKey, _pendingDecoder);

    expect(cachedCompleter, same(firstCompleter));
    expect(secondCompleter, isNot(same(firstCompleter)));
    expect(source.loadCount, 2);
  });
}

Future<ui.TargetImageSize?> _captureTargetSize(
  ImageMemoryCacheProvider provider,
  _RecordingImageProvider source, {
  required ImageConfiguration configuration,
  required int intrinsicWidth,
  required int intrinsicHeight,
}) async {
  final key = await provider.obtainKey(configuration);
  ui.TargetImageSize? targetSize;
  // ignore: invalid_use_of_protected_member
  provider.loadImage(
    key,
    (buffer, {getTargetSize}) {
      targetSize = getTargetSize?.call(intrinsicWidth, intrinsicHeight);
      return Completer<ui.Codec>().future;
    },
  );
  final buffer = await ui.ImmutableBuffer.fromUint8List(Uint8List(0));
  unawaited(source.decoder!(buffer));
  buffer.dispose();
  return targetSize;
}

Future<ui.Codec> _pendingDecoder(
  ui.ImmutableBuffer buffer, {
  ui.TargetImageSizeCallback? getTargetSize,
}) {
  return Completer<ui.Codec>().future;
}

class _RecordingImageProvider extends ImageProvider<String> {
  _RecordingImageProvider(this.key);

  final String key;
  ImageDecoderCallback? decoder;
  int loadCount = 0;

  @override
  Future<String> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<String>(key);
  }

  @override
  ImageStreamCompleter loadImage(String key, ImageDecoderCallback decode) {
    loadCount++;
    decoder = decode;
    return _TestImageStreamCompleter();
  }
}

class _TestImageStreamCompleter extends ImageStreamCompleter {
  bool isDisposed = false;

  @override
  void onDisposed() {
    isDisposed = true;
    super.onDisposed();
  }
}
