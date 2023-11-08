part of '/katana_shorten.dart';

/// Extension to make it easier to describe spaces in [num].
///
/// [num]でスペースを簡単に記述できるようにするためのエクステンション。
extension SpaceShortenExtensions on num {
  /// Convert [num] to [SizedBox] of left and right size.
  ///
  /// [num]を左右の大きさの[SizedBox]に変換します。
  SizedBox get sx => SizedBox(width: toDouble());

  /// Convert [num] to [SizedBox] of the top and bottom sizes.
  ///
  /// [num]を上下の大きさの[SizedBox]に変換します。
  SizedBox get sy => SizedBox(height: toDouble());
}
