part of model_notifier;

/// Retrieves and retrieves collection data stored in a runtime database.
///
/// The basic usage is to use the [search] method to search for data.
///
/// In order to be searched by [search], each document must have a data format stored in the specified way.
class RuntimeDynamicSearchableCollectionModel
    extends RuntimeCollectionModel<RuntimeDynamicDocumentModel>
    with RuntimeSearchQueryMixin
    implements
        DynamicCollectionModel<RuntimeDynamicDocumentModel>,
        DynamicSearchableCollectionModel<RuntimeDynamicDocumentModel> {
  RuntimeDynamicSearchableCollectionModel(String path) : super(path);

  /// Add a process to create a document object.
  @override
  @protected
  RuntimeDynamicDocumentModel createDocument(String path) =>
      RuntimeDynamicDocumentModel(path);
}
