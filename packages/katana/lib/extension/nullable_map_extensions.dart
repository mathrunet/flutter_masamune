part of '/katana.dart';

/// Provides an extension method for [Map] that is nullable.
///
/// Nullableな[Map]用の拡張メソッドを提供します。
extension NullableMapExtensions<K, V> on Map<K, V>? {
  /// Whether there is no key/value pair in the map.
  ///
  /// Returns `true` if itself is [Null].
  ///
  /// マップにキーと値のペアがないかどうかを調べます。
  ///
  /// 自身が[Null]な場合は`true`を返します。
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Whether there is at least one key/value pair in the map.
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// マップに少なくとも 1 つのキーと値のペアがあるかどうかを調べます。
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// The number of key/value pairs in the map.
  ///
  /// Returns `0` if itself is [Null].
  ///
  /// マップ内のキーと値のペアの数を返します。
  ///
  /// 自身が[Null]な場合は`0`を返します。
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Whether this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key` according to the equality used by the map.
  ///
  /// このマップに指定された [key] が含まれているかどうかを調べます。
  ///
  /// マップ内のキーのいずれかが、マップで使用される等式に従って`key`と等しい場合に true を返します。
  ///
  /// ```dart
  /// final moonCount = <String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final containsUranus = moonCount.containsKey('Uranus'); // true
  /// final containsPluto = moonCount.containsKey('Pluto'); // false
  /// ```
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool containsKey(Object? key) {
    if (this == null) {
      return false;
    }
    return this!.containsKey(key);
  }

  /// Whether this map contains the given [value].
  ///
  /// Returns true if any of the values in the map are equal to `value` according to the `==` operator.
  ///
  /// このマップに指定された [値] が含まれているかどうかを調べます。
  ///
  /// `==` 演算子に従って、マップ内のいずれかの値が `value` と等しい場合に true を返します。
  ///
  /// ```dart
  /// final moonCount = <String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final moons3 = moonCount.containsValue(3); // false
  /// final moons82 = moonCount.containsValue(82); // true
  /// ```
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool containsValue(Object? value) {
    if (this == null) {
      return false;
    }
    return this!.containsValue(value);
  }

