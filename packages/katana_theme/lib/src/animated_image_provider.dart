part of "/katana_theme.dart";

/// A custom [ImageProvider] that periodically switches between and displays multiple [ImageProvider]s.
///
/// Specify the list of images to display using [providers], and specify the switching interval using [duration].
///
/// 複数の[ImageProvider]を定期的に切り替えて表示するカスタム[ImageProvider]。
///
/// [providers]に表示したい画像のリストを指定し、[duration]で切り替え間隔を指定します。
@immutable
class AnimatedImageProvider extends ImageProvider<AnimatedImageProvider> {
  /// A custom [ImageProvider] that periodically switches between and displays multiple [ImageProvider]s.
  ///
  /// Specify the list of images to display using [providers], and specify the switching interval using [duration].
  ///
  /// 複数の[ImageProvider]を定期的に切り替えて表示するカスタム[ImageProvider]。
  ///
  /// [providers]に表示したい画像のリストを指定し、[duration]で切り替え間隔を指定します。
  const AnimatedImageProvider({
    required this.providers,
    this.duration = const Duration(seconds: 1),
  }) : assert(providers.length > 0, "providers must not be empty");

  /// List of images to display.
  ///
  /// 表示する画像のリスト。
  final List<ImageProvider> providers;

  /// Switching interval.
  ///
  /// 切り替え間隔。
  final Duration duration;

  @override
  Future<AnimatedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AnimatedImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    AnimatedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return AnimatedImageStreamCompleter(
      providers: providers,
      duration: duration,
      decode: decode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AnimatedImageProvider &&
        listEquals(other.providers, providers) &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(providers, duration);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'AnimatedImageProvider')}(providers: $providers, duration: $duration)';
}

/// [ImageStreamCompleter] for [AnimatedImageProvider].
///
/// [AnimatedImageProvider]用の[ImageStreamCompleter]。
class AnimatedImageStreamCompleter extends ImageStreamCompleter {
  /// [ImageStreamCompleter] for [AnimatedImageProvider].
  ///
  /// [AnimatedImageProvider]用の[ImageStreamCompleter]。
  AnimatedImageStreamCompleter({
    required this.providers,
    required this.duration,
    required this.decode,
  }) {
    _startAnimation();
  }

  /// List of images to display.
  ///
  /// 表示する画像のリスト。
  final List<ImageProvider> providers;

  /// Switching interval.
  ///
  /// 切り替え間隔。
  final Duration duration;

  /// Decode function.
  ///
  /// デコード関数。
  final ImageDecoderCallback decode;

  Timer? _timer;
  int _currentIndex = 0;
  final List<ui.Image?> _images = [];
  bool _disposed = false;

  void _startAnimation() {
    _images.addAll(List.filled(providers.length, null));
    _loadAllImages();
    _timer = Timer.periodic(duration, (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      _currentIndex = (_currentIndex + 1) % providers.length;
      _notifyCurrentImage();
    });
  }

  Future<void> _loadAllImages() async {
    for (var i = 0; i < providers.length; i++) {
      try {
        final ImageProvider provider = providers[i];
        const ImageConfiguration configuration = ImageConfiguration.empty;
        // ignore: invalid_use_of_protected_member
        final ImageStreamCompleter completer = provider.loadImage(
          await provider.obtainKey(configuration),
          decode,
        );

        completer.addListener(
          ImageStreamListener(
            (ImageInfo info, bool synchronousCall) {
              if (!_disposed) {
                _images[i] = info.image;
                if (i == _currentIndex) {
                  _notifyCurrentImage();
                }
              }
            },
            onError: (exception, stackTrace) {
              if (!_disposed) {
                reportError(
                  context: ErrorDescription("Failed to load image at index $i"),
                  exception: exception,
                  stack: stackTrace,
                );
              }
            },
          ),
        );
      } catch (exception, stackTrace) {
        if (!_disposed) {
          reportError(
            context: ErrorDescription("Failed to load image at index $i"),
            exception: exception,
            stack: stackTrace,
          );
        }
      }
    }
  }

  void _notifyCurrentImage() {
    final ui.Image? currentImage = _images[_currentIndex];
    if (currentImage != null) {
      setImage(
        _AnimatedImageInfo(
          image: currentImage,
          scale: 1.0,
        ),
      );
    }
  }

  @override
  void onDisposed() {
    _disposed = true;
    _timer?.cancel();
    for (final ui.Image? image in _images) {
      image?.dispose();
    }
    super.onDisposed();
  }
}

// ImageInfoがdisposeされると画像が破棄されるため、disposeをオーバーライドして何もしないようにする
class _AnimatedImageInfo extends ImageInfo {
  _AnimatedImageInfo({required super.image, super.scale = 1.0});

  @override
  void dispose() {}
}
