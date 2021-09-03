part of masamune;

@immutable
class MockModelAdapter extends ModelAdapter<RuntimeDynamicDocumentModel,
    RuntimeDynamicCollectionModel> {
  const MockModelAdapter({required this.userId, required this.data});

  final Map<String, DynamicMap> data;

  @override
  ChangeNotifierProvider<RuntimeDynamicCollectionModel> collectionProvider(
      String path) {
    path = path.trimString("/");
    return runtimeCollectionProvider(path);
  }

  @override
  ChangeNotifierProvider<RuntimeDynamicDocumentModel> documentProvider(
      String path) {
    path = path.trimString("/");
    return runtimeDocumentProvider(path);
  }

  @override
  RuntimeDynamicCollectionModel loadCollection(
      RuntimeDynamicCollectionModel collection,
      [bool once = false]) {
    RuntimeDatabase.registerMockData(data);
    collection.loadOnce();
    return collection;
  }

  @override
  RuntimeDynamicDocumentModel loadDocument(RuntimeDynamicDocumentModel document,
      [bool once = false]) {
    RuntimeDatabase.registerMockData(data);
    document.loadOnce();
    return document;
  }

  @override
  RuntimeDynamicDocumentModel createDocument(
    RuntimeDynamicCollectionModel collection, [
    String? id,
  ]) {
    return collection.create(id);
  }

  @override
  Future<void> deleteDocument(RuntimeDynamicDocumentModel document) async {
    await document.delete();
  }

  @override
  Future<void> saveDocument(RuntimeDynamicDocumentModel document) async {
    await document.save();
  }

  @override
  Future<String> uploadMedia(String path) async {
    return path;
  }

  @override
  final String userId;

  @override
  String get email => "support@mathru.net";

  @override
  bool get enabledAuth => true;

  @override
  bool get isAnonymously => false;
  @override
  bool get isSignedIn => true;

  @override
  bool get isVerified => true;

  @override
  String get name => "Name";

  @override
  String get phoneNumber => "08012345678";

  @override
  String get photoURL => "";

  @override
  Future<void> registerInEmailAndPassword({
    required String email,
    required String password,
    DynamicMap? data,
    String userPath = "user",
  }) async {
    if (data.isEmpty) {
      return;
    }
    RuntimeDatabase.registerMockData(this.data);
    final doc = readProvider(runtimeDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data!);
    await doc.save();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      Future.delayed(Duration.zero);

  @override
  Future<void> signInAnonymously({
    DynamicMap? data,
    String userPath = "user",
  }) async {
    if (data.isEmpty) {
      return;
    }
    RuntimeDatabase.registerMockData(this.data);
    final doc = readProvider(runtimeDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data!);
    await doc.save();
  }

  @override
  Future<void> signInEmailAndPassword({
    required String email,
    required String password,
    DynamicMap? data,
    String userPath = "user",
  }) async {
    data ??= {};
    RuntimeDatabase.registerMockData(this.data);
    if (email.contains("@")) {
      data["role"] = email.split("@")[0];
    } else {
      data["role"] = email;
    }
    final doc = readProvider(runtimeDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data);
    await doc.save();
  }

  @override
  Future<void> signOut() => Future.delayed(Duration.zero);

  @override
  Future<void> tryRestoreAuth() => Future.delayed(Duration.zero);

  @override
  MockModelAdapter? fromMap(DynamicMap map) {
    if (map.get("type", "") != type ||
        !map.containsKey("user") ||
        !map.containsKey("data")) {
      return null;
    }
    return MockModelAdapter(
      userId: map.get("user", ""),
      data: map.getAsMap<DynamicMap>("data"),
    );
  }

  @override
  DynamicMap toMap() {
    return <String, dynamic>{
      "type": type,
      "user": userId,
      "data": data,
    };
  }
}
