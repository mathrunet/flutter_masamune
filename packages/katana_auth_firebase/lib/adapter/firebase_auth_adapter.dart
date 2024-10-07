part of "/katana_auth_firebase.dart";

const _kUserEmailKey = "userEmail";
const _kUserPhoneNumberKey = "userPhoneNumber";
const _kSmsVerificationIdKey = "verificationId";
const _kAllowMultiProvidersKey = "allowMultiProviders";
const _kSecondaryAppName = "secondary";

/// Model adapter with FirebaseAuth available.
///
/// Firebase application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
///
/// Basically, the default [FirebaseAuth.instance] is used, but it is possible to use a specified authentication database by passing [database] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// FirebaseAuthを利用できるようにしたモデルアダプター。
///
/// 事前にFirebaseのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
///
/// 基本的にデフォルトの[FirebaseAuth.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定された認証データベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
class FirebaseAuthAdapter extends AuthAdapter {
  /// Model adapter with FirebaseAuth available.
  ///
  /// Firebase application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
  ///
  /// Basically, the default [FirebaseAuth.instance] is used, but it is possible to use a specified authentication database by passing [database] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// FirebaseAuthを利用できるようにしたモデルアダプター。
  ///
  /// 事前にFirebaseのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
  ///
  /// 基本的にデフォルトの[FirebaseAuth.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定された認証データベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  const FirebaseAuthAdapter({
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.windowsOptions,
    this.macosOptions,
    this.linuxOptions,
    this.androidPackageName,
    this.iOSBundleId,
    this.androidMinimumVersion,
    this.defaultLocale = const Locale("en", "US"),
    FirebaseAuth? database,
    this.debugUserId,
    super.authActions = const [],
  })  : _options = options,
        _database = database;

  /// Android package name.
  ///
  /// Androidのパッケージ名。
  final String? androidPackageName;

  /// IOS Bundle ID.
  ///
  /// IOSのバンドルID。
  final String? iOSBundleId;

  /// The smallest version of Android.
  ///
  /// Androidの最小バージョン。
  final int? androidMinimumVersion;

  /// Default locale when [Locale] is not set.
  ///
  /// The `en_US` is set as default.
  ///
  /// [Locale]が設定されていないときのデフォルトロケール。
  ///
  /// `en_US`がデフォルトとして設定されています。
  final Locale defaultLocale;

  /// User ID for debugging.
  ///
  /// When this is specified, this user ID should be returned.
  ///
  /// デバッグ用のユーザーID。
  ///
  /// これが指定されているときは、このユーザーIDを返すようにします。
  final String? debugUserId;

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  /// The instance of FirebaseAuth used within the adapter.
  ///
  /// アダプター内で利用しているFirebaseAuthのインスタンス。
  FirebaseAuth get database => _database ?? FirebaseAuth.instance;
  final FirebaseAuth? _database;

  static FirebaseApp? _secondaryApp;
  static FirebaseAuth? _secondaryAuth;

  User? get _user => database.currentUser;

  Future<void> _initialize() async {
    if (_initialized) {
      return;
    }
    if (_initializeCompleter != null) {
      return _initializeCompleter!.future;
    }
    _initializeCompleter = Completer();
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await FirebaseCore.initialize(options: options);
      _initialized = true;
      _initializeCompleter!.complete();
      _initializeCompleter = null;
    } catch (e) {
      _initializeCompleter!.completeError(e);
      _initializeCompleter = null;
      rethrow;
    } finally {
      _initializeCompleter!.complete();
      _initializeCompleter = null;
    }
  }

  static late final SharedPreferences _sharedPreferences;
  static bool _initialized = false;
  static Completer<void>? _initializeCompleter;

  @override
  String? get userId {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return null;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    if (debugUserId != null) {
      return debugUserId;
    }
    return _user?.uid;
  }

  @override
  String? get userName {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return null;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    return _user?.displayName;
  }

  @override
  String? get userEmail {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return null;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    return _user?.email;
  }

  @override
  String? get userPhoneNumber {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return null;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    return _user?.phoneNumber;
  }

  @override
  String? get userPhotoURL {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return null;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    return _user?.photoURL;
  }

  @override
  bool get isAnonymously {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return false;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return false;
    }
    return _user!.isAnonymous;
  }

  @override
  bool get isSignedIn {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return false;
    }
    if (_user == null || _user!.uid.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  bool get isVerified {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return false;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return false;
    }
    return _user?.emailVerified ?? false;
  }

  @override
  bool get isWaitingConfirmation {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return false;
    }
    return _sharedPreferences.containsKey(_kSmsVerificationIdKey.toSHA1()) ||
        _sharedPreferences.containsKey(_kUserEmailKey.toSHA1()) ||
        _sharedPreferences.containsKey(_kUserPhoneNumberKey.toSHA1());
  }

  @override
  Future<AccessTokenValue?> accessToken({bool forceRefresh = false}) async {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return null;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    final tokenResult = await _user!.getIdTokenResult(forceRefresh);
    if (tokenResult.token.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    return AccessTokenValue(
      token: tokenResult.token!,
      expirationTime: tokenResult.expirationTime,
    );
  }

  @override
  String? get refreshToken {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return null;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    return _user?.refreshToken;
  }

  @override
  List<String>? get activeProviderIds {
    if (!_initialized) {
      debugPrint("Please call initialize before using it.");
      return null;
    }
    if (_user == null || _user!.uid.isEmpty) {
      debugPrint(
        "Information could not be retrieved because you are not signed in, please sign in using the method for signIn.",
      );
      return null;
    }
    return _user?.providerData.map((e) => e.providerId).toList();
  }

  @override
  Future<bool> tryRestoreAuth({
    bool retryWhenTimeout = false,
    required VoidCallback onUserStateChanged,
  }) async {
    try {
      await _initialize();
      User? user = database.currentUser;
      user ??= await database.idTokenChanges().first;
      if (user != null) {
        await user.reload();
        onUserStateChanged.call();
        return true;
      }
    } on TimeoutException {
      if (!retryWhenTimeout) {
        rethrow;
      }
      return tryRestoreAuth(
        retryWhenTimeout: retryWhenTimeout,
        onUserStateChanged: onUserStateChanged,
      );
    } catch (e) {
      return false;
    }
    return false;
  }

  @override
  Future<String?> create({
    required CreateAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    if (provider is EmailAndPasswordCreateAuthProvider) {
      await _prepareProcessInternal();
      _secondaryApp ??= await Firebase.initializeApp(
        options: options,
        name: _kSecondaryAppName,
      );
      _secondaryAuth ??= FirebaseAuth.instanceFor(app: _secondaryApp!);
      await _secondaryAuth!.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      final credentials = await _secondaryAuth!.createUserWithEmailAndPassword(
        email: provider.email,
        password: provider.password,
      );
      onUserStateChanged.call();
      return credentials.user?.uid;
    }
    return null;
  }

  @override
  Future<void> register({
    required RegisterAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    if (provider is EmailAndPasswordRegisterAuthProvider) {
      await _prepareProcessInternal();
      if (_user != null) {
        if (!provider.allowMultiProvider) {
          throw FirebaseAuthException(
            message:
                "This Email address is already registered. Please register another email address.",
            code: "email-already-in-use",
          );
        }
        await _user!.linkWithCredential(
          EmailAuthProvider.credential(
            email: provider.email,
            password: provider.password,
          ),
        );
      } else {
        await database.setLanguageCode(
          provider.locale?.languageCode ?? defaultLocale.languageCode,
        );
        await database.createUserWithEmailAndPassword(
          email: provider.email,
          password: provider.password,
        );
      }
      if (_user == null || _user!.uid.isEmpty) {
        throw Exception("User is not found.");
      }
      onUserStateChanged.call();
    }
  }

  @override
  Future<void> signIn({
    required SignInAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    if (provider is DirectSignInAuthProvider) {
      throw Exception(
        "This provider is not supported: ${provider.providerId}",
      );
    } else if (provider is AnonymouslySignInAuthProvider) {
      await _prepareProcessInternal();
      if (_user != null && _user!.uid.isNotEmpty) {
        return;
      }
      await database.signInAnonymously();
      if (_user == null || _user!.uid.isEmpty) {
        throw Exception("User is not found.");
      }
      onUserStateChanged.call();
    } else if (provider is EmailAndPasswordSignInAuthProvider) {
      await _prepareProcessInternal();
      if (_user != null) {
        if (_user!.providerData.any(
          (t) => t.providerId.contains(EmailAuthProvider.PROVIDER_ID),
        )) {
          throw Exception("This user is already linked to a Email account.");
        } else if (!provider.allowMultiProvider) {
          throw Exception(
            "This user is already signed in, please sign out first.",
          );
        }
      }
      final credential = EmailAuthProvider.credential(
        email: provider.email,
        password: provider.password,
      );
      if (_user != null) {
        await _user!.linkWithCredential(credential);
      } else {
        await database.signInWithCredential(credential);
      }
      if (_user == null || _user!.uid.isEmpty) {
        throw Exception("User is not found.");
      }
      onUserStateChanged.call();
    } else if (provider is EmailLinkSignInAuthProvider) {
      await _prepareProcessInternal();
      if (_user != null) {
        if (_user!.providerData.any(
          (t) => t.providerId.contains(EmailAuthProvider.PROVIDER_ID),
        )) {
          throw Exception("This user is already linked to a Email account.");
        } else if (!provider.allowMultiProvider) {
          throw Exception(
            "This user is already signed in, please sign out first.",
          );
        }
      }
      await database.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      await database.sendSignInLinkToEmail(
        email: provider.email,
        actionCodeSettings: ActionCodeSettings(
          androidInstallApp: true,
          url: provider.url,
          handleCodeInApp: true,
          iOSBundleId: iOSBundleId,
          androidPackageName: androidPackageName,
          androidMinimumVersion: androidMinimumVersion?.toString(),
        ),
      );
      await _sharedPreferences.setString(
        _kUserEmailKey.toSHA1(),
        provider.email,
      );
      await _sharedPreferences.setBool(
        _kAllowMultiProvidersKey.toSHA1(),
        provider.allowMultiProvider,
      );
      onUserStateChanged.call();
    } else if (provider is SmsSignInAuthProvider) {
      Completer? completer = Completer();
      var phoneNumber = provider.phoneNumber;
      if (phoneNumber.startsWith("0") && phoneNumber.length >= 11) {
        phoneNumber = phoneNumber.substring(1);
      }
      phoneNumber =
          "+${provider.countryNumber.trimStringLeft("+")}$phoneNumber";
      await _prepareProcessInternal();
      if (_user != null) {
        if (_user!.providerData.any(
          (t) => t.providerId.contains(PhoneAuthProvider.PROVIDER_ID),
        )) {
          Exception("This user is already linked to a Phone number.");
        } else if (!provider.allowMultiProvider) {
          throw Exception(
            "This user is already signed in, please sign out first.",
          );
        }
      }
      await database.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      await _sharedPreferences.setString(
        _kUserPhoneNumberKey.toSHA1(),
        phoneNumber,
      );
      await _sharedPreferences.setBool(
        _kAllowMultiProvidersKey.toSHA1(),
        provider.allowMultiProvider,
      );
      await database.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          if (_user != null) {
            await _user!.linkWithCredential(credential);
          } else {
            await database.signInWithCredential(credential);
          }
          if (_user == null || _user!.uid.isEmpty) {
            completer?.completeError(Exception("User is not found."));
            completer = null;
            return;
          }
          completer?.complete();
          completer = null;
          onUserStateChanged.call();
          provider.onAutoVerificationCompleted?.call();
        },
        verificationFailed: (error) {
          completer?.completeError(error);
          completer = null;
          provider.onAutoVerificationFailed?.call(error);
        },
        codeSent: (verificationId, [code]) async {
          await _sharedPreferences.setString(
            _kSmsVerificationIdKey.toSHA1(),
            verificationId,
          );
          completer?.complete();
          completer = null;
          onUserStateChanged.call();
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          await _sharedPreferences.remove(_kSmsVerificationIdKey.toSHA1());
          completer?.completeError(TimeoutException("Code entry timed out."));
          completer = null;
          onUserStateChanged.call();
        },
      );
      await completer?.future;
    } else if (provider is SnsSignInAuthProvider) {
      await _prepareProcessInternal();
      if (_user != null) {
        if (_user!.providerData.any(
          (t) => t.providerId.contains(provider.providerId),
        )) {
          throw Exception(
              "This user is already linked to a ${provider.providerId} account.");
        } else if (!provider.allowMultiProvider) {
          throw Exception(
            "This user is already signed in, please sign out first.",
          );
        }
      }
      final credential = await provider.credential();
      final firebaseCredential = credential.signInMethod == "oauth"
          ? OAuthProvider(credential.providerId).credential(
              accessToken: credential.accessToken,
              secret: credential.secret,
              idToken: credential.idToken,
            )
          : AuthCredential(
              providerId: credential.providerId,
              signInMethod: credential.signInMethod,
              token: credential.token,
              accessToken: credential.accessToken,
            );
      if (_user != null) {
        await _user!.linkWithCredential(firebaseCredential);
      } else {
        await database.signInWithCredential(firebaseCredential);
      }
      if (_user == null || _user!.uid.isEmpty) {
        throw Exception("User is not found.");
      }
      onUserStateChanged.call();
    }
  }

  @override
  Future<void> confirmSignIn({
    required ConfirmSignInAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    if (provider is EmailLinkConfirmSignInAuthProvider) {
      await _prepareProcessInternal();
      final email = _sharedPreferences.getString(_kUserPhoneNumberKey.toSHA1());
      final allowMultiProviders =
          _sharedPreferences.getBool(_kAllowMultiProvidersKey.toSHA1()) ?? true;
      if (email.isEmpty) {
        throw Exception("Email is not saved.");
      }
      if (!database.isSignInWithEmailLink(provider.url)) {
        throw Exception("This email link is invalid.");
      }
      final credential = EmailAuthProvider.credentialWithLink(
        email: email!,
        emailLink: provider.url,
      );
      if (_user != null) {
        if (!allowMultiProviders) {
          throw Exception(
            "This user is already signed in, please sign out first.",
          );
        }
        if (!_user!.providerData
            .any((t) => t.providerId.contains(EmailAuthProvider.PROVIDER_ID))) {
          await _user!.linkWithCredential(credential);
        }
      } else {
        await database.signInWithCredential(credential);
      }
      if (_user == null || _user!.uid.isEmpty) {
        throw Exception("User is not found.");
      }
      await _sharedPreferences.remove(_kUserEmailKey.toSHA1());
      await _sharedPreferences.remove(_kAllowMultiProvidersKey.toSHA1());
      onUserStateChanged.call();
    } else if (provider is SmsConfirmSignInAuthProvider) {
      await _prepareProcessInternal();
      final phoneNumber =
          _sharedPreferences.getString(_kUserPhoneNumberKey.toSHA1());
      final verificationId =
          _sharedPreferences.getString(_kSmsVerificationIdKey.toSHA1());
      final allowMultiProviders =
          _sharedPreferences.getBool(_kAllowMultiProvidersKey.toSHA1()) ?? true;
      if (phoneNumber.isEmpty) {
        throw Exception("Phone number is not saved.");
      }
      if (verificationId.isEmpty) {
        throw Exception("Sms verirication id is not saved.");
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: provider.code,
      );
      if (_user != null) {
        if (!allowMultiProviders) {
          throw Exception(
            "This user is already signed in, please sign out first.",
          );
        }
        if (!_user!.providerData
            .any((t) => t.providerId.contains(PhoneAuthProvider.PROVIDER_ID))) {
          await _user!.linkWithCredential(credential);
        }
      } else {
        await database.signInWithCredential(credential);
      }
      if (_user == null || _user!.uid.isEmpty) {
        throw Exception("User is not found.");
      }
      await _sharedPreferences.remove(_kUserPhoneNumberKey.toSHA1());
      await _sharedPreferences.remove(_kSmsVerificationIdKey.toSHA1());
      await _sharedPreferences.remove(_kAllowMultiProvidersKey.toSHA1());
      onUserStateChanged.call();
    }
  }

  @override
  Future<bool> reauth({required ReAuthProvider provider}) async {
    if (provider is EmailAndPasswordReAuthProvider) {
      await _prepareProcessInternal();
      await _user!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: _user!.email!,
          password: provider.password,
        ),
      );
      return true;
    } else if (provider is SnsReAuthProvider) {
      await _prepareProcessInternal();
      final credential = await provider.credential();
      final firebaseCredential = credential.signInMethod == "oauth"
          ? OAuthProvider(credential.providerId).credential(
              accessToken: credential.accessToken,
              secret: credential.secret,
              idToken: credential.idToken,
            )
          : AuthCredential(
              providerId: credential.providerId,
              signInMethod: credential.signInMethod,
              token: credential.token,
              accessToken: credential.accessToken,
            );
      await _user!.reauthenticateWithCredential(firebaseCredential);
      return true;
    } else {
      throw Exception(
        "This provider is not supported: ${provider.runtimeType}",
      );
    }
  }

  @override
  Future<void> reset({required ResetAuthProvider provider}) async {
    if (provider is EmailAndPasswordResetAuthProvider) {
      await _prepareProcessInternal();
      await database.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      await database.sendPasswordResetEmail(
        email: provider.email,
        actionCodeSettings: provider.continueUrl.isEmpty
            ? null
            : ActionCodeSettings(
                androidInstallApp: true,
                url: provider.continueUrl!,
                handleCodeInApp: true,
                iOSBundleId: iOSBundleId,
                androidPackageName: androidPackageName,
                androidMinimumVersion: androidMinimumVersion?.toString(),
              ),
      );
    } else {
      throw Exception(
        "This provider is not supported: ${provider.runtimeType}",
      );
    }
  }

  @override
  Future<void> verify({
    required VerifyAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    if (provider is EmailAndPasswordVerifyAuthProvider) {
      await _prepareProcessInternal();
      if (_user!.emailVerified) {
        throw Exception("This user has already been authenticated.");
      }
      await database.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      await _user!.sendEmailVerification();
      onUserStateChanged.call();
    } else if (provider is EmailLinkVerifyAuthProvider) {
      await _prepareProcessInternal();
      if (_user!.emailVerified) {
        throw Exception("This user has already been authenticated.");
      }
      await database.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      await _user!.sendEmailVerification();
      onUserStateChanged.call();
    }
  }

  @override
  Future<void> change({
    required ChangeAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    if (provider is ChangeEmailAuthProvider) {
      await _prepareProcessInternal();
      await database.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      await _user!.verifyBeforeUpdateEmail(provider.email);
      await _user!.reload();
      onUserStateChanged.call();
    } else if (provider is ChangePasswordAuthProvider) {
      await _prepareProcessInternal();
      await database.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      await _user!.updatePassword(provider.password);
      await _user!.reload();
      onUserStateChanged.call();
    } else if (provider is ChangePhoneNumberAuthProvider) {
      Completer? completer = Completer();
      var phoneNumber = provider.phoneNumber;
      if (phoneNumber.startsWith("0") && phoneNumber.length >= 11) {
        phoneNumber = phoneNumber.substring(1);
      }
      phoneNumber =
          "+${provider.countryNumber.trimStringLeft("+")}$phoneNumber";
      await _prepareProcessInternal();
      await database.setLanguageCode(
        provider.locale?.languageCode ?? defaultLocale.languageCode,
      );
      await _sharedPreferences.setString(
        _kUserPhoneNumberKey.toSHA1(),
        phoneNumber,
      );
      await database.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          if (_user != null) {
            if (!_user!.providerData.any(
              (t) => t.providerId.contains(PhoneAuthProvider.PROVIDER_ID),
            )) {
              await _user!.linkWithCredential(credential);
            }
          } else {
            await database.signInWithCredential(credential);
          }
          if (_user == null || _user!.uid.isEmpty) {
            completer?.completeError(Exception("User is not found."));
            completer = null;
            return;
          }
          completer?.complete();
          completer = null;
          onUserStateChanged.call();
          provider.onAutoVerificationCompleted?.call();
        },
        verificationFailed: (error) {
          completer?.completeError(error);
          completer = null;
          provider.onAutoVerificationFailed?.call(error);
        },
        codeSent: (varidationId, [code]) async {
          await _sharedPreferences.setString(
            _kSmsVerificationIdKey.toSHA1(),
            varidationId,
          );
          completer?.complete();
          completer = null;
          onUserStateChanged.call();
        },
        codeAutoRetrievalTimeout: (varidationId) async {
          await _sharedPreferences.remove(_kSmsVerificationIdKey.toSHA1());
          completer?.completeError(TimeoutException("Code entry timed out."));
          completer = null;
          onUserStateChanged.call();
        },
      );
      await completer?.future;
    }
  }

  @override
  Future<void> confirmChange({
    required ConfirmChangeAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    if (provider is ConfirmChangePhoneNumberAuthProvider) {
      await _prepareProcessInternal();
      final phoneNumber =
          _sharedPreferences.getString(_kUserPhoneNumberKey.toSHA1());
      final verificationId =
          _sharedPreferences.getString(_kSmsVerificationIdKey.toSHA1());
      if (phoneNumber.isEmpty) {
        throw Exception("Phone number is not saved.");
      }
      if (verificationId.isEmpty) {
        throw Exception("Sms verirication id is not saved.");
      }
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: provider.code,
      );
      if (_user == null || _user!.uid.isEmpty) {
        throw Exception("User is not found.");
      }
      await _user!.updatePhoneNumber(credential);
      await _user!.reload();
      await _sharedPreferences.remove(_kUserPhoneNumberKey.toSHA1());
      await _sharedPreferences.remove(_kSmsVerificationIdKey.toSHA1());
      onUserStateChanged.call();
    }
  }

  @override
  Future<void> signOut({
    required VoidCallback onUserStateChanged,
  }) async {
    if (_user == null || _user!.uid.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await _initialize();
    await database.signOut();
    onUserStateChanged.call();
  }

  @override
  Future<void> delete({
    required VoidCallback onUserStateChanged,
  }) async {
    if (_user == null || _user!.uid.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await _initialize();
    await _user!.delete();
    onUserStateChanged.call();
  }

  Future<void> _prepareProcessInternal() async {
    await _initialize();
    final user = database.currentUser;
    if (user == null) {
      return;
    }
    await user.reload();
  }

  @override
  void dispose() {}

  @override
  int get hashCode => _database.hashCode ^ options.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
