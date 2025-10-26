part of "/masamune_painter.dart";

/// The type of the painting value.
///
/// 描画用のデータの型。
enum PaintingValueCategory {
  /// Text.
  ///
  /// テキスト。
  text,

  /// Shape.
  ///
  /// 図形。
  shape,

  /// Image.
  ///
  /// 画像。
  image,
}

/// A class for storing drawing data.
///
/// 描画用のデータを格納するクラス。
@immutable
abstract class PaintingValue {
  /// A class for storing drawing data.
  ///
  /// 描画用のデータを格納するクラス。
  const PaintingValue({
    required this.id,
    required this.start,
    required this.end,
    required this.property,
    this.name,
  });

  /// The type of the painting value.
  ///
  /// 描画用のデータの型。
  String get type;

  /// The category of the painting value.
  ///
  /// 描画用のデータのカテゴリ。
  PaintingValueCategory get category;

  /// Convert the painting value to a JSON object.
  ///
  /// 描画用のデータをJSONオブジェクトに変換します。
  DynamicMap toJson();

  /// Convert the painting value to a test JSON object.
  ///
  /// 描画用のデータをテスト用のJSONオブジェクトに変換します。
  DynamicMap toDebug();

  /// Object's area (rectangle).
  ///
  /// オブジェクトのエリア（四角）。
  Rect get rect;

  /// The id of the painting value.
  ///
  /// 描画用のデータのID。
  final String id;

  /// The name of the painting value.
  ///
  /// 描画用のデータの名前。
  final String? name;

  /// The property of the painting value.
  ///
  /// 描画用のデータのプロパティ。
  final PaintingProperty property;

  /// The start point of the area.
  ///
  /// エリアの四角形の開始点。
  final Offset start;

  /// The end point of the area.
  ///
  /// エリアの四角形の終了点。
  final Offset end;

  /// The key for the type.
  ///
  /// 描画用のデータの型のキー。
  static const String typeKey = "type";

  /// The key for the id.
  ///
  /// 描画用のデータのIDのキー。
  static const String idKey = "id";

  /// The key for the name.
  ///
  /// 描画用のデータの名前のキー。
  static const String nameKey = "name";

  /// The key for the property.
  ///
  /// 描画用のデータのプロパティのキー。
  static const String propertyKey = "property";

  /// The key for the start.
  ///
  /// 描画用のデータの開始点のキー。
  static const String startXKey = "startX";

  /// The key for the start.
  ///
  /// 描画用のデータの開始点のキー。
  static const String startYKey = "startY";

  /// The key for the end.
  ///
  /// 描画用のデータの終了点のキー。
  static const String endXKey = "endX";

  /// The key for the end.
  ///
  /// 描画用のデータの終了点のキー。
  static const String endYKey = "endY";

  /// The key for the path.
  ///
  /// 描画用のデータのパスのキー。
  static const String pathKey = "path";

  /// The key for the children.
  ///
  /// 子要素のキー。
  static const String childrenKey = "children";

  /// The key for the isExpanded.
  ///
  /// 展開状態のキー。
  static const String expandedKey = "expanded";

  /// The icon of the painting value.
  ///
  /// 描画用のデータのアイコン。
  Widget get icon;

  /// Updating data being created (while dragging).
  ///
  /// 作成中（ドラッグ中）のデータの更新をします。
  PaintingValue updateOnCreating({
    required Offset startPoint,
    required Offset currentPoint,
  });

  /// Updating data being moved (while dragging).
  ///
  /// 移動中（ドラッグ中）のデータの更新をします。
  PaintingValue updateOnMoving({
    required Offset delta,
  });

