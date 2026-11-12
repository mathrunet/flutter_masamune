// Platform interfaces are transitive dependencies used only to replace
// native channels with in-memory fakes in this test.
// ignore_for_file: depend_on_referenced_packages

// Package imports:
import "package:firebase_auth/firebase_auth.dart" hide AuthProvider;
import "package:firebase_core_platform_interface/firebase_core_platform_interface.dart";
import "package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart";
import "package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart";
import "package:test/test.dart";

// Project imports:
import "package:katana_auth_firebase/katana_auth_firebase.dart";

class _FakeFirebaseApp extends FirebaseAppPlatform {
  _FakeFirebaseApp(String name)
    : super(
        name,
        const FirebaseOptions(
          apiKey: "test-api-key",
          appId: "1:000000000000:ios:0000000000000000",
          messagingSenderId: "000000000000",
          projectId: "test-project",
        ),
      );
}

class _FakeFirebasePlatform extends FirebasePlatform {
  final Map<String, FirebaseAppPlatform> _apps = {};

  @override
  List<FirebaseAppPlatform> get apps => _apps.values.toList();

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    final appName = name ?? defaultFirebaseAppName;
    return _apps.putIfAbsent(appName, () => _FakeFirebaseApp(appName));
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    final app = _apps[name];
    if (app == null) {
      throw FirebaseException(plugin: "core", code: "no-app");
    }
    return app;
  }
}

class _FakeUser implements User {
  _FakeUser(this.uid, {this.isAnonymous = false});

  @override
  final String uid;

  @override
  final bool isAnonymous;

  @override
  List<UserInfo> get providerData => const [];

  @override
  Future<void> reload() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirebaseAuth implements FirebaseAuth {
  _FakeFirebaseAuth({this.customTokenUid = "custom-user"});

  final String customTokenUid;
  Object? customTokenError;
  User? user;
  final List<String> customTokens = [];
  int anonymousCalls = 0;
  final List<AuthCredential> credentials = [];

  @override
  User? get currentUser => user;

  @override
  Future<UserCredential> signInWithCustomToken(String token) async {
    customTokens.add(token);
    final error = customTokenError;
    if (error != null) {
      throw error;
    }
    user = _FakeUser(customTokenUid);
    return _FakeUserCredential(user);
  }

  @override
  Future<UserCredential> signInAnonymously() async {
    anonymousCalls++;
    user = _FakeUser("anonymous-user", isAnonymous: true);
    return _FakeUserCredential(user);
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    credentials.add(credential);
    user = _FakeUser("email-user");
    return _FakeUserCredential(user);
  }

  @override
  Future<void> signOut() async {
    user = null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUserCredential implements UserCredential {
  _FakeUserCredential(this.user);

  @override
  final User? user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    FirebasePlatform.instance = _FakeFirebasePlatform();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group("FirebaseCustomTokenSignInAuthProvider", () {
    test("signs in with the custom token and notifies the state", () async {
      final firebaseAuth = _FakeFirebaseAuth(customTokenUid: "staff-uid");
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);
      var notified = 0;

      await adapter.signIn(
        provider: const FirebaseCustomTokenSignInAuthProvider("valid-token"),
        onUserStateChanged: () => notified++,
      );

      expect(firebaseAuth.customTokens, ["valid-token"]);
      expect(notified, 1);
      expect(adapter.isSignedIn, isTrue);
      expect(adapter.userId, "staff-uid");
      expect(adapter.isAnonymously, isFalse);
    });

    test("notifies Authentication listeners through the public API", () async {
      final firebaseAuth = _FakeFirebaseAuth(customTokenUid: "play-uid");
      final auth = Authentication(
        adapter: FirebaseAuthAdapter(database: firebaseAuth),
      );
      var notified = 0;
      auth.addListener(() => notified++);
      addTearDown(auth.dispose);

      await auth.signIn(
        const FirebaseCustomTokenSignInAuthProvider("valid-token"),
      );

      expect(notified, 1);
      expect(auth.isSignedIn, isTrue);
      expect(auth.userId, "play-uid");
    });

    test("rejects an empty token without calling Firebase", () async {
      final firebaseAuth = _FakeFirebaseAuth();
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);
      var notified = 0;

      for (final token in ["", "   "]) {
        await expectLater(
          adapter.signIn(
            provider: FirebaseCustomTokenSignInAuthProvider(token),
            onUserStateChanged: () => notified++,
          ),
          throwsA(
            isA<FirebaseAuthException>().having(
              (e) => e.code,
              "code",
              "invalid-custom-token",
            ),
          ),
        );
      }

      expect(firebaseAuth.customTokens, isEmpty);
      expect(notified, 0);
      expect(adapter.isSignedIn, isFalse);
    });

    test("propagates an invalid token error from Firebase", () async {
      final firebaseAuth = _FakeFirebaseAuth()
        ..customTokenError = FirebaseAuthException(
          code: "invalid-custom-token",
          message: "The custom token format is incorrect.",
        );
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);
      var notified = 0;

      await expectLater(
        adapter.signIn(
          provider: const FirebaseCustomTokenSignInAuthProvider("broken"),
          onUserStateChanged: () => notified++,
        ),
        throwsA(
          isA<FirebaseAuthException>().having(
            (e) => e.code,
            "code",
            "invalid-custom-token",
          ),
        ),
      );

      expect(firebaseAuth.customTokens, ["broken"]);
      expect(notified, 0);
      expect(adapter.isSignedIn, isFalse);
    });

    test("propagates other Firebase failures", () async {
      final firebaseAuth = _FakeFirebaseAuth()
        ..customTokenError = FirebaseAuthException(
          code: "network-request-failed",
        );
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);
      var notified = 0;

      await expectLater(
        adapter.signIn(
          provider: const FirebaseCustomTokenSignInAuthProvider("valid-token"),
          onUserStateChanged: () => notified++,
        ),
        throwsA(
          isA<FirebaseAuthException>().having(
            (e) => e.code,
            "code",
            "network-request-failed",
          ),
        ),
      );

      expect(notified, 0);
      expect(adapter.isSignedIn, isFalse);
    });

    test("rejects sign-in while another user is signed in", () async {
      final firebaseAuth = _FakeFirebaseAuth()..user = _FakeUser("other-user");
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);
      var notified = 0;

      await expectLater(
        adapter.signIn(
          provider: const FirebaseCustomTokenSignInAuthProvider("valid-token"),
          onUserStateChanged: () => notified++,
        ),
        throwsA(isA<Exception>()),
      );

      expect(firebaseAuth.customTokens, isEmpty);
      expect(notified, 0);
      expect(adapter.userId, "other-user");
    });

