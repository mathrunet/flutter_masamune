part of katana;

/// Provides general extensions to [List<T>?].
extension NullableListExtensions<T> on List<T>? {
  /// Insert the [element] first.
  List<T>? insertFirst(T element) {
    if (this == null) {
      return this;
    }
    this!.insert(0, element);
    return this!;
  }

  /// Insert the [element] last.
  List<T>? insertLast(T element) {
    if (this == null) {
      return this;
    }
    this!.add(element);
    return this!;
  }

  /// Inserts an insert element at the element's position if True with a [test].
  List<T>? insertWhere(
    T element,
    bool Function(T? prev, T? current, T? next) test,
  ) {
    if (this == null) {
      return this;
    }
    for (int i = length - 1; i >= 0; i--) {
      if (!test(
        i <= 0 ? null : this![i - 1],
        this![i],
        i >= length - 1 ? null : this![i + 1],
      )) {
        continue;
      }
      this!.insert(i, element);
      return this;
    }
    this!.insert(0, element);
    return this!;
  }

  /// Get a random value from an array element.
  ///
  /// You can set a random seed by specifying [seed].
  T? getRandom([int? seed]) {
    if (isEmpty) {
      return null;
    }
    final index = Random(seed).nextInt(length);
    return this![index];
  }

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// The [compare] function must act as a [Comparator].
  /// ```dart
  /// final numbers = <String>['two', 'three', 'four'];
  /// // Sort from shortest to longest.
  /// final sorted = numbers.sortTo((a, b) => a.length.compareTo(b.length));
  /// print(sorted); // [two, four, three]
  /// ```
  /// The default [List] implementations use [Comparable.compare] if
  /// [compare] is omitted.
  /// ```dart
  /// final numbers = <int>[13, 2, -11, 0];
  /// final sorted = numbers.sortTo();
  /// print(sorted); // [-11, 0, 2, 13]
  /// ```
  /// In that case, the elements of the list must be [Comparable] to
  /// each other.
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they
  /// are distinct objects.
  /// The sort function is not guaranteed to be stable, so distinct objects
  /// that compare as equal may occur in any order in the result:
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// final sorted numbers.sortTo((a, b) => a.length.compareTo(b.length));
  /// print(sorted); // [one, two, four, three] OR [two, one, four, three]
  /// ```
  List<T>? sortTo([int Function(T a, T b)? compare]) {
    if (this == null) {
      return null;
    }
    final sorted = List<T>.from(this!);
    sorted.sort(compare);
    return sorted;
  }

  /// Returns True if the list contains a key ([index]).
  bool containsKey(int index) {
    if (this == null) {
      return false;
    }
    return index >= 0 && index < length;
  }

  /// Returns True if the list contains [value].
  ///
  /// Same as [contains].
  bool containsValue(T value) {
    if (this == null) {
      return false;
    }
    return contains(value);
  }

  /// Extend the list to [length], and if not, put [value].
  List<T?>? fill(int length, [T? value]) {
    if (this == null) {
      return null;
    }
    final tmp = <T?>[];
    for (int i = 0; i < max(length, this.length); i++) {
      if (i < this.length) {
        tmp.add(this![i]);
      } else {
        tmp.add(value);
      }
    }
    return tmp;
  }
}
