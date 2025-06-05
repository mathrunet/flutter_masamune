part of "/katana.dart";

/// Provides extended methods for [Clock].
///
/// [Clock]用の拡張メソッドを提供します。
extension ClockExtensions on Clock {
  /// Create a new [DateTime] by extracting only the year and month from [DateTime].
  ///
  /// All hours, minutes, and seconds will be `0`.
  ///
  /// [DateTime]から年月日のみを抽出して新しい[DateTime]を作成します。
  ///
  /// 時刻分秒はすべて`0`になります。
  Clock toDate() {
    return Clock(year, month, day);
  }

  /// Treats [DateTime], which is not defined as UTC due to parsing, as UTC and converts it to local time.
  ///
  /// パースの関係でUTCとして定義されていない[DateTime]をUTCとして扱いローカルタイムに変換します。
  Clock toUnUtc() {
    return Clock.tryParse("${toIso8601String().trimStringRight("Z")}Z")!
        .toLocal();
  }
}
