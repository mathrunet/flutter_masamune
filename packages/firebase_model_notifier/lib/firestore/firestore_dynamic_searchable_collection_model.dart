part of firebase_model_notifier;

/// Retrieves and retrieves collection data stored in a firestore database.
///
/// The basic usage is to use the [search] method to search for data.
///
/// In order to be searched by [search], each document must have a data format stored in the specified way.
class FirestoreDynamicSearchableCollectionModel
    extends FirestoreCollectionModel<FirestoreDynamicDocumentModel>
    with FirestoreSearchQueryMixin
    implements
        DynamicCollectionModel<FirestoreDynamicDocumentModel>,
        DynamicSearchableCollectionModel<FirestoreDynamicDocumentModel> {
  /// Retrieves and retrieves collection data stored in a firestore database.
  ///
  /// The basic usage is to use the [search] method to search for data.
  ///
  /// In order to be searched by [search], each document must have a data format stored in the specified way.
  FirestoreDynamicSearchableCollectionModel(String path) : super(path);

  /// Add a process to create a document object.
  @override
  @protected
  FirestoreDynamicDocumentModel createDocument(String path) =>
      FirestoreDynamicDocumentModel(path);
}
