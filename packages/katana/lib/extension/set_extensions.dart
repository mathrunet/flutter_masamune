part of katana;

/// Provides general extensions to [Set<T>].
extension SetExtensions<T> on Set<T> {
  /// Returns `true` if any of the given [others] is in the list.
  bool containsAny(Iterable<Object?> others) {
    return others.any((element) => contains(element));
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Set<T> others) {
    for (final t in this) {
      if (!others.any((o) {
        if (t is Iterable?) {
          if (o is! Iterable?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Map?) {
          if (o is! Map?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Set?) {
          if (o is! Set?) {
            return false;
          }
          return t.equalsTo(o);
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
          return t.equalsTo(o);
        } else if (t is Map?) {
          if (o is! Map?) {
            return false;
          }
          return t.equalsTo(o);
        } else if (t is Set?) {
          if (o is! Set?) {
            return false;
          }
          return t.equalsTo(o);
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