    test("does not expose the token in its string representation", () {
      const provider = FirebaseCustomTokenSignInAuthProvider("secret-token");

      expect(provider.toString(), isNot(contains("secret-token")));
      expect(provider.providerId, "custom");
      expect(provider.allowMultiProvider, isFalse);
    });
  });

  group("Existing sign-in providers", () {
    test("anonymous sign-in still works", () async {
      final firebaseAuth = _FakeFirebaseAuth();
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);
      var notified = 0;

      await adapter.signIn(
        provider: const AnonymouslySignInAuthProvider(),
        onUserStateChanged: () => notified++,
      );

      expect(firebaseAuth.anonymousCalls, 1);
      expect(firebaseAuth.customTokens, isEmpty);
      expect(notified, 1);
      expect(adapter.userId, "anonymous-user");
      expect(adapter.isAnonymously, isTrue);
    });

    test("email and password sign-in still works", () async {
      final firebaseAuth = _FakeFirebaseAuth();
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);
      var notified = 0;

      await adapter.signIn(
        provider: const EmailAndPasswordSignInAuthProvider(
          email: "test@mathru.net",
          password: "12345678",
        ),
        onUserStateChanged: () => notified++,
      );

      expect(firebaseAuth.credentials, hasLength(1));
      expect(firebaseAuth.customTokens, isEmpty);
      expect(notified, 1);
      expect(adapter.userId, "email-user");
    });

    test("direct sign-in is still rejected", () async {
      final firebaseAuth = _FakeFirebaseAuth();
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);

      await expectLater(
        adapter.signIn(
          provider: const DirectSignInAuthProvider(userId: "direct-user"),
          onUserStateChanged: () {},
        ),
        throwsA(isA<Exception>()),
      );

      expect(firebaseAuth.user, isNull);
    });

    test("sign-out after custom token sign-in clears the state", () async {
      final firebaseAuth = _FakeFirebaseAuth(customTokenUid: "staff-uid");
      final adapter = FirebaseAuthAdapter(database: firebaseAuth);
      var notified = 0;

      await adapter.signIn(
        provider: const FirebaseCustomTokenSignInAuthProvider("valid-token"),
        onUserStateChanged: () => notified++,
      );
      await adapter.signOut(onUserStateChanged: () => notified++);

      expect(notified, 2);
      expect(adapter.isSignedIn, isFalse);
    });
  });
}
