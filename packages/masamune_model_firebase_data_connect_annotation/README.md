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

# Masamune Model Firebase Data Connect Annotation

## Overview

`masamune_model_firebase_data_connect_annotation` provides annotations for code generation with Firebase Data Connect. This is a companion package that works with the builder and runtime packages.

**Package Roles**:
- `masamune_model_firebase_data_connect_annotation` (this package) - Provides annotations
- `masamune_model_firebase_data_connect_builder` - Generates GraphQL schemas and adapters
- `masamune_model_firebase_data_connect` - Runtime adapter implementation

## Usage

This package is automatically included when you use the full Firebase Data Connect stack. Install all three packages:

```bash
flutter pub add masamune_model_firebase_data_connect
flutter pub add masamune_model_firebase_data_connect_annotation
flutter pub add --dev masamune_model_firebase_data_connect_builder
```

## Annotations

### @firebaseDataConnect

Mark models that should generate Firebase Data Connect schemas:

```dart
import 'package:masamune_model_firebase_data_connect_annotation/masamune_model_firebase_data_connect_annotation.dart';

@freezed
@formValue
@immutable
@firebaseDataConnect  // Enables Data Connect generation
@CollectionModelPath('user')
class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    @Default('') String email,
  }) = _UserModel;
  // ... rest of model
}
```

### @FirebaseDataConnectAdapter

Configure custom adapter settings:

```dart
@FirebaseDataConnectAdapter(
  connector: "my-connector",     // Connector name
  service: "my-service",         // Service name
  location: "us-central1",       // Cloud location
  outputDirectory: "firebase/dataconnect",  // Output path
)
@firebaseDataConnect
@CollectionModelPath('post')
class PostModel with _$PostModel {
  // ... model definition
}
```

## Code Generation

After annotating your models, run:

```bash
katana code generate
```

This generates:
- GraphQL schema files (`.gql`)
- Query and mutation definitions
- `connector.yaml` configuration
- `*.dataconnect.dart` adapter implementations

## For Full Documentation

See the complete Firebase Data Connect integration guide in the `masamune_model_firebase_data_connect` package.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)