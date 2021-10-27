part of masamune;

@immutable
class MockModelAdapter extends ModelAdapter<RuntimeDynamicDocumentModel,
    RuntimeDynamicCollectionModel, RuntimeDynamicSearchableCollectionModel> {
  const MockModelAdapter({required this.userId, required this.data});

  final Map<String, DynamicMap> data;

  @override
  ChangeNotifierProvider<RuntimeDynamicCollectionModel> collectionProvider(
      String path) {
    path = path.trimString("/");
    return runtimeCollectionProvider(path);
  }

  @override
  ChangeNotifierProvider<RuntimeDynamicSearchableCollectionModel>
      searchableCollectionProvider(String path) {
    path = path.trimString("/");
    return runtimeSearchableCollectionProvider(path);
  }

  @override
  ChangeNotifierProvider<RuntimeDynamicDocumentModel> documentProvider(
      String path) {
    path = path.trimString("/");
    return runtimeDocumentProvider(path);
  }

  @override
  Future<String> generateCode({
    required String path,
    required String key,
    int length = 6,
    String charSet = "23456789abcdefghjkmnpqrstuvwxy",
  }) =>
      RuntimeTransaction.generateCode(
        path: path,
        key: key,
        length: length,
        charSet: charSet,
      );

  @override
  IncrementCounterTransactionBuilder incrementCounter(
          {required String collectionPath,
          String counterSuffix = "Count",
          String Function(String path)? counterBuilder,
          String? linkedCollectionPath,
          String Function(String linkPath)? linkedCounterBuilder,
          List<CounterUpdaterInterval> counterIntervals = const []}) =>
      RuntimeTransaction.incrementCounter(
        collectionPath: collectionPath,
        counterSuffix: counterSuffix,
        counterBuilder: counterBuilder,
        linkedCollectionPath: linkedCollectionPath,
        counterIntervals: counterIntervals,
      );

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

  @override
  Future<bool> skipRegistration({
    DynamicMap? data,
    String userPath = "user",
  }) async {
    if (data.isEmpty) {
      return true;
    }
    RuntimeDatabase.registerMockData(this.data);
    final doc = readProvider(runtimeDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data!);
    await doc.save();
    return true;
  }

  @override
  Future<void> reauthInEmailAndPassword({required String password}) =>
      Future.value();

  @override
  bool requiredReauthInEmailAndPassword() => false;

  @override
  Future<void> changeEmail({required String email}) => Future.value();

  @override
  Future<void> changePassword({required String password}) => Future.value();

  @override
  Future<void> changePhoneNumber({required String smsCode}) => Future.value();

  @override
  Future<void> confirmPasswordReset(
          {required String code, required String password}) =>
      Future.value();

  @override
  Future<void> deleteAccount() => Future.value();

  @override
  Future<void> sendEmailLink(
          {required String email,
          required String url,
          required String packageName,
          int androidMinimumVersion = 1}) =>
      Future.value();

  @override
  Future<void> sendEmailVerification() => Future.value();
  @override
  Future<void> sendSMS({required String phoneNumber}) => Future.value();

  @override
  Future<void> signInEmailLink({required String link}) => Future.value();

  @override
  Future<void> signInSMS({required String smsCode}) => Future.value();
}
