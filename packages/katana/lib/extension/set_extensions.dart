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

  /// Returns `true` if the internals of [Set] and [others] are compared and match.
  ///
  /// [Set]と[others]の内部を比較して一致している場合`true`を返します。
  bool equalsTo(Set<T> others) {
    for (final t in this) {
      if (!others.any((o) {
        if (t is Iterable?) {
          if (o is! Iterable?) {
            return false;
          }
          if (!t.equalsTo(o)) {
            return false;
          }
        } else if (t is Map?) {
          if (o is! Map?) {
            return false;
          }
          if (!t.equalsTo(o)) {
            return false;
          }
        } else if (t is Set?) {
          if (o is! Set?) {
            return false;
          }
          if (!t.equalsTo(o)) {
            return false;
          }
        } else if (t != o) {
          return false;
        }
        return true;
      })) {
        return false;
      }
    }
    for (final t in others) {
      if (!any((o) {
        if (t is Iterable?) {
          if (o is! Iterable?) {
            return false;
          }
          if (!t.equalsTo(o)) {
            return false;
          }
        } else if (t is Map?) {
          if (o is! Map?) {
            return false;
          }
          if (!t.equalsTo(o)) {
            return false;
          }
        } else if (t is Set?) {
          if (o is! Set?) {
            return false;
          }
          if (!t.equalsTo(o)) {
            return false;
          }
        } else if (t != o) {
          return false;
        }
        return true;
      })) {
        return false;
      }
    }
    return true;
  }
}
