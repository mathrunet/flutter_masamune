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

  /// Mock data.
  final Map<String, DynamicMap> data;

  /// Gets the provider of the [Collection].
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  @override
  ChangeNotifierProvider<RuntimeDynamicCollectionModel> collectionProvider(
      String path) {
    path = path.trimString("/");
    return runtimeCollectionProvider(path);
  }

  /// Gets the provider of the [Collection] for search.
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  @override
  ChangeNotifierProvider<RuntimeDynamicSearchableCollectionModel>
      searchableCollectionProvider(String path) {
    path = path.trimString("/");
    return runtimeSearchableCollectionProvider(path);
  }

  /// Gets the provider of the [Document].
  ///
  /// In [path], enter the path where you want to retrieve the document.
  @override
  ChangeNotifierProvider<RuntimeDynamicDocumentModel> documentProvider(
      String path) {
    path = path.trimString("/");
    return runtimeDocumentProvider(path);
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

  /// Save the number of elements in [collectionPath] to its parent document with [counterSuffix].
  ///
  /// You can add the corresponding element by specifying [linkedCollectionPath].
  ///
  /// You can generate a key to store the number of elements in a document by specifying [counterBuilder] or [linkedCounterBuilder].
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

  /// Performs the process of loading a collection.
  ///
  /// Usually, you specify a method that can be executed only the first time, such as [loadOnce] or [listen].
  ///
  /// If you set [once] to true, [loadOnce] is used even if the model can use [listen].
  @override
  RuntimeDynamicCollectionModel loadCollection(
      RuntimeDynamicCollectionModel collection,
      [bool once = false]) {
    RuntimeDatabase.registerMockData(data);
    collection.loadOnce();
    return collection;
  }

  /// Performs the process of loading a document.
  ///
  /// Usually, you specify a method that can be executed only the first time, such as [loadOnce] or [listen].
  ///
  /// If you set [once] to true, [loadOnce] is used even if the model can use [listen].
  @override
  RuntimeDynamicDocumentModel loadDocument(RuntimeDynamicDocumentModel document,
      [bool once = false]) {
    RuntimeDatabase.registerMockData(data);
    document.loadOnce();
    return document;
  }

  /// Performs the process of loading a collection.
  ///
  /// Usually, you specify a method that can be executed only the first time, such as [loadOnce] or [listen]. Retrieves a document from a [collection].
  ///
  /// By specifying [id], you can specify the ID of newly created document. If not specified, [uuid] will be used.
  @override
  RuntimeDynamicDocumentModel createDocument(
    RuntimeDynamicCollectionModel collection, [
    String? id,
  ]) {
    return collection.create(id);
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
    final doc = read(runtimeDocumentProvider("$userPath/$userId"));
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
    final doc = read(runtimeDocumentProvider("$userPath/$userId"));
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
    final doc = read(runtimeDocumentProvider("$userPath/$userId"));
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
    final doc = read(runtimeDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data!);
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
  Future<void> confirmPasswordReset(
          {required String code, required String password}) =>
      Future.value();

  /// Account delete.
  @override
  Future<void> deleteAccount() => Future.value();

  /// Send an email link.
  @override
  Future<void> sendEmailLink(
          {required String email,
          required String url,
          required String packageName,
          int androidMinimumVersion = 1}) =>
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
}