  /// Updating data being resized (while dragging).
  ///
  /// リサイズ中（ドラッグ中）のデータの更新をします。
  PaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  });

  /// Pasting the painting value.
  ///
  /// 描画用のデータをペーストします。
  PaintingValue copyWith({
    Offset? offset,
    String? id,
    PaintingProperty? property,
    Offset? start,
    Offset? end,
    String? name,
  });

  /// Painting the painting value.
  ///
  /// 描画用のデータを描画します。
  Rect? paint(Canvas canvas);

  /// The minimum rectangle of the painting value.
  ///
  /// 描画用のデータの最小四角形。
  Size get minimumSize;

  /// Minimum area (height x width) for drawing data.
  ///
  /// 描画用のデータの縦✕横の最小面積。
  double get minimumArea;

  // 作成中の最小サイズオフセットを取得します。
  Offset _getMinimumSizeOffsetOnCreating(
    Offset startPoint,
    Offset currentPoint,
  ) {
    // startPointからcurrentPointへの差分を計算
    final dx = currentPoint.dx - startPoint.dx;
    final dy = currentPoint.dy - startPoint.dy;

    // 幅と高さの絶対値を計算
    var width = dx.abs();
    var height = dy.abs();

    // 最小サイズ制約を適用
    if (width < minimumSize.width) {
      width = minimumSize.width;
    }
    if (height < minimumSize.height) {
      height = minimumSize.height;
    }

    // 最小面積制約を確認し、必要に応じて調整
    final area = width * height;
    if (area < minimumArea) {
      // アスペクト比を維持しながら最小面積を満たすようスケール
      final scale = math.sqrt(minimumArea / area);
      width *= scale;
      height *= scale;
    }

    // 方向を維持しながら新しいendPointを計算
    final adjustedEndX = startPoint.dx + (dx >= 0 ? width : -width);
    final adjustedEndY = startPoint.dy + (dy >= 0 ? height : -height);

    return Offset(adjustedEndX, adjustedEndY);
  }

  // リサイズ中の最小サイズオフセットを取得します。
  ({Offset startPoint, Offset endPoint}) _getMinimumSizeOffsetOnResizing(
    Offset currentPoint,
    PainterResizeDirection direction,
  ) {
    var newStart = start;
    var newEnd = end;

    switch (direction) {
      case PainterResizeDirection.topLeft:
        // 右下を固定点として、左上をドラッグ
        final currentRect = rect;
        final aspectRatio = currentRect.width / currentRect.height;
        final fixedPoint = Offset(currentRect.right, currentRect.bottom);
        var newWidth = (fixedPoint.dx - currentPoint.dx).abs();
        var newHeight = newWidth / aspectRatio;

        // 最小サイズ制約を適用
        if (newWidth < minimumSize.width) {
          newWidth = minimumSize.width;
          newHeight = newWidth / aspectRatio;
        }
        if (newHeight < minimumSize.height) {
          newHeight = minimumSize.height;
          newWidth = newHeight * aspectRatio;
        }

        // 最小面積制約を確認
        final area = newWidth * newHeight;
        if (area < minimumArea) {
          final scale = math.sqrt(minimumArea / area);
          newWidth *= scale;
          newHeight *= scale;
        }

        newStart = Offset(
          fixedPoint.dx - newWidth,
          fixedPoint.dy - newHeight,
        );
        newEnd = fixedPoint;
        break;
      case PainterResizeDirection.topRight:
        // 左下を固定点として、右上をドラッグ
        final currentRect = rect;
        final aspectRatio = currentRect.width / currentRect.height;
        final fixedPoint = Offset(currentRect.left, currentRect.bottom);
        var newWidth = (currentPoint.dx - fixedPoint.dx).abs();
        var newHeight = newWidth / aspectRatio;

        // 最小サイズ制約を適用
        if (newWidth < minimumSize.width) {
          newWidth = minimumSize.width;
          newHeight = newWidth / aspectRatio;
        }
        if (newHeight < minimumSize.height) {
          newHeight = minimumSize.height;
          newWidth = newHeight * aspectRatio;
        }

        // 最小面積制約を確認
        final area = newWidth * newHeight;
        if (area < minimumArea) {
          final scale = math.sqrt(minimumArea / area);
          newWidth *= scale;
          newHeight *= scale;
        }

        newStart = fixedPoint;
        newEnd = Offset(
          fixedPoint.dx + newWidth,
          fixedPoint.dy - newHeight,
        );
        break;
      case PainterResizeDirection.bottomLeft:
        // 右上を固定点として、左下をドラッグ
        final currentRect = rect;
        final aspectRatio = currentRect.width / currentRect.height;
        final fixedPoint = Offset(currentRect.right, currentRect.top);
        var newWidth = (fixedPoint.dx - currentPoint.dx).abs();
        var newHeight = newWidth / aspectRatio;

        // 最小サイズ制約を適用
        if (newWidth < minimumSize.width) {
          newWidth = minimumSize.width;
          newHeight = newWidth / aspectRatio;
        }
        if (newHeight < minimumSize.height) {
          newHeight = minimumSize.height;
          newWidth = newHeight * aspectRatio;
        }

        // 最小面積制約を確認
        final area = newWidth * newHeight;
        if (area < minimumArea) {
          final scale = math.sqrt(minimumArea / area);
          newWidth *= scale;
          newHeight *= scale;
        }

        newStart = Offset(
          fixedPoint.dx - newWidth,
          fixedPoint.dy,
        );
        newEnd = Offset(
          fixedPoint.dx,
          fixedPoint.dy + newHeight,
        );
        break;
      case PainterResizeDirection.bottomRight:
        // 左上を固定点として、右下をドラッグ
        final currentRect = rect;
        final aspectRatio = currentRect.width / currentRect.height;
        final fixedPoint = Offset(currentRect.left, currentRect.top);
        var newWidth = (currentPoint.dx - fixedPoint.dx).abs();
        var newHeight = newWidth / aspectRatio;

        // 最小サイズ制約を適用
        if (newWidth < minimumSize.width) {
          newWidth = minimumSize.width;
          newHeight = newWidth / aspectRatio;
        }
        if (newHeight < minimumSize.height) {
          newHeight = minimumSize.height;
          newWidth = newHeight * aspectRatio;
        }

        // 最小面積制約を確認
        final area = newWidth * newHeight;
        if (area < minimumArea) {
          final scale = math.sqrt(minimumArea / area);
          newWidth *= scale;
          newHeight *= scale;
        }

        newStart = fixedPoint;
        newEnd = Offset(
          fixedPoint.dx + newWidth,
          fixedPoint.dy + newHeight,
        );
        break;
      case PainterResizeDirection.left:
        // 左辺をドラッグ（右辺は固定）
        final currentRect = rect;
        var newX = currentPoint.dx;
        final rightX = currentRect.right;

        // 最小幅を確保
        if ((rightX - newX).abs() < minimumSize.width) {
          newX = rightX - minimumSize.width;
        }

        // 最小面積を確保
        final height = currentRect.height;
        final width = (rightX - newX).abs();
        if (width * height < minimumArea) {
          final minWidth = minimumArea / height;
          newX = rightX - minWidth;
        }

        newStart = Offset(newX, currentRect.top);
        newEnd = Offset(currentRect.right, currentRect.bottom);
        break;
      case PainterResizeDirection.right:
        // 右辺をドラッグ（左辺は固定）
        final currentRect = rect;
        var newX = currentPoint.dx;
        final leftX = currentRect.left;

        // 最小幅を確保
        if ((newX - leftX).abs() < minimumSize.width) {
          newX = leftX + minimumSize.width;
        }

        // 最小面積を確保
        final height = currentRect.height;
        final width = (newX - leftX).abs();
        if (width * height < minimumArea) {
          final minWidth = minimumArea / height;
          newX = leftX + minWidth;
        }

        newStart = Offset(currentRect.left, currentRect.top);
        newEnd = Offset(newX, currentRect.bottom);
        break;
      case PainterResizeDirection.top:
        // 上辺をドラッグ（下辺は固定）
        final currentRect = rect;
        var newY = currentPoint.dy;
        final bottomY = currentRect.bottom;

        // 最小高さを確保
        if ((bottomY - newY).abs() < minimumSize.height) {
          newY = bottomY - minimumSize.height;
        }

        // 最小面積を確保
        final width = currentRect.width;
        final height = (bottomY - newY).abs();
        if (width * height < minimumArea) {
          final minHeight = minimumArea / width;
          newY = bottomY - minHeight;
        }

        newStart = Offset(currentRect.left, newY);
        newEnd = Offset(currentRect.right, currentRect.bottom);
        break;
      case PainterResizeDirection.bottom:
        // 下辺をドラッグ（上辺は固定）
        final currentRect = rect;
        var newY = currentPoint.dy;
        final topY = currentRect.top;

        // 最小高さを確保
        if ((newY - topY).abs() < minimumSize.height) {
          newY = topY + minimumSize.height;
        }

        // 最小面積を確保
        final width = currentRect.width;
        final height = (newY - topY).abs();
        if (width * height < minimumArea) {
          final minHeight = minimumArea / width;
          newY = topY + minHeight;
        }

        newStart = Offset(currentRect.left, currentRect.top);
        newEnd = Offset(currentRect.right, newY);
        break;
    }

    return (startPoint: newStart, endPoint: newEnd);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PaintingValue && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

/// Property of [PaintingValue].
///
/// [PaintingValue]のプロパティ。
@immutable
class PaintingProperty {
  /// Property of [PaintingValue].
  ///
  /// [PaintingValue]のプロパティ。
  const PaintingProperty({
    this.backgroundColor,
    this.foregroundColor,
    this.line,
    this.fontSize,
    this.fontStyle,
    this.paragraphAlign,
  });

  /// Create a [PaintingProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[PaintingProperty]を作成します。
  factory PaintingProperty.fromJson(DynamicMap json) {
    final backgroundColor = json.get(backgroundColorKey, nullOfNum)?.toInt();
    final foregroundColor = json.get(foregroundColorKey, nullOfNum)?.toInt();
    final line = PainterMasamuneAdapter.findTool<PainterLineBlockTools>(
      toolId: json.get(lineKey, ""),
      recursive: true,
    );
    final fontSize = PainterMasamuneAdapter.findTool<PainterFontSizeBlockTools>(
      toolId: json.get(fontSizeKey, ""),
      recursive: true,
    );
    final fontStyle =
        PainterMasamuneAdapter.findTool<PainterFontStyleBlockTools>(
      toolId: json.get(fontStyleKey, ""),
      recursive: true,
    );
    final paragraphAlign =
        PainterMasamuneAdapter.findTool<PainterParagraphAlignBlockTools>(
      toolId: json.get(paragraphAlignKey, ""),
      recursive: true,
    );

    return PaintingProperty(
      backgroundColor: backgroundColor != null ? Color(backgroundColor) : null,
      foregroundColor: foregroundColor != null ? Color(foregroundColor) : null,
      line: line,
      fontSize: fontSize,
      fontStyle: fontStyle,
      paragraphAlign: paragraphAlign,
    );
  }

  /// The key for the color.
  ///
  /// 描画用のデータの色のキー。
  static const String backgroundColorKey = "backgroundColor";

  /// The key for the foreground color.
  ///
  /// 描画用のデータの前景色のキー。
  static const String foregroundColorKey = "foregroundColor";

  /// Key for drawing line data.
  ///
  /// 描画用のラインデータのキー。
  static const String lineKey = "line";

  /// Key for drawing font size data.
  ///
  /// 描画用のフォントサイズデータのキー。
  static const String fontSizeKey = "fontSize";

  /// Key for drawing font style data.
  ///
  /// 描画用のフォントスタイルデータのキー。
  static const String fontStyleKey = "fontStyle";

  /// Key for drawing paragraph align data.
  ///
  /// 描画用の段落揃えデータのキー。
  static const String paragraphAlignKey = "paragraphAlign";

  /// The color of the painting value.
  ///
  /// 描画用のデータの色。
  final Color? backgroundColor;

  /// The foreground color of the painting value.
  ///
  /// 描画用のデータの前景色。
  final Color? foregroundColor;

  /// The line of the painting value.
  ///
  /// 描画用のラインデータ。
  final PainterLineBlockTools? line;

  /// The font size of the painting value.
  ///
  /// 描画用のフォントサイズデータ。
  final PainterFontSizeBlockTools? fontSize;

  /// The font style of the painting value.
  ///
  /// 描画用のフォントスタイルデータ。
  final PainterFontStyleBlockTools? fontStyle;

  /// The paragraph align of the painting value.
  ///
  /// 描画用の段落揃えデータ。
  final PainterParagraphAlignBlockTools? paragraphAlign;

  /// Convert the painting property to a JSON object.
  ///
  /// 描画用のデータのプロパティをJSONオブジェクトに変換します。
  DynamicMap toJson() {
    return {
      backgroundColorKey: backgroundColor?.toInt(),
      foregroundColorKey: foregroundColor?.toInt(),
      lineKey: line?.id,
      fontSizeKey: fontSize?.id,
      fontStyleKey: fontStyle?.id,
      paragraphAlignKey: paragraphAlign?.id,
    };
  }

  /// Copy the painting property with the given fields.
  ///
  /// 描画用のデータのプロパティをコピーします。
  PaintingProperty copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    PainterLineBlockTools? line,
    PainterFontSizeBlockTools? fontSize,
    PainterFontStyleBlockTools? fontStyle,
    PainterParagraphAlignBlockTools? paragraphAlign,
  }) {
    return PaintingProperty(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      line: line ?? this.line,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      paragraphAlign: paragraphAlign ?? this.paragraphAlign,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PaintingProperty &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.line == line &&
        other.fontSize == fontSize &&
        other.fontStyle == fontStyle &&
        other.paragraphAlign == paragraphAlign;
  }

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      foregroundColor.hashCode ^
      line.hashCode ^
      fontSize.hashCode ^
      fontStyle.hashCode ^
      paragraphAlign.hashCode;
}

/// Extension methods for [List<PaintingValue>].
///
/// [List<PaintingValue>]の拡張メソッド。
extension PaintingValueListExtension on List<PaintingValue> {
  /// Convert the painting value list to a JSON object.
  ///
  /// 描画用のデータリストをJSONオブジェクトに変換します。
  List<DynamicMap> toJson() {
    return map((value) => value.toJson()).toList();
  }

  /// Convert the painting value list to a test JSON object.
  ///
  /// 描画用のデータリストをテスト用のJSONオブジェクトに変換します。
  List<DynamicMap> toDebug() {
    return map((value) => value.toDebug()).toList();
  }
}
