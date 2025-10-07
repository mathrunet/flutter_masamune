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

# Masamune Model FirebaseDataConnect

## Usage

1. Add the packages to your Masamune project. Include the runtime package plus the annotation and builder packages so that generated adapters and GraphQL assets are produced.

```yaml
dependencies:
  masamune_model_firebase_data_connect: ^latest
  masamune_model_firebase_data_connect_annotation: ^latest

dev_dependencies:
  masamune_model_firebase_data_connect_builder: ^latest
```

2. Import the libraries and annotate your model with `@firebaseDataConnect` together with `@CollectionModelPath`/`@DocumentModelPath`. The generator relies on `freezed`/Masamune conventions, so be sure to keep the `part` directives.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';
import 'package:masamune_model_firebase_data_connect/masamune_model_firebase_data_connect.dart';
import 'package:masamune_model_firebase_data_connect_annotation/masamune_model_firebase_data_connect_annotation.dart';

part 'user.model.dart';
part 'user.dataconnect.dart';

@freezed
@formValue
@immutable
@firebaseDataConnect
@CollectionModelPath('user')
class UserModel with _$UserModel {
  const factory UserModel({
    @Default('') String name,
    @Default('') String description,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);

  static const document = _$UserModelDocumentQuery();
  static const collection = _$UserModelCollectionQuery();
}
```

3. Run the generator. Masamune projects use `katana code generate`, which wraps `build_runner` and produces GraphQL schemas, connector definitions, and the `.dataconnect.dart` adapter parts.

```bash
katana code generate
```

After the command finishes, you will find:

- `.gql` schema, query, and mutation files under the directory configured by the annotation (defaults to `firebase/dataconnect/`).
- `connector.yaml` describing the Firebase Data Connect connector.
- A generated adapter mixin in `*.dataconnect.dart`, which extends `FirebaseDataConnectModelAdapterBase` and is ready to be wired into your Masamune model layer.

4. Register or instantiate the generated adapter where you configure your models so that the runtime package can convert values to and from Firebase Data Connect.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)