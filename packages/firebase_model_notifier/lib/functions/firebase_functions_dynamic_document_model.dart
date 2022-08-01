part of firebase_model_notifier;

/// Class for retrieving document data of [DynamicMap] through Functions.
class FirebaseFunctionsDynamicDocumentModel
    extends FirebaseFunctionsDocumentModel<DynamicMap>
    with MapModelMixin<String, dynamic> {
  /// Class for retrieving document data of [DynamicMap] through Functions.
  FirebaseFunctionsDynamicDocumentModel(String endpoint, [DynamicMap? map])
      : super(endpoint, map ?? {});

  /// If this value is true,
  /// Notify changes when there are changes in the map itself using map-specific methods.
  @override
  @protected
  bool get notifyOnChangeMap => false;

  /// Initial value.
  @override
  @protected
  DynamicMap get initialValue => {};

  /// Creates a specific object from a given [map].
  ///
  /// This is used to convert the loaded data into an object for internal management.
  @override
  DynamicMap fromMap(DynamicMap map) => map.cast<String, dynamic>();

  /// Creates a [DynamicMap] from its own [value].
  ///
  /// It is used for storing data.
  @override
  DynamicMap toMap(DynamicMap value) => value.cast<String, Object>();
}
