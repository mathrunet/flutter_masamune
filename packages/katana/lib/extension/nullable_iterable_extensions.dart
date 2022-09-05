part of katana;

/// Provides general extensions to [Iterable<T>?].
extension NullableIterableExtensions<T> on Iterable<T>? {
  /// Returns true if there are no elements in this collection.
  ///
  /// May be computed by checking if iterator.moveNext() returns false.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Returns true if there is at least one element in this collection.
  ///
  /// May be computed by checking if iterator.moveNext() returns true.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// Returns the number of elements in [this].
  ///
  /// Counting all elements may involve iterating through all elements and can therefore be slow.
  /// Some iterables have a more efficient way to find the number of elements.
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Returns the first element.
  ///
  /// Return `null` if the list has no element.
  T? get firstOrNull {
    if (this == null || isEmpty) {
      return null;
    }
    return this?.first;
  }

  /// Returns the last element.
  ///
  /// Return `null` if the list has no element.
  T? get lastOrNull {
    if (this == null || isEmpty) {
      return null;
    }
    return this?.last;
  }

  /// Returns the first value found by searching based on the condition specified in [test].
  ///
  /// If the value is not found, [Null] is returned.
  T? firstWhereOrNull(bool Function(T item) test) {
    if (this == null || isEmpty) {
      return null;
    }
    for (final element in this!) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// Whether the collection contains an element equal to [element].
  ///
  /// This operation will check each element in order for being equal to [element],
  /// unless it has a more efficient way to find an element equal to [element].
  ///
  /// The equality used to determine whether [element] is equal to an element of the iterable defaults to the [Object.==] of the element.
  ///
  /// Some types of iterable may have a different equality used for its elements.
  /// For example, a [Set] may have a custom equality (see [Set.identity]) that its contains uses.
  /// Likewise the Iterable returned by a [Map.keys] call should use the same equality that the Map uses for keys.
  bool contains(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.contains(element);
  }

  /// Returns `true` if any of the given [elements] is in the list.
  bool containsAny(Iterable<Object?> elements) {
    if (this == null) {
      return false;
    }
    return elements.any((element) => this!.contains(element));
  }

  /// Returns `true` if all of the given [elements] is in the list.
  bool containsAll(Iterable<Object?> elements) {
    if (this == null) {
      return false;
    }
    return elements.every((element) => this!.contains(element));
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
    if (this == null) {
      return tmp;
    }
    for (final original in this!) {
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

  /// Return `True` if all match while comparing the contents of [others].
  bool equalsTo(Iterable<T>? others) {
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
