part of masamune;

/// Adapter that can put data in advance at the time of application start by putting mock data in [data].
///
/// If you put the user ID in [userId], you can pass around the authentication.
@immutable
class MockModelAdapter extends ModelAdapter<RuntimeDynamicDocumentModel,
    RuntimeDynamicCollectionModel, RuntimeDynamicSearchableCollectionModel> {
  /// Adapter that can put data in advance at the time of application start by putting mock data in [data].
  ///
  /// If you put the user ID in [userId], you can pass around the authentication.
  const MockModelAdapter({required this.userId, required this.data});

  /// Path prefix.
  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String prefix = "";

  /// Path suffix.
  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String suffix = "";

  /// Mock data.
  final Map<String, DynamicMap> data;

  /// Gets the provider of the [Collection].
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  @override
  ProviderBase<RuntimeDynamicCollectionModel> collectionProvider(
    String path, {
    bool disposable = true,
  }) {
    path = path.trimString("/");
    if (disposable) {
      return runtimeCollectionDisposableProvider(path);
    } else {
      return runtimeCollectionProvider(path);
    }
  }

  /// Gets the provider of the [Collection] for search.
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  @override
  ProviderBase<RuntimeDynamicSearchableCollectionModel>
      searchableCollectionProvider(String path) {
    path = path.trimString("/");
    return runtimeSearchableCollectionProvider(path);
  }

  /// Gets the provider of the [Document].
  ///
  /// In [path], enter the path where you want to retrieve the document.
  @override
  ProviderBase<RuntimeDynamicDocumentModel> documentProvider(
    String path, {
    bool disposable = true,
  }) {
    path = path.trimString("/");
    if (disposable) {
      return runtimeDocumentDisposableProvider(path);
    } else {
      return runtimeDocumentProvider(path);
    }
  }

  /// Create a code of length [length] randomly for id.
  ///
  /// Characters that are difficult to understand are omitted.
  ///
  /// If the data of [key] in [path] contains the generated random value, the random value is generated again.
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

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [documentPath].
  @override
  DocumentTransactionBuilder documentTransaction(String documentPath) =>
      RuntimeTransaction.documentTransaction(documentPath);

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
      RuntimeTransaction.collectionTransaction(
        collectionPath: collectionPath,
        linkedCollectionPath: linkedCollectionPath,
      );

  /// Performs the process of loading a collection.
  ///
  /// Usually, you specify a method that can be executed only the first time, such as [loadOnce] or [listen].
  ///
  /// If you set [listen] to `false`, [loadOnce] is used even if the model can use [listen].
  @override
  RuntimeDynamicCollectionModel loadCollection(
    RuntimeDynamicCollectionModel collection, {
    bool listen = true,
  }) {
    RuntimeDatabase.registerMockData(data);
    collection.loadOnce();
    return collection;
  }

  /// Reload the given [document].
  ///
  /// There is no effect with respect to the document being listened to.
  @override
  RuntimeDynamicDocumentModel reloadDocument(
      RuntimeDynamicDocumentModel document) {
    document.reload();
    return document;
  }

  /// Reload the given [collection].
  ///
  /// There is no effect with respect to the collection being listened to.
  @override
  RuntimeDynamicCollectionModel reloadCollection(
    RuntimeDynamicCollectionModel collection,
  ) {
    collection.reload();
    return collection;
  }

  /// Loads data for the next cursor further in the [collection] that has been read.
  @override
  RuntimeDynamicCollectionModel loadNextCollection(
    RuntimeDynamicCollectionModel collection,
  ) {
    collection.next();
    return collection;
  }

  /// Performs the process of loading a document.
  ///
  /// Usually, you specify a method that can be executed only the first time, such as [loadOnce] or [listen].
  ///
  /// If you set [listen] to `false`, [loadOnce] is used even if the model can use [listen].
  @override
  RuntimeDynamicDocumentModel loadDocument(
    RuntimeDynamicDocumentModel document, {
    bool listen = true,
  }) {
    RuntimeDatabase.registerMockData(data);
    document.loadOnce();
    return document;
  }

  /// Retrieves a document from a [collection].
  ///
  /// By specifying [id], you can specify the ID of newly created document. If not specified, [uuid] will be used.
  @override
  RuntimeDynamicDocumentModel createDocument(
    RuntimeDynamicCollectionModel collection, [
    String? id,
  ]) {
    return collection.create(id);
  }

  /// Retrieves a document from a [path].
  @override
  RuntimeDynamicDocumentModel createDocumentFromPath(String path) {
    return RuntimeDynamicDocumentModel(path);
  }

  /// Deletes information associated with a document.
  @override
  Future<void> deleteDocument(RuntimeDynamicDocumentModel document) async {
    await document.delete();
  }

  /// Save the data in the document so that you can use it after restarting the app.
  @override
  Future<void> saveDocument(RuntimeDynamicDocumentModel document) async {
    await document.save();
  }

  /// Upload your media.
  @override
  Future<String> uploadMedia(String path) async {
    return path;
  }

  /// You can get the UID after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  final String userId;

  /// You can get the Email after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get email => "support@mathru.net";

  /// Return `true` If authentication is enabled.
  @override
  bool get enabledAuth => true;

  /// For anonymous logged in users, True.
  @override
  bool get isAnonymously => false;

  /// True if you are signed in.
  @override
  bool get isSignedIn => true;

  /// You can get the status that user email is verified after authentication is completed.
  @override
  bool get isVerified => true;

  /// You can get the Display Name after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get name => "Name";

  /// You can get the PhoneNumber after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get phoneNumber => "08012345678";

  /// You can get the PhotoURL after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get photoURL => "";

  /// Register as a user using your [email] and [password].
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

  /// Email for password reset will be sent to the specified [email].
  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      Future.delayed(Duration.zero);

  /// Guest login.
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

  /// Login using your [email] and [password].
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

  /// Log out.
  @override
  Future<void> signOut() => Future.delayed(Duration.zero);

  /// Used to restore your login information.
  @override
  Future<void> tryRestoreAuth() async {
    await Config.onUserStateChanged.call(userId);
  }

  /// Skip registration and register [data].
  ///
  /// If the return value is true, registration is skipped.
  ///
  /// Intended for mock use.
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
    doc.addAll(data!);
    await doc.save();
    return true;
  }

  /// Enter your [password] to re-authenticate.
  @override
  Future<void> reauthInEmailAndPassword({required String password}) =>
      Future.value();

  /// Returns `true` if re-authentication is required.
  @override
  bool requiredReauthInEmailAndPassword() => false;

  /// Change your email address.
  ///
  /// It is necessary to execute [reauthInEmailAndPassword] in advance to re-authenticate.
  @override
  Future<void> changeEmail({required String email}) => Future.value();

  /// Change your password.
  ///
  /// It is necessary to execute [reauthInEmailAndPassword] in advance to re-authenticate.
  @override
  Future<void> changePassword({required String password}) => Future.value();

  /// Update your phone number. You need to send an SMS with [sendSMS] in advance.
  @override
  Future<void> changePhoneNumber({required String smsCode}) => Future.value();

  /// Send you an email to reset your password.
  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String password,
  }) =>
      Future.value();

  /// Account delete.
  @override
  Future<void> deleteAccount() => Future.value();

  /// Send an email link.
  @override
  Future<void> sendEmailLink({
    required String email,
    required String url,
    required String packageName,
    int androidMinimumVersion = 1,
  }) =>
      Future.value();

  /// Resend the email for email address verification.
  @override
  Future<void> sendEmailVerification() => Future.value();

  /// Authenticate by sending a code to your phone number.
  @override
  Future<void> sendSMS({required String phoneNumber}) => Future.value();

  /// Link by email link.
  ///
  /// You need to do [sendEmailLink] first.
  ///
  /// Enter the link acquired by Dynamic Link.
  @override
  Future<void> signInEmailLink({required String link}) => Future.value();

  /// Authenticate by sending a code to your phone number.
  @override
  Future<void> signInSMS({required String smsCode}) => Future.value();

  /// Returns the ID of the currently active sign-in provider.
  @override
  List<String> get activeSignInProviders => const [];

  /// Export the currently used data to [fileName].
  @override
  Future<void> exportDatabase(String fileName) {
    return RuntimeDatabase.export(fileName);
  }

  /// Import the data stored in [fileName] into the database you are currently using.
  @override
  Future<void> importDatabase(String fileName) {
    return RuntimeDatabase.import(fileName);
  }
}