  /// Retrieves the element [key] from [Map].
  ///
  /// If [Map] has no element of [key], or if the type does not match [T], or if [Map] is itself [Null], [orElse] is returned.
  ///
  /// [Map]から[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[T]と型が合わない場合、自身が[Null]の場合は[orElse]が返されます。
  T get<T>(K key, T orElse) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key) || this![key] is! T?) {
      return orElse;
    }
    return (this![key] as T?) ?? orElse;
  }

  /// Retrieves the element of [key] of type [int] from [Map].
  ///
  /// If [Map] has no element of [key], or if the type does not match [int], or if [Map] is itself [Null], [orElse] is returned.
  ///
  /// [Map]から[int]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[int]と型が合わない場合、自身が[Null]の場合は[orElse]が返されます。
  int getAsInt(K key, [int orElse = 0]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key) || this![key] is! num?) {
      return orElse;
    }
    return (this![key] as num?)?.toInt() ?? orElse;
  }

  /// Retrieves the element of [key] of type [double] from [Map].
  ///
  /// If [Map] has no element of [key], or if the type does not match [double], or if [Map] is itself [Null], [orElse] is returned.
  ///
  /// [Map]から[double]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[double]と型が合わない場合、自身が[Null]の場合は[orElse]が返されます。
  double getAsDouble(K key, [double orElse = 0.0]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key) || this![key] is! num?) {
      return orElse;
    }
    return (this![key] as num?)?.toDouble() ?? orElse;
  }

  /// Retrieves the element of [key] of type [List] from [Map].
  ///
  /// If [Map] has no element of [key], or if the type does not match [List<T>], or if [Map] is itself [Null], [orElse] is returned.
  ///
  /// [Map]から[List]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[List<T>]と型が合わない場合、自身が[Null]の場合は[orElse]が返されます。
  List<T> getAsList<T>(K key, [List<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key) || this![key] is! List?) {
      return orElse ?? [];
    }
    return (this![key] as List?)?.cast<T>() ?? orElse ?? [];
  }

  /// Retrieves the element of [key] of type [Map] from [Map].
  ///
  /// If [Map] has no element of [key], or if the type does not match [Map<String, T>], or if [Map] is itself [Null], [orElse] is returned.
  ///
  /// [Map]から[Map]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[Map<String, T>]と型が合わない場合、自身が[Null]の場合は[orElse]が返されます。
  Map<String, T> getAsMap<T>(K key, [Map<String, T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key) || this![key] is! Map?) {
      return orElse ?? {};
    }
    return (this![key] as Map?)?.cast<String, T>() ?? orElse ?? {};
  }

  /// Retrieves the element of [key] of type [Set] from [Map].
  ///
  /// If [Map] has no element of [key], or if the type does not match [Set<T>], or if [Map] is itself [Null], [orElse] is returned.
  ///
  /// [Map]から[Set]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[Set<T>]と型が合わない場合、自身が[Null]の場合は[orElse]が返されます。
  Set<T> getAsSet<T>(K key, [Set<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key) || this![key] is! Set?) {
      return orElse ?? {};
    }
    return (this![key] as Set?)?.cast<T>() ?? orElse ?? {};
  }

  /// Retrieves the element of [key] of type [Map] from [Map].
  ///
  /// If it is an [int] type, convert it to a [DateTime] type with [DateTime.fromMillisecondsSinceEpoch].
  ///
  /// If there is no element of [key] in [Map], or if the type does not match [int] or [DateTime], or if it is [Null] itself, [orElse] is returned.
  ///
  /// [Map]から[DateTime]の[key]の要素を取得します。
  ///
  /// [int]型の場合は[DateTime.fromMillisecondsSinceEpoch]で[DateTime]型に変換します。
  ///
  /// [Map]に[key]の要素がない場合や[int]もしくは[DateTime]と型が合わない場合、自身が[Null]の場合は[orElse]が返されます。
  DateTime getAsDateTime(K key, [DateTime? orElse]) {
    if (this == null || !containsKey(key)) {
      return orElse ?? DateTime.now();
    }
    if (this![key] is int?) {
      final millisecondsSinceEpoch = this![key] as int?;
      if (millisecondsSinceEpoch == null) {
        return orElse ?? DateTime.now();
      }
      return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    } else if (this![key] is DateTime?) {
      return (this![key] as DateTime?) ?? orElse ?? DateTime.now();
    } else {
      return orElse ?? DateTime.now();
    }
  }

  /// Returns `true` if any of the keys in [Map] contain any of the keys in [keys].
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// [Map]のキーに[keys]のいずれかが含まれている場合`true`を返します。
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool containsKeyAny(Iterable<Object?> keys) {
    if (this == null) {
      return false;
    }
    return keys.any((element) => this!.containsKey(element));
  }

  /// Returns `true` if all [keys] are included in the keys of [Map].
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// [Map]のキーに[keys]がすべて含まれている場合`true`を返します。
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool containsKeyAll(Iterable<Object?> keys) {
    if (this == null) {
      return false;
    }
    return keys.every((element) => this!.containsKey(element));
  }

  /// Returns `true` if the value of [Map] contains one of [values].
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// [Map]の値に[values]のいずれかが含まれている場合`true`を返します。
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool containsValueAny(Iterable<Object?> values) {
    if (this == null) {
      return false;
    }
    return values.any((element) => this!.containsValue(element));
  }

  /// Returns `true` if the value of [Map] contains all [values].
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// [Map]の値に[values]がすべて含まれている場合`true`を返します。
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool containsValueAll(Iterable<Object?> values) {
    if (this == null) {
      return false;
    }
    return values.every((element) => this!.containsValue(element));
  }

  /// Returns `true` if the internals of [Map] and [others] are compared and match.
  ///
  /// Returns `true` if both itself and [others] are [null].
  ///
  /// [Map]と[others]の内部を比較して一致している場合`true`を返します。
  ///
  /// 自身と[others]が両方とも[Null]な場合`true`を返します。
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
