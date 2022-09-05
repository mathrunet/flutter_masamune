part of katana;

/// Provides general extensions to [Map<K,V>].
extension MapExtensions<K, V> on Map<K, V> {
  /// Convert it to a list through [callback].
  Iterable<T> toList<T>(T Function(K key, V value) callback) sync* {
    for (final tmp in entries) {
      yield callback(tmp.key, tmp.value);
    }
  }

  /// Set only the value of the key specified
  /// by [keys] in the map specified by [other].
  ///
  /// ```
  /// final main = {"c": 3, "d": 4};
  /// final other = {"a": 1, "b": 2};
  /// main.addWith(other, ["a"]);     // {"a": 1, "c": 3, "d": 4}
  /// ```
  Map<K, V> addWith(Map<K, V> other, Iterable<K> keys) {
    for (final key in keys) {
      if (!other.containsKey(key)) {
        continue;
      }
      // ignore: null_check_on_nullable_type_parameter
      this[key] = other[key]!;
    }
    return this;
  }

  /// Get the value corresponding to [key] in the map.
  ///
  /// If [key] is not found, the value of [orElse] is returned.
  T get<T>(K key, T orElse) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse;
    }
    return (this[key] as T?) ?? orElse;
  }

  /// Get the int value corresponding to [key] in the map.
  ///
  /// If [key] is not found, the value of [orElse] is returned.
  int getAsInt(K key, [int orElse = 0]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse;
    }
    return (this[key] as num?)?.toInt() ?? orElse;
  }

  /// Get the double value corresponding to [key] in the map.
  ///
  /// If [key] is not found, the value of [orElse] is returned.
  double getAsDouble(K key, [double orElse = 0.0]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse;
    }
    return (this[key] as num?)?.toDouble() ?? orElse;
  }

  /// Get the list corresponding to [key] in the map.
  ///
  /// If [key] is not found, the list of [orElse] is returned.
  List<T> getAsList<T>(K key, [List<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? [];
    }
    return (this[key] as List?)?.cast<T>() ?? orElse ?? [];
  }

  /// Get the map corresponding to [key] in the map.
  ///
  /// If [key] is not found, the map of [orElse] is returned.
  Map<String, T> getAsMap<T>(K key, [Map<String, T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? {};
    }
    return (this[key] as Map?)?.cast<String, T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the map.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  Set<T> getAsSet<T>(K key, [Set<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? {};
    }
    return (this[key] as Set?)?.cast<T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the DateTime.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  DateTime getAsDateTime(K key, [DateTime? orElse]) {
    if (!containsKey(key)) {
      return orElse ?? DateTime.now();
    }
    final millisecondsSinceEpoch = this[key] as int?;
    if (millisecondsSinceEpoch == null) {
      return orElse ?? DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  /// Merges the map in [others] with the current map.
  ///
  /// If the same key is found, the value of [others] has priority.
  Map<K, V> merge(
    Map<K, V>? others, {
    K Function(K key)? convertKeys,
    V Function(V value)? convertValues,
  }) {
    others ??= const {};
    final res = <K, V>{};
    for (final tmp in entries) {
      res[tmp.key] = tmp.value;
    }
    for (final tmp in others.entries) {
      final key = convertKeys?.call(tmp.key) ?? tmp.key;
      final value = convertValues?.call(tmp.value) ?? tmp.value;
      res[key] = value;
    }
    return res;
  }

  /// Add the values of the keys in [others]
  /// that do not exist in the current Map.
  void addAllIfEmpty(Map<K, V>? others) {
    if (others.isEmpty) {
      return;
    }
    for (final tmp in others!.entries) {
      if (containsKey(tmp.key)) {
        continue;
      }
      this[tmp.key] = tmp.value;
    }
  }

  /// Returns `true` if any of the given [keys] is in the map.
  bool containsKeyAny(Iterable<Object?> keys) {
    return keys.any((element) => containsKey(element));
  }

  /// Returns `true` if all of the given [keys] is in the map.
  bool containsKeyAll(Iterable<Object?> keys) {
    return keys.every((element) => containsKey(element));
  }

  /// Returns `true` if any of the given [values] is in the map.
  bool containsValueAny(Iterable<Object?> values) {
    return values.any((element) => containsValue(element));
  }

  /// Returns `true` if all of the given [values] is in the map.
  bool containsValueAll(Iterable<Object?> values) {
    return values.every((element) => containsValue(element));
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Map<K, V> others) {
    for (final tmp in entries) {
      if (!others.containsKey(tmp.key)) {
        return false;
      }
      final t = tmp.value;
      final o = others[tmp.key];
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
    }
    for (final tmp in others.entries) {
      if (!containsKey(tmp.key)) {
        return false;
      }
    }
    return true;
  }
}
