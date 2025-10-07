<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Auth Google</h1>
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

# Masamune Auth Google

## Usage

`masamune_auth_google` adds Google Sign In to the Masamune/Katana authentication stack. It is intended to work alongside:

- `katana_auth` – core authentication abstractions
- `katana_auth_firebase` – optional Firebase Authentication integration
- `masamune_auth_google_firebase` – helper for exchanging Google credentials with Firebase

### Installation

Install the base packages first:

```bash
flutter pub add katana_auth
flutter pub add katana_auth_firebase
```

Then add Google support:

```bash
flutter pub add masamune_auth_google
flutter pub add masamune_auth_google_firebase
```

### Register Adapters

Configure adapters near the root of your app so Google Sign In works across the application.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const RuntimeAuthMasamuneAdapter(),
  FirebaseAuthMasamuneAdapter(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  ),

  const GoogleAuthMasamuneAdapter(
    clientId: "YOUR_GOOGLE_CLIENT_ID",
  ),
  FirebaseGoogleAuthMasamuneAdapter(
    functionsAdapter: const FunctionsMasamuneAdapter(),
  ),
];
```

Provide the appropriate `clientId` for the platform. On Android, configure the reversed client ID in the manifest; on iOS, update the URL types in `Info.plist`.

### Authenticate Users

Use `Authentication` from `katana_auth` to start the Google Sign In flow.

```dart
final auth = ref.app.controller(Authentication.query());

await auth.initialize();

await auth.signIn(GoogleAuthQuery.signIn());
```

After sign-in, the Google account information becomes available through `auth.userId`, `auth.userEmail`, and other getters.

### Firebase Integration

If you also install `masamune_auth_google_firebase`, the adapter will exchange Google credentials for Firebase tokens. Ensure your Cloud Functions endpoint (or Firebase SDK) validates the Google ID token and returns Firebase credentials.

### Platform Setup

- **Android:** Configure SHA-1 fingerprints in Google Cloud Console and add the generated configuration (`google-services.json`).
- **iOS:** Add the reversed client ID to URL schemes in `Info.plist` and include the `GoogleService-Info.plist` file.

### Tips

- Test on real devices to ensure Google Play Services or the iOS Google Sign In flow works as expected.
- Provide clear error messages if the user cancels the sign-in process.
- Combine with other providers (Apple, Facebook, etc.) using `auth.link` to support multi-provider accounts.
- Log sign-in attempts with `AuthLoggerAdapter` for analytics.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)