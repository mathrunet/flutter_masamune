// ignore_for_file: use_late_for_private_fields_and_variables

part of masamune_firebase;

/// Retrieves and retrieves collection data stored in a firestore database.
///
/// The basic usage is to use the [search] method to search for data.
///
/// In order to be searched by [search], each document must have a data format stored in the specified way.
final firestoreSearchableCollectionProvider = ChangeNotifierProvider.family<
    FirestoreDynamicSearchableCollectionModel, String>(
  (_, path) => FirestoreDynamicSearchableCollectionModel(path),
);

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
