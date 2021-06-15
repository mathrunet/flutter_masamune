part of masamune;

@immutable
class InheritedModelAdapter<TDocument extends DynamicDocumentModel,
        TCollection extends DynamicCollectionModel>
    extends ModelAdapter<TDocument, TCollection> {
  const InheritedModelAdapter(
    this.adapter, {
    this.prefix = "",
    this.suffix = "",
  });

  final String prefix;
  final String suffix;
  final ModelAdapter<TDocument, TCollection> adapter;

  @override
  ModelProvider<TCollection> collectionProvider(String path) =>
      adapter.collectionProvider("$prefix$path$suffix");

  @override
  ModelProvider<TDocument> documentProvider(String path) =>
      adapter.documentProvider("$prefix$path$suffix");

  @override
  TDocument loadDocument(TDocument document) => adapter.loadDocument(document);

  @override
  TCollection loadCollection(TCollection collection) =>
      adapter.loadCollection(collection);

  @override
  Future<void> deleteDocument(TDocument document) =>
      adapter.deleteDocument(document);

  @override
  TDocument createDocument(
    TCollection collection, [
    String? id,
  ]) =>
      adapter.createDocument(collection, id);

  @override
  Future<void> saveDocument(TDocument document) =>
      adapter.saveDocument(document);

  @override
  Future<String> uploadMedia(String path) => adapter.uploadMedia(path);

  @override
  bool get enabledAuth => adapter.enabledAuth;

  @override
  Future<void> registerInEmailAndPassword(
          {required String email, required String password}) =>
      adapter.registerInEmailAndPassword(email: email, password: password);

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      adapter.sendPasswordResetEmail(email: email);

  @override
  Future<void> signInAnonymously() => adapter.signInAnonymously();

  @override
  Future<void> signInEmailAndPassword(
          {required String email, required String password}) =>
      adapter.signInEmailAndPassword(email: email, password: password);

  @override
  Future<void> signOut() => adapter.signOut();

  @override
  Future<void> tryRestoreAuth() => adapter.tryRestoreAuth();

  @override
  String get email => adapter.email;

  @override
  bool get isAnonymously => adapter.isAnonymously;

  @override
  bool get isSignedIn => adapter.isSignedIn;

  @override
  bool get isVerified => adapter.isVerified;

  @override
  String get name => adapter.name;

  @override
  String get phoneNumber => adapter.phoneNumber;

  @override
  String get photoURL => adapter.photoURL;

  @override
  String get userId => adapter.userId;

  @override
  InheritedModelAdapter? fromMap(DynamicMap map) {
    throw UnimplementedError();
  }

  @override
  DynamicMap toMap() {
    throw UnimplementedError();
  }
}
