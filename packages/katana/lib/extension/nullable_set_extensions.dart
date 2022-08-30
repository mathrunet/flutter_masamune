part of katana;


/// Provides general extensions to [Set<T>?].
extension NullableSetExtensions<T> on Set<T>? {
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

  /// Returns the number of elements in the iterable.
  ///
  /// This is an efficient operation that doesn't require iterating through the elements.
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Whether value is in the set.
  bool contains(Object? element) {
    if (this == null) {
      return false;
    }
    return this!.contains(element);
  }

  /// Returns `true` if any of the given [others] is in the list.
  bool containsAny(Iterable<Object?> others) {
    if (this == null) {
      return false;
    }
    return others.any((element) => this!.contains(element));
  }

  /// Return `True` if all match while comparing the contents of [others].
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
