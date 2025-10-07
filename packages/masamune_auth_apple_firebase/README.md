<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Auth Apple for Firebase</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Masamune Auth Apple for Firebase

## Usage

`masamune_auth_apple_firebase` bridges Apple Sign In credentials to Firebase Authentication within the Masamune/Katana auth stack. It complements:

- `katana_auth` – core authentication abstractions
- `katana_auth_firebase` – Firebase Authentication integration
- `masamune_auth_apple` – native Apple Sign In flow

### Installation

Install the base packages first:

```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
```

Then add the Apple packages:

```bash
flutter pub add masamune_auth_apple
flutter pub add masamune_auth_apple_firebase
```

### Register Adapters

Place the adapters near the root of your application so that Apple credentials can be exchanged for Firebase tokens.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const RuntimeAuthMasamuneAdapter(),
  FirebaseAuthMasamuneAdapter(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  ),

  const AppleAuthMasamuneAdapter(),
  FirebaseAppleAuthMasamuneAdapter(
    functionsAdapter: const FunctionsMasamuneAdapter(),
  ),
];
```

`FirebaseAppleAuthMasamuneAdapter` expects a Cloud Functions endpoint (or direct Firebase SDK) capable of validating Apple ID tokens and minting Firebase credentials.

### Authenticate Users

Use `Authentication` from `katana_auth` to trigger Apple Sign In and automatically sign the user into Firebase.

```dart
class SignInPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final auth = ref.app.controller(Authentication.query());

    // Initialize on page load
    ref.page.on(
      initOrUpdate: () {
        auth.initialize();
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (auth.isSignedIn)
              Column(
                children: [
                  Text("Signed in with Apple"),
                  Text("User ID: ${auth.userId}"),
                  Text("Email: ${auth.userEmail ?? 'N/A'}"),
                  TextButton(
                    onPressed: () => auth.signOut(),
                    child: const Text("Sign Out"),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                icon: Icon(Icons.apple),
                label: const Text("Sign in with Apple"),
                onPressed: () async {
                  try {
                    await auth.signIn(AppleAuthQuery.signIn());
                  } catch (e) {
                    print("Sign in failed: $e");
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
```

Upon success, `auth.isSignedIn` becomes `true` and Firebase Authentication will contain the linked user record.

### Cloud Functions Validation

Implement the provided `FirebaseAppleAuthFunctionsAction` on your server to verify Apple credentials. A high-level outline:

1. Receive the identity token and authorization code from the client.
2. Validate the token using Apple’s public keys.
3. Exchange the authorization code (if provided) for user information.
4. Mint a Firebase custom token or sign in via `signInWithCredential`.
5. Return the Firebase ID token back to the app.

### Linking and Anonymous Upgrade

- Use `auth.link(AppleAuthQuery.link())` to attach Apple Sign In to an existing account.
- Anonymous users can upgrade to Apple Sign In while preserving data.

### iOS-Specific Setup

- Enable Sign In with Apple in the Apple Developer portal.
- Configure your services ID, redirect URI, and keys.
- Update `Info.plist` with the required entitlements and URL schemes.

### Tips

- Test on real devices; the simulator does not fully support Apple Sign In token flows.
- Use `AuthLoggerAdapter` to record sign-in attempts and error states.
- Provide fallbacks for users who cannot use Apple Sign In (e.g., additional provider or email/password).
- Keep your Cloud Functions secure and monitor token exchange errors for debugging.


# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)