<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Auth GitHub for Firebase</h1>
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
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static.v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Masamune Auth GitHub for Firebase

## Usage

`masamune_auth_github_firebase` enables GitHub OAuth sign-in with Firebase Authentication using the Masamune/Katana auth stack. It is intended to be used with:

- `katana_auth` – core authentication abstractions
- `katana_auth_firebase` – Firebase Authentication integration

### Installation

Install the base packages first:

```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
```

Then install the GitHub integration:

```bash
flutter pub add masamune_auth_github_firebase
```

### Register Adapters

Add the adapters near the root of your app so GitHub tokens can be exchanged for Firebase credentials.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const RuntimeAuthMasamuneAdapter(),
  FirebaseAuthMasamuneAdapter(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  ),

  FirebaseGithubAuthMasamuneAdapter(
    functionsAdapter: const FunctionsMasamuneAdapter(),
  ),
];
```

`FirebaseGithubAuthMasamuneAdapter` expects a Cloud Functions endpoint (or your own backend) that validates GitHub OAuth codes and mints Firebase tokens.

### Authenticate Users

Use `Authentication` from `katana_auth` to trigger GitHub sign-in. The query handles OAuth authorization and token exchange.

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
                  Text("Signed in with GitHub"),
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
                icon: Icon(Icons.code),
                label: const Text("Sign in with GitHub"),
                onPressed: () async {
                  try {
                    await auth.signIn(FirebaseGithubAuthQuery.signIn());
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

After completion, `auth.isSignedIn` becomes `true` and the Firebase user is authenticated.

### Cloud Functions Outline

Implement the supplied Functions action to exchange GitHub credentials:

1. Receive the GitHub authorization code from the client.
2. Exchange it for an access token via GitHub’s OAuth API.
3. Use the token to fetch the user’s GitHub profile (optional).
4. Mint a Firebase custom token or use `signInWithCredential` on the backend.
5. Return the Firebase ID token or custom token to the app.

### Linking Accounts

- Use `auth.link(FirebaseGithubAuthQuery.link())` to add GitHub as an additional provider for an existing user.
- Anonymous users can upgrade to GitHub sign-in without losing data.

### Tips

- Configure GitHub OAuth application settings (client ID, client secret, redirect URI) in the GitHub Developer portal.
- Ensure redirect URIs match those used in your Cloud Functions.
- Provide alternative sign-in options for users without GitHub accounts.
- Log sign-in events via `AuthLoggerAdapter` for debugging and analytics.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)