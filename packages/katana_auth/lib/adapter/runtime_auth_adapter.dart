// ignore_for_file: avoid_field_initializers_in_const_classes

part of '/katana_auth.dart';

/// Authentication adapter using a database that runs only in the app's memory.
///
/// All data will be reset when the application is re-launched.
///
/// It is usually used for temporary databases under development or for testing.
///
/// Normally, a common database [sharedDatabase] is used for the entire app, but if you want to reset the database each time, for example for testing, pass an individual database to [database].
///
/// Individual data can be preconfigured and used as data mocks for authentication.
///
/// アプリのメモリ上でのみ動作するデータベースを利用した認証アダプター。
///
/// アプリを立ち上げ直すとデータはすべてリセットされます。
///
/// 通常は開発途中の仮のデータベースやテスト用のデータベースに利用します。
///
/// 通常はアプリ内全体での共通のデータベース[sharedDatabase]が利用されますが、テスト用などで毎回データベースをリセットする場合は[database]に個別のデータベースを渡してください。
///
/// 個別のデータを予め設定しておくことで認証用のデータモックとして利用することができます。
class RuntimeAuthAdapter extends AuthAdapter {
  /// Authentication adapter using a database that runs only in the app's memory.
  ///
  /// All data will be reset when the application is re-launched.
  ///
  /// It is usually used for temporary databases under development or for testing.
  ///
  /// Normally, a common database [sharedDatabase] is used for the entire app, but if you want to reset the database each time, for example for testing, pass an individual database to [database].
  ///
  /// Individual data can be preconfigured and used as data mocks for authentication.
  ///
  /// アプリのメモリ上でのみ動作するデータベースを利用した認証アダプター。
  ///
  /// アプリを立ち上げ直すとデータはすべてリセットされます。
  ///
  /// 通常は開発途中の仮のデータベースやテスト用のデータベースに利用します。
  ///
  /// 通常はアプリ内全体での共通のデータベース[sharedDatabase]が利用されますが、テスト用などで毎回データベースをリセットする場合は[database]に個別のデータベースを渡してください。
  ///
  /// 個別のデータを予め設定しておくことで認証用のデータモックとして利用することができます。
  const RuntimeAuthAdapter({
    AuthDatabase? database,
    this.initialUserId,
    this.initialValue,
    super.authActions = const [],
  }) : _database = database;

  /// Designated database. Please use for testing purposes, etc.
  ///
  /// 指定のデータベース。テスト用途などにご利用ください。
  AuthDatabase get database {
    final database = _database ?? sharedDatabase;
    if (!database.isInitialValueRegistered) {
      if (initialValue.isNotEmpty) {
        for (final value in initialValue!) {
          database.setInitialValue(value);
        }
      }
      if (initialUserId.isNotEmpty) {
        database.setInitialId(initialUserId);
        database.setInitialValue(
          AuthInitialValue.anonymously(userId: initialUserId!),
        );
      }
    }
    return database;
  }

  final AuthDatabase? _database;

  /// Initial user id.
  ///
  /// 初期ユーザーID。
  final String? initialUserId;

  /// Initial value.
  ///
  /// 初期値。
  final List<AuthInitialValue>? initialValue;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final AuthDatabase sharedDatabase = AuthDatabase();

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
  Future<AccessTokenValue?> accessToken({bool forceRefresh = false}) =>
      Future.value(
        !isSignedIn ? null : const AccessTokenValue(token: ""),
      );

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

  @override
  int get hashCode => _database.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
