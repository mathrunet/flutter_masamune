<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model Algolia</h1>
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

# Masamune Model Algolia

## Usage

1. Add the package to your project.

```bash
flutter pub add masamune_model_algolia
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

2. Combine the adapter with an existing Firestore model adapter. Algolia handles collection loading, while Firestore continues to manage mutations and document access.

```dart
import 'package:masamune_model_algolia/masamune_model_algolia.dart';
import 'package:katana_model_firestore/katana_model_firestore.dart';

final modelAdapter = AlgoliaModelAdapter(
  firestoreModelAdapter: const FirestoreModelAdapter(
    options: DefaultFirebaseOptions.currentPlatform,
  ),
  applicationId: "YOUR_ALGOLIA_APP_ID",
  apiKey: "YOUR_ALGOLIA_SEARCH_API_KEY",
);
```

3. Apply `ModelQueryFilter.like()` to send the search keyword to Algolia. Pagination relies on `limit()` and the internal page parameter.

```dart
final result = await UserModel.collection.query(
  filters: [
    ModelQueryFilter.like(UserModel.kNameKey, keyword),
    ModelQueryFilter.limit(20),
  ],
).load(adapter: algoliaAdapter);
```

Ensure your Algolia index stores entries containing the Masamune model `@uid` so `AlgoliaModelAdapter` can map hits back to documents.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)