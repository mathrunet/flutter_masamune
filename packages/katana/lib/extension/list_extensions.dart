part of katana;

/// Provides extended methods for [List] in [T].
/// [T]の[List]用の拡張メソッドを提供します。
extension ListExtensions<T> on List<T> {
  /// Insert [element] at the beginning of [List].
  /// [List]の最初に[element]を挿入します。
  List<T> insertFirst(T element) {
    insert(0, element);
    return this;
  }

  /// Insert [element] at the end of [List].
  /// [List]の最後に[element]を挿入します。
  List<T> insertLast(T element) {
    add(element);
    return this;
  }

  /// Inserts [element] before the first element in [List] for which the return value of [test] is `true`.
  /// [List]内の[test]の戻り値が`true`になった最初の要素の前に[element]を挿入します。
  ///
  /// ```dart
  /// final array = [1, 2, 3, 4, 5, 6, 7, 8];
  /// final inserted = array.insertWhere(10, (prev, current, next) => current == 3); // [1, 2, 10, 3, 4, 5, 6, 7, 8];
  /// ```
  List<T> insertWhere(
    T element,
    bool Function(T? prev, T? current, T? next) test,
  ) {
    for (int i = length - 1; i >= 0; i--) {
      if (!test(
        i <= 0 ? null : this[i - 1],
        this[i],
        i >= length - 1 ? null : this[i + 1],
      )) {
        continue;
      }
      insert(i, element);
      return this;
    }
    insert(0, element);
    return this;
  }

  /// Get the [index]th element.
  /// [index]番目の要素を取得します。
  ///
  /// If [index] is out of range, [defaultValue] is returned.
  /// [index]が範囲外の場合[defaultValue]が返されます。
  T get(int index, T defaultValue) {
    if (!containsIndex(index)) {
      return defaultValue;
    }
    return this[index];
  }

  /// Get a random element from [List].
  /// [List]からランダムに要素を取得します。
  ///
  /// If [seed] is specified, a random value is obtained according to the seed.
  /// [seed]を指定するとシードに応じたランダム値を取得します。
  T? getRandom([int? seed]) {
    if (isEmpty) {
      return null;
    }
    final index = Random(seed).nextInt(length);
    return this[index];
  }

  /// Sorts this list according to the order specified by the [compare] function.
  /// [compare] 関数で指定された順序に従って、このリストを並べ替えます。
  ///
  /// The [compare] function must act as a [Comparator].
  /// [compare] 関数は [Comparator] として機能する必要があります。
  ///
  /// ```dart
  /// final numbers = <String>['two', 'three', 'four'];
  /// // Sort from shortest to longest.
  /// final sorted = numbers.sortTo((a, b) => a.length.compareTo(b.length));
  /// print(sorted); // [two, four, three]
  /// ```
  ///
  /// The default [List] implementations use [Comparable.compare] if [compare] is omitted.
  /// [compare] が省略されている場合、デフォルトの [List] 実装は [Comparable.compare] を使用します。
  ///
  /// ```dart
  /// final numbers = <int>[13, 2, -11, 0];
  /// final sorted = numbers.sortTo();
  /// print(sorted); // [-11, 0, 2, 13]
  /// ```
  ///
  /// In that case, the elements of the list must be [Comparable] to each other.
  /// その場合、リストの要素は互いに [Comparable] でなければなりません。
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they are distinct objects.
  /// [Comparator] は、それらが異なるオブジェクトであっても、オブジェクトを等しいものとして比較する (0 を返す) 場合があります。
  ///
  /// The [sortTo] function is not guaranteed to be stable, so distinct objects that compare as equal may occur in any order in the result:
  /// [sortTo]関数は安定していることが保証されていないため、比較すると等しいと見なされる個別のオブジェクトが、結果内で任意の順序で発生する可能性があります。
  ///
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// final sorted numbers.sortTo((a, b) => a.length.compareTo(b.length));
  /// print(sorted); // [one, two, four, three] OR [two, one, four, three]
  /// ```
  List<T> sortTo([int Function(T a, T b)? compare]) {
    final sorted = List<T>.from(this);
    sorted.sort(compare);
    return sorted;
  }

  /// Returns `true` if [index] is within the range of elements in [List].
  /// [index]が[List]の要素の範囲内にある場合`true`を返します。
  bool containsIndex(int index) {
    return index >= 0 && index < length;
  }

  /// If the number of elements in [List] is less than [length], it is filled with [value] up to the [length] elements.
  /// [List]の要素の数が[length]未満の場合、[length]の要素まで[value]で埋め尽くします。
  ///
  /// If [value] is not specified, [null] is inserted.
  /// [value]が指定されない場合は[Null]が挿入されます。
  ///
  /// ```dart
  /// final array = [1, 2, 3];
  /// final filled = array.fill(5, 0); // [1, 2, 3, 0, 0]
  /// ```
  List<T?> fill(int length, [T? value]) {
    final tmp = <T?>[];
    for (int i = 0; i < max(length, this.length); i++) {
      if (i < this.length) {
        tmp.add(this[i]);
      } else {
        tmp.add(value);
      }
    }
    return tmp;
  }
}
