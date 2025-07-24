part of "/masamune_picker.dart";

/// Interpolation method to use when resizing images.
///
/// 画像のサイズ変更時に使用する補間方法。
enum PickerInterpolation {
  /// Select the closest pixel. Fastest, lowest quality.
  ///
  /// 最も近いピクセルを選択。最速、最低品質。
  nearest,

  /// Linearly blend between the neighboring pixels.
  ///
  /// 隣接するピクセルを線形に混合。最遅、最高品質。
  linear,

  /// Cubic blend between the neighboring pixels. Slowest, highest Quality.
  ///
  /// 隣接するピクセルを三次補間で混合。最遅、最高品質。
  cubic,

  /// Average the colors of the neighboring pixels.
  ///
  /// 隣接するピクセルの色を平均化。
  average;
}
