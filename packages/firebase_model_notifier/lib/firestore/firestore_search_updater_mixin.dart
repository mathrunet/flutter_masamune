part of firebase_model_notifier;

/// Data that can be searched is given at the time of data saving.
mixin FirestoreSearchUpdaterMixin<T> on FirestoreDocumentModel<T> {
  /// The key prefix for the search.
  @protected
  String get searchValueKey => MetaConst.search;

  /// The key of the data to be made searchable.
  @protected
  List<String> get searchableKey;

  /// You can filter the saving content when it is saving.
  ///
  /// Edit the value of [save] and return.
  @override
  @protected
  @mustCallSuper
  DynamicMap filterOnSave(DynamicMap save) {
    var tmp = "";
    for (final key in searchableKey) {
      if (key.isEmpty || !save.containsKey(key)) {
        continue;
      }
      final val = save.get(key, "");
      tmp += val;
    }
    if (tmp.isEmpty) {
      return super.filterOnSave(save);
    }
    save[searchValueKey] =
        tmp.toLowerCase().splitByBigram().toMap((e) => MapEntry(e, true));
    return super.filterOnSave(save);
  }
}
