<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model Firestore</h1>
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

# Masamune Model Firestore

## Usage

### Installation

1. Add the package to your project.

```bash
flutter pub add masamune_model_firestore
```

### Model Definition

2. Define your models using standard Masamune annotations. Use `katana code collection` or `katana code document` to generate model templates.

```dart
// lib/models/user.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';

part 'user.m.dart';
part 'user.g.dart';
part 'user.freezed.dart';

@freezed
@formValue
@immutable
@CollectionModelPath('user')
class UserModel with _$UserModel {
  const factory UserModel({
    @Default('') String name,
    @Default('') String email,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);

  static const document = _$UserModelDocumentQuery();
  static const collection = _$UserModelCollectionQuery();
  static const form = _$UserModelFormQuery();
}
```

3. Generate the code with:

```bash
katana code generate
```

### Adapter Configuration

4. Choose an adapter that fits your caching strategy and register it in your app:

**CachedFirestoreModelAdapter** (With local cache):

```dart
// lib/main.dart

import 'package:masamune_model_firestore/masamune_model_firestore.dart';

final modelAdapter = CachedFirestoreModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
);

void main() {
  runMasamuneApp(
    appRef: appRef,
    modelAdapter: modelAdapter,
    (appRef, _) => MasamuneApp(
      appRef: appRef,
      home: HomePage(),
    ),
  );
}
```

**CachedListenableFirestoreModelAdapter** (With real-time updates):

```dart
final modelAdapter = CachedListenableFirestoreModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  listenOnlyWhenWatching: true,  // Listen only when document/collection is watched
);
```

### Basic Operations

**Load a Collection**:

```dart
final collection = ref.app.model(UserModel.collection())..load();

// Access users
for (final doc in collection) {
  print("User: ${doc.value?.name}");
}
```

**Load a Document**:

```dart
final document = ref.app.model(UserModel.document("user_id"))..load();
print("Name: ${document.value?.name}");
```

**Create/Update**:

```dart
final collection = ref.app.model(UserModel.collection());
final newDoc = collection.create();
await newDoc.save(
  UserModel(
    name: "John Doe",
    email: "john@example.com",
  ),
);
```

**Delete**:

```dart
await document.delete();
```

### Filtering and Pagination

Use generated filter methods for querying:

```dart
final users = ref.app.model(
  UserModel.collection()
    .name.equal("John")
    .createdAt.greaterThan(ModelTimestamp.now().subtract(Duration(days: 7)))
    .limitTo(20),
)..load();

// Load next page
await users.next();
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)