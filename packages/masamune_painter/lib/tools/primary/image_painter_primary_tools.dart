part of "/masamune_painter.dart";

/// Display the menu to select image [PainterTools].
///
/// 画像を選択するメニューを表示する[PainterTools]。
@immutable
class ImagePainterPrimaryTools
    extends PainterVariablePrimaryTools<ImagePaintingValue> {
  /// Display the menu to select image [PainterTools].
  ///
  /// 画像を選択するメニューを表示する[PainterTools]。
  const ImagePainterPrimaryTools({
    required this.blockTools,
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "画像",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Image",
        ),
      ]),
      icon: FontAwesomeIcons.image,
    ),
  });

  /// Tools for selecting image.
  ///
  /// 画像を選択するツール。
  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => "__painter_image__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool is ImagePainterPrimaryTools;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    return Icon(config.icon);
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {
    ref.toggleMode(this);
  }

  @override
  ImagePaintingValue create({
    required Offset point,
    required PaintingProperty property,
    String? uid,
    Uri? uri,
  }) {
    return ImagePaintingValue(
      id: uid ?? uuid(),
      property: property,
      start: point,
      end: point,
      uri: uri,
    );
  }

  @override
  ImagePaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == id) {
      return ImagePaintingValue.fromJson(json);
    }
    return null;
  }

  @override
  DynamicMap? convertToJson(PaintingValue value) {
    if (value is ImagePaintingValue) {
      return value.toJson();
    }
    return null;
  }
}

/// A class for storing image drawing data.
///
/// 画像描画用のデータを格納するクラス。
@immutable
class ImagePaintingValue extends PaintingValue {
  /// A class for storing image drawing data.
  ///
  /// 画像描画用のデータを格納するクラス。
  const ImagePaintingValue({
    required super.id,
    required super.property,
    required super.start,
    required super.end,
    this.uri,
  });

  /// The URI of the image.
  ///
  /// 画像のURI。
  final Uri? uri;

  /// Create a [ImagePaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[ImagePaintingValue]を作成します。
  factory ImagePaintingValue.fromJson(DynamicMap json) {
    final properties = PaintingProperty.fromJson(
      json.getAsMap(PaintingValue.propertyKey),
    );
    final uriString = json.get("uri", "");
    return ImagePaintingValue(
      id: json.get(PaintingValue.idKey, ""),
      property: properties,
      start: Offset(
        json.get(PaintingValue.startXKey, 0.0),
        json.get(PaintingValue.startYKey, 0.0),
      ),
      end: Offset(
        json.get(PaintingValue.endXKey, 0.0),
        json.get(PaintingValue.endYKey, 0.0),
      ),
      uri: uriString.isNotEmpty ? Uri.tryParse(uriString) : null,
    );
  }

  @override
  String get type => "__painter_shape_image__";

  @override
  PaintingValueCategory get category => PaintingValueCategory.image;

  @override
  Rect get rect {
    return Rect.fromPoints(start, end);
  }

  @override
  double get minimumArea => 2500.0;

  @override
  Size get minimumSize => const Size(50, 50);

  @override
  DynamicMap toJson() {
    return {
      PaintingValue.typeKey: type,
      PaintingValue.idKey: id,
      PaintingValue.propertyKey: property.toJson(),
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
      "uri": uri?.toString() ?? "",
    };
  }

