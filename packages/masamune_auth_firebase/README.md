<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Auth Firebase</h1>
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

# Masamune Auth Firebase

## Usage

1. Add the plugin to your project.

```bash
flutter pub add masamune_auth_firebase
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

2. Import the package and register the Firebase Auth adapter when you configure Masamune adapters. Pass Firebase options per platform if you need to override the default configuration.

```dart
import 'package:masamune/masamune.dart';
import 'package:masamune_auth_firebase/masamune_auth_firebase.dart';

final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  const FirebaseAuthMasamuneAdapter(
    options: FirebaseOptions(
      apiKey: "YOUR_API_KEY",
      appId: "YOUR_APP_ID",
      messagingSenderId: "YOUR_SENDER_ID",
      projectId: "YOUR_PROJECT_ID",
    ),
  ),
];
```

`FirebaseAuthMasamuneAdapter` initializes Firebase and exposes `FirebaseAuthMasamuneAdapter.primary` so controllers and widgets can access the configured instance.

3. Use the provided Cloud Functions action when you need to delete a Firebase Authentication user from secure server-side code.

```dart
import 'package:masamune_functions/masamune_functions.dart';
import 'package:masamune_auth_firebase/masamune_auth_firebase.dart';

Future<void> deleteUser(String uid) async {
  final response = await FunctionsQuery
      .call(const FirebaseDeleteUserFunctionsAction(userId: uid));
  // Handle the response if necessary. An exception is thrown on failure.
}
```

The action posts `{ "userId": uid }` to your Masamune Functions endpoint and returns an empty response on success. Configure the corresponding server-side function to authenticate and delete the user via the Firebase Admin SDK.

4. Combine this package with platform-specific sign-in plugins (e.g. `masamune_auth_google`) to add authentication providers, while `masamune_auth_firebase` keeps token management consistent across your app.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)