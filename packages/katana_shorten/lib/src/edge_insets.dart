part of "/katana_shorten.dart";

/// Extension to allow [EdgeInsets] to be easily described in [num].
///
/// [num]で[EdgeInsets]を簡単に記述できるようにするためのエクステンション。
extension EdgeInsetsShortenExtensions on num {
  /// Converts [num] as padding in all directions.
  ///
  /// [num]を全方向のパディングとして変換します。
  EdgeInsets get p => EdgeInsets.all(toDouble());

  /// Converts [num] as horizontal padding.
  ///
  /// [num]を水平方向のパディングとして変換します。
  EdgeInsets get px => EdgeInsets.symmetric(horizontal: toDouble());

  /// Converts [num] as vertical padding.
  ///
  /// [num]を垂直方向のパディングとして変換します。
  EdgeInsets get py => EdgeInsets.symmetric(vertical: toDouble());

  /// Converts [num] as upward padding.
  ///
  /// [num]を上方向のパディングとして変換します。
  EdgeInsets get pt => EdgeInsets.only(top: toDouble());

  /// Converts [num] as downward padding.
  ///
  /// [num]を下方向のパディングとして変換します。
  EdgeInsets get pb => EdgeInsets.only(bottom: toDouble());

  /// Converts [num] as left padding.
  ///
  /// [num]を左方向のパディングとして変換します。
  EdgeInsets get pl => EdgeInsets.only(left: toDouble());

  /// Converts [num] as right padding.
  ///
  /// [num]を右方向のパディングとして変換します。
  EdgeInsets get pr => EdgeInsets.only(right: toDouble());

  /// Converts [num] as padding in the upper left direction.
  ///
  /// [num]を左上方向のパディングとして変換します。
  EdgeInsets get ptl => EdgeInsets.only(top: toDouble(), left: toDouble());

  /// Converts [num] as padding in the upper right direction.
  ///
  /// [num]を右上方向のパディングとして変換します。
  EdgeInsets get ptr => EdgeInsets.only(top: toDouble(), right: toDouble());

  /// Converts [num] as padding in the lower left direction.
  ///
  /// [num]を左下方向のパディングとして変換します。
  EdgeInsets get pbl => EdgeInsets.only(bottom: toDouble(), left: toDouble());

  /// Convert [num] as padding in the lower right direction.
  ///
  /// [num]を右下方向のパディングとして変換します。
  EdgeInsets get pbr => EdgeInsets.only(bottom: toDouble(), right: toDouble());
}
