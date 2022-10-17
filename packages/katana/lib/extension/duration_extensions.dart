part of katana;

/// Provides extended methods for [Duration].
/// 
/// [Duration]用の拡張メソッドを提供します。
extension DurationExtensions on Duration {
  /// Parses [Duration] to [String] according to the definition given in [format].
  ///
  /// The following parameters are available
  ///
  /// [format]で与えられた定義に従って[Duration]を[String]にパースします。
  ///
  /// 下記のパラメーターを利用することが可能です。
  ///
  /// - `d` Displays days. 日付を表示します。
  /// - `H` Displays hours. 時間を表示します。
  /// - `m` Display minutes. 分を表示します。
  /// - `s` Display seconds. 秒を表示します。
  /// - `HH` Displays hours in two digits. 時間を２桁で表示します。
  /// - `mm` Displays minutes in two digits. 分を２桁で表示します。
  /// - `ss` Displays seconds in two digits. 秒を２桁で表示します。
  /// - `S` Display milli-seconds. ミリ秒を表示します。
  /// - `M` Display micro-seconds. マイクロ秒を表示します。
  ///
  /// For example,
  ///
  /// ```dart
  /// final duration = const Duration(days: 6, hours: 12);
  /// print(duration.format("d : H")); // 6 : 12
  /// ```
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String threeDigits(int n) => n.toString().padLeft(3, "0");
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    final milliSeconds = inMilliseconds.remainder(1000);
    final microSeconds = inMicroseconds.remainder(1000);
    return format
        .replaceAll("d", inDays.toString())
        .replaceAll("HH", twoDigits(hours))
        .replaceAll("mm", twoDigits(minutes))
        .replaceAll("ss", twoDigits(seconds))
        .replaceAll("H", hours.toString())
        .replaceAll("m", minutes.toString())
        .replaceAll("s", seconds.toString())
        .replaceAll("S", threeDigits(milliSeconds))
        .replaceAll("M", threeDigits(microSeconds));
  }
}
