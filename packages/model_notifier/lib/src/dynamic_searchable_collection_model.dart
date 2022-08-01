part of model_notifier;

/// Searchable collection model for flexibly modifying the contents of an object that is primarily a [DynamicMap].
abstract class DynamicSearchableCollectionModel<T extends DynamicDocumentModel>
    extends DynamicCollectionModel<T> {
  /// Give [search] to perform a search.
  ///
  /// Basically, it returns itself.
  ///
  /// If [force] is specified, the update will be forced.
  Future<List<T>> search(
    String search, {
    bool force = false,
  });
}
