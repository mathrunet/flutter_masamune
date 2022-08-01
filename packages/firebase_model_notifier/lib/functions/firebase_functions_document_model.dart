part of firebase_model_notifier;

/// Abstract class for retrieving document data of [T] through Functions.
abstract class FirebaseFunctionsDocumentModel<T> extends DocumentModel<T> {
  /// Abstract class for retrieving document data of [T] through Functions.
  FirebaseFunctionsDocumentModel(this.endpoint, T initialValue)
      : super(initialValue);

  /// The method to be executed when initialization is performed.
  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    value ??= initialValue;
  }

  /// Get an instance of Firebase Functions.
  @protected
  FirebaseFunctions get functions {
    return FirebaseFunctions.instanceFor(region: FirebaseCore.region);
  }

  /// Initial value.
  @protected
  T get initialValue;

  /// Firebase Functions endpoint.
  final String endpoint;

  /// Callback before the load has been done.
  @protected
  @mustCallSuper
  Future<void> onLoad() async {}

  /// Callback before the save has been done.
  @protected
  @mustCallSuper
  Future<void> onSave() async {}

  /// Callback after the load has been done.
  @protected
  @mustCallSuper
  Future<void> onDidLoad() async {}

  /// Callback after the save has been done.
  @protected
  @mustCallSuper
  Future<void> onDidSave() async {}

  /// You can describe the process when you get the [response].
  ///
  /// Describe error handling (throw Exception in case of error), etc.
  @protected
  @mustCallSuper
  void onCatchResponse(HttpsCallableResult<Map> response) {}

  /// You can describe the process of converting the response [map] data to [DynamicMap] data.
  @protected
  DynamicMap fromResponse(Map map) => map.cast<String, dynamic>();

  /// You can describe a process to filter the [loaded] data.
  @protected
  @mustCallSuper
  DynamicMap filterOnCall(DynamicMap loaded) => loaded;

  /// Functions can be called to retrieve the data.
  ///
  /// You can specify the Post data to be called in [parameters].
  Future<T> call({DynamicMap? parameters}) async {
    await FirebaseCore.initialize();
    await onLoad();
    final res = await functions
        .httpsCallable(endpoint.split("/").last)
        .call<Map>(parameters);
    onCatchResponse(res);
    value = fromMap(filterOnCall(fromResponse(res.data)));
    notifyListeners();
    await onDidLoad();
    return value;
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
  int get hashCode => super.hashCode ^ endpoint.hashCode;
}
