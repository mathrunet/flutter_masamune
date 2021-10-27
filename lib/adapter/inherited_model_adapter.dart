part of masamune;

@immutable
class InheritedModelAdapter<
        TDocument extends DynamicDocumentModel,
        TCollection extends DynamicCollectionModel,
        TSeachableCollection extends DynamicSearchableCollectionModel>
    extends ModelAdapter<TDocument, TCollection, TSeachableCollection> {
  const InheritedModelAdapter(
    this.adapter, {
    this.prefix = "",
    this.suffix = "",
  });

  final String prefix;
  final String suffix;
  final ModelAdapter<TDocument, TCollection, TSeachableCollection> adapter;

  @override
  ChangeNotifierProvider<TCollection> collectionProvider(String path) =>
      adapter.collectionProvider("$prefix$path$suffix");

  @override
  ChangeNotifierProvider<TDocument> documentProvider(String path) =>
      adapter.documentProvider("$prefix$path$suffix");

  @override
  ChangeNotifierProvider<TSeachableCollection> searchableCollectionProvider(
          String path) =>
      adapter.searchableCollectionProvider("$prefix$path$suffix");

  @override
  Future<String> generateCode({
    required String path,
    required String key,
    int length = 6,
    String charSet = "23456789abcdefghjkmnpqrstuvwxy",
  }) =>
      adapter.generateCode(
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
      adapter.incrementCounter(
        collectionPath: collectionPath,
        counterSuffix: counterSuffix,
        counterBuilder: counterBuilder,
        linkedCollectionPath: linkedCollectionPath,
        counterIntervals: counterIntervals,
      );

  @override
  TDocument loadDocument(TDocument document, [bool once = false]) =>
      adapter.loadDocument(document, once);

  @override
  TCollection loadCollection(TCollection collection, [bool once = false]) =>
      adapter.loadCollection(collection, once);

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
  Future<void> registerInEmailAndPassword({
    required String email,
    required String password,
    DynamicMap? data,
    String userPath = "user",
  }) =>
      adapter.registerInEmailAndPassword(
        email: email,
        password: password,
        data: data,
        userPath: userPath,
      );

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      adapter.sendPasswordResetEmail(email: email);

  @override
  Future<void> signInAnonymously({
    DynamicMap? data,
    String userPath = "user",
  }) =>
      adapter.signInAnonymously(
        data: data,
        userPath: userPath,
      );

  @override
  Future<void> signInEmailAndPassword({
    required String email,
    required String password,
    DynamicMap? data,
    String userPath = "user",
  }) =>
      adapter.signInEmailAndPassword(
        email: email,
        password: password,
        data: data,
        userPath: userPath,
      );

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

  @override
  Future<bool> skipRegistration({
    DynamicMap? data,
    String userPath = "user",
  }) =>
      adapter.skipRegistration(data: data, userPath: userPath);

  @override
  Future<void> reauthInEmailAndPassword({required String password}) =>
      adapter.reauthInEmailAndPassword(password: password);

  @override
  bool requiredReauthInEmailAndPassword() =>
      adapter.requiredReauthInEmailAndPassword();

  @override
  Future<void> changeEmail({required String email}) =>
      adapter.changeEmail(email: email);

  @override
  Future<void> changePassword({required String password}) =>
      adapter.changePassword(password: password);

  @override
  Future<void> changePhoneNumber({required String smsCode}) =>
      adapter.changePhoneNumber(smsCode: smsCode);

  @override
  Future<void> confirmPasswordReset(
          {required String code, required String password}) =>
      adapter.confirmPasswordReset(code: code, password: password);

  @override
  Future<void> deleteAccount() => adapter.deleteAccount();

  @override
  Future<void> sendEmailLink(
          {required String email,
          required String url,
          required String packageName,
          int androidMinimumVersion = 1}) =>
      adapter.sendEmailLink(
        email: email,
        url: url,
        packageName: packageName,
        androidMinimumVersion: androidMinimumVersion,
      );

  @override
  Future<void> sendEmailVerification() => adapter.sendEmailVerification();

  @override
  Future<void> sendSMS({required String phoneNumber}) =>
      adapter.sendSMS(phoneNumber: phoneNumber);

  @override
  Future<void> signInEmailLink({required String link}) =>
      adapter.signInEmailLink(link: link);

  @override
  Future<void> signInSMS({required String smsCode}) =>
      adapter.signInSMS(smsCode: smsCode);
}
