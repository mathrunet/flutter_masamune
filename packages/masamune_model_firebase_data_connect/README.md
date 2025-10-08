<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model FirebaseDataConnect</h1>
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

# Masamune Model Firebase Data Connect

## Overview

`masamune_model_firebase_data_connect` provides Firebase Data Connect integration for Masamune models. Use GraphQL-powered data access with automatic schema generation from your Dart models.

**Package Roles**:
- `masamune_model_firebase_data_connect` (this package) - Runtime adapter and converters
- `masamune_model_firebase_data_connect_annotation` - Annotations (`@firebaseDataConnect`)
- `masamune_model_firebase_data_connect_builder` - Code generator

## Usage

### Installation

```bash
flutter pub add masamune_model_firebase_data_connect
flutter pub add masamune_model_firebase_data_connect_annotation
flutter pub add --dev masamune_model_firebase_data_connect_builder
```

### Annotate Models

Add `@firebaseDataConnect` and permission settings to your Masamune models:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';
import 'package:masamune_model_firebase_data_connect_annotation/masamune_model_firebase_data_connect_annotation.dart';

part 'user.m.dart';
part 'user.g.dart';
part 'user.freezed.dart';
part 'user.dataconnect.dart';  // Generated

@freezed
@formValue
@immutable
@firebaseDataConnect  // Enable Data Connect
@CollectionModelPath(
  'user',
  permission: [
    AllowReadModelPermissionQuery.allUsers(),   // All users can read
    AllowWriteModelPermissionQuery.allUsers(),  // All users can write
  ],
)
class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    @Default('') String email,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);

  static const document = _$UserModelDocumentQuery();
  static const collection = _$UserModelCollectionQuery();
}
```

### Generate GraphQL Schema

Run the code generator:

```bash
katana code generate
```

This generates:
- GraphQL schema, queries, and mutations in `firebase/dataconnect/`
- `connector.yaml` configuration
- `*.dataconnect.dart` adapter implementation

### Register the Adapter

Configure the Firebase Data Connect adapter in your app:

```dart
// lib/main.dart

import 'package:masamune_model_firebase_data_connect/masamune_model_firebase_data_connect.dart';

final modelAdapter = FirebaseDataConnectModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  connectorId: "default",  // Your connector ID
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

### Use Your Models

Use models with Firebase Data Connect just like other Masamune models:

```dart
class UserListPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final users = ref.app.model(UserModel.collection())..load();

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index].value;
        return ListTile(
          title: Text(user?.name ?? ''),
          subtitle: Text(user?.email ?? ''),
        );
      },
    );
  }
}
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

### Deploy to Firebase

Deploy generated files to Firebase Data Connect:

```bash
firebase deploy --only dataconnect
```

### Field Value Converters

The package includes converters for Masamune field types:
- `ModelTimestamp` / `ModelTimestampRange`
- `ModelDate` / `ModelDateRange` / `ModelTime` / `ModelTimeRange`
- `ModelUri` / `ModelImageUri` / `ModelVideoUri`
- `ModelRef` (references)
- `ModelGeoValue` (geographic coordinates)
- `ModelCounter` / `ModelToken`
- `ModelLocale` / `ModelLocalizedValue`
- And more...

These are automatically applied during schema generation and data conversion.

### Tips

- Annotate all models you want to sync with Data Connect
- Run `katana code generate` after model changes
- Review generated GraphQL before deploying
- Use Firebase Data Connect Studio to test queries
- Monitor query performance in Firebase Console

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)