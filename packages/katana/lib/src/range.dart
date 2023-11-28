part of '/katana.dart';

/// A class that represents a range of numbers.
///
/// Includes values from [start] to [end].
///
/// 数値のレンジを表すクラス。
///
/// [start]から[end]までの値を含みます。
class NumRange<TNum extends num> {
  const NumRange(
    this.start,
    this.end,
  );

  /// Starting value.
  ///
  /// 開始の値。
  final TNum start;

  /// Exit value.
  ///
  /// 終了の値。
  final TNum end;

  /// Returns `true` if the value is in the range.
  ///
  /// 値がレンジ内にある場合は`true`を返します。
  bool contains(num value) => value >= start && value < end;

  @override
  String toString() {
    return "$runtimeType($start, $end)";
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => start.hashCode ^ end.hashCode;
}
