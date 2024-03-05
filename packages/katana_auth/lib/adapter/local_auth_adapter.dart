// ignore_for_file: avoid_field_initializers_in_const_classes

part of '/katana_auth.dart';

const _kLocalDatabaseId = "auth://";

/// Authentication adapter that stores data on the local terminal.
///
/// Use for application development that does not require external storage of values.
///
/// For mobile and desktop, data is encrypted and stored in external files, and for the Web, data is encrypted and stored in LocalStorage.
///
/// ローカル端末にデータを保存する認証アダプター。
///
/// 外部に値を保存する必要のないアプリ開発に利用します。
///
/// モバイルやデスクトップは外部ファイルに暗号化してデータが保存されWebの場合はLocalStorageに暗号化されデータが保存されます。
class LocalAuthAdapter extends AuthAdapter {
  /// Authentication adapter that stores data on the local terminal.
  ///
  /// Use for application development that does not require external storage of values.
  ///
  /// For mobile and desktop, data is encrypted and stored in external files, and for the Web, data is encrypted and stored in LocalStorage.
  ///
  /// ローカル端末にデータを保存する認証アダプター。
  ///
  /// 外部に値を保存する必要のないアプリ開発に利用します。
  ///
  /// モバイルやデスクトップは外部ファイルに暗号化してデータが保存されWebの場合はLocalStorageに暗号化されデータが保存されます。
  const LocalAuthAdapter({
    AuthDatabase? database,
    String? initialUserId,
    List<AuthInitialValue>? initialValue,
  })  : _database = database,
        _initialUserId = initialUserId,
        _initialValue = initialValue;

  /// Designated database.
  ///
  /// 指定のデータベース。
  AuthDatabase get database {
    final database = _database ?? sharedDatabase;
    if (!database.isInitialValueRegistered) {
      if (_initialValue.isNotEmpty) {
        for (final value in _initialValue!) {
          database.setInitialValue(value);
        }
      }
      if (_initialUserId.isNotEmpty) {
        database.setInitialId(_initialUserId);
        database.setInitialValue(
          AuthInitialValue.anonymously(userId: _initialUserId!),
        );
      }
    }
    return database;
  }

  final AuthDatabase? _database;
  final String? _initialUserId;
  final List<AuthInitialValue>? _initialValue;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final AuthDatabase sharedDatabase = AuthDatabase(
    onInitialize: (database) async {
      try {
        database._data = await AuthExporter.import(
          "${AuthExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        );
      } catch (e) {
        database._data = {};
      }
    },
    onSaved: (database) async {
      await AuthExporter.export(
        "${AuthExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database._data,
      );
    },
  );

  @override
  String? get userEmail => !isSignedIn ? null : database.userEmail;

  @override
  String? get userId => !isSignedIn ? null : database.userId;

  @override
  String? get userName => !isSignedIn ? null : database.userName;

  @override
  String? get userPhoneNumber => !isSignedIn ? null : database.userPhoneNumber;

  @override
  String? get userPhotoURL => !isSignedIn ? null : database.userPhotoURL;

  @override
  bool get isAnonymously => database.isAnonymously;

  @override
  bool get isSignedIn => database.isSignedIn;

  @override
  bool get isVerified => database.isVerified;

  @override
  bool get isWaitingConfirmation => database.isWaitingConfirmation;

  @override
  Future<String?> get accessToken => Future.value(!isSignedIn ? null : "");

  @override
  String? get refreshToken => !isSignedIn ? null : "";

  @override
  List<String>? get activeProviderIds =>
      !isSignedIn ? null : database.activeProviderIds;

  @override
  Future<bool> tryRestoreAuth({
    bool retryWhenTimeout = false,
    required VoidCallback onUserStateChanged,
  }) async {
    final signedIn = await database.tryRestoreAuth();
    if (signedIn) {
      onUserStateChanged.call();
    }
    return signedIn;
  }

  @override
  Future<String?> create({
    required CreateAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    final userId = await database.create(provider: provider);
    onUserStateChanged.call();
    return userId;
  }

  @override
  Future<void> register({
    required RegisterAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    await database.register(provider: provider);
    onUserStateChanged.call();
  }

  @override
  Future<void> signIn({
    required SignInAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    await database.signIn(provider: provider);
    onUserStateChanged.call();
  }

  @override
  Future<void> confirmSignIn({
    required ConfirmSignInAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    await database.confirmSignIn(provider: provider);
    onUserStateChanged.call();
  }

  @override
  Future<bool> reauth({
    required ReAuthProvider provider,
  }) async {
    return await database.reauth(provider: provider);
  }

  @override
  Future<void> reset({required ResetAuthProvider provider}) async {
    return await database.reset(provider: provider);
  }

  @override
  Future<void> verify({
    required VerifyAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    await database.verify(provider: provider);
    onUserStateChanged.call();
  }

  @override
  Future<void> change({
    required ChangeAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    await database.change(provider: provider);
    onUserStateChanged.call();
  }

  @override
  Future<void> confirmChange({
    required ConfirmChangeAuthProvider provider,
    required VoidCallback onUserStateChanged,
  }) async {
    await database.confirmChange(provider: provider);
    onUserStateChanged.call();
  }

  @override
  Future<void> signOut({
    required VoidCallback onUserStateChanged,
  }) async {
    await database.signOut();
    onUserStateChanged.call();
  }

  @override
  Future<void> delete({
    required VoidCallback onUserStateChanged,
  }) async {
    await database.delete();
    onUserStateChanged.call();
  }

  @override
  void dispose() {
    database.dispose();
  }
}
