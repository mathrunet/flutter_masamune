part of model_notifier;

/// This is a [ChangeNotifier] class that can be handled as a list.
///
/// When the contents of the list change, you will be notified of the change.
class ListenableList<T> extends ValueNotifier<List<T>>
    implements List<T>, ValueListenable<List<T>> {
  /// This is a [ChangeNotifier] class that can be handled as a list.
  ///
  /// When the contents of the list change, you will be notified of the change.
  ListenableList() : super([]);

  /// This is a [ChangeNotifier] class that can be handled as a list.
  ///
  /// When the contents of the list change, you will be notified of the change.
  ListenableList.from(List<T> list) : super(List<T>.from(list));

  /// This is a [ChangeNotifier] class that can be handled as a list.
  ///
  /// When the contents of the list change, you will be notified of the change.
  factory ListenableList.fromListenable(Listenable listenable) {
    if (listenable is ListenableList<T>) {
      final list = ListenableList<T>.from(listenable);
      listenable.addListener(list.notifyListeners);
      return list;
    } else if (listenable is ValueListenable<List<T>>) {
      final list = ListenableList<T>.from(listenable.value);
      listenable.addListener(list.notifyListeners);
      return list;
    } else {
      final list = ListenableList<T>();
      listenable.addListener(list.notifyListeners);
      return list;
    }
  }

  /// Sends a notification to itself when the target [listenable] is updated.
  void dependOn(
    Listenable listenable, [
    List<T> Function(List<T> origin)? filter,
  ]) {
    listenable.addListener(() {
      if (filter != null) {
        value = filter.call(value);
      } else {
        notifyListeners();
      }
    });
  }

  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] and [removeListener] will throw after the object is
  /// disposed).
  ///
  /// This method should only be called by the object's owner.
  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    value.clear();
  }

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (value == other) {
      return true;
    }
    if (other is ListenableList) {
      if (value.length != other.length) {
        return false;
      }
      for (int i = 0; i < value.length; i++) {
        if (value[i] != other[i]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => value.hashCode;

  /// A string representation of this object.
  ///
  /// Some classes have a default textual representation,
  /// often paired with a static parse function (like [int.parse]).
  /// These classes will provide the textual representation as their string represetion.
  ///
  /// Other classes have no meaningful textual representation that a program will care about.
  /// Such classes will typically override toString to provide useful information when inspecting the object, mainly for debugging or logging.
  @override
  String toString() => IterableBase.iterableToShortString(this, "(", ")");

  /// Changes the length of this list.
  ///
  /// The list must be growable.
  /// If [newLength] is greater than current length,
  /// new entries are initialized to null,
  /// so [newLength] must not be greater than the current length if the element type [E] is non-nullable.
  @override
  set length(int value) {
    this.value.length = value;
    notifyListeners();
  }

  /// Returns the concatenation of this list and [other].
  ///
  /// Returns a new list containing the elements of this list followed by the elements of [other].
  ///
  /// The default behavior is to return a normal growable list.
  /// Some list types may choose to return a list of the same type as themselves (see [Uint8List.+]);
  @override
  List<T> operator +(List<T> other) => value + other;

  /// The object at the given [index] in the list.
  ///
  /// The [index] must be a valid index of this list,
  /// which means that index must be non-negative and less than [length].
  @override
  T operator [](int index) => value[index];

  /// Sets the value at the given [index] in the list to [value].
  ///
  /// The [index] must be a valid index of this list,
  /// which means that index must be non-negative and less than [length].
  @override
  void operator []=(int index, T value) {
    this.value[index] = value;
    notifyListeners();
  }

  /// Adds [value] to the end of this list, extending the length by one.
  ///
  /// The list must be growable.
  @override
  void add(T value) {
    this.value.add(value);
    notifyListeners();
  }

  /// Appends all objects of [iterable] to the end of this list.
  ///
  /// Extends the length of the list by the number of objects in [iterable].
  /// The list must be growable.
  @override
  void addAll(Iterable<T> iterable) {
    value.addAll(iterable);
    notifyListeners();
  }

  /// Removes all objects from this list; the length of the list becomes zero.
  ///
  /// The list must be growable.
  @override
  void clear() {
    value.clear();
    notifyListeners();
  }

  /// Overwrites a range of elements with [fillValue].
  ///
  /// Sets the positions greater than or equal to [start] and less than [end],
  /// to [fillValue].
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// Example:
  /// ```dart
  /// var list = List.filled(5, -1);
  /// print(list); //  [-1, -1, -1, -1, -1]
  /// list.fillRange(1, 3, 4);
  /// print(list); //  [-1, 4, 4, -1, -1]
  /// ```
  ///
  /// If the element type is not nullable, the [fillValue] must be provided and
  /// must be non-`null`.
  @override
  void fillRange(int start, int end, [T? fillValue]) {
    value.fillRange(start, end, fillValue);
    notifyListeners();
  }

  /// Inserts [element] at position [index] in this list.
  ///
  /// This increases the length of the list by one and shifts all objects
  /// at or after the index towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  @override
  void insert(int index, T element) {
    value.insert(index, element);
    notifyListeners();
  }

  /// Inserts all objects of [iterable] at position [index] in this list.
  ///
  /// This increases the length of the list by the length of [iterable] and
  /// shifts all later objects towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  @override
  void insertAll(int index, Iterable<T> iterable) {
    value.insertAll(index, iterable);
    notifyListeners();
  }

  /// Removes the first occurrence of [value] from this list.
  ///
  /// Returns true if [value] was in the list, false otherwise.
  /// ```dart
  /// var parts = ['head', 'shoulders', 'knees', 'toes'];
  /// parts.remove('head'); // true
  /// parts.join(', ');     // 'shoulders, knees, toes'
  /// ```
  /// The method has no effect if [value] was not in the list.
  /// ```dart
  /// // Note: 'head' has already been removed.
  /// parts.remove('head'); // false
  /// parts.join(', ');     // 'shoulders, knees, toes'
  /// ```
  ///
  /// The list must be growable.
  @override
  bool remove(Object? value) {
    if (this.value.remove(value)) {
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Removes the object at position [index] from this list.
  ///
  /// This method reduces the length of `this` by one and moves all later objects
  /// down by one position.
  ///
  /// Returns the removed value.
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  ///
  /// The list must be growable.
  @override
  T removeAt(int index) {
    final value = this.value.removeAt(index);
    notifyListeners();
    return value;
  }

  /// Removes and returns the last object in this list.
  ///
  /// The list must be growable and non-empty.
  @override
  T removeLast() {
    final value = this.value.removeLast();
    notifyListeners();
    return value;
  }

  /// Removes a range of elements from the list.
  ///
  /// Removes the elements with positions greater than or equal to [start]
  /// and less than [end], from the list.
  /// This reduces the list's length by `end - start`.
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The list must be growable.
  @override
  void removeRange(int start, int end) {
    value.removeRange(start, end);
    notifyListeners();
  }

  /// Removes all objects from this list that satisfy [test].
  ///
  /// An object `o` satisfies [test] if `test(o)` is true.
  /// ```dart
  /// var numbers = ['one', 'two', 'three', 'four'];
  /// numbers.removeWhere((item) => item.length == 3);
  /// numbers.join(', '); // 'three, four'
  /// ```
  /// The list must be growable.
  @override
  void removeWhere(bool Function(T element) test) {
    value.removeWhere((e) {
      if (!test(e)) {
        return false;
      }
      return true;
    });
    notifyListeners();
  }

  /// Replaces a range of elements with the elements of [replacement].
  ///
  /// Removes the objects in the range from [start] to [end],
  /// then inserts the elements of [replacements] at [start].
  /// ```dart
  /// var list = [1, 2, 3, 4, 5];
  /// list.replaceRange(1, 4, [6, 7]);
  /// list.join(', '); // '1, 6, 7, 5'
  /// ```
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The operation `list.replaceRange(start, end, replacements)`
  /// is roughly equivalent to:
  /// ```dart
  /// list.removeRange(start, end);
  /// list.insertAll(start, replacements);
  /// ```
  /// but may be more efficient.
  ///
  /// The list must be growable.
  /// This method does not work on fixed-length lists, even when [replacement]
  /// has the same number of elements as the replaced range. In that case use
  /// [setRange] instead.
  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    value.replaceRange(start, end, replacement);
    notifyListeners();
  }

  /// Removes all objects from this list that fail to satisfy [test].
  ///
  /// An object `o` satisfies [test] if `test(o)` is true.
  /// ```dart
  /// var numbers = ['one', 'two', 'three', 'four'];
  /// numbers.retainWhere((item) => item.length == 3);
  /// numbers.join(', '); // 'one, two'
  /// ```
  /// The list must be growable.
  @override
  void retainWhere(bool Function(T element) test) {
    value.retainWhere((e) {
      if (test(e)) {
        return true;
      }
      return false;
    });
    notifyListeners();
  }

  /// An [Iterable] of the objects in this list in reverse order.
  @override
  Iterable<T> get reversed {
    final iterable = value.reversed;
    notifyListeners();
    return iterable;
  }

  /// Overwrites elements with the objects of [iterable].
  ///
  /// The elements of [iterable] are written into this list,
  /// starting at position [index].
  /// ```dart
  /// var list = ['a', 'b', 'c', 'd'];
  /// list.setAll(1, ['bee', 'sea']);
  /// list.join(', '); // 'a, bee, sea, d'
  /// ```
  /// This operation does not increase the length of the list.
  ///
  /// The [index] must be non-negative and no greater than [length].
  ///
  /// The [iterable] must not have more elements than what can fit from [index]
  /// to [length].
  ///
  /// If `iterable` is based on this list, its values may change _during_ the
  /// `setAll` operation.
  @override
  void setAll(int index, Iterable<T> iterable) {
    value.setAll(index, iterable);
    notifyListeners();
  }

  /// Writes some elements of [iterable] into a range of this list.
  ///
  /// Copies the objects of [iterable], skipping [skipCount] objects first,
  /// into the range from [start], inclusive, to [end], exclusive, of this list.
  /// ```dart
  /// var list1 = [1, 2, 3, 4];
  /// var list2 = [5, 6, 7, 8, 9];
  /// // Copies the 4th and 5th items in list2 as the 2nd and 3rd items
  /// // of list1.
  /// list1.setRange(1, 3, list2, 3);
  /// list1.join(', '); // '1, 8, 9, 4'
  /// ```
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The [iterable] must have enough objects to fill the range from `start`
  /// to `end` after skipping [skipCount] objects.
  ///
  /// If `iterable` is this list, the operation correctly copies the elements
  /// originally in the range from `skipCount` to `skipCount + (end - start)` to
  /// the range `start` to `end`, even if the two ranges overlap.
  ///
  /// If `iterable` depends on this list in some other way, no guarantees are
  /// made.
  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    value.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  /// Shuffles the elements of this list randomly.
  @override
  void shuffle([Random? random]) {
    value.shuffle(random);
    notifyListeners();
  }

  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// The [compare] function must act as a [Comparator].
  /// ```dart
  /// var numbers = ['two', 'three', 'four'];
  /// // Sort from shortest to longest.
  /// numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers);  // [two, four, three]
  /// ```
  /// The default [List] implementations use [Comparable.compare] if
  /// [compare] is omitted.
  /// ```dart
  /// List<int> nums = [13, 2, -11];
  /// nums.sort();
  /// print(nums);  // [-11, 2, 13]
  /// ```
  /// In that case, the elements of the list must be [Comparable] to
  /// each other.
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they
  /// are distinct objects.
  /// The sort function is not guaranteed to be stable, so distinct objects
  /// that compare as equal may occur in any order in the result:
  /// ```dart
  /// var numbers = ['one', 'two', 'three', 'four'];
  /// numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers);  // [one, two, four, three] OR [two, one, four, three]
  /// ```
  @override
  void sort([int Function(T a, T b)? compare]) {
    value.sort(compare);
    notifyListeners();
  }

  /// Checks whether any element of this iterable satisfies [test].
  ///
  /// Checks every element in iteration order, and returns `true` if
  /// any of them make [test] return `true`, otherwise returns false.
  @override
  bool any(bool test(T element)) => value.any(test);

  /// Returns a view of this list as a list of [R] instances.
  ///
  /// If this list contains only instances of [R], all read operations
  /// will work correctly. If any operation tries to access an element
  /// that is not an instance of [R], the access will throw instead.
  ///
  /// Elements added to the list (e.g., by using [add] or [addAll])
  /// must be instance of [R] to be valid arguments to the adding function,
  /// and they must be instances of [E] as well to be accepted by
  /// this list as well.
  ///
  /// Typically implemented as `List.castFrom<E, R>(this)`.
  @override
  List<E> cast<E>() => value.cast<E>();

  /// Whether the collection contains an element equal to [element].
  ///
  /// This operation will check each element in order for being equal to
  /// [element], unless it has a more efficient way to find an element
  /// equal to [element].
  ///
  /// The equality used to determine whether [element] is equal to an element of
  /// the iterable defaults to the [Object.==] of the element.
  ///
  /// Some types of iterable may have a different equality used for its elements.
  /// For example, a [Set] may have a custom equality
  /// (see [Set.identity]) that its `contains` uses.
  /// Likewise the `Iterable` returned by a [Map.keys] call
  /// should use the same equality that the `Map` uses for keys.
  @override
  bool contains(Object? element) => value.contains(element);

  /// Returns the [index]th element.
  ///
  /// The [index] must be non-negative and less than [length].
  /// Index zero represents the first element (so `iterable.elementAt(0)` is
  /// equivalent to `iterable.first`).
  ///
  /// May iterate through the elements in iteration order, ignoring the
  /// first [index] elements and then returning the next.
  /// Some iterables may have a more efficient way to find the element.
  @override
  T elementAt(int index) => value.elementAt(index);

  /// Checks whether every element of this iterable satisfies [test].
  ///
  /// Checks every element in iteration order, and returns `false` if
  /// any of them make [test] return `false`, otherwise returns `true`.
  @override
  bool every(bool test(T element)) => value.every(test);

  /// Expands each element of this [Iterable] into zero or more elements.
  ///
  /// The resulting Iterable runs through the elements returned
  /// by [f] for each element of this, in iteration order.
  ///
  /// The returned [Iterable] is lazy, and calls [f] for each element
  /// of this every time it's iterated.
  ///
  /// Example:
  /// ```dart
  /// var pairs = [[1, 2], [3, 4]];
  /// var flattened = pairs.expand((pair) => pair).toList();
  /// print(flattened); // => [1, 2, 3, 4];
  ///
  /// var input = [1, 2, 3];
  /// var duplicated = input.expand((i) => [i, i]).toList();
  /// print(duplicated); // => [1, 1, 2, 2, 3, 3]
  /// ```
  @override
  Iterable<E> expand<E>(Iterable<E> f(T element)) => value.expand(f);

  /// Returns the first element.
  ///
  /// Throws a [StateError] if `this` is empty.
  /// Otherwise returns the first element in the iteration order,
  /// equivalent to `this.elementAt(0)`.
  @override
  T get first => value.first;

  /// Put the value at the first [element].
  @override
  set first(T element) {
    if (isEmpty) {
      throw RangeError.index(0, this);
    }
    this[0] = element;
  }

  /// Returns the first element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// If [orElse] is omitted, it defaults to throwing a [StateError].
  @override
  T firstWhere(bool test(T element), {T Function()? orElse}) =>
      value.firstWhere(test, orElse: orElse);

  /// Reduces a collection to a single value by iteratively combining each
  /// element of the collection with an existing value
  ///
  /// Uses [initialValue] as the initial value,
  /// then iterates through the elements and updates the value with
  /// each element using the [combine] function, as if by:
  /// ```dart
  /// var value = initialValue;
  /// for (E element in this) {
  ///   value = combine(value, element);
  /// }
  /// return value;
  /// ```
  /// Example of calculating the sum of an iterable:
  /// ```dart
  /// iterable.fold(0, (prev, element) => prev + element);
  /// ```
  @override
  E fold<E>(E initialValue, E combine(E previousValue, T element)) =>
      value.fold(initialValue, combine);

  /// Returns the lazy concatenation of this iterable and [other].
  ///
  /// The returned iterable will provide the same elements as this iterable,
  /// and, after that, the elements of [other], in the same order as in the
  /// original iterables.
  @override
  Iterable<T> followedBy(Iterable<T> other) => value.followedBy(other);

  /// Applies the function [f] to each element of this collection in iteration
  /// order.
  @override
  void forEach(void f(T element)) => value.forEach(f);

  /// Returns `true` if there are no elements in this collection.
  ///
  /// May be computed by checking if `iterator.moveNext()` returns `false`.
  @override
  bool get isEmpty => value.isEmpty;

  /// Returns true if there is at least one element in this collection.
  ///
  /// May be computed by checking if `iterator.moveNext()` returns `true`.
  @override
  bool get isNotEmpty => value.isNotEmpty;

  /// Returns a new `Iterator` that allows iterating the elements of this
  /// `Iterable`.
  ///
  /// Iterable classes may specify the iteration order of their elements
  /// (for example [List] always iterate in index order),
  /// or they may leave it unspecified (for example a hash-based [Set]
  /// may iterate in any order).
  ///
  /// Each time `iterator` is read, it returns a new iterator,
  /// which can be used to iterate through all the elements again.
  /// The iterators of the same iterable can be stepped through independently,
  /// but should return the same elements in the same order,
  /// as long as the underlying collection isn't changed.
  ///
  /// Modifying the collection may cause new iterators to produce
  /// different elements, and may change the order of existing elements.
  /// A [List] specifies its iteration order precisely,
  /// so modifying the list changes the iteration order predictably.
  /// A hash-based [Set] may change its iteration order completely
  /// when adding a new element to the set.
  ///
  /// Modifying the underlying collection after creating the new iterator
  /// may cause an error the next time [Iterator.moveNext] is called
  /// on that iterator.
  /// Any *modifiable* iterable class should specify which operations will
  /// break iteration.
  @override
  Iterator<T> get iterator => value.iterator;

  /// Converts each element to a [String] and concatenates the strings.
  ///
  /// Iterates through elements of this iterable,
  /// converts each one to a [String] by calling [Object.toString],
  /// and then concatenates the strings, with the
  /// [separator] string interleaved between the elements.
  @override
  String join([String separator = ""]) => value.join(separator);

  /// Returns the last element.
  ///
  /// Throws a [StateError] if `this` is empty.
  /// Otherwise may iterate through the elements and returns the last one
  /// seen.
  /// Some iterables may have more efficient ways to find the last element
  /// (for example a list can directly access the last element,
  /// without iterating through the previous ones).
  @override
  T get last => value.last;

  /// Put the value at the last [element].
  @override
  set last(T element) {
    if (isEmpty) {
      throw RangeError.index(0, this);
    }
    this[length - 1] = element;
  }

  /// Returns the last element that satisfies the given predicate [test].
  ///
  /// An iterable that can access its elements directly may check its
  /// elements in any order (for example a list starts by checking the
  /// last element and then moves towards the start of the list).
  /// The default implementation iterates elements in iteration order,
  /// checks `test(element)` for each,
  /// and finally returns that last one that matched.
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// If [orElse] is omitted, it defaults to throwing a [StateError].
  @override
  T lastWhere(bool test(T element), {T Function()? orElse}) =>
      value.lastWhere(test, orElse: orElse);

  /// The number of objects in this list.
  ///
  /// The valid indices for a list are `0` through `length - 1`.
  @override
  int get length => value.length;

  /// Returns a new lazy [Iterable] with elements that are created by
  /// calling `f` on each element of this `Iterable` in iteration order.
  ///
  /// This method returns a view of the mapped elements. As long as the
  /// returned [Iterable] is not iterated over, the supplied function [f] will
  /// not be invoked. The transformed elements will not be cached. Iterating
  /// multiple times over the returned [Iterable] will invoke the supplied
  /// function [f] multiple times on the same element.
  ///
  /// Methods on the returned iterable are allowed to omit calling `f`
  /// on any element where the result isn't needed.
  /// For example, [elementAt] may call `f` only once.
  @override
  Iterable<E> map<E>(E f(T e)) => value.map(f);

  /// Reduces a collection to a single value by iteratively combining elements
  /// of the collection using the provided function.
  ///
  /// The iterable must have at least one element.
  /// If it has only one element, that element is returned.
  ///
  /// Otherwise this method starts with the first element from the iterator,
  /// and then combines it with the remaining elements in iteration order,
  /// as if by:
  /// ```dart
  /// E value = iterable.first;
  /// iterable.skip(1).forEach((element) {
  ///   value = combine(value, element);
  /// });
  /// return value;
  /// ```
  /// Example of calculating the sum of an iterable:
  /// ```dart
  /// iterable.reduce((value, element) => value + element);
  /// ```
  @override
  T reduce(T combine(T value, T element)) => value.reduce(combine);

  /// Checks that this iterable has only one element, and returns that element.
  ///
  /// Throws a [StateError] if `this` is empty or has more than one element.
  @override
  T get single => value.single;

  /// Returns the single element that satisfies [test].
  ///
  /// Checks elements to see if `test(element)` returns true.
  /// If exactly one element satisfies [test], that element is returned.
  /// If more than one matching element is found, throws [StateError].
  /// If no matching element is found, returns the result of [orElse].
  /// If [orElse] is omitted, it defaults to throwing a [StateError].
  @override
  T singleWhere(bool test(T element), {T Function()? orElse}) =>
      value.singleWhere(test, orElse: orElse);

  /// Returns an [Iterable] that provides all but the first [count] elements.
  ///
  /// When the returned iterable is iterated, it starts iterating over `this`,
  /// first skipping past the initial [count] elements.
  /// If `this` has fewer than `count` elements, then the resulting Iterable is
  /// empty.
  /// After that, the remaining elements are iterated in the same order as
  /// in this iterable.
  ///
  /// Some iterables may be able to find later elements without first iterating
  /// through earlier elements, for example when iterating a [List].
  /// Such iterables are allowed to ignore the initial skipped elements.
  ///
  /// The [count] must not be negative.
  @override
  Iterable<T> skip(int n) => value.skip(n);

  /// Returns an `Iterable` that skips leading elements while [test] is satisfied.
  ///
  /// The filtering happens lazily. Every new [Iterator] of the returned
  /// iterable iterates over all elements of `this`.
  ///
  /// The returned iterable provides elements by iterating this iterable,
  /// but skipping over all initial elements where `test(element)` returns
  /// true. If all elements satisfy `test` the resulting iterable is empty,
  /// otherwise it iterates the remaining elements in their original order,
  /// starting with the first element for which `test(element)` returns `false`.
  @override
  Iterable<T> skipWhile(bool test(T value)) => value.skipWhile(test);

  /// Returns a lazy iterable of the [count] first elements of this iterable.
  ///
  /// The returned `Iterable` may contain fewer than `count` elements, if `this`
  /// contains fewer than `count` elements.
  ///
  /// The elements can be computed by stepping through [iterator] until [count]
  /// elements have been seen.
  ///
  /// The `count` must not be negative.
  @override
  Iterable<T> take(int n) => value.take(n);

  /// Returns a lazy iterable of the leading elements satisfying [test].
  ///
  /// The filtering happens lazily. Every new iterator of the returned
  /// iterable starts iterating over the elements of `this`.
  ///
  /// The elements can be computed by stepping through [iterator] until an
  /// element is found where `test(element)` is false. At that point,
  /// the returned iterable stops (its `moveNext()` returns false).
  @override
  Iterable<T> takeWhile(bool test(T value)) => value.takeWhile(test);

  /// Creates a [List] containing the elements of this [Iterable].
  ///
  /// The elements are in iteration order.
  /// The list is fixed-length if [growable] is false.
  @override
  @override
  List<T> toList({bool growable = true}) => value.toList(growable: growable);

  /// Creates a [Set] containing the same elements as this iterable.
  ///
  /// The set may contain fewer elements than the iterable,
  /// if the iterable contains an element more than once,
  /// or it contains one or more elements that are equal.
  /// The order of the elements in the set is not guaranteed to be the same
  /// as for the iterable.
  @override
  Set<T> toSet() => value.toSet();

  /// Returns a new lazy [Iterable] with all elements that satisfy the
  /// predicate [test].
  ///
  /// The matching elements have the same order in the returned iterable
  /// as they have in [iterator].
  ///
  /// This method returns a view of the mapped elements.
  /// As long as the returned [Iterable] is not iterated over,
  /// the supplied function [test] will not be invoked.
  /// Iterating will not cache results, and thus iterating multiple times over
  /// the returned [Iterable] may invoke the supplied
  /// function [test] multiple times on the same element.
  @override
  Iterable<T> where(bool test(T element)) => value.where(test);

  /// Returns a new lazy [Iterable] with all elements that have type [T].
  ///
  /// The matching elements have the same order in the returned iterable
  /// as they have in [iterator].
  ///
  /// This method returns a view of the mapped elements.
  /// Iterating will not cache results, and thus iterating multiple times over
  /// the returned [Iterable] may yield different results,
  /// if the underlying elements change between iterations.
  @override
  Iterable<E> whereType<E>() => value.whereType<E>();

  /// An unmodifiable [Map] view of this list.
  ///
  /// The map uses the indices of this list as keys and the corresponding objects
  /// as values. The `Map.keys` [Iterable] iterates the indices of this list
  /// in numerical order.
  /// ```dart
  /// var words = ['fee', 'fi', 'fo', 'fum'];
  /// var map = words.asMap();  // {0: fee, 1: fi, 2: fo, 3: fum}
  /// map[0] + map[1];   // 'feefi';
  /// map.keys.toList(); // [0, 1, 2, 3]
  /// ```
  @override
  Map<int, T> asMap() => value.asMap();

  /// Creates an [Iterable] that iterates over a range of elements.
  ///
  /// The returned iterable iterates over the elements of this list
  /// with positions greater than or equal to [start] and less than [end].
  ///
  /// The provided range, [start] and [end], must be valid at the time
  /// of the call.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The returned [Iterable] behaves like `skip(start).take(end - start)`.
  /// That is, it does *not* break if this list changes size, it just
  /// ends early if it reaches the end of the list early
  /// (if `end`, or even `start`, becomes greater than [length]).
  /// ```dart
  /// List<String> colors = ['red', 'green', 'blue', 'orange', 'pink'];
  /// Iterable<String> range = colors.getRange(1, 4);
  /// range.join(', ');  // 'green, blue, orange'
  /// colors.length = 3;
  /// range.join(', ');  // 'green, blue'
  /// ```
  @override
  Iterable<T> getRange(int start, int end) => value.getRange(start, end);

  /// The first index of [element] in this list.
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `o == element`,
  /// the index of `o` is returned.
  /// ```dart
  /// var notes = ['do', 're', 'mi', 're'];
  /// notes.indexOf('re');    // 1
  /// notes.indexOf('re', 2); // 3
  /// ```
  /// Returns -1 if [element] is not found.
  /// ```dart
  /// notes.indexOf('fa');    // -1
  /// ```
  @override
  int indexOf(T element, [int start = 0]) => value.indexOf(element, start);

  /// The first index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `test(o)` is true,
  /// the index of `o` is returned.
  ///
  /// ```
  /// var notes = ['do', 're', 'mi', 're'];
  /// notes.indexWhere((note) => note.startsWith('r'));       // 1
  /// notes.indexWhere((note) => note.startsWith('r'), 2);    // 3
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  /// ```
  /// notes.indexWhere((note) => note.startsWith('k'));    // -1
  /// ```
  @override
  int indexWhere(bool test(T element), [int start = 0]) =>
      value.indexWhere(test, start);

  /// The last index of [element] in this list.
  ///
  /// Searches the list backwards from index [start] to 0.
  ///
  /// The first time an object `o` is encountered so that `o == element`,
  /// the index of `o` is returned.
  /// ```dart
  /// var notes = ['do', 're', 'mi', 're'];
  /// notes.lastIndexOf('re', 2); // 1
  /// ```
  /// If [start] is not provided, this method searches from the end of the
  /// list.
  /// ```dart
  /// notes.lastIndexOf('re');  // 3
  /// ```
  /// Returns -1 if [element] is not found.
  /// ```dart
  /// notes.lastIndexOf('fa');  // -1
  /// ```
  @override
  int lastIndexOf(T element, [int? start]) => value.lastIndexOf(element, start);

  /// The last index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to 0.
  /// The first time an object `o` is encountered so that `test(o)` is true,
  /// the index of `o` is returned.
  /// If [start] is omitted, it defaults to the [length] of the list.
  ///
  /// ```
  /// var notes = ['do', 're', 'mi', 're'];
  /// notes.lastIndexWhere((note) => note.startsWith('r'));       // 3
  /// notes.lastIndexWhere((note) => note.startsWith('r'), 2);    // 1
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  /// ```
  /// notes.lastIndexWhere((note) => note.startsWith('k'));    // -1
  /// ```
  @override
  int lastIndexWhere(bool test(T element), [int? start]) =>
      value.lastIndexWhere(test, start);

  /// Returns a new list containing the elements between [start] and [end].
  ///
  /// The new list is a `List<E>` containing the elements of this list at
  /// positions greater than or equal to [start] and less than [end] in the same
  /// order as they occur in this list.
  ///
  /// ```dart
  /// var colors = ["red", "green", "blue", "orange", "pink"];
  /// print(colors.sublist(1, 3)); // [green, blue]
  /// ```
  ///
  /// If [end] is omitted, it defaults to the [length] of this list.
  ///
  /// ```dart
  /// print(colors.sublist(1)); // [green, blue, orange, pink]
  /// ```
  ///
  /// The `start` and `end` positions must satisfy the relations
  /// 0 ≤ `start` ≤ `end` ≤ [length]
  /// If `end` is equal to `start`, then the returned list is empty.
  @override
  List<T> sublist(int start, [int? end]) => value.sublist(start, end);
}
