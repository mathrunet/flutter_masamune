part of katana_shorten;

/// Extension to allow [BorderRadius] to be easily described in [num].
///
/// [num]で[BorderRadius]を簡単に記述できるようにするためのエクステンション。
extension BorderRadiusShortenExtensions on num {
  /// Convert [num] to [BorderRadius.circular].
  ///
  /// [num]を[BorderRadius.circular]に変換します。
  BorderRadius get r => BorderRadius.circular(toDouble());
}
