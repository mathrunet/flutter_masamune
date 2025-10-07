<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model Firebase Remote Config</h1>
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

# Masamune Model Firebase Remote Config

## Usage

1. Add the package to your project.

```bash
flutter pub add masamune_model_firebase_remote_config
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

2. Register the adapter with your Masamune model adapters. Optionally provide default values and platform-specific Firebase options.

```dart
import 'package:masamune_model_firebase_remote_config/masamune_model_firebase_remote_config.dart';

final modelAdapters = FirebaseRemoteConfigModelAdapter(
  initialValue: {
    "feature_enabled": false,
    "api_endpoint": "https://api.example.com",
  },
  minimumFetchInterval: Duration(minutes: 30),
);
```

3. Load the remote config as a Masamune model. Fetching is handled automatically through `fetchAndActivate()` each time the adapter loads.

```dart
final config = await FirebaseRemoteConfigModel.document.load();
final enabled = config.value.get<bool>("feature_enabled");
```

4. Only read operations are supported. Saving or deleting documents with this adapter throws `UnsupportedError`. Use Firebase Console or the Remote Config REST API to update values.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)