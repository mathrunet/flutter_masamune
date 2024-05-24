part of '/katana.dart';

/// Provides extended methods for [T] arrays.
///
/// [T]の配列用の拡張メソッドを提供します。
extension IterableExtensions<T> on Iterable<T> {
  /// Deletes duplicate elements in an array.
  ///
  /// By setting the return value of [key] to a specific duplicate key, duplicate checking can be performed for each specified duplicate key.
  ///
  /// 配列の中の重複している要素を削除します。
  ///
  /// [key]の返り値を特定の重複キーにすることで指定された重複キーごとに重複チェックを行うことが可能です。
  ///
  /// ```dart
  /// final array = [1, 1, 3, 5, 6, 8, 9, 9];
  /// final distinct = array.distinct(); // [1, 3, 5, 6, 8, 9]
  /// ```
  List<T> distinct([Object? Function(T element)? key]) {
    if (key == null) {
      return toSet().toList();
    }
    final tmp = <Object?, T>{};
    for (final element in this) {
      final o = key.call(element);
      if (tmp.containsKey(o)) {
        continue;
      }
      tmp[o] = element;
    }
    return tmp.values.toList();
  }

  /// Returns the first element.
  ///
  /// Return [Null] if the list has no element.
  ///
  /// 最初の要素を返します。
  ///
  /// リストに要素がない場合は[Null]が返されます。
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }

  /// Returns the last element.
  ///
  /// Return [Null] if the list has no element.
  ///
  /// 最後の要素を返します。
  ///
  /// リストに要素がない場合は[Null]が返されます。
  T? get lastOrNull {
    if (isEmpty) {
      return null;
    }
    return last;
  }

  /// Returns the first element for which the return value of [test] is `true`.
  ///
  /// [Null] is returned if there is no element for which the return value of [test] is `true`.
  ///
  /// [test]の返り値が`true`になる場合の最初の要素を返します。
  ///
  /// [test]の返り値が`true`になる要素がない場合は[Null]が返されます。
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

  /// Returns the last element for which the return value of [test] is `true`.
  ///
  /// [Null] is returned if there is no element for which the return value of [test] is `true`.
  ///
  /// [test]の返り値が`true`になる場合の最後の要素を返します。
  ///
  /// [test]の返り値が`true`になる要素がない場合は[Null]が返されます。
  T? lastWhereOrNull(bool Function(T item) test) {
    return toList().reversed.firstWhereOrNull(test);
  }

  /// Each element of the list is converted to [TCast] data using [callback].
  ///
  /// If the return value of [callback] is [Null], the element is removed from the element.
  ///
  /// It is returned as a [List] type, not as a [Iterable] type like [map].
  ///
  /// リストの各要素を[callback]を用い[TCast]のデータに変換します。
  ///
  /// [callback]の戻り値が[Null]の場合、要素から削除されます。
  ///
  /// [map]のように[Iterable]型ではなく[List]型で返されます。
  List<TCast> mapAndRemoveEmpty<TCast>(TCast? Function(T item) callback) {
    return map<TCast?>(callback).removeEmpty();
  }

  /// Each element of the list is converted to [TCast] data using [callback].
  ///
  /// The return value of [callback] can be [Iterable] or [List], all of which will be each element of the list.
  ///
  /// If the element inside the return value of [callback] is [Null], it is removed from the element.
  ///
  /// It is returned as a [List] type, not as a [Iterable] type like [expand].
  ///
  /// リストの各要素を[callback]を用い[TCast]のデータに変換します。
  ///
  /// [callback]の戻り値は[Iterable]や[List]を指定でき、その全要素がリストの各要素となります。
  ///
  /// [callback]の戻り値内部の要素が[Null]の場合、要素から削除されます。
  ///
  /// [expand]のように[Iterable]型ではなく[List]型で返されます。
  List<TCast> expandAndRemoveEmpty<TCast>(
    Iterable<TCast?> Function(T item) callback,
  ) {
    return expand<TCast?>(callback).removeEmpty();
  }

  /// [Iterable] is divided into [length] elements each, creating a list of lists.
  ///
  /// [Iterable]を[length]個の要素ごとに分割し、リストのリストを作成します。
  ///
  /// ```dart
  /// final array = [1, 2, 3, 4, 5, 6, 7, 8];
  /// final splitted = array.split(2); // [[1, 2], [3, 4], [5, 6], [7, 8]]
  /// ```
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

  /// Groups [Iterable] together with elements that have a return value of `true` for [test] and returns a list of each group.
  ///
  /// [Iterable]を[test]の返り値が`true`になる要素同士でまとめて１つのグループとし、各グループのリストを返します。
  ///
  /// ```dart
  /// final array = [1, 1, 2, 2, 3, 4, 5, 6];
  /// final splitted = array.splitWhere((a, b) => a == b); // [[1, 1], [2, 2], [3], [4], [5], [6]]
  /// ```
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

  /// The callback given by [f] from [Iterable] will create a map of [K] and [V].
  ///
  /// The return value of [f] must be [MapEntry].
  ///
  /// If the return value of [f] is [Null], it is removed from the element.
  ///
  /// If there are duplicate keys, the earlier element takes precedence.
  ///
  /// [Iterable]から[f]で与えられたコールバックによって[K]と[V]のマップを作成します。
  ///
  /// [f]の戻り値は[MapEntry]である必要があります。
  ///
  /// [f]の戻り値を[Null]にした場合は要素から削除されます。
  ///
  /// キーが重複した場合、先の要素が優先されます。
  ///
  /// ```dart
  /// final array = [1, 2, 3, 4, 5, 6];
  /// final map = array.toMap<String, int>(
  ///   (item) => MapEntry(item.toString(), item);
  /// ); // {"1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6 }
  ///
  /// ```
  Map<K, V> toMap<K, V>(
    MapEntry<K, V>? Function(T item) f,
  ) {
    return Map.fromEntries(map((e) => f.call(e)).removeEmpty());
  }

  /// Extract only the elements from [start] to [end] of [Iterable].
  ///
  /// [Iterable]を[start]から[end]までの要素のみを抽出します。
  ///
  /// ```dart
  /// final colors = <String>["red", "green", "blue", "orange", "pink"];
  /// print(colors.limit(1, 3)); // [green, blue]
  /// ```
  List<T> limit(int start, int end) {
    if (this is List) {
      return (this as List).sublist(start, min(length, end)).cast<T>();
    } else {
      return toList().sublist(start, min(length, end));
    }
  }

  /// Extract only the elements from [start] of [Iterable].
  ///
  /// [Iterable]を[start]からの要素のみを抽出します。
  ///
  /// ```dart
  /// final colors = <String>["red", "green", "blue", "orange", "pink"];
  /// print(colors.limitStart(1)); // [green, blue, orange, pink]
  /// ```
  List<T> limitStart(int start) => limit(start, length);

  /// Extract only the elements to [end] of [Iterable].
  ///
  /// [Iterable]を[end]までの要素のみを抽出します。からの要素のみを抽出します。
  ///
  /// ```dart
  /// final colors = <String>["red", "green", "blue", "orange", "pink"];
  /// print(colors.limitEnd(3)); // [red, green, blue]
  /// ```
  List<T> limitEnd(int end) => limit(0, end);

  /// Returns `true` if [Iterable] contains any of [elements].
  ///
  /// [Iterable]に[elements]のいずれかが含まれている場合`true`を返します。
  bool containsAny(Iterable<Object?> elements) {
    return elements.any((element) => contains(element));
  }

  /// Returns `true` if [Iterable] contains all [elements].
  ///
  /// [Iterable]に[elements]がすべて含まれている場合`true`を返します。
  bool containsAll(Iterable<Object?> elements) {
    return elements.every((element) => contains(element));
  }

  /// If [length] is greater than the current number, returns [Iterable] filled with elements generated by [generator].
  ///
  /// If the length of [Iterable] is greater than or equal to [length], it is returned as is.
  ///
  /// 現在の数より[length]が多い場合、[generator]で生成された要素で埋められた[Iterable]を返します。
  ///
  /// [Iterable]の長さが[length]以上の場合、そのまま返します。
  Iterable<T> fill(int length, T Function(int index) generator) {
    if (this.length >= length) {
      return this;
    }
    final res = List<T>.from(this);
    for (var i = this.length; i < length; i++) {
      res.add(generator.call(i));
    }
    return res;
  }

  /// If [others] is given to [Iterable] and the return value of [test] is `true`,
  /// the return value of [apply] is replaced with the corresponding value of [Iterable].
  ///
  /// If no element is found in [others] for which the return value of [test] is `true`, it is replaced by the return value of [orElse].
  ///
  /// If [orElse] is not given, the element is deleted.
  ///
  /// [Iterable]に[others]を与え、[test]の戻り値が`true`になる場合[apply]の戻り値を[Iterable]の該当値と置き換えます。
  ///
  /// [test]の戻り値が`true`になる要素が[others]から見つからなかった場合、[orElse]の戻り値に置き換えられます。
  ///
  /// [orElse]が与えられていない場合は要素が削除されます。
  ///
  /// ```dart
  /// final colors = <Map<String, dynamic>>[
  ///   {"id": 1, "color": "red"},
  ///   {"id": 2, "color": "green"},
  ///   {"id": 5, "color": "yellow"}
  /// ];
  /// final fruits =  <Map<String, dynamic>>[
  ///   {"id": 1, "fruits": "strawberry"},
  ///   {"id": 3, "fruits": "orange"},
  ///   {"id": 5, "fruits": "banana"}
  /// ];
  /// final merged = colors.setWhere(
  ///   fruits,
  ///   test: (original, other) => original["id"] == other["id"],
  ///   apply: (original, other) => original..["fruits"] = other["fruits"],
  /// ); // [{"id": 1, "color": "red", "fruits": "strawberry"}, {"id": 5, "color": "yellow", "fruits": "banana"}]
  /// ```
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

  /// Inserts a [value] element for each [per] of [Iterable].
  ///
  /// [Iterable]の[per]ごとに[value]の要素をインサートします。
  ///
  /// ```dart
  /// final array = [1, 3, 5, 7, 9];
  /// final inserted = array.insertEvery(2, 3); // [1, 3, 5, 2, 7, 9]
  /// ```
  Iterable<T> insertEvery(T value, int per) {
    return split(per).joinToList(value);
  }

  /// Returns `true` if the internals of [Iterable] and [others] are compared and match.
  ///
  /// [Iterable]と[others]の内部を比較して一致している場合`true`を返します。
  bool equalsTo(Iterable<T>? others) {
    return deepEquals(this, others);
  }

  /// [print] the entire contents of [List].
  ///
  /// [List]の中身をすべて[print]します。
  void print() {
    for (final tmp in this) {
      // ignore: avoid_print
      core.print(tmp.toString());
    }
  }
}
