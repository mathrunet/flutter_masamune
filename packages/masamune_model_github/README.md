<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model GitHub</h1>
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

# Masamune Model GitHub

## Usage

### Installation

1. Add the package to your project.

```bash
flutter pub add masamune_model_github
```

### Setup

2. Create a GitHub API token and configure the adapter. The token should have the scopes required for the data you plan to access or mutate.

```dart
// lib/main.dart

import 'package:masamune_model_github/masamune_model_github.dart';

final githubAdapter = GithubModelAdapter(
  onRetrieveToken: () async {
    // Return your GitHub personal access token
    // Store securely using environment variables or secret storage
    return String.fromEnvironment("GITHUB_TOKEN");
  },
);

final masamuneAdapters = <MasamuneAdapter>[
  GithubModelMasamuneAdapter(
    modelAdapter: githubAdapter,
    appRef: appRef,
  ),
];

void main() {
  runMasamuneApp(
    appRef: appRef,
    modelAdapter: githubAdapter,
    masamuneAdapters: masamuneAdapters,
    (appRef, _) => MasamuneApp(
      appRef: appRef,
      home: HomePage(),
    ),
  );
}
```

### Available Models

The package provides pre-built models for GitHub API entities:

- `GithubRepositoryModel` - Repositories
- `GithubIssueModel` - Issues
- `GithubPullRequestModel` - Pull requests
- `GithubUserModel` - Users
- `GithubOrganizationModel` - Organizations
- `GithubCommitModel` - Commits
- `GithubBranchModel` - Branches
- `GithubContentModel` - Repository contents
- `GithubLabelModel` - Labels
- `GithubMilestoneModel` - Milestones
- `GithubProjectModel` - Projects

### Load GitHub Data

3. Load GitHub resources using the generated models:

```dart
class RepositoriesPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    // Load repositories for an organization
    final repos = ref.app.model(
      GithubRepositoryModel.collection(organizationId: "flutter"),
    )..load();

    return ListView.builder(
      itemCount: repos.length,
      itemBuilder: (context, index) {
        final repo = repos[index].value;
        return ListTile(
          title: Text(repo?.name ?? ''),
          subtitle: Text(repo?.description ?? ''),
          trailing: Text('⭐ ${repo?.stargazersCount ?? 0}'),
        );
      },
    );
  }
}
```

### Load Issues and Pull Requests

```dart
// Load issues for a repository
final issues = ref.app.model(
  GithubIssueModel.collection(
    organizationId: "flutter",
    repositoryId: "flutter",
  ),
)..load();

// Load pull requests
final pullRequests = ref.app.model(
  GithubPullRequestModel.collection(
    organizationId: "flutter",
    repositoryId: "flutter",
  ),
)..load();
```

### Create/Update GitHub Resources

```dart
// Create a new issue
final issueCollection = ref.app.model(
  GithubIssueModel.collection(
    organizationId: "myorg",
    repositoryId: "myrepo",
  ),
);

final newIssue = issueCollection.create();
await newIssue.save(
  GithubIssueModel(
    title: 'Bug Report',
    body: 'Description of the bug...',
    labels: ['bug', 'high-priority'],
  ),
);
```

### GitHub Token Setup

Create a Personal Access Token at [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens).

Required scopes depend on your use case:
- `repo` - Full control of private repositories
- `public_repo` - Access public repositories
- `read:org` - Read org and team membership
- `user` - Read user profile data

Store the token securely:

```bash
# Set as environment variable
export GITHUB_TOKEN="ghp_your_token_here"

# Or use --dart-define
flutter run --dart-define=GITHUB_TOKEN=ghp_your_token_here
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)