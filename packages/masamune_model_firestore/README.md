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

1. Add the package to your Masamune project so you can leverage Firestore-backed model adapters.

```yaml
dependencies:
  masamune_model_firestore: ^latest
```

2. Annotate your models with `@CollectionModelPath` and/or `@DocumentModelPath` along with your existing Masamune/`freezed` setup. Keep the `part` directives so the generated sources compile, and refresh the generated files with your usual `katana code generate` workflow.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune/masamune.dart';
import 'package:masamune_model_firestore/masamune_model_firestore.dart';

part 'user.model.dart';

@freezed
@formValue
@immutable
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

3. Choose the adapter that fits your caching strategy, such as `CachedFirestoreModelAdapter` or `CachedListenableFirestoreModelAdapter`, and register it in your Masamune application so models read and write through Firestore while benefiting from local caching.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)