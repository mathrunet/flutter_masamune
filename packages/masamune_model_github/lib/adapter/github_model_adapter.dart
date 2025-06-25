part of "/masamune_model_github.dart";

/// Model adapter with GitHub available.
///
/// Obtain [token] from the GitHub API token and provide it.
///
/// All CRUD operations are available.
///
/// GitHubを利用できるようにしたモデルアダプター。
///
/// GitHubのAPIトークンから[token]を取得して与えてください。
///
/// すべてのCRUD操作が利用できます。
class GithubModelAdapter extends ModelAdapter {
  /// Model adapter with GitHub available.
  ///
  /// Obtain [token] from the GitHub API token and provide it.
  ///
  /// All CRUD operations are available.
  ///
  /// GitHubを利用できるようにしたモデルアダプター。
  ///
  /// GitHubのAPIトークンから[token]を取得して与えてください。
  ///
  /// すべてのCRUD操作が利用できます。
  GithubModelAdapter({
    required this.token,
    this.owner,
    this.repository,
  });

  /// GitHub API token.
  ///
  /// GitHubのAPIトークン。
  final String token;

  /// Repository owner (optional).
  ///
  /// リポジトリの所有者（オプション）。
  final String? owner;

  /// Repository name (optional).
  ///
  /// リポジトリ名（オプション）。
  final String? repository;

  late final github.GitHub _github = github.GitHub(auth: github.Authentication.withToken(token));

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    final path = _parsePath(query.query.path);
    
    switch (path.collection) {
      case "issue":
        if (path.owner == null || path.repository == null || path.documentId == null) {
          throw ArgumentError("Invalid path for issue document deletion");
        }
        await _github.issues.edit(
          github.RepositorySlug(path.owner!, path.repository!),
          int.parse(path.documentId!),
          github.IssueRequest(state: "closed"),
        );
        break;
      case "pull_request":
        if (path.owner == null || path.repository == null || path.documentId == null) {
          throw ArgumentError("Invalid path for pull request document deletion");
        }
        await _github.pullRequests.edit(
          github.RepositorySlug(path.owner!, path.repository!),
          int.parse(path.documentId!),
          state: "closed",
        );
        break;
      case "repository":
        if (path.owner == null || path.documentId == null) {
          throw ArgumentError("Invalid path for repository document deletion");
        }
        await _github.repositories.deleteRepository(github.RepositorySlug(path.owner!, path.documentId!));
        break;
      default:
        throw UnsupportedError("Unsupported collection: ${path.collection}");
    }
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final path = _parsePath(query.query.path);
    
    switch (path.collection) {
      case "issue":
        if (path.owner == null || path.repository == null || path.documentId == null) {
          throw ArgumentError("Invalid path for issue document");
        }
        final issue = await _github.issues.get(
          github.RepositorySlug(path.owner!, path.repository!),
          int.parse(path.documentId!),
        );
        return _convertIssueToMap(issue);
      case "pull_request":
        if (path.owner == null || path.repository == null || path.documentId == null) {
          throw ArgumentError("Invalid path for pull request document");
        }
        final pr = await _github.pullRequests.get(
          github.RepositorySlug(path.owner!, path.repository!),
          int.parse(path.documentId!),
        );
        return _convertPullRequestToMap(pr);
      case "repository":
        if (path.owner == null || path.documentId == null) {
          throw ArgumentError("Invalid path for repository document");
        }
        final repo = await _github.repositories.getRepository(github.RepositorySlug(path.owner!, path.documentId!));
        return _convertRepositoryToMap(repo);
      default:
        throw UnsupportedError("Unsupported collection: ${path.collection}");
    }
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {}

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {}

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final path = _parsePath(query.query.path);
    final Map<String, DynamicMap> result = {};
    
    switch (path.collection) {
      case "issue":
        if (path.owner == null || path.repository == null) {
          throw ArgumentError("Invalid path for issue collection");
        }
        final issues = await _github.issues.listByRepo(
          github.RepositorySlug(path.owner!, path.repository!),
          state: "all",
        ).toList();
        for (final issue in issues) {
          result[issue.number.toString()] = _convertIssueToMap(issue);
        }
        break;
      case "pull_request":
        if (path.owner == null || path.repository == null) {
          throw ArgumentError("Invalid path for pull request collection");
        }
        final prs = await _github.pullRequests.list(
          github.RepositorySlug(path.owner!, path.repository!),
          state: "all",
        ).toList();
        for (final pr in prs) {
          result[pr.number.toString()] = _convertPullRequestToMap(pr);
        }
        break;
      case "repository":
        if (path.owner == null) {
          throw ArgumentError("Invalid path for repository collection");
        }
        final repos = await _github.repositories.listUserRepositories(path.owner!).toList();
        for (final repo in repos) {
          result[repo.name] = _convertRepositoryToMap(repo);
        }
        break;
      default:
        throw UnsupportedError("Unsupported collection: ${path.collection}");
    }
    
