part of katana_module;

/// This class is used to specify data adapters for modules.
///
/// Specify the Document class in [Document],
/// the Collection class in [Collection], and the Provider for each.
///
/// [ModelAdapter] can switch the data
/// when the module is used by passing it to [UIMaterialApp].
@immutable
abstract class ModelAdapter<
        TDocument extends DynamicDocumentModel,
        TCollection extends DynamicCollectionModel,
        TSearchableCollection extends DynamicSearchableCollectionModel>
    extends AdapterModule {
  const ModelAdapter();

  /// Path prefix.
  String get prefix;

  /// Path suffix.
  String get suffix;

  /// Gets the provider of the [Document].
  ///
  /// In [path], enter the path where you want to retrieve the document.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  ProviderBase<TDocument> documentProvider(
    String path, {
    bool disposable = true,
  });

  /// Performs the process of loading a document.
  ///
  /// Usually, you specify a method that can be executed only the first time,
  /// such as [loadOnce] or [listen].
  ///
  /// If you set [listen] to `false`, [loadOnce] is used even if the model can use [listen].
  TDocument loadDocument(
    TDocument document, {
    bool listen = true,
  });

  /// Gets the provider of the [Collection].
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  ///
  /// If [disposable] is `true`, the widget is automatically disposed when it is destroyed.
  ProviderBase<TCollection> collectionProvider(
    String path, {
    bool disposable = true,
  });

  /// Gets the provider of the [Collection] for search.
  ///
  /// In [path], enter the path where you want to retrieve the collection.
  ProviderBase<TSearchableCollection> searchableCollectionProvider(
    String path,
  );

  /// Performs the process of loading a collection.
  ///
  /// Usually, you specify a method that can be executed only the first time,
  /// such as [loadOnce] or [listen].
  ///
  /// If you set [listen] to `false`, [loadOnce] is used even if the model can use [listen].
  TCollection loadCollection(
    TCollection collection, {
    bool listen = true,
  });

  /// Reload the given [document].
  ///
  /// There is no effect with respect to the document being listened to.
  Future<TDocument> reloadDocument(TDocument document);

  /// Reload the given [collection].
  ///
  /// There is no effect with respect to the collection being listened to.
  Future<TCollection> reloadCollection(TCollection collection);

  /// Loads data for the next cursor further in the [collection] that has been read.
  Future<TCollection> loadNextCollection(TCollection collection);

  /// Cast [collection] into the form [DynamicCollectionModel<E>] using [convert].
  DynamicCollectionModel<E> castCollection<E extends DynamicDocumentModel>(
    TCollection collection,
    E Function(DynamicDocumentModel e) convert,
  );

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [collectionPath].
  ///
  /// You can add the corresponding element by specifying [linkedCollectionPath].
  CollectionTransactionBuilder collectionTransaction({
    required String collectionPath,
    String? linkedCollectionPath,
  });

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [documentPath].
  DocumentTransactionBuilder documentTransaction(String documentPath);

  /// Create a code of length [length] randomly for id.
  ///
  /// Characters that are difficult to understand are omitted.
  ///
  /// If the data of [key] in [path] contains the generated random value,
  /// the random value is generated again.
  Future<String> generateCode({
    required String path,
    required String key,
    int length = 6,
    String charSet = "23456789abcdefghjkmnpqrstuvwxy",
  });

  /// Performs the process of loading a collection.
  ///
  /// Usually, you specify a method that can be executed only the first time,
  /// such as [loadOnce] or [listen].
  // TCollection listenCollection(TCollection collection);

  /// Retrieves a document from a [collection].
  ///
  /// By specifying [id], you can specify the ID of newly created document.
  /// If not specified, [uuid] will be used.
  TDocument createDocument(TCollection collection, [String? id]);

  /// Retrieves a document from a [path].
  TDocument createDocumentFromPath(String path);

  /// Save the data in the document so that
  /// you can use it after restarting the app.
  Future<void> saveDocument(TDocument document);

  /// Deletes information associated with a document.
  Future<void> deleteDocument(TDocument document);

  /// Upload your media.
  ///
  /// Folder can be specified by specifying [folderPath].
  Future<String> uploadMedia(String path, [String? folderPath]);

  /// Used to restore your login information.
  Future<void> tryRestoreAuth();

  /// Skip registration and register [data].
  ///
  /// If the return value is `true`, registration is skipped.
  ///
  /// Intended for mock use.
  Future<bool> skipRegistration({
    DynamicMap? data,
    String userPath = "user",
  }) {
    return Future.value(false);
  }

  /// Guest login.
  Future<void> signInAnonymously({
    DynamicMap? data,
    String userPath = "user",
  });

  /// Login using your [email] and [password].
  Future<void> signInEmailAndPassword({
    required String email,
    required String password,
    DynamicMap? data,
    String userPath = "user",
  });

  /// Log out.
  Future<void> signOut();

  /// Register as a user using your [email] and [password].
  Future<void> registerInEmailAndPassword({
    required String email,
    required String password,
    DynamicMap? data,
    String userPath = "user",
  });

  /// Link by email link.
  ///
  /// You need to do [sendEmailLink] first.
  ///
  /// Enter the link acquired by Dynamic Link.
  Future<void> signInEmailLink({required String link});

  /// Send an email link.
  Future<void> sendEmailLink({
    required String email,
    required String url,
    required String packageName,
    int androidMinimumVersion = 1,
  });

  /// Authenticate by sending a code to your phone number.
  Future<void> sendSMS({required String phoneNumber});

  /// Authenticate by sending a code to your phone number.
  Future<void> signInSMS({required String smsCode});

  /// Update your phone number.
  /// You need to send an SMS with [sendSMS] in advance.
  Future<void> changePhoneNumber({required String smsCode});

  /// Resend the email for email address verification.
  Future<void> sendEmailVerification();

  /// Email for password reset will be sent to the specified [email].
  Future<void> sendPasswordResetEmail({required String email});

  /// Send you an email to reset your password.
  Future<void> confirmPasswordReset({
    required String code,
    required String password,
  });

  /// Enter your [password] to re-authenticate.
  Future<void> reauthInEmailAndPassword({required String password});

  /// Returns `true` if re-authentication is required.
  bool requiredReauthInEmailAndPassword();

  /// Account delete.
  Future<void> deleteAccount();

  /// Change your email address.
  ///
  /// It is necessary to execute [reauthInEmailAndPassword]
  /// in advance to re-authenticate.
  Future<void> changeEmail({
    required String email,
  });

  /// Change your password.
  ///
  /// It is necessary to execute [reauthInEmailAndPassword]
  /// in advance to re-authenticate.
  Future<void> changePassword({
    required String password,
  });

  /// Return `true` If authentication is enabled.
  bool get enabledAuth;

  /// True if you are signed in.
  bool get isSignedIn;

  /// You can get the UID after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get userId;

  /// You can get the Email after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get email;

  /// You can get the status that user email is verified
  /// after authentication is completed.
  bool get isVerified;

  /// You can get the PhoneNumber after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get phoneNumber;

  /// You can get the PhotoURL after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get photoURL;

  /// You can get the Display Name after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get name;

  /// For anonymous logged in users, True.
  bool get isAnonymously;

  /// Returns the ID of the currently active sign-in provider.
  List<String> get activeSignInProviders;

  /// Export the currently used data to [fileName].
  Future<void> exportDatabase(String fileName);

  /// Import the data stored in [fileName] into the database you are currently using.
  Future<void> importDatabase(String fileName);
}
