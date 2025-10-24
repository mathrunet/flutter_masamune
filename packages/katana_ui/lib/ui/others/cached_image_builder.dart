part of "others.dart";

/// Cached image widget.
///
/// キャッシュされた画像を表示するためのウィジェット。
@immutable
class CachedImageBuilder extends StatefulWidget {
  /// Cached image widget.
  ///
  /// キャッシュされた画像を表示するためのウィジェット。
  const CachedImageBuilder({
    required super.key,
    required this.builder,
    this.width,
    this.height,
    this.showLoadingIndicator = false,
    this.coverBackgroundColor,
    this.enabled = true,
  }) : assert(coverBackgroundColor == null || showLoadingIndicator,
            "coverBackgroundColor is only used when showLoadingIndicator is true");

  /// True if caching is enabled. Default is true.
  ///
  /// キャッシュが有効な場合は`true`。デフォルトは`true`。
  final bool enabled;

  /// Builder that returns the widget to be converted to an image.
  ///
  /// 画像を生成するためのウィジェットを返すビルダー。
  final Widget Function(BuildContext context) builder;

  /// Image width (optional).
  ///
  /// 画像の幅 (オプション)。
  final double? width;

  /// Image height (optional).
  ///
  /// 画像の高さ (オプション)。
  final double? height;

  /// Show loading indicator while caching (optional).
  final bool showLoadingIndicator;

  /// Cover background color (optional).
  ///
  /// 背景色 (オプション)。
  final Color? coverBackgroundColor;

  @override
  State<CachedImageBuilder> createState() => _CachedImageBuilderState();
}

class _CachedImageBuilderState extends State<CachedImageBuilder> {
  File? _cachedImageFile;
  var _isLoading = true;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadOrGenerateImage();
  }

  @override
  void didUpdateWidget(CachedImageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Regenerate if Key has changed
    // (Usually this case does not occur because a new State instance is created when Key changes,
    //  but check just in case)
    if (oldWidget.key != widget.key) {
      _loadOrGenerateImage();
    }
  }

  /// Generate file name from Key.
  String _getCacheFileName() {
    final key = widget.key;
    if (key is ValueKey<String>) {
      return "${key.value}.png";
    }
    // For other Key types, use toString()
    return "${key.toString().replaceAll(RegExp(r"[^\w-]"), "_")}.png";
  }

  Future<void> _loadOrGenerateImage() async {
    setState(() => _isLoading = true);

    try {
      final tempDir = await const PlatformInfo().getTemporaryDirectory();
      final fileName = _getCacheFileName();
      final cacheFile = File("${tempDir.path}/$fileName");

      // Use cache file if it exists
      if (await cacheFile.exists()) {
        setState(() {
          _cachedImageFile = cacheFile;
          _isLoading = false;
        });
        return;
      }

      // Generate if cache does not exist
      await _generateAndSaveImage(cacheFile);
    } catch (e) {
      debugPrint("CachedImageWidget error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateAndSaveImage(File cacheFile) async {
    try {
      // Wait for the next frame to ensure the widget is rendered
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Capture the widget as an image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Save image
      await cacheFile.writeAsBytes(byteData.buffer.asUint8List());

      setState(() {
        _cachedImageFile = cacheFile;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("CachedImageWidget error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Display cached image if available
    final cachedFile = _cachedImageFile;
    if (widget.enabled && cachedFile != null && !_isLoading) {
      return Image.file(
        cachedFile,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.fill,
      );
    }

    // Display loading indicator or original widget while caching
    return Stack(
      children: [
        // Hidden widget for caching (always rendered)
        RepaintBoundary(
          key: _repaintBoundaryKey,
          child: widget.builder(context),
        ),
        // Visible loading indicator or original widget
        if (widget.enabled && widget.showLoadingIndicator)
          Container(
            color: widget.coverBackgroundColor,
            width: widget.width ?? double.infinity,
            height: widget.height ?? double.infinity,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
