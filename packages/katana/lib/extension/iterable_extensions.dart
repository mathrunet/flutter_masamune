part of katana;

/// Provides general extensions to [Iterable<T>].
extension IterableExtensions<T> on Iterable<T> {
  /// Remove duplicate values from the list.
  ///
  /// The [key] can be specified to change what is summarized by a particular element in the element.
  List<T> distinct([Object Function(T element)? key]) {
    if (key == null) {
      return toSet().toList();
    }
    final tmp = <Object, T>{};
    for (final element in this) {
      final o = key.call(element);
      if (tmp.containsKey(o)) {
        continue;
      }
      tmp[o] = element;
    }
    return tmp.values.toList();
  }

  /// Index and loop it through [callback].
  Iterable<T> index(T Function(T item, int index) callback) {
    int i = 0;
    for (final tmp in this) {
      callback(tmp, i);
      i++;
    }
    return this;
  }

  /// Returns the first element.
  ///
  /// Return `null` if the list has no element.
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }

  /// Returns the last element.
  ///
  /// Return `null` if the list has no element.
  T? get lastOrNull {
    if (isEmpty) {
      return null;
    }
    return last;
  }

  /// Returns the first value found by searching based on the condition specified in [test].
  ///
  /// If the value is not found, [Null] is returned.
  T? firstWhereOrNull(bool Function(T item) test) {
    if (isEmpty) {
      return null;
    }
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// After replacing the data in the list, delete the null.
  ///
  /// [callback]: Callback function used in map.
  List<TCast> mapAndRemoveEmpty<TCast>(TCast? Function(T item) callback) {
    return map<TCast?>(callback).removeEmpty();
  }

  /// After replacing the data in the list through [callback], delete the [Null].
  List<TCast> expandAndRemoveEmpty<TCast>(
    Iterable<TCast?> Function(T item) callback,
  ) {
    return expand<TCast?>(callback).removeEmpty();
  }

  /// Divides the array by the specified [length] into an array.
  Iterable<Iterable<T>> split(int length) {
    length = length.limit(0, this.length);
    List<T>? tmp;
    final res = <Iterable<T>>[];
    if (length == 0) {
      return res;
    }
    int i = 0;
    for (final item in this) {
      if (i % length == 0) {
        if (tmp != null) {
          res.add(tmp);
        }
        tmp = [];
      }
      tmp?.add(item);
      i++;
    }
    if (tmp != null) {
      res.add(tmp);
    }
    return res;
  }

  /// Create a list of lists, grouping those that match [a] and [b] in [test].
  Iterable<Iterable<T>> splitWhere(bool Function(T a, T b) test) {
    final res = <List<T>>[];
    for (final item in this) {
      if (res.isEmpty) {
        res.add([item]);
      } else {
        final found = res.firstWhereOrNull((e) {
          if (e.isEmpty) {
            return false;
          }
          return test.call(item, e.first);
        });
        if (found == null) {
          res.add([item]);
        } else {
          found.add(item);
        }
      }
    }
    return res;
  }

  /// Convert the map to Map<K,V> by passing [MapEntry] in the callback of [f].
  Map<K, V> toMap<K, V>(
    MapEntry<K, V>? Function(T item) f,
  ) {
    return Map.fromEntries(map((e) => f.call(e)).removeEmpty());
  }

  /// Extract an array with a given range between [start] and [end].
  List<T> limit(int start, int end) {
    if (this is List) {
      return (this as List).sublist(start, min(length, end)).cast<T>();
    } else {
      return toList().sublist(start, min(length, end));
    }
  }

  /// Extract an array with a given range at [start].
  List<T> limitStart(int start) => limit(start, length);

  /// Extract an array with a given range at [end].
  List<T> limitEnd(int end) => limit(0, end);

  /// Returns `true` if any of the given [elements] is in the list.
  bool containsAny(Iterable<Object?> elements) {
    return elements.any((element) => contains(element));
  }

  /// Returns `true` if all of the given [elements] is in the list.
  bool containsAll(Iterable<Object?> elements) {
    return elements.every((element) => contains(element));
  }

  /// The data in the list of [others] is conditionally given to the current list.
  ///
  /// If [test] is `true`, [apply] will be executed.
  ///
  /// Otherwise, [orElse] will be executed.
  Iterable<K> setWhere<K extends Object>(
    Iterable<T> others, {
    required bool Function(T original, T other) test,
    required K? Function(T original, T other) apply,
    K? Function(T original)? orElse,
  }) {
    final tmp = <K>[];
    for (final original in this) {
      final res = others.firstWhereOrNull((item) => test.call(original, item));
      if (res != null) {
        final applied = apply.call(original, res);
        if (applied != null) {
          tmp.add(applied);
        }
      } else {
        final applied = orElse?.call(original);
        if (applied != null) {
          tmp.add(applied);
        }
      }
    }
    return tmp;
  }

  /// Insert [value] for each [per].
  ///
  /// They are not added at the beginning and end.
  Iterable<T> insertEvery(T value, int per) {
    return split(per).joinToList(value);
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Iterable<T> others) {
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
