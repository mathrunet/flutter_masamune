part of model_notifier;

/// A mixin to add search functionality to [LocalCollectionModel].
mixin LocalSearchQueryMixin<T extends LocalDocumentModel>
    on LocalCollectionModel<T> {
  String _searchText = "";
  List<String>? _splitBygram;

  /// The key to perform the search.
  @protected
  String get searchValueKey => MetaConst.search;

  /// True if filtering by [ModelQuery] is enabled.
  @override
  @protected
  bool get enableQueryFilter => false;

  /// Filters the given [data].
  ///
  /// If it returns true, the data will be included.
  @override
  @protected
  bool filter(DynamicMap data) {
    if (_searchText.isEmpty) {
      return true;
    }
    final tmp = [];
    final search = data.getAsMap(searchValueKey);
    _splitBygram ??= _searchText.toLowerCase().splitByBigram();
    for (final text in _splitBygram!) {
      if (tmp.contains(text)) {
        continue;
      }
      if (search.get(text, false)) {
        return true;
      }
    }
    return false;
  }

  /// Give [search] to perform a search.
  ///
  /// Basically, it returns itself.
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
    _splitBygram = null;
    clear();
    await load();
    return this;
  }
}
