part of "/masamune_painter.dart";

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
    required this.color,
    required this.width,
    this.filled = false,
  });

  /// The type of the painting value.
  ///
  /// 描画用のデータの型。
  String get type;

  /// Convert the painting value to a JSON object.
  ///
  /// 描画用のデータをJSONオブジェクトに変換します。
  DynamicMap toJson();

  /// Object's area (rectangle).
  ///
  /// オブジェクトのエリア（四角）。
  Rect get rect;

  /// The id of the painting value.
  ///
  /// 描画用のデータのID。
  final String id;

  /// The color of the painting value.
  ///
  /// 描画用のデータの色。
  final Color color;

  /// The width of the painting value.
  ///
  /// 描画用のデータの幅。
  final double width;

  /// Whether the painting value is filled.
  ///
  /// 描画用のデータが塗りつぶされているかどうか。
  final bool filled;

  /// The key for the type.
  ///
  /// 描画用のデータの型のキー。
  static const String typeKey = "type";

  /// The key for the id.
  ///
  /// 描画用のデータのIDのキー。
  static const String idKey = "id";

  /// The key for the color.
  ///
  /// 描画用のデータの色のキー。
  static const String colorKey = "color";

  /// The key for the width.
  ///
  /// 描画用のデータの幅のキー。
  static const String widthKey = "width";

  /// The key for the filled.
  ///
  /// 描画用のデータが塗りつぶされているかどうかのキー。
  static const String filledKey = "filled";

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
  });

  /// Painting the painting value.
  ///
  /// 描画用のデータを描画します。
  Rect? paint(Canvas canvas);

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
