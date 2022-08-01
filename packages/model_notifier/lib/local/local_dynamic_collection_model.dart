part of model_notifier;

/// Specify the path and use [DynamicMap] to
/// hold the data [LocalCollectionModel].
///
/// You don't need to define a class to hold data strictly,
/// so you can develop quickly, but it lacks stability.
class LocalDynamicCollectionModel
    extends LocalCollectionModel<LocalDynamicDocumentModel>
    implements DynamicCollectionModel<LocalDynamicDocumentModel> {
  /// Specify the path and use [DynamicMap] to
  /// hold the data [LocalCollectionModel].
  ///
  /// You don't need to define a class to hold data strictly,
  /// so you can develop quickly, but it lacks stability.
  LocalDynamicCollectionModel(
    String path, [
    List<LocalDynamicDocumentModel>? value,
  ])  : assert(
          !(path.splitLength() <= 0 || path.splitLength() % 2 != 1),
          "The path hierarchy must be an odd number: $path",
        ),
        super(path, value ?? []);

  /// Add a process to create a document object.
  @override
  @protected
  LocalDynamicDocumentModel createDocument(String path) =>
      LocalDynamicDocumentModel(path);
}
