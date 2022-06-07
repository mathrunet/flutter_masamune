part of masamune;

/// Retrieves and retrieves collection data stored in a runtime database.
///
/// The basic usage is to use the [search] method to search for data.
///
/// In order to be searched by [search], each document must have a data format stored in the specified way.
final runtimeSearchableCollectionProvider = ChangeNotifierProvider.family<
    RuntimeDynamicSearchableCollectionModel, String>(
  (_, path) => RuntimeDynamicSearchableCollectionModel(path),
);
