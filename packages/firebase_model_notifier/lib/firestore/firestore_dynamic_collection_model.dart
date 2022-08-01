part of firebase_model_notifier;

/// Specify the path and use [DynamicMap] to
/// hold the data [FirestoreCollectionModel].
///
/// You don't need to define a class to hold data strictly,
/// so you can develop quickly, but it lacks stability.
class FirestoreDynamicCollectionModel
    extends FirestoreCollectionModel<FirestoreDynamicDocumentModel>
    with FirestoreCollectionQueryMixin<FirestoreDynamicDocumentModel>
    implements DynamicCollectionModel<FirestoreDynamicDocumentModel> {
  /// Specify the path and use [DynamicMap] to
  /// hold the data [FirestoreCollectionModel].
  ///
  /// You don't need to define a class to hold data strictly,
  /// so you can develop quickly, but it lacks stability.
  FirestoreDynamicCollectionModel(
    String path, [
    List<FirestoreDynamicDocumentModel>? value,
  ])  : assert(
          !(path.splitLength() <= 0 || path.splitLength() % 2 != 1),
          "The path hierarchy must be an odd number: $path",
        ),
        super(path, value ?? []);

  /// Add a process to create a document object.
  @override
  @protected
  FirestoreDynamicDocumentModel createDocument(String path) =>
      FirestoreDynamicDocumentModel(path);
}
