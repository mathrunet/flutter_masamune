part of model_notifier;

/// Specify the path and use [DynamicMap] to
/// hold the data [RuntimeDocumentModel].
///
/// You don't need to define a class to hold data strictly,
/// so you can develop quickly, but it lacks stability.
class RuntimeDynamicDocumentModel extends RuntimeDocumentModel<DynamicMap>
    with MapModelMixin<String, dynamic>, RuntimeDocumentMetaMixin<DynamicMap>
    implements DynamicDocumentModel {
  /// Specify the path and use [DynamicMap] to
  /// hold the data [RuntimeDocumentModel].
  ///
  /// You don't need to define a class to hold data strictly,
  /// so you can develop quickly, but it lacks stability.
  RuntimeDynamicDocumentModel(String path, [DynamicMap? map])
      : assert(
          !(path.splitLength() <= 0 || path.splitLength() % 2 != 0),
          "The path hierarchy must be an even number: $path",
        ),
        super(path, map ?? {});

  /// If this value is `true`,
  /// Notify changes when there are changes in the map itself using map-specific methods.
  @override
  @protected
  bool get notifyOnChangeMap => false;

  // @override
  // void notifyListeners() {
  //   super.notifyListeners();
  //   _LocalDatabase._notifyChildChanges(this);
  // }

  /// Creates a specific object from a given [map].
  ///
  /// This is used to convert the loaded data into an object for internal management.
  @override
  DynamicMap fromMap(DynamicMap map) => map.cast<String, dynamic>();

  /// Creates a specific object from a given [map].
  ///
  /// This is used to convert the loaded data into an object for internal management.
  @override
  DynamicMap toMap(DynamicMap value) => value.cast<String, dynamic>();

  /// Callback after the delete has been done.
  @override
  @protected
  @mustCallSuper
  Future<void> onDidDelete() async {
    super.onDidDelete();
    clear();
  }
}
