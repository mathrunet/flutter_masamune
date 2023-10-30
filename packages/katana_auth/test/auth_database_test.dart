// ignore_for_file: prefer_typing_uninitialized_variables

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana_auth/katana_auth.dart';

void main() {
  test("AuthDatabase.create", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    await db.create(
      provider: const EmailAndPasswordCreateAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.accounts, [
      {
        AuthDatabase.userIdKey: userId,
        AuthDatabase.userEmailKey: "test@mathru.net",
        AuthDatabase.userPasswordKey: "12345678",
        AuthDatabase.activeProvidersKey: ["password"]
      }
    ]);
    expect(db.current, null);
    expect(db.isSignedIn, false);
  });
  test("AuthDatabase.register", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    await db.register(
      provider: const EmailAndPasswordRegisterAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.accounts, [
      {
        AuthDatabase.userIdKey: userId,
        AuthDatabase.userEmailKey: "test@mathru.net",
        AuthDatabase.userPasswordKey: "12345678",
        AuthDatabase.activeProvidersKey: ["password"]
      }
    ]);
    expect(db.current, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "12345678",
      AuthDatabase.activeProvidersKey: ["password"]
    });
    expect(db.isSignedIn, false);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.isSignedIn, true);
    expect(db.active, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "12345678",
      AuthDatabase.activeProvidersKey: ["password"]
    });
  });
  test("AuthDatabase.signInWithAnonymously", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    await db.signIn(
      provider: const AnonymouslySignInAuthProvider(),
    );
    expect(db.accounts, [
      {
        AuthDatabase.anonymouslyKey: true,
        AuthDatabase.userIdKey: userId,
        AuthDatabase.activeProvidersKey: ["anonymous"]
      }
    ]);
    expect(db.isSignedIn, true);
    expect(db.current, {
      AuthDatabase.anonymouslyKey: true,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.activeProvidersKey: ["anonymous"]
    });
    expect(db.active, {
      AuthDatabase.anonymouslyKey: true,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.activeProvidersKey: ["anonymous"]
    });
  });
  test("AuthDatabase.signInWithEmailAndPassword", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    db.setInitialValue(
      AuthInitialValue(
        userId: userId,
        email: "test@mathru.net",
        password: "12345678",
        activeProviders: ["password"],
      ),
    );
    await db.tryRestoreAuth();
    expect(db.isSignedIn, false);
    expect(db.accounts, [
      {
        AuthDatabase.verifiedKey: false,
        AuthDatabase.anonymouslyKey: false,
        AuthDatabase.userIdKey: userId,
        AuthDatabase.userEmailKey: "test@mathru.net",
        AuthDatabase.userPasswordKey: "12345678",
        AuthDatabase.activeProvidersKey: ["password"]
      }
    ]);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.isSignedIn, true);
    expect(db.current, {
      AuthDatabase.verifiedKey: false,
      AuthDatabase.anonymouslyKey: false,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "12345678",
      AuthDatabase.activeProvidersKey: ["password"]
    });
    expect(db.active, {
      AuthDatabase.verifiedKey: false,
      AuthDatabase.anonymouslyKey: false,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "12345678",
      AuthDatabase.activeProvidersKey: ["password"]
    });
  });
  test("AuthDatabase.signInWithEmailLink", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    await db.signIn(
      provider: const EmailLinkSignInAuthProvider(
        email: "test@mathru.net",
        url: "https://mathru.net",
      ),
    );
    expect(db.accounts, [
      {
        AuthDatabase.userIdKey: userId,
        AuthDatabase.emailLinkUrlKey: "https://mathru.net",
        AuthDatabase.tmpUserEmailKey: "test@mathru.net",
      }
    ]);
    expect(db.isSignedIn, false);
    await db.confirmSignIn(
      provider: const EmailLinkConfirmSignInAuthProvider(
        url: "https://mathru.net",
      ),
    );
    expect(db.accounts, [
      {
        AuthDatabase.userIdKey: userId,
        AuthDatabase.userEmailKey: "test@mathru.net",
        AuthDatabase.emailLinkUrlKey: "https://mathru.net",
        AuthDatabase.tmpUserEmailKey: "test@mathru.net",
        AuthDatabase.activeProvidersKey: ["password"]
      }
    ]);
    expect(db.isSignedIn, true);
    expect(db.current, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.emailLinkUrlKey: "https://mathru.net",
      AuthDatabase.tmpUserEmailKey: "test@mathru.net",
      AuthDatabase.activeProvidersKey: ["password"]
    });
    expect(db.active, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.emailLinkUrlKey: "https://mathru.net",
      AuthDatabase.tmpUserEmailKey: "test@mathru.net",
      AuthDatabase.activeProvidersKey: ["password"]
    });
  });
  test("AuthDatabase.signInWithSms", () async {
    const code = "123456";
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
      debugSmsCode: code,
    );
    await db.signIn(
      provider: const SmsSignInAuthProvider(
        phoneNumber: "00000000000",
      ),
    );
    expect(db.accounts, [
      {
        AuthDatabase.userIdKey: userId,
        AuthDatabase.tmpUserPhoneNumberKey: "00000000000",
        AuthDatabase.smsCodeKey: code,
      }
    ]);
    expect(db.isSignedIn, false);
    await db.confirmSignIn(
      provider: const SmsConfirmSignInAuthProvider(
        code: code,
      ),
    );
    expect(db.accounts, [
      {
        AuthDatabase.userIdKey: userId,
        AuthDatabase.tmpUserPhoneNumberKey: "00000000000",
        AuthDatabase.smsCodeKey: code,
        AuthDatabase.userPhoneNumberKey: "00000000000",
        AuthDatabase.activeProvidersKey: ["phone"]
      }
    ]);
    expect(db.isSignedIn, true);
    expect(db.current, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.tmpUserPhoneNumberKey: "00000000000",
      AuthDatabase.smsCodeKey: code,
      AuthDatabase.userPhoneNumberKey: "00000000000",
      AuthDatabase.activeProvidersKey: ["phone"]
    });
    expect(db.active, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.tmpUserPhoneNumberKey: "00000000000",
      AuthDatabase.smsCodeKey: code,
      AuthDatabase.userPhoneNumberKey: "00000000000",
      AuthDatabase.activeProvidersKey: ["phone"]
    });
  });
  test("AuthDatabase.reauth", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    db.setInitialValue(
      AuthInitialValue(
        userId: userId,
        email: "test@mathru.net",
        password: "12345678",
        activeProviders: ["password"],
      ),
    );
    expect(db.isSignedIn, false);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.isSignedIn, true);
    final res = await db.reauth(
      provider: const EmailAndPasswordReAuthProvider(password: "12345678"),
    );
    expect(res, true);
  });
  test("AuthDatabase.reset", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
      onResetPassword: (newPassword, locale) async {
        return "abcdefgh";
      },
    );
    db.setInitialValue(
      AuthInitialValue(
        userId: userId,
        email: "test@mathru.net",
        password: "12345678",
        activeProviders: ["password"],
      ),
    );
    expect(db.isSignedIn, false);
    await db.reset(
      provider: const EmailAndPasswordResetAuthProvider(
        email: "test@mathru.net",
      ),
    );
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "abcdefgh",
      ),
    );
    expect(db.isSignedIn, true);
    expect(db.active, {
      AuthDatabase.verifiedKey: false,
      AuthDatabase.anonymouslyKey: false,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "abcdefgh",
      AuthDatabase.activeProvidersKey: ["password"]
    });
  });
  test("AuthDatabase.verifyEmailAndPassword", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
      onVerify: (email, locale) async {
        return true;
      },
    );
    db.setInitialValue(
      AuthInitialValue(
        userId: userId,
        email: "test@mathru.net",
        password: "12345678",
        activeProviders: ["password"],
      ),
    );
    expect(db.isSignedIn, false);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.isVerified, false);
    await db.verify(provider: const EmailAndPasswordVerifyAuthProvider());
    expect(db.isVerified, true);
    expect(db.active, {
      AuthDatabase.verifiedKey: true,
      AuthDatabase.anonymouslyKey: false,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "12345678",
      AuthDatabase.activeProvidersKey: ["password"]
    });
  });
  test("AuthDatabase.verifyEmailLink", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
      onVerify: (email, locale) async {
        return true;
      },
    );
    await db.signIn(
      provider: const EmailLinkSignInAuthProvider(
        email: "test@mathru.net",
        url: "https://mathru.net",
      ),
    );
    expect(db.isSignedIn, false);
    await db.confirmSignIn(
      provider: const EmailLinkConfirmSignInAuthProvider(
        url: "https://mathru.net",
      ),
    );
    expect(db.isSignedIn, true);
    expect(db.isVerified, false);
    await db.verify(provider: const EmailLinkVerifyAuthProvider());
    expect(db.isVerified, true);
    expect(db.active, {
      AuthDatabase.verifiedKey: true,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.emailLinkUrlKey: "https://mathru.net",
      AuthDatabase.tmpUserEmailKey: "test@mathru.net",
      AuthDatabase.activeProvidersKey: ["password"]
    });
  });
  test("AuthDatabase.changeEmail", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    db.setInitialValue(
      AuthInitialValue(
        userId: userId,
        email: "test@mathru.net",
        password: "12345678",
        activeProviders: ["password"],
      ),
    );
    expect(db.isSignedIn, false);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.isSignedIn, true);
    expect(db.userEmail, "test@mathru.net");
    await db.change(
      provider: const EmailAndPasswordChangeEmailAuthProvider(
          email: "aaa@mathru.net"),
    );
    expect(db.userEmail, "aaa@mathru.net");
    expect(db.active, {
      AuthDatabase.verifiedKey: false,
      AuthDatabase.anonymouslyKey: false,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "aaa@mathru.net",
      AuthDatabase.userPasswordKey: "12345678",
      AuthDatabase.activeProvidersKey: ["password"]
    });
    await db.signOut();
    expect(db.isSignedIn, false);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "aaa@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.isSignedIn, true);
  });
  test("AuthDatabase.changePassword", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    db.setInitialValue(
      AuthInitialValue(
        userId: userId,
        email: "test@mathru.net",
        password: "12345678",
        activeProviders: ["password"],
      ),
    );
    expect(db.isSignedIn, false);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.isSignedIn, true);
    expect(db.userPassword, "12345678");
    await db.change(
      provider: const EmailAndPasswordChangePasswordAuthProvider(
          password: "abcdhfgh"),
    );
    expect(db.userPassword, "abcdhfgh");
    expect(db.active, {
      AuthDatabase.verifiedKey: false,
      AuthDatabase.anonymouslyKey: false,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "abcdhfgh",
      AuthDatabase.activeProvidersKey: ["password"]
    });
    await db.signOut();
    expect(db.isSignedIn, false);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "abcdhfgh",
      ),
    );
    expect(db.isSignedIn, true);
  });
  test("AuthDatabase.changePhoneNumber", () async {
    const code = "123456";
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
      debugSmsCode: code,
    );
    await db.signIn(
      provider: const SmsSignInAuthProvider(
        phoneNumber: "00000000000",
      ),
    );
    expect(db.isSignedIn, false);
    await db.confirmSignIn(
      provider: const SmsConfirmSignInAuthProvider(
        code: code,
      ),
    );
    expect(db.isSignedIn, true);
    expect(db.userPhoneNumber, "00000000000");
    await db.change(
      provider: const SmsChangePhoneNumberAuthProvider(
        phoneNumber: "11111111111",
      ),
    );
    expect(db.userPhoneNumber, "00000000000");
    expect(db.active, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.tmpUserPhoneNumberKey: "11111111111",
      AuthDatabase.smsCodeKey: code,
      AuthDatabase.userPhoneNumberKey: "00000000000",
      AuthDatabase.activeProvidersKey: ["phone"]
    });
    await db.confirmChange(
      provider: const SmsConfirmChangePhoneNumberAuthProvider(code: code),
    );
    expect(db.userPhoneNumber, "11111111111");
    expect(db.active, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.tmpUserPhoneNumberKey: "11111111111",
      AuthDatabase.smsCodeKey: code,
      AuthDatabase.userPhoneNumberKey: "11111111111",
      AuthDatabase.activeProvidersKey: ["phone"]
    });
    await db.signOut();
    await db.signIn(
      provider: const SmsSignInAuthProvider(
        phoneNumber: "11111111111",
      ),
    );
    expect(db.isSignedIn, false);
    expect(db.current, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.tmpUserPhoneNumberKey: "11111111111",
      AuthDatabase.smsCodeKey: code,
      AuthDatabase.userPhoneNumberKey: "11111111111",
      AuthDatabase.activeProvidersKey: ["phone"]
    });
    await db.confirmSignIn(
      provider: const SmsConfirmSignInAuthProvider(
        code: code,
      ),
    );
    expect(db.isSignedIn, true);
  });
  test("AuthDatabase.delete", () async {
    final userId = uuid();
    final db = AuthDatabase(
      debugUserId: userId,
    );
    await db.register(
      provider: const EmailAndPasswordRegisterAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.accounts, [
      {
        AuthDatabase.userIdKey: userId,
        AuthDatabase.userEmailKey: "test@mathru.net",
        AuthDatabase.userPasswordKey: "12345678",
        AuthDatabase.activeProvidersKey: ["password"]
      }
    ]);
    expect(db.current, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "12345678",
      AuthDatabase.activeProvidersKey: ["password"]
    });
    expect(db.isSignedIn, false);
    await db.signIn(
      provider: const EmailAndPasswordSignInAuthProvider(
        email: "test@mathru.net",
        password: "12345678",
      ),
    );
    expect(db.isSignedIn, true);
    expect(db.active, {
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userEmailKey: "test@mathru.net",
      AuthDatabase.userPasswordKey: "12345678",
      AuthDatabase.activeProvidersKey: ["password"]
    });
    await db.delete();
    expect(db.isSignedIn, false);
    expect(db.active, null);
    expect(db.accounts, []);
  });
}
