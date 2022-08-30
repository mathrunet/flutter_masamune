part of katana;

/// Provides general extensions to [Map<K,V>?].
extension NullableMapExtensions<K, V> on Map<K, V>? {
  /// Whether there is no key/value pair in the map.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Whether there is at least one key/value pair in the map.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// The number of key/value pairs in the map.
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Whether this map contains the given key.
  ///
  /// Returns true if any of the keys in the map are equal to key according to the equality used by the map.
  bool containsKey(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.containsKey(element);
  }

  /// Whether this map contains the given value.
  ///
  /// Returns true if any of the values in the map are equal to value according to the == operator.
  bool containsValue(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.containsValue(element);
  }

  /// Get the value corresponding to [key] in the map.
  ///
  /// If [key] is not found, the value of [orElse] is returned.
  T get<T>(K key, T orElse) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse;
    }
    return (this![key] as T?) ?? orElse;
  }

  /// Get the int value corresponding to [key] in the map.
  ///
  /// If [key] is not found, the value of [orElse] is returned.
  int getAsInt(K key, [int orElse = 0]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse;
    }
    return (this![key] as num?)?.toInt() ?? orElse;
  }

  /// Get the double value corresponding to [key] in the map.
  ///
  /// If [key] is not found, the value of [orElse] is returned.
  double getAsDouble(K key, [double orElse = 0.0]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse;
    }
    return (this![key] as num?)?.toDouble() ?? orElse;
  }

  /// Get the list corresponding to [key] in the map.
  ///
  /// If [key] is not found, the list of [orElse] is returned.
  List<T> getAsList<T>(K key, [List<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? [];
    }
    return (this![key] as List?)?.cast<T>() ?? orElse ?? [];
  }

  /// Get the map corresponding to [key] in the map.
  ///
  /// If [key] is not found, the map of [orElse] is returned.
  Map<String, T> getAsMap<T>(K key, [Map<String, T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? {};
    }
    return (this![key] as Map?)?.cast<String, T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the map.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  Set<T> getAsSet<T>(K key, [Set<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? {};
    }
    return (this![key] as Set?)?.cast<T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the DateTime.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  DateTime getAsDateTime(K key, [DateTime? orElse]) {
    if (this == null || !containsKey(key)) {
      return orElse ?? DateTime.now();
    }
    final millisecondsSinceEpoch = this![key] as int?;
    if (millisecondsSinceEpoch == null) {
      return orElse ?? DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  /// Merges the map in [others] with the current map.
  ///
  /// If the same key is found, the value of [others] has priority.
  Map<K, V> merge(Map<K, V>? others) {
    others ??= const {};
    final res = <K, V>{};
    if (this != null) {
      for (final tmp in this!.entries) {
        res[tmp.key] = tmp.value;
      }
    }
    for (final tmp in others.entries) {
      res[tmp.key] = tmp.value;
    }
    return res;
  }

  /// Add the values of the keys in [others]
  /// that do not exist in the current Map.
  void addAllIfEmpty(Map<K, V>? others) {
    if (this == null || others.isEmpty) {
      return;
    }
    for (final tmp in others!.entries) {
      if (containsKey(tmp.key)) {
        continue;
      }
      this![tmp.key] = tmp.value;
    }
  }

  /// Returns `true` if any of the given [keys] is in the map.
  bool containsKeyAny(Iterable<Object?> keys) {
    if (this == null) {
      return false;
    }
    return keys.any((element) => this!.containsKey(element));
  }

  /// Returns `true` if all of the given [keys] is in the map.
  bool containsKeyAll(Iterable<Object?> keys) {
    if (this == null) {
      return false;
    }
    return keys.every((element) => this!.containsKey(element));
  }

  /// Returns `true` if any of the given [values] is in the map.
  bool containsValueAny(Iterable<Object?> values) {
    if (this == null) {
      return false;
    }
    return values.any((element) => this!.containsValue(element));
  }

  /// Returns `true` if all of the given [values] is in the map.
  bool containsValueAll(Iterable<Object?> values) {
    if (this == null) {
      return false;
    }
    return values.every((element) => this!.containsValue(element));
  }

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Map<K, V>? others) {
    if (this == null && others != null) {
      return false;
    }
    if (this != null && others == null) {
      return false;
    }
    if (this == null && others == null) {
      return true;
    }
    return this!.equalsTo(others!);
  }
}
