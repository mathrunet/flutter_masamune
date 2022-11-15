part of katana_shorten;

/// Extension to allow [Duration] to be easily described in [num].
///
/// [num]で[Duration]を簡単に記述できるようにするためのエクステンション。
extension DurationShortenExtensions on num {
  /// Convert [num] to [Duration] in Milli-seconds.
  ///
  /// [num]をMilli-secondsの[Duration]に変換します。
  Duration get ms => Duration(microseconds: (this * 1000).round());

  /// Convert [num] to [Duration] in seconds.
  ///
  /// [num]をsecondsの[Duration]に変換します。
  Duration get s => Duration(microseconds: (this * 1000 * 1000).round());

  /// Convert [num] to [Duration] in minutes.
  ///
  /// [num]をminutesの[Duration]に変換します。
  Duration get m => Duration(microseconds: (this * 1000 * 1000 * 60).round());

  /// Convert [num] to [Duration] in hours.
  ///
  /// [num]をhoursの[Duration]に変換します。
  Duration get h =>
      Duration(microseconds: (this * 1000 * 1000 * 60 * 60).round());

  /// Convert [num] to [Duration] in days.
  ///
  /// [num]をdaysの[Duration]に変換します。
  Duration get d =>
      Duration(microseconds: (this * 1000 * 1000 * 60 * 60 * 24).round());
}
