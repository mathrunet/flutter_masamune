part of katana;

/// Provides extended methods for [num].
///
/// [num]用の拡張メソッドを提供します。
extension NumExtensions on num {
  /// Convert [num] to [Duration] in Micro-seconds.
  ///
  /// [num]をMicro-secondsの[Duration]に変換します。
  Duration get microseconds => Duration(microseconds: round());

  /// Convert [num] to [Duration] in Milli-seconds.
  ///
  /// [num]をMilli-secondsの[Duration]に変換します。
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  /// Convert [num] to [Duration] in seconds.
  ///
  /// [num]をsecondsの[Duration]に変換します。
  Duration get seconds => Duration(microseconds: (this * 1000 * 1000).round());

  /// Convert [num] to [Duration] in minutes.
  ///
  /// [num]をminutesの[Duration]に変換します。
  Duration get minutes =>
      Duration(microseconds: (this * 1000 * 1000 * 60).round());

  /// Convert [num] to [Duration] in hours.
  ///
  /// [num]をhoursの[Duration]に変換します。
  Duration get hours =>
      Duration(microseconds: (this * 1000 * 1000 * 60 * 60).round());

  /// Convert [num] to [Duration] in days.
  ///
  /// [num]をdaysの[Duration]に変換します。
  Duration get days =>
      Duration(microseconds: (this * 1000 * 1000 * 60 * 60 * 24).round());

  /// Convert [num] to [Duration] in Milli-seconds.
  ///
  /// [num]をMilli-secondsの[Duration]に変換します。
  Duration get ms => milliseconds;
}
