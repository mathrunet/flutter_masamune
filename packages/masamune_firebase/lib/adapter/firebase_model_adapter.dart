part of masamune_firebase;

@immutable
class FirebaseModelAdapter extends ModelAdapter<
    FirestoreDynamicDocumentModel,
    FirestoreDynamicCollectionModel,
    FirestoreDynamicSearchableCollectionModel> {
  const FirebaseModelAdapter({
    this.prefix = "",
    this.options,
  });

  /// Path prefix.
  @override
  final String prefix;

  /// Firebase options.
  final FirebaseOptions? options;

  /// Path suffix.
  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String suffix = "";

  String get _prefix {
    if (prefix.isEmpty) {
      return "";
    } else if (prefix.endsWith("/")) {
      return prefix;
    } else {
      return "$prefix/";
    }
  }

  @override
  ProviderBase<FirestoreDynamicCollectionModel> collectionProvider(
    String path, {
    bool disposable = true,
  }) {
    if (disposable) {
      return firestoreCollectionDisposableProvider("$_prefix$path");
    } else {
      return firestoreCollectionProvider("$_prefix$path");
    }
  }

  @override
  ProviderBase<FirestoreDynamicDocumentModel> documentProvider(
    String path, {
    bool disposable = true,
  }) {
    if (disposable) {
      return firestoreDocumentDisposableProvider("$_prefix$path");
    } else {
      return firestoreDocumentProvider("$_prefix$path");
    }
  }

  @override
  Future<String> generateCode({
    required String path,
    required String key,
    int length = 6,
    String charSet = "23456789abcdefghjkmnpqrstuvwxy",
  }) =>
      FirestoreTransaction.generateCode(
        path: "$_prefix$path",
        key: key,
        length: length,
        charSet: charSet,
      );

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [documentPath].
  @override
  DocumentTransactionBuilder documentTransaction(String documentPath) =>
      FirestoreTransaction.documentTransaction(documentPath);

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [collectionPath].
  ///
  /// You can add the corresponding element by specifying [linkedCollectionPath].
  @override
  CollectionTransactionBuilder collectionTransaction({
    required String collectionPath,
    String? linkedCollectionPath,
  }) =>
      FirestoreTransaction.collectionTransaction(
        collectionPath: collectionPath,
        linkedCollectionPath: linkedCollectionPath,
      );

  @override
  ChangeNotifierProvider<FirestoreDynamicSearchableCollectionModel>
      searchableCollectionProvider(String path) =>
          firestoreSearchableCollectionProvider("$_prefix$path");

  @override
  FirestoreDynamicDocumentModel createDocument(String path) {
    return FirestoreDynamicDocumentModel("$_prefix$path");
  }

  @override
  Future<String> uploadMedia(String path, [String? folderPath]) async {
    folderPath = folderPath?.trimString("/") ?? "";
    if (folderPath.isNotEmpty) {
      folderPath = "$folderPath/";
    }
    final fileName = "$folderPath$uuid.${path.split(".").last}";
    final remotePath = await FirebaseStorageCore.upload(path, fileName);
    ImageMemoryCache.cacheLocalImageAsRemote(
      localUrl: path,
      remoteUrl: remotePath,
    );
    return remotePath;
  }

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final bool enabledAuth = true;

  @override
  Future<void> registerInEmailAndPassword({
    required String email,
    required String password,
    DynamicMap? data,
    String userPath = "user",
  }) async {
    await EmailAndPasswordAuth.register(email: email, password: password);
    final doc = readProvider(localDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    if (data.isNotEmpty) {
      doc.addAllIfEmpty(data!);
    }
    await doc.save();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await EmailAndPasswordAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signInAnonymously({
    DynamicMap? data,
    String userPath = "user",
  }) async {
    await AnonymouslyAuth.signIn();
    if (data.isEmpty) {
      return;
    }
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
    await EmailAndPasswordAuth.signIn(email: email, password: password);
    if (data.isEmpty) {
      return;
    }
    final doc = readProvider(runtimeDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data!);
    await doc.save();
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuthCore.signOut();
  }

  @override
  Future<void> tryRestoreAuth() async {
    await FirebaseAuthCore.tryRestoreAuth();
  }

  @override
  String get email => FirebaseAuthCore.email;

  @override
  bool get isAnonymously => FirebaseAuthCore.isAnonymously;

  @override
  bool get isSignedIn => FirebaseAuthCore.isSignedIn;

  @override
  bool get isVerified => FirebaseAuthCore.isVerified;

  @override
  String get name => FirebaseAuthCore.name;

  @override
  String get phoneNumber => FirebaseAuthCore.phoneNumber;

  @override
  String get photoURL => FirebaseAuthCore.photoURL;

  @override
  String get userId => FirebaseAuthCore.uid;

  @override
  Future<void> reauthInEmailAndPassword({required String password}) async {
    await FirebaseAuthCore.reauthInEmailAndPassword(password: password);
  }

  @override
  bool requiredReauthInEmailAndPassword() => true;

  @override
  Future<void> changeEmail({required String email}) async {
    await FirebaseAuthCore.changeEmail(email: email);
  }

  @override
  Future<void> changePassword({required String password}) async {
    await FirebaseAuthCore.changePassword(password: password);
  }

  @override
  Future<void> changePhoneNumber({required String smsCode}) async {
    await FirebaseAuthCore.changePhoneNumber(smsCode);
  }

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String password,
  }) async {
    await FirebaseAuthCore.confirmPasswordReset(code: code, password: password);
  }

  @override
  Future<void> deleteAccount() async {
    await FirebaseAuthCore.delete();
  }

  @override
  Future<void> sendEmailLink({
    required String email,
    required String url,
    required String packageName,
    int androidMinimumVersion = 1,
  }) async {
    await FirebaseAuthCore.sendEmailLink(
      email: email,
      url: url,
      packageName: packageName,
      androidMinimumVersion: androidMinimumVersion,
    );
  }

  @override
  Future<void> sendEmailVerification() async {
    await FirebaseAuthCore.delete();
  }

  @override
  Future<void> sendSMS({required String phoneNumber}) async {
    await FirebaseAuthCore.sendSMS(phoneNumber);
  }

  @override
  Future<void> signInEmailLink({required String link}) async {
    await FirebaseAuthCore.signInEmailLink(link);
  }

  @override
  Future<void> signInSMS({required String smsCode}) async {
    await FirebaseAuthCore.signInSMS(smsCode);
  }

  @override
  List<String> get activeSignInProviders => FirebaseAuthCore.activeProviders;

  /// Export the currently used data to [fileName].
  @override
  Future<void> exportDatabase(String fileName) {
    throw UnimplementedError("The export function is not implemented.");
  }

  /// Import the data stored in [fileName] into the database you are currently using.
  @override
  Future<void> importDatabase(String fileName) {
    throw UnimplementedError("The import function is not implemented.");
  }

  /// Run it the first time the app is launched.
  @override
  @mustCallSuper
  Future<void> onInit(BuildContext context) async {
    super.onInit(context);
    await FirebaseCore.initialize(options: options);
  }
}
