<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model Docs Builder</h1>
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

# Masamune Model Docs Builder

## Usage

### Installation

1. Add the builder as a development dependency.

```yaml
dev_dependencies:
  masamune_model_docs_builder: ^latest
  build_runner: ^latest
```

### Generate Documentation

2. Annotate your models with standard Masamune annotations:

```dart
// lib/models/user.dart

@freezed
@formValue
@immutable
@CollectionModelPath('user')
class UserModel with _$UserModel {
  const factory UserModel({
    /// User's display name
    required String name,
    
    /// User's email address
    @Default('') String email,
    
    /// Timestamp when the user was created
    @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
  }) = _UserModel;
  // ... rest of the model
}
```

3. Run the code generator:

```bash
katana code generate
```

This generates Markdown documentation files in `docs/model/` with:
- Model name and type (Collection/Document)
- Field names, types, and descriptions
- Default values and constraints

### Generated Documentation Example

The builder creates files like `docs/model/user.md`:

```markdown
# UserModel

Type: Collection
Path: `user`

## Fields

| Field Name | Type | Required | Default | Description |
|------------|------|----------|---------|-------------|
| name | String | Yes | - | User's display name |
| email | String | No | '' | User's email address |
| createdAt | ModelTimestamp | No | now() | Timestamp when the user was created |
```

### Customize Output

Configure the output directory in `build.yaml`:

```yaml
targets:
  $default:
    builders:
      masamune_model_docs_builder:
        options:
          output_dir: "docs/model"  # Default output directory
```

### Use Cases

- **Team Documentation**: Keep database schemas documented and in sync with code
- **API Documentation**: Generate reference docs for your backend API
- **Onboarding**: Help new developers understand data models
- **Version Control**: Track schema changes over time in git history

### Tips

- Run `katana code generate` after model changes to update docs
- Commit generated docs to version control
- Use detailed Dart doc comments on fields for better documentation
- Integrate with your CI/CD to ensure docs stay up-to-date

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)