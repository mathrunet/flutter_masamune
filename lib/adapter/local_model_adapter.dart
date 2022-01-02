part of masamune;

/// ModelAdapter for storing locally on the device.
///
/// The authentication area is not done by this Adapter.
@immutable
class LocalModelAdapter extends ModelAdapter<LocalDynamicDocumentModel,
    LocalDynamicCollectionModel, LocalDynamicSearchableCollectionModel> {
  /// ModelAdapter for storing locally on the device.
  ///
  /// The authentication area is not done by this Adapter.
  const LocalModelAdapter();

  /// Gets the provider of the [Collection].
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  @override
  ChangeNotifierProvider<LocalDynamicCollectionModel> collectionProvider(
          String path) =>
      localCollectionProvider(path);

  /// Gets the provider of the [Document].
  ///
  /// In [path], enter the path where you want to retrieve the document.
  @override
  ChangeNotifierProvider<LocalDynamicDocumentModel> documentProvider(
          String path) =>
      localDocumentProvider(path);

  /// Gets the provider of the [Collection] for search.
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  @override
  ChangeNotifierProvider<LocalDynamicSearchableCollectionModel>
      searchableCollectionProvider(String path) =>
          localSearchableCollectionProvider(path);

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
      LocalTransaction.generateCode(
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
      LocalTransaction.incrementCounter(
        collectionPath: collectionPath,
        counterSuffix: counterSuffix,
        counterBuilder: counterBuilder,
        linkedCollectionPath: linkedCollectionPath,
        counterIntervals: counterIntervals,
      );

  /// Performs the process of loading a document.
  ///
  /// Usually, you specify a method that can be executed only the first time, such as [loadOnce] or [listen].
  ///
  /// If you set [once] to true, [loadOnce] is used even if the model can use [listen].
  @override
  LocalDynamicDocumentModel loadDocument(LocalDynamicDocumentModel document,
      [bool once = false]) {
    document.loadOnce();
    return document;
  }

  /// Performs the process of loading a collection.
  ///
  /// Usually, you specify a method that can be executed only the first time, such as [loadOnce] or [listen].
  ///
  /// If you set [once] to true, [loadOnce] is used even if the model can use [listen].
  @override
  LocalDynamicCollectionModel loadCollection(
      LocalDynamicCollectionModel collection,
      [bool once = false]) {
    collection.loadOnce();
    return collection;
  }

  /// Deletes information associated with a document.
  @override
  Future<void> deleteDocument(LocalDynamicDocumentModel document) async {
    await document.delete();
  }

  /// Performs the process of loading a collection.
  ///
  /// Usually, you specify a method that can be executed only the first time, such as [loadOnce] or [listen]. Retrieves a document from a [collection].
  ///
  /// By specifying [id], you can specify the ID of newly created document. If not specified, [uuid] will be used.
  @override
  LocalDynamicDocumentModel createDocument(
    LocalDynamicCollectionModel collection, [
    String? id,
  ]) {
    return collection.create(id);
  }

  /// Save the data in the document so that you can use it after restarting the app.
  @override
  Future<void> saveDocument(LocalDynamicDocumentModel document) async {
    await document.save();
  }

  /// Upload your media.
  @override
  Future<String> uploadMedia(String path) async {
    return path;
  }

  /// Return true If authentication is enabled.
  @override
  // ignore: avoid_field_initializers_in_const_classes
  final bool enabledAuth = false;

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
    final doc = read(localDocumentProvider("$userPath/$userId"));
    await doc.loadOnce();
    doc.addAllIfEmpty(data!);
    await doc.save();
  }

  /// Email for password reset will be sent to the specified [email].
  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  /// Guest login.
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

  /// Login using your [email] and [password].
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

  /// Log out.
  @override
  Future<void> signOut() {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  /// Used to restore your login information.
  @override
  Future<void> tryRestoreAuth() async {
    await Config.onUserStateChanged.call(userId);
  }

  /// You can get the Email after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get email {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  /// For anonymous logged in users, True.
  @override
  // ignore: avoid_field_initializers_in_const_classes
  final bool isAnonymously = true;

  /// True if you are signed in.
  @override
  // ignore: avoid_field_initializers_in_const_classes
  final bool isSignedIn = true;

  /// You can get the status that user email is verified after authentication is completed.
  @override
  // ignore: avoid_field_initializers_in_const_classes
  final bool isVerified = true;

  /// You can get the Display Name after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get name {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  /// You can get the PhoneNumber after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get phoneNumber {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  /// You can get the PhotoURL after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get photoURL {
    throw UnimplementedError("The authentication function is not implemented.");
  }

  /// You can get the UID after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get userId => Config.uid;

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
