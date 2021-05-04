part of masamune;

@immutable
class MockModuleAdapter extends ModuleAdapter {
  const MockModuleAdapter({required this.userId, required this.data});

  final Map<String, Map<String, dynamic>> data;

  @override
  ModelProvider<T> collectionProvider<T extends DynamicCollectionModel>(
      String path) {
    path = path.trimString("/");
    return runtimeCollectionProvider(path) as ModelProvider<T>;
  }

  @override
  ModelProvider<T> documentProvider<T extends DynamicDocumentModel>(
      String path) {
    path = path.trimString("/");
    return runtimeDocumentProvider(path) as ModelProvider<T>;
  }

  @override
  T loadCollection<T extends DynamicCollectionModel<DynamicDocumentModel>>(
      T collection) {
    if (collection is RuntimeDynamicCollectionModel && collection.isEmpty) {
      final runtime = collection;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        if (runtime.isNotEmpty) {
          return;
        }
        final path = runtime.path.trimString("/");
        final match = RegExp(r"^" + path + r"/[^/]+$");
        data.entries.where((e) => match.hasMatch(e.key)).forEach((element) {
          final doc = runtime.create(path.split("/").last);
          doc.value = element.value;
          runtime.add(doc);
        });
      });
    }
    return collection;
  }

  @override
  T loadDocument<T extends DynamicDocumentModel>(T document) {
    if (document is RuntimeDynamicDocumentModel && document.isEmpty) {
      final runtime = document;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        if (runtime.isNotEmpty) {
          return;
        }
        final path = runtime.path.trimString("/");
        final doc = data.entries.firstWhereOrNull((item) => item.key == path);
        if (doc != null) {
          runtime.value = doc.value;
        }
      });
    }
    return document;
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
}
