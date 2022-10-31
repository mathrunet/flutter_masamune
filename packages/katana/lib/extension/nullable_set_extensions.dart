part of katana;

/// Provides an extension method for [Set] that is nullable.
///
/// Nullableな[Set]用の拡張メソッドを提供します。
extension NullableSetExtensions<T> on Set<T>? {
  /// Whether this collection has no elements.
  ///
  /// May be computed by checking if `iterator.moveNext()` returns `false`.
  ///
  /// このコレクションに要素がないかどうかを調べます。
  ///
  /// `iterator.moveNext()` が `false` を返すかどうかを確認することで計算できます。
  ///
  /// Example:
  ///
  /// ```dart
  /// final emptyList = <int>[];
  /// print(emptyList.isEmpty); // true;
  /// print(emptyList.iterator.moveNext()); // false
  /// ```
  ///
  /// Returns `true` if itself is [Null].
  ///
  /// 自身が[Null]な場合は`true`を返します。
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Whether this collection has at least one element.
  ///
  /// May be computed by checking if `iterator.moveNext()` returns `true`.
  ///
  /// このコレクションに少なくとも 1 つの要素があるかどうかを調べます。
  ///
  /// `iterator.moveNext()` が `true` を返すかどうかを確認することで計算できます。
  ///
  /// Example:
  ///
  /// ```dart
  /// final numbers = <int>{1, 2, 3};
  /// print(numbers.isNotEmpty); // true;
  /// print(numbers.iterator.moveNext()); // true
  /// ```
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// Returns the number of elements in [Iterable].
  ///
  /// Counting all elements may involve iterating through all elements and can therefore be slow.
  ///
  /// Some [Iterable] have a more efficient way to find the number of elements.
  ///
  /// Returns `0` if itself is [Null].
  ///
  /// [Iterable] の要素数を返します。
  ///
  /// すべての要素をカウントするには、すべての要素を反復処理する必要があるため、処理が遅くなる可能性があります。
  ///
  /// 一部の[Iterable]には、要素の数を見つけるためのより効率的な方法があります。
  ///
  /// 自身が[Null]な場合は`0`を返します。
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Whether the collection contains an element equal to [element].
  ///
  /// This operation will check each element in order for being equal to [element], unless it has a more efficient way to find an element equal to [element].
  ///
  /// The equality used to determine whether [element] is equal to an element of the [Iterable] defaults to the [Object.==] of the element.
  ///
  /// Some types of [Iterable] may have a different equality used for its elements.
  ///
  /// For example, a [Set] may have a custom equality (see [Set.identity]) that its `contains` uses.
  ///
  /// Likewise the `Iterable` returned by a [Map.keys] call should use the same equality that the `Map` uses for keys.
  ///
  /// コレクションに [element] と等しい要素が含まれているかどうかを調べます。
  ///
  /// この操作は、[element] と等しい要素を見つけるためのより効率的な方法がない限り、各要素が [element] と等しいかどうかを順番にチェックします。
  ///
  /// [element] が [Iterable] の要素と等しいかどうかを判断するために使用される等価性は、デフォルトで要素の [Object.==] になります。
  ///
  /// 一部のタイプの [Iterable] では、要素に使用される等価性が異なる場合があります。
  ///
  /// たとえば、[Set] には、その `contains` が使用するカスタムの等価性 ([Set.identity] を参照) がある場合があります。
  ///
  /// 同様に、[Map.keys] 呼び出しによって返される `Iterable` は、`Map` がキーに使用するのと同じ等価性を使用する必要があります。
  ///
  /// Example:
  ///
  /// ```dart
  /// final gasPlanets = <int, String>{1: 'Jupiter', 2: 'Saturn'};
  /// final containsOne = gasPlanets.keys.contains(1); // true
  /// final containsFive = gasPlanets.keys.contains(5); // false
  /// final containsJupiter = gasPlanets.values.contains('Jupiter'); // true
  /// final containsMercury = gasPlanets.values.contains('Mercury'); // false
  /// ```
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool contains(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.contains(element);
  }

  /// Returns `true` if [Set] contains any of [elements].
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// [Set]に[elements]のいずれかが含まれている場合`true`を返します。
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool containsAny(Iterable<Object?> elements) {
    if (this == null) {
      return false;
    }
    return elements.any((element) => this!.contains(element));
  }

  /// Returns `true` if [Set] contains all [elements].
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// [Set]に[elements]がすべて含まれている場合`true`を返します。
  ///
  /// 自身が[Null]な場合は`false`を返します。
  bool containsAll(Iterable<Object?> elements) {
    if (this == null) {
      return false;
    }
    return elements.every((element) => this!.contains(element));
  }

  /// Returns `true` if the internals of [Set] and [others] are compared and match.
  ///
  /// Returns `true` if both itself and [others] are [null].
  ///
  /// [Set]と[others]の内部を比較して一致している場合`true`を返します。
  ///
  /// 自身と[others]が両方とも[Null]な場合`true`を返します。
  bool equalsTo(Set<T>? others) {
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
