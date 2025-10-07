<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model Functions</h1>
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

# Masamune Model Functions

## Usage

1. Add the package to your project.

```bash
flutter pub add masamune_model_functions
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

2. Register the adapter with your Masamune model adapters. Supply a configured `FunctionsAdapter` that knows how to contact your backend (e.g. Firebase Functions, Cloud Run).

```dart
import 'package:masamune_model_functions/masamune_model_functions.dart';
import 'package:katana_functions_firebase/katana_functions_firebase.dart';

final functions = FirebaseFunctionsAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  region: FirebaseRegion.asiaNortheast1
);

final modelAdapters = FunctionsModelAdapter(functionsAdapter: functions);
```

3. Execute Masamune model operations as usual. Reads and writes are proxied through the configured Functions endpoints.

```dart
await UserModel.collection.save(
  const UserModel(id: 'user_123', name: 'Masamune'),
  adapter: modelAdapters.first,
);

final users = await UserModel.collection.load(adapter: modelAdapters.first);
```

4. Customize the action names (`documentAction`, `collectionAction`, `aggregateAction`) if your Functions expect different identifiers.

```dart
final adapter = FunctionsModelAdapter(
  functionsAdapter: functions,
  documentAction: 'document_model_custom',
  collectionAction: 'collection_model_custom',
  aggregateAction: 'aggregate_model_custom',
);
```

5. Aggregations are available via `ModelAggregateQuery`. Ensure your server action returns numeric values that can be cast to the requested type.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)