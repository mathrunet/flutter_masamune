part of model_notifier;

/// Specify the path and use [DynamicMap] to
/// hold the data [LocalCollectionModel].
///
/// You don't need to define a class to hold data strictly,
/// so you can develop quickly, but it lacks stability.
class RuntimeDynamicCollectionModel
    extends RuntimeCollectionModel<RuntimeDynamicDocumentModel>
    implements DynamicCollectionModel<RuntimeDynamicDocumentModel> {
  /// Specify the path and use [DynamicMap] to
  /// hold the data [LocalCollectionModel].
  ///
  /// You don't need to define a class to hold data strictly,
  /// so you can develop quickly, but it lacks stability.
  RuntimeDynamicCollectionModel(
    String path, [
    List<RuntimeDynamicDocumentModel>? value,
  ])  : assert(
          !(path.splitLength() <= 0 || path.splitLength() % 2 != 1),
          "The path hierarchy must be an odd number: $path",
        ),
        super(path, value ?? []);

  /// Add a process to create a document object.
  @override
  @protected
  RuntimeDynamicDocumentModel createDocument(String path) =>
      RuntimeDynamicDocumentModel(path);
}
