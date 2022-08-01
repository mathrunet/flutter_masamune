part of model_notifier;

/// [Model] which only stores one value.
///
/// It can be used in the same way as [ValueNotifier].
///
/// You can also use [toString()] to convert it to a [Stream].
abstract class ValueModel<T> extends Model<T> implements ValueListenable<T> {
  /// [Model] which only stores one value.
  ///
  /// It can be used in the same way as [ValueNotifier].
  ///
  /// You can also use [toString()] to convert it to a [Stream].
  ValueModel(T value)
      : _value = value,
        super();

  final Map<Function, ValueNotifier> _valueNotifiers = {};

  /// Generates a value notifier.
  ///
  /// Whenever a value is updated, the value of the notifier is also updated.
  ///
  /// The notifier is also closed when the ValueModel is [dispose()].
  ValueNotifier<V> toNotifier<V>(V Function(T value) converter) {
    if (_valueNotifiers.containsKey(converter)) {
      return _valueNotifiers[converter]! as ValueNotifier<V>;
    }
    return _valueNotifiers[converter] = ValueNotifier<V>(converter.call(value));
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
    _valueNotifiers.values.forEach((element) => element.dispose());
    _valueNotifiers.clear();
  }

  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have changed. Listeners that are added during this iteration
  /// will not be visited. Listeners that are removed during this iteration will
  /// not be visited after they are removed.
  ///
  /// Exceptions thrown by listeners will be caught and reported using
  /// [FlutterError.reportError].
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (e.g.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removeListener].
  @override
  @protected
  @mustCallSuper
  void notifyListeners() {
    if (disposed) {
      return;
    }
    super.notifyListeners();
    for (final tmp in _valueNotifiers.entries) {
      tmp.value.value = tmp.key.call(value);
    }
  }

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  T get value => _value;
  T _value;

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    if (notifyOnChangeValue) {
      notifyListeners();
    }
  }

  /// If this value is `true`,
  /// the change will be notified when [value] itself is changed.
  bool get notifyOnChangeValue => true;

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
  bool operator ==(Object other) => hashCode == other.hashCode;

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
  int get hashCode => value?.hashCode ?? super.hashCode;

  /// A string representation of this object.
  ///
  /// Some classes have a default textual representation,
  /// often paired with a static parse function (like [int.parse]).
  /// These classes will provide the textual representation as their string represetion.
  ///
  /// Other classes have no meaningful textual representation that a program will care about.
  /// Such classes will typically override toString to provide useful information when inspecting the object, mainly for debugging or logging.
  @override
  String toString() => "$runtimeType($value)";
}
