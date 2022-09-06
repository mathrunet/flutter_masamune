part of firebase_model_notifier;

/// Abstract class for retrieving collection data of [T] through Functions.
abstract class FirebaseFunctionsCollectionModel<T> extends ValueModel<List<T>>
    with ListModelMixin<T> {
  /// Abstract class for retrieving collection data of [T] through Functions.
  FirebaseFunctionsCollectionModel(this.endpoint, [List<T>? value])
      : super(value ?? []);

  /// Get an instance of Firebase Functions.
  @protected
  FirebaseFunctions get functions {
    return FirebaseFunctions.instanceFor(region: FirebaseCore.region);
  }

  /// If this value is true,
  /// Notify changes when there are changes in the list itself using list-specific methods.
  @override
  bool get notifyOnChangeList => false;

  /// If this value is true,
  /// the change will be notified when [value] itself is changed.
  @override
  bool get notifyOnChangeValue => true;

  /// Firebase Functions endpoint.
  final String endpoint;

  /// Converts the [list] data retrieved from Functions to a type of [List<T>].
  List<T> fromCollection(List<Object> list);

  /// Converts the current [list] data to a [List<Object>] for storage in Functions.
  List<Object> toCollection(List<T> list);

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

  /// Callback after the load has been done.
  @protected
  @mustCallSuper
  Future<void> onDidSave() async {}

  /// You can describe the process when you get the [response].
  ///
  /// Describe error handling (throw Exception in case of error), etc.
  @protected
  @mustCallSuper
  void onCatchResponse(HttpsCallableResult<List> response) {}

  /// You can describe the process of converting the response [list] data to [List<Object>] data.
  @protected
  List<Object> fromResponse(List list) => list.cast<Object>();

  /// You can describe a process to filter the [loaded] data.
  @protected
  @mustCallSuper
  List<Object> filterOnCall(List<Object> loaded) => loaded;

  /// Add a process to create a document object.
  @protected
  T createDocument();

  /// Create a new document.
  T create() => createDocument();

  /// Functions can be called to retrieve the data.
  ///
  /// You can specify the Post data to be called in [parameters].
  Future<List<T>> call({DynamicMap? parameters}) async {
    await FirebaseCore.initialize();
    await onLoad();
    final res = await functions
        .httpsCallable(endpoint.split("/").last)
        .call<List>(parameters);
    onCatchResponse(res);
    final data = fromCollection(filterOnCall(fromResponse(res.data)));
    addAll(data);
    notifyListeners();
    await onDidLoad();
    return this;
  }
}
