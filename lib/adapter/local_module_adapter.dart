part of masamune;

@immutable
class LocalModuleAdapter extends ModuleAdapter {
  const LocalModuleAdapter();

  @override
  ModelProvider<T> collectionProvider<T extends DynamicCollectionModel>(
          String path) =>
      localCollectionProvider(path) as ModelProvider<T>;

  @override
  ModelProvider<T> documentProvider<T extends DynamicDocumentModel>(
          String path) =>
      localDocumentProvider(path) as ModelProvider<T>;

  @override
  T loadDocument<T extends DynamicDocumentModel>(T document) {
    if (document is LocalDynamicDocumentModel) {
      document.loadOnce();
    }
    return document;
  }

  @override
  T loadCollection<T extends DynamicCollectionModel>(T collection) {
    if (collection is LocalDynamicCollectionModel) {
      collection.loadOnce();
    }
    return collection;
  }

  @override
  Future<void> deleteDocument<T extends DynamicDocumentModel>(
      T document) async {
    if (document is LocalDynamicDocumentModel) {
      await document.delete();
    }
  }

  @override
  Future<void> saveDocument<T extends DynamicDocumentModel>(T document) async {
    if (document is LocalDynamicDocumentModel) {
      await document.save();
    }
  }

  @override
  Future<String> uploadMedia(String path) {
    throw UnimplementedError("The function is not implemented.");
  }

  @override
  // ignore: avoid_field_initializers_in_const_classes
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

  @override
  String get email {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final bool isAnonymously = true;

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final bool isSignedIn = true;

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final bool isVerified = true;

  @override
  String get name {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  String get phoneNumber {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  String get photoURL {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  String get userId => Config.uid;
}
