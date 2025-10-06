part of "/masamune_painter.dart";

/// Value for exporting painter data.
///
/// Painter データをエクスポートするための値。
@immutable
class PainterExportValue {
  /// Value for exporting painter data.
  ///
  /// Painter データをエクスポートするための値。
  const PainterExportValue({
    required this.data,
    this.localImagePath,
    this.base64Image,
  });

  /// The exported data in NoSQL database structure.
  ///
  /// NoSQL データベース構造のエクスポートされたデータ。
  ///
  /// Structure:
  /// ```
  /// {
  ///   "layer": {
  ///     "id1": { ... },
  ///     "id2": { ... }
  ///   },
  ///   "layer/groupId/children": {
  ///     "childId1": { ... },
  ///     "childId2": { ... }
  ///   }
  /// }
  /// ```
  final DynamicMap data;

  /// The local image path (absolute path).
  ///
  /// Available only for non-Web platforms.
  ///
  /// ローカル画像パス（絶対パス）。
  ///
  /// Web以外のプラットフォームでのみ利用可能。
  final String? localImagePath;

  /// The base64 encoded image data.
  ///
  /// Available only for Web platform.
  ///
  /// Base64エンコードされた画像データ。
  ///
  /// Webプラットフォームでのみ利用可能。
  final String? base64Image;
}
