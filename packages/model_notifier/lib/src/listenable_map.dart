part of model_notifier;

/// This is a [ChangeNotifier] class that can be handled as a map.
///
/// When the contents of the map change, you will be notified of the change.
class ListenableMap<K, V> extends ValueNotifier<Map<K, V>>
    implements Map<K, V> {
  /// This is a [ChangeNotifier] class that can be handled as a map.
  ///
  /// When the contents of the map change, you will be notified of the change.
  ListenableMap() : super({});

  /// This is a [ChangeNotifier] class that can be handled as a map.
  ///
  /// When the contents of the map change, you will be notified of the change.
  ListenableMap.from(Map<K, V> map) : super(Map<K, V>.from(map));

  /// This is a [ChangeNotifier] class that can be handled as a map.
  ///
  /// When the contents of the map change, you will be notified of the change.
  factory ListenableMap.fromListenable(Listenable listenable) {
    if (listenable is ListenableMap<K, V>) {
      final map = ListenableMap<K, V>.from(listenable);
      listenable.addListener(map.notifyListeners);
      return map;
    } else if (listenable is ValueListenable<Map<K, V>>) {
      final map = ListenableMap<K, V>.from(listenable.value);
      listenable.addListener(map.notifyListeners);
      return map;
    } else {
      final map = ListenableMap<K, V>();
      listenable.addListener(map.notifyListeners);
      return map;
    }
  }

  /// Sends a notification to itself when the target [listenable] is updated.
  void dependOn(
    Listenable listenable, [
    Map<K, V> Function(Map<K, V> origin)? filter,
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
    if (other is ListenableMap) {
      if (value.length != other.length) {
        return false;
      }
      for (final key in value.keys) {
        if (!other.containsKey(key) || value[key] != other[key]) {
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

  /// The value for the given [key], or null if [key] is not in the map.
  ///
  /// Some maps allow null as a value.
  /// For those maps, a lookup using this operator cannot distinguish between a key not being in the map,
  /// and the key being there with a null value.
  /// Methods like [containsKey] or [putIfAbsent] can be used if the distinction is important.
  @override
  V? operator [](Object? key) => value[key];

  /// Associates the [key] with the given [value].
  ///
  /// If the key was already in the map, its associated value is changed.
  /// Otherwise the key/value pair is added to the map.
  @override
  void operator []=(K key, V value) {
    if (this.value.containsKey(key) && this.value[key] == value) {
      return;
    }
    this.value[key] = value;
    notifyListeners();
  }

  /// Adds all key/value pairs of [other] to this map.
  ///
  /// If a key of [other] is already in this map, its value is overwritten.
  ///
  /// The operation is equivalent to doing `this[key] = value` for each key
  /// and associated value in other. It iterates over [other], which must
  /// therefore not change during the iteration.
  @override
  void addAll(Map<K, V> other) {
    value.addAll(other);
    notifyListeners();
  }

  /// Adds all key/value pairs of [newEntries] to this map.
  ///
  /// If a key of [newEntries] is already in this map,
  /// the corresponding value is overwritten.
  ///
  /// The operation is equivalent to doing `this[entry.key] = entry.value`
  /// for each [MapEntry] of the iterable.
  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    value.addEntries(newEntries);
    notifyListeners();
  }

  /// Provides a view of this map as having [RK] keys and [RV] instances,
  /// if necessary.
  ///
  /// If this map is already a `Map<RK, RV>`, it is returned unchanged.
  ///
  /// If this set contains only keys of type [RK] and values of type [RV],
  /// all read operations will work correctly.
  /// If any operation exposes a non-[RK] key or non-[RV] value,
  /// the operation will throw instead.
  ///
  /// Entries added to the map must be valid for both a `Map<K, V>` and a
  /// `Map<RK, RV>`.
  @override
  Map<RK, RV> cast<RK, RV>() => value.cast<RK, RV>();

  /// Removes all entries from the map.
  ///
  /// After this, the map is empty.
  @override
  void clear() {
    value.clear();
    notifyListeners();
  }

  /// Whether this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  @override
  bool containsKey(Object? key) => value.containsKey(key);

  /// Whether this map contains the given [value].
  ///
  /// Returns true if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  @override
  bool containsValue(Object? value) => this.value.containsValue(value);

  /// The map entries of [this].
  @override
  Iterable<MapEntry<K, V>> get entries => value.entries;

  /// Applies [action] to each key/value pair of the map.
  ///
  /// Calling `action` must not add or remove keys from the map.
  @override
  void forEach(void Function(K key, V value) action) {
    value.forEach(action);
  }

  /// Whether there is no key/value pair in the map.
  @override
  bool get isEmpty => value.isEmpty;

  /// Whether there is at least one key/value pair in the map.
  @override
  bool get isNotEmpty => value.isNotEmpty;

  /// The keys of [this].
  ///
  /// The returned iterable has efficient `length` and `contains` operations,
  /// based on [length] and [containsKey] of the map.
  ///
  /// The order of iteration is defined by the individual `Map` implementation,
  /// but must be consistent between changes to the map.
  ///
  /// Modifying the map while iterating the keys may break the iteration.
  @override
  Iterable<K> get keys => value.keys;

  /// The number of key/value pairs in the map.
  @override
  int get length => value.length;

  /// Returns a new map where all entries of this map are transformed by
  /// the given [convert] function.
  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    return value.map<K2, V2>(convert);
  }

  /// Look up the value of [key], or add a new entry if it isn't there.
  ///
  /// Returns the value associated to [key], if there is one.
  /// Otherwise calls [ifAbsent] to get a new value, associates [key] to
  /// that value, and then returns the new value.
  /// ```dart
  /// Map<String, int> scores = {'Bob': 36};
  /// for (var key in ['Bob', 'Rohan', 'Sophena']) {
  ///   scores.putIfAbsent(key, () => key.length);
  /// }
  /// scores['Bob'];      // 36
  /// scores['Rohan'];    //  5
  /// scores['Sophena'];  //  7
  /// ```
  /// Calling [ifAbsent] must not add or remove keys from the map.
  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final value = this.value.putIfAbsent(key, ifAbsent);
    notifyListeners();
    return value;
  }

  /// Removes [key] and its associated value, if present, from the map.
  ///
  /// Returns the value associated with `key` before it was removed.
  /// Returns `null` if `key` was not in the map.
  ///
  /// Note that some maps allow `null` as a value,
  /// so a returned `null` value doesn't always mean that the key was absent.
  @override
  V? remove(Object? key) {
    final value = this.value.remove(key);
    if (value != null) {
      notifyListeners();
    }
    return value;
  }

  /// Removes all entries of this map that satisfy the given [test].
  @override
  void removeWhere(bool Function(K key, V value) test) {
    value.removeWhere((key, value) {
      if (!test(key, value)) {
        return false;
      }
      notifyListeners();
      return true;
    });
  }

  /// Updates the value for the provided [key].
  ///
  /// Returns the new value associated with the key.
  ///
  /// If the key is present, invokes [update] with the current value and stores
  /// the new value in the map.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned value to the map.
  ///
  /// If the key is not present, [ifAbsent] must be provided.
  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final value = this.value.update(key, update, ifAbsent: ifAbsent);
    notifyListeners();
    return value;
  }

  /// Updates all values.
  ///
  /// Iterates over all entries in the map and updates them with the result
  /// of invoking [update].
  @override
  void updateAll(V Function(K key, V value) update) {
    value.updateAll(update);
    notifyListeners();
  }

  /// The values of [this].
  ///
  /// The values are iterated in the order of their corresponding keys.
  /// This means that iterating [keys] and [values] in parallel will
  /// provide matching pairs of keys and values.
  ///
  /// The returned iterable has an efficient `length` method based on the
  /// [length] of the map. Its [Iterable.contains] method is based on
  /// `==` comparison.
  ///
  /// Modifying the map while iterating the values may break the iteration.
  @override
  Iterable<V> get values => value.values;
}
