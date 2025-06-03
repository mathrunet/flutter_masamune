part of "/katana.dart";

/// Provides extended methods for [Map].
///
/// [Map]用の拡張メソッドを提供します。
extension MapExtensions<K, V> on Map<K, V> {
  /// Returns a list of [callback] return values generated from [Map].
  ///
  /// [Map]から生成された[callback]の戻り値のリストを返します。
  ///
  /// ```dart
  /// final map = {"a": 1, "b": 2, "c": 3};
  /// final list = map.toList((k, v) => k); // ["a", "b", "c"]
  /// ```
  Iterable<T> toList<T>(T Function(K key, V value) callback) sync* {
    for (final tmp in entries) {
      yield callback(tmp.key, tmp.value);
    }
  }

  /// Extracts only elements for which the return value of the callback given by [test] is `true`.
  ///
  /// An object different from the original object is returned.
  ///
  /// [test]で与えたコールバックの戻り値が`true`の要素だけを抽出します。
  ///
  /// 元のオブジェクトとは別のオブジェクトが返されます。
  Map<K, V> where(bool Function(K key, V value) test) {
    return Map.from(this)..removeWhere((key, value) => !test(key, value));
  }

  /// Set only the value of the key specified by [keys] in the map specified by [others].
  ///
  /// [others] で指定されたマップに、[keys] で指定されたキーの値のみを設定します。
  ///
  /// ```dart
  /// final main = {"c": 3, "d": 4};
  /// final other = {"a": 1, "b": 2};
  /// main.addWith(other, ["a"]); // {"a": 1, "c": 3, "d": 4}
  /// ```
  Map<K, V> addWith(Map<K, V> others, Iterable<K> keys) {
    for (final key in keys) {
      if (!others.containsKey(key)) {
        continue;
      }
      // ignore: null_check_on_nullable_type_parameter
      this[key] = others[key]!;
    }
    return this;
  }

