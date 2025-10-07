<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Auth Facebook</h1>
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

# Masamune Auth Facebook

## Usage

`masamune_auth_facebook` integrates Facebook login with the Masamune/Katana authentication stack. It is intended to work alongside:

- `katana_auth` – core authentication abstractions
- `katana_auth_firebase` – optional Firebase Authentication integration

### Installation

Install the base packages first:

```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
```

Then add Facebook support:

```bash
flutter pub add masamune_auth_facebook
```

If you need to link Facebook with Firebase, also install:

```bash
flutter pub add masamune_auth_facebook_firebase
```

### Register Adapters

Configure adapters near the root of your application so the Facebook SDK can authenticate properly.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const FacebookAuthMasamuneAdapter(
    clientToken: "YOUR_FACEBOOK_APP_ID",
    clientSecret: "YOUR_FACEBOOK_APP_SECRET",
  ),
];
```

**Note**: This package requires `katana_auth` and `katana_auth_firebase` to be installed separately. Those packages provide the core authentication infrastructure.

`FacebookAuthMasamuneAdapter` handles the native login flow and provides access tokens to the Katana authentication layer.

### Authenticate Users

Use `Authentication` from `katana_auth` to initiate the Facebook sign-in flow.

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
                  Text("Welcome!"),
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
                icon: Icon(Icons.facebook),
                label: const Text("Sign in with Facebook"),
                onPressed: () async {
                  try {
                    await auth.signIn(FacebookAuthQuery.signIn());
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

The controller automatically notifies listeners on state changes.

### Firebase Integration

If you also include `masamune_auth_facebook_firebase`, add the Firebase adapter and ensure you exchange Facebook credentials for Firebase tokens on the server (via Cloud Functions) or directly with the Firebase SDK.

```dart
FirebaseFacebookAuthMasamuneAdapter(
  functionsAdapter: const FunctionsMasamuneAdapter(),
),
```

### Facebook Platform Setup

- Create a Facebook app and obtain the App ID and App Secret.
- Configure redirect URIs, bundle IDs, and package names in Facebook Developer settings.
- Update your iOS and Android projects with the required meta-data (e.g., `AndroidManifest.xml`, `Info.plist`).

### Tips

- Test on real devices; browsers and simulators may have limitations when invoking the Facebook app or WebView.
- Provide fallbacks or alternative sign-in options for regions where Facebook is unavailable.
- Monitor token expiration and refresh logic if your app relies on long-lived sessions.
- Pair with `AuthLoggerAdapter` to capture login analytics.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)