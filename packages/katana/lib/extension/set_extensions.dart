part of '/katana.dart';

/// Provides extended methods for [Set].
///
/// [Set]用の拡張メソッドを提供します。
extension SetExtensions<T> on Set<T> {
  /// Returns `true` if [Set] contains any of [elements].
  ///
  /// [Set]に[elements]のいずれかが含まれている場合`true`を返します。
  bool containsAny(Iterable<Object?> elements) {
    return elements.any((element) => contains(element));
  }

  /// Returns `true` if [Set] contains all [elements].
  ///
  /// [Set]に[elements]がすべて含まれている場合`true`を返します。
  bool containsAll(Iterable<Object?> elements) {
    return elements.every((element) => contains(element));
  }

  /// Clone another set from an existing set.
  ///
  /// All contents are shallow copies.
  ///
  /// 既存のセットから別のセットをクローンします。
  ///
  /// 中身はすべてシャローコピーです。
  Set<T> clone({bool growable = false}) {
    return Set<T>.from(this);
  }

  /// Returns `true` if the internals of [Set] and [others] are compared and match.
  ///
  /// [Set]と[others]の内部を比較して一致している場合`true`を返します。
  bool equalsTo(Set<T>? others) {
    return deepEquals(this, others);
  }
}