  /// Retrieves the element [key] from [Map].
  ///
  /// If [Map] does not have an element of [key] or the type does not match [T], [orElse] is returned.
  ///
  /// [Map]から[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[T]と型が合わない場合、[orElse]が返されます。
  T get<T>(K key, T orElse) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key) || this[key] is! T?) {
      return orElse;
    }
    return (this[key] as T?) ?? orElse;
  }

  /// Retrieves the element of [key] of type [int] from [Map].
  ///
  /// If [Map] does not have an element of [key] or the type does not match [int], [orElse] is returned.
  ///
  /// [Map]から[int]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[int]と型が合わない場合、[orElse]が返されます。
  int getAsInt(K key, [int orElse = 0]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key) || this[key] is! num?) {
      return orElse;
    }
    return (this[key] as num?)?.toInt() ?? orElse;
  }

  /// Retrieves the element of [key] of type [double] from [Map].
  ///
  /// If [Map] does not have an element of [key] or the type does not match [double], [orElse] is returned.
  ///
  /// [Map]から[double]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[double]と型が合わない場合、[orElse]が返されます。
  double getAsDouble(K key, [double orElse = 0.0]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key) || this[key] is! num?) {
      return orElse;
    }
    return (this[key] as num?)?.toDouble() ?? orElse;
  }

  /// Retrieves the element of [key] of type [List] from [Map].
  ///
  /// If [Map] does not have an element of [key] or the type does not match [List<T>], [orElse] is returned.
  ///
  /// [Map]から[List]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[List<T>]と型が合わない場合、[orElse]が返されます。
  List<T> getAsList<T>(K key, [List<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key) || this[key] is! List?) {
      return orElse ?? [];
    }
    return (this[key] as List?)?.cast<T>() ?? orElse ?? [];
  }

  /// Retrieves the element of [key] of type [Map] from [Map].
  ///
  /// If [Map] does not have an element of [key] or the type does not match [Map<String, T>], [orElse] is returned.
  ///
  /// [Map]から[Map]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[Map<String, T>]と型が合わない場合、[orElse]が返されます。
  Map<String, T> getAsMap<T>(K key, [Map<String, T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key) || this[key] is! Map?) {
      return orElse ?? {};
    }
    return (this[key] as Map?)?.cast<String, T>() ?? orElse ?? {};
  }

  /// Retrieves the element of [key] of type [Set] from [Map].
  ///
  /// If [Map] does not have an element of [key] or the type does not match [Set<T>], [orElse] is returned.
  ///
  /// [Map]から[Set]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[Set<T>]と型が合わない場合、[orElse]が返されます。
  Set<T> getAsSet<T>(K key, [Set<T>? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key) || this[key] is! Set?) {
      return orElse ?? {};
    }
    return (this[key] as Set?)?.cast<T>() ?? orElse ?? {};
  }

  /// Retrieves the element of [key] of type [Map] from [Map].
  ///
  /// If it is an [int] type, convert it to a [DateTime] type with [DateTime.fromMicrosecondsSinceEpoch].
  ///
  /// If there is no element of [key] in [Map] or the type does not match [int] or [DateTime], [orElse] is returned.
  ///
  /// [Map]から[DateTime]の[key]の要素を取得します。
  ///
  /// [int]型の場合は[DateTime.fromMicrosecondsSinceEpoch]で[DateTime]型に変換します。
  ///
  /// [Map]に[key]の要素がない場合や[int]もしくは[DateTime]と型が合わない場合、[orElse]が返されます。
  DateTime getAsDateTime(K key, [DateTime? orElse]) {
    if (!containsKey(key)) {
      return orElse ?? DateTime.now();
    }
    if (this[key] is int?) {
      final microsecondsSinceEpoch = this[key] as int?;
      if (microsecondsSinceEpoch == null) {
        return orElse ?? DateTime.now();
      }
      return DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
    } else if (this[key] is DateTime?) {
      return (this[key] as DateTime?) ?? orElse ?? DateTime.now();
    } else {
      return orElse ?? DateTime.now();
    }
  }

  /// Merges elements of [others] into [Map].
  ///
  /// You can use [convertKeys] to convert keys when merging [others].
  ///
  /// You can use [convertValues] to convert values when merging [others].
  ///
  /// [Map]に[others]の要素をマージします。
  ///
  /// [others]をマージする際のキーを[convertKeys]で変換できます。
  ///
  /// [others]をマージする際の値を[convertValues]で変換できます。
  ///
  /// ```dart
  /// final map = {"a": 1, "b": 2, "c": 3};
  /// final others = {"d": 4, "e": 5};
  /// final merged = map.merge(others, convertKeys: (key) => "merged_$key", convertValues: (value) => value * 2); // {"a": 1, "b": 2, "c": 3, "merged_d": 8, "merged_e": 10}
  /// ```
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

  /// Add [others] to [Map].
  ///
  /// Keys in [others] that are already in [Map] will not be added.
  ///
  /// [Map]に[others]を追加します。
  ///
  /// [others]のキーの中で[Map]の中にすでにあるものは追加されません。
  ///
  /// ```dart
  /// final map = {"a": 1, "b": 2, "c": 3};
  /// final others = {"c": 4, "d": 5};
  /// map.addAllIfEmpty(others); // {"a": 1, "b": 2, "c": 3, "d": 5}
  /// ```
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

  /// Returns `true` if any of the keys in [Map] contain any of the keys in [keys].
  ///
  /// [Map]のキーに[keys]のいずれかが含まれている場合`true`を返します。
  bool containsKeyAny(Iterable<Object?> keys) {
    return keys.any((element) => containsKey(element));
  }

  /// Returns `true` if all [keys] are included in the keys of [Map].
  ///
  /// [Map]のキーに[keys]がすべて含まれている場合`true`を返します。
  bool containsKeyAll(Iterable<Object?> keys) {
    return keys.every((element) => containsKey(element));
  }

  /// Returns `true` if the value of [Map] contains one of [values].
  ///
  /// [Map]の値に[values]のいずれかが含まれている場合`true`を返します。
  bool containsValueAny(Iterable<Object?> values) {
    return values.any((element) => containsValue(element));
  }

  /// Returns `true` if the value of [Map] contains all [values].
  ///
  /// [Map]の値に[values]がすべて含まれている場合`true`を返します。
  bool containsValueAll(Iterable<Object?> values) {
    return values.every((element) => containsValue(element));
  }

  /// Clone another map from an existing map.
  ///
  /// All contents are shallow copies.
  ///
  /// 既存のマップから別のマップをクローンします。
  ///
  /// 中身はすべてシャローコピーです。
  Map<K, V> clone() {
    return Map<K, V>.from(this);
  }

  /// If this object is Json encodable, `true` is returned.
  ///
  /// If a [List] or [Map] exists, its contents are also checked.
  ///
  /// このオブジェクトがJsonでエンコード可能な場合`true`が返されます。
  ///
  /// [List]や[Map]が存在していた場合はその中身までチェックされます。
  bool get isJsonEncodable {
    if (K != String) {
      return false;
    }
    return values.every((element) => element.isJsonEncodable);
  }

  /// Returns `true` if the internals of [Map] and [others] are compared and match.
  ///
  /// [Map]と[others]の内部を比較して一致している場合`true`を返します。
  bool equalsTo(Map<K, V>? others) {
    if (others == null) {
      return false;
    }
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
    }
    for (final tmp in others.entries) {
      if (!containsKey(tmp.key)) {
        return false;
      }
    }
    return true;
  }
}
