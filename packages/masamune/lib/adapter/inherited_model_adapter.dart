part of masamune;

/// Adapter to read another [adapter] and convert the path location with [prefix] or [suffix] to the path.
///
/// This is used when you want each user to use different data in the app.
///
/// It is not used in normal module operation.
@immutable
class InheritedModelAdapter<
        TDocument extends DynamicDocumentModel,
        TCollection extends DynamicCollectionModel,
        TSeachableCollection extends DynamicSearchableCollectionModel>
    extends ModelAdapter<TDocument, TCollection, TSeachableCollection> {
  /// Adapter to read another [adapter] and convert the path location with [prefix] or [suffix] to the path.
  ///
  /// This is used when you want each user to use different data in the app.
  ///
  /// It is not used in normal module operation.
  const InheritedModelAdapter(
    this.adapter, {
    this.prefix = "",
    this.suffix = "",
  });

  /// Prefix of the path.
  @override
  final String prefix;

  /// Suffix of the path.
  @override
  final String suffix;

  /// Adapter to reference.
  final ModelAdapter<TDocument, TCollection, TSeachableCollection> adapter;

  String get _prefix {
    if (prefix.isEmpty) {
      return "";
    } else if (prefix.endsWith("/")) {
      return prefix;
    } else {
      return "$prefix/";
    }
  }

  String get _suffix {
    if (suffix.isEmpty) {
      return "";
    } else if (suffix.startsWith("/")) {
      return suffix;
    } else {
      return "/$suffix";
    }
  }

  /// Gets the provider of the [Collection].
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  @override
  ProviderBase<TCollection> collectionProvider(
    String path, {
    bool disposable = false,
  }) =>
      adapter.collectionProvider(
        "$_prefix$path$_suffix",
        disposable: disposable,
      );

  /// Gets the provider of the [Document].
  ///
  /// In [path], enter the path where you want to retrieve the document.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  @override
  ProviderBase<TDocument> documentProvider(
    String path, {
    bool disposable = false,
  }) =>
      adapter.documentProvider(
        "$_prefix$path$_suffix",
        disposable: disposable,
      );

  /// Gets the provider of the [Collection] for search.
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  @override
  ProviderBase<TSeachableCollection> searchableCollectionProvider(
    String path,
  ) =>
      adapter.searchableCollectionProvider("$_prefix$path$_suffix");

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
      adapter.generateCode(
        path: "$_prefix$path$_suffix",
        key: key,
        length: length,
        charSet: charSet,
      );

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [documentPath].
  @override
  DocumentTransactionBuilder documentTransaction(String documentPath) =>
      adapter.documentTransaction(documentPath);

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
      adapter.collectionTransaction(
        collectionPath: "$_prefix$collectionPath$_suffix",
        linkedCollectionPath: "$_prefix$linkedCollectionPath$_suffix",
      );

  /// Retrieves a document from a [path].
  @override
  TDocument createDocument(String path) =>
      adapter.createDocument("$_prefix$path$_suffix");

  /// Upload your media.
  ///
  /// Folder can be specified by specifying [folderPath].
  @override
  Future<String> uploadMedia(String path, [String? folderPath]) =>
      adapter.uploadMedia(path, folderPath);

  /// Return true If authentication is enabled.
  @override
  bool get enabledAuth => adapter.enabledAuth;

  /// Register as a user using your [email] and [password].
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

  /// Email for password reset will be sent to the specified [email].
  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      adapter.sendPasswordResetEmail(email: email);

  /// Guest login.
  @override
  Future<void> signInAnonymously({
    DynamicMap? data,
    String userPath = "user",
  }) =>
      adapter.signInAnonymously(
        data: data,
        userPath: userPath,
      );

  /// Login using your [email] and [password].
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

  /// Log out.
  @override
  Future<void> signOut() => adapter.signOut();

  /// Used to restore your login information.
  @override
  Future<void> tryRestoreAuth() => adapter.tryRestoreAuth();

  /// You can get the Email after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get email => adapter.email;

  /// For anonymous logged in users, True.
  @override
  bool get isAnonymously => adapter.isAnonymously;

  /// True if you are signed in.
  @override
  bool get isSignedIn => adapter.isSignedIn;

  /// You can get the status that user email is verified after authentication is completed.
  @override
  bool get isVerified => adapter.isVerified;

  /// You can get the Display Name after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get name => adapter.name;

  /// You can get the PhoneNumber after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get phoneNumber => adapter.phoneNumber;

  /// You can get the PhotoURL after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get photoURL => adapter.photoURL;

  /// You can get the UID after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  @override
  String get userId => adapter.userId;

  /// Skip registration and register [data].
  ///
  /// If the return value is true, registration is skipped.
  ///
  /// Intended for mock use.
  @override
  Future<bool> skipRegistration({
    DynamicMap? data,
    String userPath = "user",
  }) =>
      adapter.skipRegistration(data: data, userPath: userPath);

  /// Enter your [password] to re-authenticate.
  @override
  Future<void> reauthInEmailAndPassword({required String password}) =>
      adapter.reauthInEmailAndPassword(password: password);

  /// Returns `true` if re-authentication is required.
  @override
  bool requiredReauthInEmailAndPassword() =>
      adapter.requiredReauthInEmailAndPassword();

  /// Change your email address.
  ///
  /// It is necessary to execute [reauthInEmailAndPassword] in advance to re-authenticate.
  @override
  Future<void> changeEmail({required String email}) =>
      adapter.changeEmail(email: email);

  /// Change your password.
  ///
  /// It is necessary to execute [reauthInEmailAndPassword] in advance to re-authenticate.
  @override
  Future<void> changePassword({required String password}) =>
      adapter.changePassword(password: password);

  /// Update your phone number. You need to send an SMS with [sendSMS] in advance.
  @override
  Future<void> changePhoneNumber({required String smsCode}) =>
      adapter.changePhoneNumber(smsCode: smsCode);

  /// Send you an email to reset your password.
  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String password,
  }) =>
      adapter.confirmPasswordReset(code: code, password: password);

  /// Account delete.
  @override
  Future<void> deleteAccount() => adapter.deleteAccount();

  /// Send an email link.
  @override
  Future<void> sendEmailLink({
    required String email,
    required String url,
    required String packageName,
    int androidMinimumVersion = 1,
  }) =>
      adapter.sendEmailLink(
        email: email,
        url: url,
        packageName: packageName,
        androidMinimumVersion: androidMinimumVersion,
      );

  /// Resend the email for email address verification.
  @override
  Future<void> sendEmailVerification() => adapter.sendEmailVerification();

  /// Authenticate by sending a code to your phone number.
  @override
  Future<void> sendSMS({required String phoneNumber}) =>
      adapter.sendSMS(phoneNumber: phoneNumber);

  /// Link by email link.
  ///
  /// You need to do [sendEmailLink] first.
  ///
  /// Enter the link acquired by Dynamic Link.
  @override
  Future<void> signInEmailLink({required String link}) =>
      adapter.signInEmailLink(link: link);

  /// Authenticate by sending a code to your phone number.
  @override
  Future<void> signInSMS({required String smsCode}) =>
      adapter.signInSMS(smsCode: smsCode);

  /// Returns the ID of the currently active sign-in provider.
  @override
  List<String> get activeSignInProviders => adapter.activeSignInProviders;

  /// Export the currently used data to [fileName].
  @override
  Future<void> exportDatabase(String fileName) {
    return adapter.exportDatabase(fileName);
  }

  /// Import the data stored in [fileName] into the database you are currently using.
  @override
  Future<void> importDatabase(String fileName) {
    return adapter.importDatabase(fileName);
  }
}
