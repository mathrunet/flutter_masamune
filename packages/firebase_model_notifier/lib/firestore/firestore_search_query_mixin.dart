part of firebase_model_notifier;

/// A mix-in to let the search take place.
///
/// You can add a search function to a document by attaching it to the document.
mixin FirestoreSearchQueryMixin<T extends FirestoreDocumentModel>
    on FirestoreCollectionModel<T> {
  String _searchText = "";

  /// The key prefix for the search.
  @protected
  String get searchValueKey => MetaConst.search;

  /// You can change the [query] object of Firestore.
  @override
  @protected
  @mustCallSuper
  Query<DynamicMap> query(Query<DynamicMap> query) {
    if (_searchText.isEmpty) {
      return query;
    }
    final tmp = [];
    _searchText.toLowerCase().splitByBigram().forEach((text) {
      if (tmp.contains(text)) {
        return;
      }
      tmp.add(text);
      query = query.where("$searchValueKey.$text", isEqualTo: true);
    });
    return super.query(query);
  }

  /// You can search by specifying search characters in [search].
  ///
  /// If [force] is specified, the update will be forced.
  Future<List<T>> search(
    String search, {
    bool force = false,
  }) async {
    if (!force && _searchText == search) {
      return this;
    }
    _searchText = search;
    clear();
    await load();
    return this;
  }

  /// Load data while monitoring Firestore for real-time updates.
  ///
  /// It will continue to monitor for updates until [dispose()].
  @override
  Future<FirestoreCollectionModel<T>> listen() {
    throw UnimplementedError(
      "In the case of search processing, Listen is not possible.",
    );
  }
}
