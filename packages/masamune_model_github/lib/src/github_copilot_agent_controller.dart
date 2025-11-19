part of "/masamune_model_github.dart";

/// Controller for the Copilot agent.
///
/// Reads the repository status in [load], and checks the usage status of Copilot and the existence of instruction files.
///
/// If instruction files do not exist, they are created with [saveInstructions].
///
/// Copilotエージェントのコントローラー。
///
/// [load]でレポジトリの状況を読み取り、Copilotの利用状況およびインストラクションファイルの存在を確認します。
///
/// インストラクションファイルがない場合は[saveInstructions]で作成します。
class GithubCopilotAgentController
    extends MasamuneControllerBase<String?, GithubModelMasamuneAdapter> {
  /// Controller for the Copilot agent.
  ///
  /// Reads the repository status in [load], and checks the usage status of Copilot and the existence of instruction files.
  ///
  /// If instruction files do not exist, they are created with [saveInstructions].
  ///
  /// Copilotエージェントのコントローラー。
  ///
  /// [load]でレポジトリの状況を読み取り、Copilotの利用状況およびインストラクションファイルの存在を確認します。
  ///
  /// インストラクションファイルがない場合は[saveInstructions]で作成します。
  GithubCopilotAgentController({
    required this.organizationId,
    required this.repositoryId,
    super.adapter,
  }) {
    load();
  }

  /// Query for GithubCopilotAgentController.
  ///
  /// ```dart
  /// appRef.controller(GithubCopilotAgentController.query(parameters));     // Get from application scope.
  /// ref.app.controller(GithubCopilotAgentController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(GithubCopilotAgentController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$GithubCopilotAgentControllerQuery();

  @override
  GithubModelMasamuneAdapter get primaryAdapter =>
      GithubModelMasamuneAdapter.primary;

  @override
  String? get value => _currentInstructions;
  String? _currentInstructions;

  /// Instructions file name.
  static String get instructionsFileName => _instructionsFileName;

  static const _instructionsFileName = "copilot-instructions.md";
  static const _instructionsDirectory = ".github";
  static const _githubApiBase = "https://api.github.com";

  /// Organization ID.
  final String organizationId;

  /// Repository ID.
  final String repositoryId;

  /// Whether the controller is loaded.
  bool get loaded => _loaded;
  bool _loaded = false;

  /// Future for loading the controller.
  Future<void>? get loading => _loadCompleter?.future;
  Completer<void>? _loadCompleter;

  /// Future for saving the instructions.
  Future<bool>? get saving => _saveCompleter?.future;
  Completer<bool>? _saveCompleter;

  /// Whether the instructions file exists.
  bool get hasInstructions => _instructionsSha != null;
  String? _instructionsSha;

  /// Whether the Copilot agent is available.
  bool get copilotAgentAvailable => _copilotAgentId != null;
  String? _copilotAgentId;

  /// Repository model.
  late final GithubRepositoryModelDocument repository = adapter.appRef.model(
    GithubRepositoryModel.document(
      repositoryId,
      organizationId: organizationId,
    ),
  );

  /// Reads the repository status, checks Copilot usage, and the existence of instruction files.
  ///
  /// レポジトリの状況を読み取り、Copilotの利用状況およびインストラクションファイルの存在を確認します。
  Future<void> load() async {
    if (_loaded) {
      return;
    }
    if (_loadCompleter != null) {
      return _loadCompleter?.future;
    }
    _loadCompleter = Completer<void>();
    try {
      await repository.load(reloadOnce: true);
      await _checkCopilotAgent();
      await _checkInstructionsFile();
      _loaded = true;
      notifyListeners();
      _loadCompleter?.complete();
      _loadCompleter = null;
    } catch (error) {
      _loadCompleter?.completeError(error);
      _loadCompleter = null;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
  }

  /// Reread the repository status, and check the Copilot usage status and the existence of the instruction file.
  ///
  /// レポジトリの状況を再度読み取り、Copilotの利用状況およびインストラクションファイルの存在を確認します。
  Future<void> reload() async {
    _loaded = false;
    await load();
  }

  // Future<void> createIssueWithCopilot({
  //   required String title,
  //   String? body,
  // }) async {
  //   if (!copilotAgentAvailable) {
  //     throw Exception("Copilot agent is unavailable.");
  //   }
  //   final token = await GithubModelMasamuneAdapter.primary.getAccessToken();
  //   if (token == null) {
  //     throw Exception("GitHub credentials not found.");
  //   }

  //   // GraphQL mutation for Issue creation with Copilot assignment
  //   final repoId = _getRepositoryId();
  //   const mutation = """
  //     mutation CreateIssue(\$repositoryId: ID!, \$title: String!, \$body: String, \$assigneeIds: [ID!]) {
  //       createIssue(input: {
  //         repositoryId: \$repositoryId,
  //         title: \$title,
  //         body: \$body,
  //         assigneeIds: \$assigneeIds
  //       }) {
  //         issue {
  //           id
  //           number
  //           title
  //           url
  //         }
  //       }
  //     }
  //   """;

  //   final response = await _graphqlRequest(
  //     query: mutation,
  //     variables: {
  //       "repositoryId": repoId,
  //       "title": title,
  //       "body": body ?? "",
  //       "assigneeIds": [_copilotAgentId],
  //     },
  //   );

  //   final errors = response["errors"] as List?;
  //   if (errors != null && errors.isNotEmpty) {
  //     throw Exception("Issueの作成に失敗しました: ${errors.first["message"]}");
  //   }
  // }

  Future<void> _checkCopilotAgent() async {
    final token = await GithubModelMasamuneAdapter.primary.getAccessToken();
    if (token == null) {
      throw Exception("GitHub credentials not found.");
    }

    // GraphQL query to check if Copilot agent is available
    final query = """
      query GetCopilotAgent {
        repository(owner: "$organizationId", name: "$repositoryId") {
          suggestedActors(capabilities: [CAN_BE_ASSIGNED], first: 100) {
            nodes {
              login
              __typename
              ... on Bot {
                id
              }
            }
          }
        }
      }
    """;

    try {
      final response = await _graphqlRequest(query: query);
      final nodes = response["data"]?["repository"]?["suggestedActors"]
          ?["nodes"] as List?;
      if (nodes != null) {
        for (final node in nodes) {
          if (node["login"] == "copilot-swe-agent" &&
              node["__typename"] == "Bot") {
            _copilotAgentId = node["id"] as String?;
            break;
          }
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _checkInstructionsFile() async {
    final token = await GithubModelMasamuneAdapter.primary.getAccessToken();
    if (token == null) {
      throw Exception("GitHub credentials not found.");
    }
    _instructionsSha = null;
    _currentInstructions = null;

    final client = GitHub(auth: git_hub.Authentication.withToken(token));
    try {
      final defaultBranch = repository.value?.masterBranch?.fromUrlEncode();
      final contents = await client.repositories.getContents(
        RepositorySlug(organizationId, repositoryId),
        "$_instructionsDirectory/$_instructionsFileName",
        ref: defaultBranch ?? "main",
      );
      final file = contents.file;
      if (file != null) {
        _instructionsSha = file.sha;
        final content = file.content ?? "";
        _currentInstructions = utf8.decode(
          base64Decode(content.replaceAll("\n", "")),
        );
      }
    } catch (error) {
      // ファイルが存在しない場合は無視
      if (!error.toString().contains("404")) {
        return;
      }
      rethrow;
    } finally {
      client.dispose();
    }
  }

  /// Saves the instruction file.
  ///
  /// [content] - The content of the instruction file.
  /// [force] - Whether to overwrite the instruction file if it exists.
  ///
  /// インストラクションファイルを保存します。
  ///
  /// [content] - インストラクションファイルの内容。
  /// [force] - インストラクションファイルが存在する場合に上書きするかどうか。
  Future<bool> saveInstructions({
    required String content,
    bool force = false,
  }) async {
    if (_saveCompleter != null) {
      return await _saveCompleter?.future ?? false;
    }
    if (content.trim().isEmpty) {
      throw Exception("Prompt is empty.");
    }
    if (!force && hasInstructions) {
      debugPrint(
        ".github/$_instructionsFileName already exists. Please confirm overwrite if you wish to continue.",
      );
      notifyListeners();
      return false;
    }
    await load();
    _saveCompleter = Completer<bool>();
    try {
      await _upsertInstructionsFile(content: content);
      _currentInstructions = content;
      notifyListeners();
      _saveCompleter?.complete(true);
      _saveCompleter = null;
      return true;
    } catch (error) {
      _saveCompleter?.completeError(error);
      _saveCompleter = null;
      rethrow;
    } finally {
      _saveCompleter?.complete(true);
      _saveCompleter = null;
    }
  }

  Future<void> _upsertInstructionsFile({required String content}) async {
    final token = await GithubModelMasamuneAdapter.primary.getAccessToken();
    if (token == null) {
      throw Exception("GitHub credentials not found.");
    }

    final client = GitHub(auth: git_hub.Authentication.withToken(token));
    try {
      final defaultBranch = repository.value?.masterBranch?.fromUrlEncode();
      const path = "$_instructionsDirectory/$_instructionsFileName";
      final message = hasInstructions
          ? "chore: Update Copilot instructions"
          : "chore: Add Copilot instructions";

      final sha = _instructionsSha;
      if (sha != null) {
        // Update existing file
        final result = await client.repositories.updateFile(
          RepositorySlug(organizationId, repositoryId),
          path,
          message,
          base64Encode(utf8.encode(content)),
          sha,
          branch: defaultBranch ?? "main",
        );
        _instructionsSha = result.content?.sha;
      } else {
        // Create new file
        final result = await client.repositories.createFile(
          RepositorySlug(organizationId, repositoryId),
          CreateFile(
            path: path,
            message: message,
            content: base64Encode(utf8.encode(content)),
            branch: defaultBranch ?? "main",
          ),
        );
        _instructionsSha = result.content?.sha;
      }
    } finally {
      client.dispose();
    }
  }

  Future<DynamicMap> _graphqlRequest({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    final token = await GithubModelMasamuneAdapter.primary.getAccessToken();
    if (token == null) {
      throw Exception("GitHub credentials not found.");
    }

    final response = await Api.post(
      "$_githubApiBase/graphql",
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "X-GitHub-Api-Version": adapter.githubCopilotApiVersion,
      },
      body: jsonEncode({
        "query": query,
        if (variables != null) "variables": variables,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        "GitHub GraphQL API Error: (${response.statusCode}): ${response.body}",
      );
    }

    return jsonDecodeAsMap(response.body);
  }
}

@immutable
class _$GithubCopilotAgentControllerQuery {
  const _$GithubCopilotAgentControllerQuery();

  @useResult
  _$_GithubCopilotAgentControllerQuery call({
    required String organizationId,
    required String repositoryId,
    GithubModelMasamuneAdapter? adapter,
  }) =>
      _$_GithubCopilotAgentControllerQuery(
        "$organizationId/$repositoryId",
        organizationId: organizationId,
        repositoryId: repositoryId,
        adapter: adapter,
      );
}

@immutable
class _$_GithubCopilotAgentControllerQuery
    extends ControllerQueryBase<GithubCopilotAgentController> {
  const _$_GithubCopilotAgentControllerQuery(
    this._name, {
    required this.organizationId,
    required this.repositoryId,
    this.adapter,
  });

  final String _name;

  final String organizationId;
  final String repositoryId;

  final GithubModelMasamuneAdapter? adapter;

  @override
  GithubCopilotAgentController Function() call(Ref ref) {
    return () => GithubCopilotAgentController(
          organizationId: organizationId,
          repositoryId: repositoryId,
          adapter: adapter,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