  @override
  ImagePaintingValue copyWith({
    Offset? offset,
    PaintingProperty? property,
    Offset? start,
    Offset? end,
    String? id,
    Uri? uri,
  }) {
    return ImagePaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: (start ?? this.start) + (offset ?? Offset.zero),
      end: (end ?? this.end) + (offset ?? Offset.zero),
      uri: uri ?? this.uri,
    );
  }

  @override
  Rect? paint(Canvas canvas) {
    final rect = Rect.fromPoints(start, end);

    if (rect.width.isNaN ||
        rect.height.isNaN ||
        rect.width.isInfinite ||
        rect.height.isInfinite) {
      return null;
    }

    // Draw image if uri is available
    if (uri != null) {
      final image = _imageCache[uri];
      if (image != null) {
        final paint = Paint()..filterQuality = FilterQuality.high;
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          rect,
          paint,
        );
      } else {
        // Load image if not cached
        _loadImage(uri!);
        // Draw placeholder
        _drawPlaceholder(canvas, rect);
      }
    } else {
      // Draw placeholder if no uri
      _drawPlaceholder(canvas, rect);
    }

    // Draw border if foreground color is set
    final foregroundColor = property.foregroundColor;
    final line = property.line;
    if (foregroundColor != null && foregroundColor.a > 0.0 && line != null) {
      final paint = Paint()
        ..color = foregroundColor
        ..strokeWidth = line.strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);
    }
    return rect;
  }

  void _drawPlaceholder(Canvas canvas, Rect rect) {
    final backgroundColor = property.backgroundColor ?? const Color(0xFFE0E0E0);
    final foregroundColor = property.foregroundColor ?? const Color(0xFF9E9E9E);
    final line = property.line;

    // Draw background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, bgPaint);

    // Draw icon
    final iconSize = math.min(rect.width, rect.height) * 0.5;
    final iconRect = Rect.fromCenter(
      center: rect.center,
      width: iconSize,
      height: iconSize,
    );

    final iconPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw simple image icon (mountain with sun)
    final path = Path();
    path.moveTo(iconRect.left, iconRect.bottom);
    path.lineTo(iconRect.left + iconRect.width * 0.3,
        iconRect.top + iconRect.height * 0.4);
    path.lineTo(iconRect.left + iconRect.width * 0.6, iconRect.bottom);
    path.moveTo(iconRect.left + iconRect.width * 0.4, iconRect.bottom);
    path.lineTo(iconRect.right, iconRect.top + iconRect.height * 0.3);
    path.lineTo(iconRect.right, iconRect.bottom);
    canvas.drawPath(path, iconPaint);

    // Draw sun
    canvas.drawCircle(
      Offset(iconRect.right - iconRect.width * 0.25,
          iconRect.top + iconRect.height * 0.25),
      iconRect.width * 0.15,
      iconPaint,
    );

    // Draw border
    if (line != null) {
      final borderPaint = Paint()
        ..color = foregroundColor
        ..strokeWidth = line.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawRect(rect, borderPaint);
    }
  }

  static final Map<Uri, ui.Image> _imageCache = {};
  static final Set<Uri> _loadingImages = {};
  static VoidCallback? _onImageLoaded;

  /// Set the callback to be called when an image is loaded.
  ///
  /// 画像が読み込まれたときに呼び出されるコールバックを設定します。
  static void setOnImageLoaded(VoidCallback? callback) {
    _onImageLoaded = callback;
  }

  static Future<void> _loadImage(Uri uri) async {
    if (_imageCache.containsKey(uri) || _loadingImages.contains(uri)) {
      return;
    }

    _loadingImages.add(uri);

    try {
      final Uint8List bytes;
      if (uri.isScheme("file")) {
        final file = File(uri.toFilePath());
        bytes = await file.readAsBytes();
      } else if (uri.isScheme("http") || uri.isScheme("https")) {
        final response = await http.get(uri);
        bytes = response.bodyBytes;
      } else if (uri.isScheme("data")) {
        final uriData = UriData.fromUri(uri);
        bytes = uriData.contentAsBytes();
      } else {
        _loadingImages.remove(uri);
        return;
      }

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      _imageCache[uri] = frame.image;
      codec.dispose();

      // Notify that image is loaded
      _onImageLoaded?.call();
    } catch (e) {
      // Image load failed, ignore
    } finally {
      _loadingImages.remove(uri);
    }
  }

  /// Clear the image cache.
  ///
  /// 画像キャッシュをクリアします。
  static void clearImageCache() {
    for (final image in _imageCache.values) {
      image.dispose();
    }
    _imageCache.clear();
    _loadingImages.clear();
  }

  @override
  ImagePaintingValue updateOnCreating({
    required Offset startPoint,
    required Offset currentPoint,
  }) {
    return ImagePaintingValue(
      id: id,
      property: property,
      start: startPoint,
      end: currentPoint,
      uri: uri,
    );
  }

  @override
  ImagePaintingValue updateOnMoving({required Offset delta}) {
    return ImagePaintingValue(
      id: id,
      property: property,
      start: start + delta,
      end: end + delta,
      uri: uri,
    );
  }

  @override
  ImagePaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  }) {
    return ImagePaintingValue(
      id: id,
      property: property,
      start: startPoint,
      end: endPoint,
      uri: uri,
    );
  }
}
