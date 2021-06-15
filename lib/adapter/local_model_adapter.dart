part of masamune;

@immutable
class LocalModelAdapter extends ModelAdapter<LocalDynamicDocumentModel,
    LocalDynamicCollectionModel> {
  const LocalModelAdapter();

  @override
  ModelProvider<LocalDynamicCollectionModel> collectionProvider(String path) =>
      localCollectionProvider(path);

  @override
  ModelProvider<LocalDynamicDocumentModel> documentProvider(String path) =>
      localDocumentProvider(path);

  @override
  LocalDynamicDocumentModel loadDocument(LocalDynamicDocumentModel document) {
    document.loadOnce();
    return document;
  }

  @override
  LocalDynamicCollectionModel loadCollection(
      LocalDynamicCollectionModel collection) {
    collection.loadOnce();
    return collection;
  }

  @override
  Future<void> deleteDocument(LocalDynamicDocumentModel document) async {
    await document.delete();
  }

  @override
  LocalDynamicDocumentModel createDocument(
    LocalDynamicCollectionModel collection, [
    String? id,
  ]) {
    return collection.create(id);
  }

  @override
  Future<void> saveDocument(LocalDynamicDocumentModel document) async {
    await document.save();
  }

  @override
  Future<String> uploadMedia(String path) async {
    return path;
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

  @override
  LocalModelAdapter? fromMap(DynamicMap map) {
    if (map.get("type", "") != type) {
      return null;
    }
    return const LocalModelAdapter();
  }

  @override
  DynamicMap toMap() {
    return <String, dynamic>{
      "type": type,
    };
  }
}
