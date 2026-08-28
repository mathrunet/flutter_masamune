// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana_theme/katana_theme.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    ImageMemoryCache.maximumSize = 0;
    ImageMemoryCache.maximumSize = 50;
  });

  tearDown(() {
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
}

class _TestImageStreamCompleter extends ImageStreamCompleter {
  bool isDisposed = false;

  @override
  void onDisposed() {
    isDisposed = true;
    super.onDisposed();
  }
}
