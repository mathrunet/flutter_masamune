part of masamune;

@immutable
class MockModelAdapter extends ModelAdapter<RuntimeDynamicDocumentModel,
    RuntimeDynamicCollectionModel> {
  const MockModelAdapter({required this.userId, required this.data});

  final Map<String, DynamicMap> data;

  @override
  ModelProvider<RuntimeDynamicCollectionModel> collectionProvider(String path) {
    path = path.trimString("/");
    return runtimeCollectionProvider(path);
  }

  @override
  ModelProvider<RuntimeDynamicDocumentModel> documentProvider(String path) {
    path = path.trimString("/");
    return runtimeDocumentProvider(path);
  }

  @override
  RuntimeDynamicCollectionModel loadCollection(
      RuntimeDynamicCollectionModel collection) {
    if (collection.isEmpty) {
      final runtime = collection;
      final path = runtime.path.trimQuery().trimString("/");
      final match = RegExp(r"^" + path + r"/[^/]+$");
      data.entries.where((e) => match.hasMatch(e.key)).forEach((element) {
        final doc = runtime.create(path.split("/").last);
        doc.value = element.value;
        runtime.add(doc);
      });
    }
    return collection;
  }

  @override
  RuntimeDynamicDocumentModel loadDocument(
      RuntimeDynamicDocumentModel document) {
    if (document.isEmpty) {
      final runtime = document;
      final path = runtime.path.trimQuery().trimString("/");
      final doc = data.entries.firstWhereOrNull((item) => item.key == path);
      if (doc != null) {
        for (final tmp in doc.value.entries) {
          runtime.value[tmp.key] = tmp.value;
        }
      }
    }
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
  Future<void> registerInEmailAndPassword(
          {required String email, required String password}) =>
      Future.delayed(Duration.zero);

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      Future.delayed(Duration.zero);

  @override
  Future<void> signInAnonymously() => Future.delayed(Duration.zero);

  @override
  Future<void> signInEmailAndPassword(
          {required String email, required String password}) =>
      Future.delayed(Duration.zero);

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
