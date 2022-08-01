part of masamune;

/// Base class for holding and manipulating data from a local database as a collection of [LocalDocumentModel].
///
/// The [load()] method retrieves the value from the local database and
/// the [save()] method saves the value to the local database.
///
/// The local database is a Json database.
/// Specify a path to specify the location of the contents.
///
/// In addition, since it can be used as [List],
/// it is possible to operate the content as it is.
final localCollectionProvider =
    ChangeNotifierProvider.family<LocalDynamicCollectionModel, String>(
  (_, path) => LocalDynamicCollectionModel(path),
);

/// Base class for holding and manipulating data from a local database as a collection of [LocalDocumentModel].
///
/// The [load()] method retrieves the value from the local database and
/// the [save()] method saves the value to the local database.
///
/// The local database is a Json database.
/// Specify a path to specify the location of the contents.
///
/// In addition, since it can be used as [List],
/// it is possible to operate the content as it is.
final localCollectionDisposableProvider = ChangeNotifierProvider.autoDispose
    .family<LocalDynamicCollectionModel, String>(
  (_, path) => LocalDynamicCollectionModel(path),
);
