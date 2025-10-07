<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Storage Functions</h1>
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

# Masamune Storage Functions

## Usage

1. Add the package to your project.

```bash
flutter pub add masamune_storage_functions
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

2. Configure the storage adapter backed by Cloud Functions. Supply a `FunctionsAdapter` (for example, `FirebaseFunctionsAdapter`) and the Storage bucket name.

```dart
import 'package:masamune_storage_functions/masamune_storage_functions.dart';
import 'package:katana_functions_firebase/katana_functions_firebase.dart';

final functionsAdapter = FirebaseFunctionsAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  region: FirebaseRegion.usCentral1,
);

final storageAdapter = FunctionsStorageAdapter(
  functionsAdapter: functionsAdapter,
  bucketName: 'your-project.appspot.com',
);
```

3. Register the adapter with Masamune so `StorageQuery` and other storage utilities use it by default.

```dart
final masamuneAdapters = <MasamuneAdapter>[
  StorageMasamuneAdapter(adapter: storageAdapter),
];
```

4. Upload and download files through Functions. Metadata such as public/download URLs is cached automatically.

```dart
final file = await storageAdapter.uploadWithBytes(
  await File('assets/logo.png').readAsBytes(),
  'uploads/logo.png',
  mimeType: 'image/png',
);

final download = await storageAdapter.download('uploads/logo.png');
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)