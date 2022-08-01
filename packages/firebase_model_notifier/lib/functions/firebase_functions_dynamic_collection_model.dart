part of firebase_model_notifier;

/// Class for retrieving collection data of [DynamicMap] list through Functions.
class FirebaseFunctionsDynamicCollectionModel
    extends FirebaseFunctionsCollectionModel<DynamicMap> {
  /// Class for retrieving collection data of [DynamicMap] list through Functions.
  FirebaseFunctionsDynamicCollectionModel(
    String endpoint, [
    List<MapModel<dynamic>>? value,
  ]) : super(endpoint, value ?? []);

  /// Converts the [list] data retrieved from Functions to a type of [List].
  @override
  List<DynamicMap> fromCollection(List<Object> list) => list.cast<DynamicMap>();

  /// Converts the current [list] data to a [List] for storage in Functions.
  @override
  List<Object> toCollection(List<DynamicMap> list) => list.cast<Object>();

  /// Add a process to create a document object.
  @override
  DynamicMap createDocument() => {};
}
