part of masamune;

@immutable
class LocalModuleAdapter extends ModuleAdapter<
    LocalDynamicDocumentModel,
    LocalDynamicCollectionModel,
    ModelProvider<LocalDynamicDocumentModel>,
    ModelProvider<LocalDynamicCollectionModel>> {
  const LocalModuleAdapter();

  @override
  T collectionProvider<T extends ModelProvider<LocalDynamicCollectionModel>>(
          String path) =>
      localCollectionProvider(path) as T;

  @override
  T documentProvider<T extends ModelProvider<LocalDynamicDocumentModel>>(
          String path) =>
      localDocumentProvider(path) as T;

  @override
  LocalDynamicDocumentModel loadDocument(LocalDynamicDocumentModel document) {
    return document..loadOnce();
  }

  @override
  LocalDynamicCollectionModel loadCollection(
      LocalDynamicCollectionModel collection) {
    return collection..loadOnce();
  }

  @override
  final bool enabledAuth = false;

  @override
  Future<void> registerInEmailAndPassword(
      {required String email, required String password}) {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  Future<void> signInAnonymously() {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  Future<void> signInEmailAndPassword(
      {required String email, required String password}) {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  Future<void> tryRestoreAuth() {
    throw UnimplementedError("The authentication function is not implemented.");
  }
}
