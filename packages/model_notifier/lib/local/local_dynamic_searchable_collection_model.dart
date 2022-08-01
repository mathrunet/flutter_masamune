part of model_notifier;

/// Retrieves and retrieves collection data stored in a local database.
///
/// The basic usage is to use the [search] method to search for data.
///
/// In order to be searched by [search], each document must have a data format stored in the specified way.
class LocalDynamicSearchableCollectionModel
    extends LocalCollectionModel<LocalDynamicDocumentModel>
    with LocalSearchQueryMixin
    implements
        DynamicCollectionModel<LocalDynamicDocumentModel>,
        DynamicSearchableCollectionModel<LocalDynamicDocumentModel> {
  LocalDynamicSearchableCollectionModel(String path) : super(path);

  /// Add a process to create a document object.
  @override
  @protected
  LocalDynamicDocumentModel createDocument(String path) =>
      LocalDynamicDocumentModel(path);
}
