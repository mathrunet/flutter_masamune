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

3. Use filters to search and paginate data. The `like` filter sends the search keyword to Algolia, while `limitTo` controls pagination.

**Using standard filters (for exact matches, ordering, etc.)**

```dart
// In your widget or controller
final collection = appRef.model(
  UserModel.collection()
    .name.equal("John")       // Filter by exact match
    .limitTo(20),             // Limit to 20 results per page
)..load();

// Access via next() for pagination
await collection.next();
```

**Using full-text search with Algolia**

For full-text search, Algolia looks for the `like` filter in the query. The simplest way is to use models that extend `SearchableCollectionMixin`:

```dart
// Extend your collection with SearchableCollectionMixin in your model file
// Then use the search method:
final collection = appRef.model(UserModel.collection());
await collection.load();
await collection.search(keyword);  // Trigger Algolia full-text search
```

The search method automatically creates a `like` filter with the `@search` field (or your custom search field). Make sure your Algolia index includes bigram-tokenized data for the search field.

**Advanced: Direct filter usage**

If you need more control, you can use the raw filter approach by extending the generated collection query with custom filters. However, this is not the recommended approach for typical use cases.

Ensure your Algolia index stores entries containing the Masamune model `@uid` so `AlgoliaModelAdapter` can map hits back to documents.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)