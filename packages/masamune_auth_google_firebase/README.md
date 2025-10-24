<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Auth Google for Firebase</h1>
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

# Masamune Auth Google for Firebase

## Usage

`masamune_auth_google_firebase` bridges Google Sign In credentials to Firebase Authentication using the Masamune/Katana stack. Use it alongside:

- `katana_auth` – core authentication abstractions
- `katana_auth_firebase` – Firebase Authentication integration
- `masamune_auth_google` – native Google sign-in flow

### Installation

Install the base packages first:

```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
```

Then add Google sign-in support:

```bash
flutter pub add masamune_auth_google
flutter pub add masamune_auth_google_firebase
```

### Register Adapters

Configure adapters near the top of your widget tree so Google tokens can be exchanged for Firebase credentials.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const GoogleAuthMasamuneAdapter(
    clientId: "YOUR_GOOGLE_CLIENT_ID",
  ),
  FirebaseGoogleAuthMasamuneAdapter(
    functionsAdapter: const FunctionsMasamuneAdapter(),
  ),
];
```

**Note**: This package requires `katana_auth` and `katana_auth_firebase` to be installed separately. Those packages provide the core authentication infrastructure.

`FirebaseGoogleAuthMasamuneAdapter` expects a backend (Cloud Functions or your own server) that validates Google ID tokens and returns Firebase credentials to the app.

### Authenticate Users

Use `Authentication` from `katana_auth` to start the Google sign-in flow.

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
                  Text("Signed in with Google"),
                  Text("User ID: ${auth.userId}"),
                  Text("Email: ${auth.userEmail}"),
                  TextButton(
                    onPressed: () => auth.signOut(),
                    child: const Text("Sign Out"),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                icon: Icon(Icons.g_mobiledata),
                label: const Text("Sign in with Google"),
                onPressed: () async {
                  try {
                    await auth.signIn(GoogleAuthQuery.signIn());
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

After completion, Firebase Authentication holds the signed-in user and `auth.isSignedIn` becomes `true`.

### Backend Token Exchange

Implement `FirebaseGoogleAuthFunctionsAction` to exchange Google credentials:

1. Receive the ID token and optional server auth code from the client.
2. Verify the token with Google’s OAuth endpoints.
3. Exchange tokens if necessary (server auth code flow).
4. Mint a Firebase custom token or use `signInWithCredential`.
5. Return the Firebase ID token/custom token to the client.

### Linking Providers

- Call `auth.link(GoogleAuthQuery.link())` to add Google as another sign-in method for an existing user.
- Supports upgrading anonymous accounts to Google sign-in without losing data.

### Tips

- Configure OAuth consent screen, package names, SHA certificates, and reversed client IDs in Google Cloud Console.
- Test on real devices; some emulators lack Google Play Services support.
- Provide fallback authentication methods for users without Google accounts.
- Log sign-in attempts using `AuthLoggerAdapter` for analytics and debugging.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)