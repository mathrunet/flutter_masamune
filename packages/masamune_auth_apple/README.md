<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Auth Apple</h1>
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

# Masamune Auth Apple

## Usage

`masamune_auth_apple` adds Apple Sign In support on top of the Masamune/Katana authentication stack. It is intended to be used together with:

- `katana_auth` – core authentication abstractions
- `katana_auth_firebase` – optional Firebase Authentication integration
- `masamune_auth_apple_firebase` – optional helper for exchanging Apple credentials with Firebase

### Installation

Install the base packages first:

```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
```

Then add the Apple-specific packages:

```bash
flutter pub add masamune_auth_apple
flutter pub add masamune_auth_apple_firebase
```

### Register Adapters

Place the adapters near the root of your app so they are available to the authentication controller.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  /// Core authentication adapters
  const RuntimeAuthMasamuneAdapter(),
  FirebaseAuthMasamuneAdapter(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  ),

  /// Apple Sign In adapters
  const AppleAuthMasamuneAdapter(),
  FirebaseAppleAuthMasamuneAdapter(
    functionsAdapter: const FunctionsMasamuneAdapter(),
  ),
];
```

`AppleAuthMasamuneAdapter` prepares the native Apple sign-in flow on iOS. `FirebaseAppleAuthMasamuneAdapter` exchanges the Apple credential for a Firebase token (via Cloud Functions or the Firebase SDK).

### Authenticate with Apple

Use `Authentication` from `katana_auth` to manage sign-in state.

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
            // Show user info if signed in
            if (auth.isSignedIn)
              Column(
                children: [
                  Text("Welcome!"),
                  Text("User ID: ${auth.userId}"),
                  Text("Email: ${auth.userEmail ?? 'N/A'}"),
                ],
              )
            else
              ElevatedButton.icon(
                icon: Icon(Icons.apple),
                label: const Text("Sign in with Apple"),
                onPressed: () async {
                  try {
                    await auth.signIn(AppleAuthQuery.signIn());
                    print("Signed in successfully!");
                  } catch (e) {
                    print("Sign in failed: $e");
                  }
                },
              ),
            
            // Sign out button
            if (auth.isSignedIn)
              TextButton(
                onPressed: () async {
                  await auth.signOut();
                },
                child: const Text("Sign Out"),
              ),
          ],
        ),
      ),
    );
  }
}
```

**State Management**: The `Authentication` controller is a `ChangeNotifier`, so the UI automatically rebuilds when sign-in state changes.

### Handling Tokens and Linking

- When the Firebase adapter is present, Apple credentials are automatically linked to the Firebase user.
- For mock or offline testing, rely on `RuntimeAuthMasamuneAdapter` without the Firebase adapter.
- Link additional providers later with `auth.link(AppleAuthQuery.link())` if your application allows multiple sign-in methods.

### iOS Configuration

Apple Sign In requires platform-specific configuration:

- Enable Sign In with Apple in the Apple Developer portal and create the necessary identifiers.
- Update `Info.plist` with the `NSAppleMusicUsageDescription` and `CFBundleURLSchemes` entries generated by Xcode.
- Ensure your bundle ID matches the identifier configured in the Apple Developer console.

### Tips

- Test on real iOS devices; the simulator may not fully support Apple Sign In flows.
- Use `AuthLoggerAdapter` to capture sign-in analytics or error reports.
- Provide fallbacks or alternative sign-in methods for platforms where Apple Sign In is unavailable.
- Combine with `masamune_purchase` or other Masamune modules to unlock premium features once the user signs in.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)