    return result;
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery aggregateQuery,
  ) async {
    switch (aggregateQuery.type) {
      case ModelAggregateQueryType.count:
        final collection = await loadCollection(query);
        final val = collection.length;
        if (val is! T) {
          return null;
        }
        return val as T;
      default:
        throw UnsupportedError("This aggregation function is not available.");
    }
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    final path = _parsePath(query.query.path);
    
    switch (path.collection) {
      case "issue":
        if (path.owner == null || path.repository == null) {
          throw ArgumentError("Invalid path for issue document save");
        }
        if (path.documentId == null) {
          // Create new issue
          await _github.issues.create(
            github.RepositorySlug(path.owner!, path.repository!),
            github.IssueRequest(
              title: value["title"] ?? "",
              body: value["body"] ?? "",
              labels: (value["labels"] as List?)?.cast<String>(),
            ),
          );
        } else {
          // Update existing issue
          await _github.issues.edit(
            github.RepositorySlug(path.owner!, path.repository!),
            int.parse(path.documentId!),
            github.IssueRequest(
              title: value["title"],
              body: value["body"],
              state: value["state"],
              labels: (value["labels"] as List?)?.cast<String>(),
            ),
          );
        }
        break;
      case "pull_request":
        if (path.owner == null || path.repository == null) {
          throw ArgumentError("Invalid path for pull request document save");
        }
        if (path.documentId == null) {
          // Create new pull request
          await _github.pullRequests.create(
            github.RepositorySlug(path.owner!, path.repository!),
            github.CreatePullRequest(
              value["title"] ?? "",
              value["head"] ?? "",
              value["base"] ?? "",
              body: value["body"],
            ),
          );
        } else {
          // Update existing pull request
          await _github.pullRequests.edit(
            github.RepositorySlug(path.owner!, path.repository!),
            int.parse(path.documentId!),
            title: value["title"],
            body: value["body"],
            state: value["state"],
          );
        }
        break;
      case "repository":
        // Repository creation/update is limited in GitHub API
        throw UnsupportedError("Repository save operation is not supported");
      default:
        throw UnsupportedError("Unsupported collection: ${path.collection}");
    }
  }

  @override
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("Transactions are not supported.");
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("Transactions are not supported.");
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    throw UnsupportedError("Transactions are not supported.");
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) {
    throw UnsupportedError("Transactions are not supported.");
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("Batch operations are not supported.");
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) {
    throw UnsupportedError("Batch operations are not supported.");
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    throw UnsupportedError("Batch operations are not supported.");
  }

  @override
  Future<void> clearAll() {
    // GitHub doesn't support clearing all data
    throw UnsupportedError("Clear all operation is not supported.");
  }

  @override
  Future<void> clearCache() async {
    // No cache to clear
  }

  _GitHubPath _parsePath(String path) {
    final trimmedPath = path.trimQuery().trimString("/");
    final parts = trimmedPath.split("/");
    
    if (parts.isEmpty) {
      throw ArgumentError("Invalid path format");
    }
    
    final collection = parts[0];
    String? pathOwner = owner;
    String? pathRepository = repository;
    String? documentId;
    
    // Parse path based on collection type
    switch (collection) {
      case "issue":
      case "pull_request":
        if (parts.length >= 3) {
          pathOwner = parts[1];
          pathRepository = parts[2];
          if (parts.length >= 4) {
            documentId = parts[3];
          }
        } else if (parts.length == 2) {
          documentId = parts[1];
        }
        break;
      case "repository":
        if (parts.length >= 2) {
          pathOwner = parts[1];
          if (parts.length >= 3) {
            documentId = parts[2];
          }
        }
        break;
    }
    
    return _GitHubPath(
      collection: collection,
      owner: pathOwner,
      repository: pathRepository,
      documentId: documentId,
    );
  }

  DynamicMap _convertIssueToMap(github.Issue issue) {
    return {
      kUidFieldKey: issue.number.toString(),
      "id": issue.id,
      "number": issue.number,
      "title": issue.title,
      "body": issue.body,
      "state": issue.state,
      "user": {
        "id": issue.user?.id,
        "login": issue.user?.login,
        "avatar_url": issue.user?.avatarUrl,
      },
      "labels": issue.labels.map((label) => {
        "name": label.name,
        "color": label.color,
      }).toList(),
      "created_at": issue.createdAt?.toIso8601String(),
      "updated_at": issue.updatedAt?.toIso8601String(),
      "closed_at": issue.closedAt?.toIso8601String(),
    };
  }

  DynamicMap _convertPullRequestToMap(github.PullRequest pr) {
    return {
      kUidFieldKey: pr.number.toString(),
      "id": pr.id,
      "number": pr.number,
      "title": pr.title,
      "body": pr.body,
      "state": pr.state,
      "user": {
        "id": pr.user?.id,
        "login": pr.user?.login,
        "avatar_url": pr.user?.avatarUrl,
      },
      "head": {
        "ref": pr.head?.ref,
        "sha": pr.head?.sha,
      },
      "base": {
        "ref": pr.base?.ref,
        "sha": pr.base?.sha,
      },
      "created_at": pr.createdAt?.toIso8601String(),
      "updated_at": pr.updatedAt?.toIso8601String(),
      "merged_at": pr.mergedAt?.toIso8601String(),
    };
  }

  DynamicMap _convertRepositoryToMap(github.Repository repo) {
    return {
      kUidFieldKey: repo.name,
      "id": repo.id,
      "name": repo.name,
      "full_name": repo.fullName,
      "description": repo.description,
      "private": repo.isPrivate,
      "html_url": repo.htmlUrl,
      "clone_url": repo.cloneUrl,
      "ssh_url": repo.sshUrl,
      "owner": {
        "id": repo.owner?.id,
        "login": repo.owner?.login,
        "avatar_url": repo.owner?.avatarUrl,
      },
      "default_branch": repo.defaultBranch,
      "language": repo.language,
      "stargazers_count": repo.stargazersCount,
      "forks_count": repo.forksCount,
      "open_issues_count": repo.openIssuesCount,
      "created_at": repo.createdAt?.toIso8601String(),
      "updated_at": repo.updatedAt?.toIso8601String(),
      "pushed_at": repo.pushedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return token.hashCode ^ owner.hashCode ^ repository.hashCode;
  }
}

@immutable
class _GitHubPath {
  const _GitHubPath({
    required this.collection,
    this.owner,
    this.repository,
    this.documentId,
  });

  final String collection;
  final String? owner;
  final String? repository;
  final String? documentId;
}
