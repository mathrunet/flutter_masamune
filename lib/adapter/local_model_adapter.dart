part of masamune;

@immutable
class LocalModelAdapter extends ModelAdapter<LocalDynamicDocumentModel,
    LocalDynamicCollectionModel, LocalDynamicSearchableCollectionModel> {
  const LocalModelAdapter();

  @override
  ChangeNotifierProvider<LocalDynamicCollectionModel> collectionProvider(
          String path) =>
      localCollectionProvider(path);

  @override
  ChangeNotifierProvider<LocalDynamicDocumentModel> documentProvider(
          String path) =>
      localDocumentProvider(path);

  @override
  ChangeNotifierProvider<LocalDynamicSearchableCollectionModel>
      searchableCollectionProvider(String path) =>
          localSearchableCollectionProvider(path);

  @override
  Future<String> generateCode({
    required String path,
    required String key,
    int length = 6,
    String charSet = "23456789abcdefghjkmnpqrstuvwxy",
  }) =>
      LocalTransaction.generateCode(
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
      LocalTransaction.incrementCounter(
        collectionPath: collectionPath,
        counterSuffix: counterSuffix,
        counterBuilder: counterBuilder,
        linkedCollectionPath: linkedCollectionPath,
        counterIntervals: counterIntervals,
      );

  @override
  LocalDynamicDocumentModel loadDocument(LocalDynamicDocumentModel document,
      [bool once = false]) {
    document.loadOnce();
    return document;
  }

  @override
  LocalDynamicCollectionModel loadCollection(
      LocalDynamicCollectionModel collection,
      [bool once = false]) {
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
  Future<void> registerInEmailAndPassword({
    required String email,
    required String password,
    DynamicMap? data,
    String userPath = "user",
  }) async {
    if (data.isEmpty) {
      return;
    }
    final doc = read(localDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data!);
    await doc.save();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  Future<void> signInAnonymously({
    DynamicMap? data,
    String userPath = "user",
  }) async {
    if (data.isEmpty) {
      return;
    }
    final doc = read(localDocumentProvider("$userPath/$userId"));
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
    if (data.isEmpty) {
      return;
    }
    final doc = read(localDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data!);
    await doc.save();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  @override
  Future<void> tryRestoreAuth() async {
    await Config.onUserStateChanged.call(userId);
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
