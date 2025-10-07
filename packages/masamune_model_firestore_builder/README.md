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

# Masamune Model Firestore Builder

## Usage

### Installation

1. Add the builder as a development dependency alongside the runtime package.

```yaml
dependencies:
  katana_model_firestore: ^latest

dev_dependencies:
  masamune_model_firestore_builder: ^latest
  build_runner: ^latest
```

### Generate Firestore Rules and Indexes

2. Annotate your models with `@CollectionModelPath` and/or `@DocumentModelPath`:

```dart
// lib/models/user.dart

@freezed
@formValue
@immutable
@CollectionModelPath('user')
class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    @Default('') String email,
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
  }) = _UserModel;
  // ... rest of the model
}
```

3. Run the code generator:

```bash
katana code generate
```

This generates:
- `firebase/firestore.rules` - Security rules based on your model structure
- `firebase/firestore.indexes.json` - Composite indexes for your queries

### Generated Files

**firestore.rules**: Contains security rules like:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user/{userId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**firestore.indexes.json**: Contains index definitions for complex queries:

```json
{
  "indexes": [
    {
      "collectionGroup": "user",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "createdAt", "order": "DESCENDING"},
        {"fieldPath": "name", "order": "ASCENDING"}
      ]
    }
  ]
}
```

### Deploy to Firebase

4. Deploy the generated rules and indexes to your Firebase project:

```bash
# Deploy both rules and indexes
firebase deploy --only firestore:rules,firestore:indexes

# Or deploy individually
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

### Customize Generation

Configure output paths in `build.yaml`:

```yaml
targets:
  $default:
    builders:
      masamune_model_firestore_builder:
        options:
          output_dir: "firebase"  # Default output directory
```

### Tips

- Run `katana code generate` after any model changes to keep rules synchronized
- Review generated rules before deploying to production
- Add custom rules in the Firebase Console if needed (they won't be overwritten)
- Use `firebase deploy --only firestore:rules` for quick rule updates during development

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)