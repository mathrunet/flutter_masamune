<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model Github</h1>
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

# Masamune Model Github

## Usage

1. Add the package to your project.

```bash
flutter pub add masamune_model_github
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

2. Provide a GitHub API token so the adapter can authenticate requests. The token should have the scopes required for the data you plan to access or mutate.

```dart
import 'package:masamune_model_github/masamune_model_github.dart';

final githubAdapter = GithubModelAdapter(
  onRetrieveToken: () async => await loadGithubToken(),
);

final masamuneAdapters = <MasamuneAdapter>[
  GithubModelMasamuneAdapter(
    modelAdapter: githubAdapter,
    appRef: appRef,
  ),
];
```

3. Load and edit GitHub resources using the generated models. Each model maps to a GitHub API entity (organization, repository, pull request, etc.).

```dart
final repos = await GithubRepositoryModel.collection
    .query(organizationId: "orgId")
    .load(adapter: githubAdapter);

final repo = GithubRepositoryModel(
  id: repos.keys.first,
  name: 'example',
  isPrivate: false,
);

await GithubRepositoryModel.document("documentId", organizationId: "orgId")
    .save(repo, adapter: githubAdapter);
```

4. Use the helper Masamune adapter (`GithubModelMasamuneAdapter`) to expose the primary instance, automatically clear caches on app restart, and share the adapter across your application.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)