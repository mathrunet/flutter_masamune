part of "/masamune_model_github.dart";

/// Controller for the user of GitHub.
///
/// ユーザーのGitHubのコントローラー。
class GithubUserController extends MasamuneControllerBase<GithubUserModel?,
    GithubModelMasamuneAdapter> {
  /// Controller for the user of GitHub.
  ///
  /// ユーザーのGitHubのコントローラー。
  GithubUserController({super.adapter});

  /// Query for GithubUserController.
  ///
  /// ```dart
  /// appRef.controller(GithubUserController.query(parameters));     // Get from application scope.
  /// ref.app.controller(GithubUserController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(GithubUserController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$GithubUserControllerQuery();

  @override
  GithubUserModel? get value => _value;
  GithubUserModel? _value;

  /// Returns the UID of the user.
  ///
  /// ユーザーのUIDを返します。
  String? get uid => _value?.login;

  /// Returns the name of the user.

  @override
  GithubModelMasamuneAdapter get primaryAdapter =>
      GithubModelMasamuneAdapter.primary;

  /// Returns [Future] if loading is being performed.
  ///
  /// ロードを行っている場合に[Future]を返します。
  Future<void>? get loading => _loadingCompleter?.future;
  Completer<void>? _loadingCompleter;
  bool _loaded = false;

  /// Returns the organizations of the user.
  ///
  /// ユーザーの組織を返します。
  GithubOrganizationModelCollection? get organizations => _organizations;
  GithubOrganizationModelCollection? _organizations;

  /// Returns the current organization of the user.
  ///
  /// ユーザーの現在の組織を返します。
  GithubOrganizationModelDocument? get currentOrganization {
    if (_organizations.isEmpty) {
      return null;
    }
    _currentOrganization ??= _organizations?.firstOrNull;
    return _currentOrganization;
  }

  GithubOrganizationModelDocument? _currentOrganization;

  /// Returns the current organization slug.
  ///
  /// 現在の組織のスラッグを返します。
  String? get currentOrganizationSlug {
    if (currentOrganization == null) {
      return uid;
    }
    return currentOrganization?.uid ?? uid;
  }

  /// Returns the repositories of the user.

  /// Loads the user.
  ///
  /// ユーザーをロードします。
  Future<void> load() async {
    if (_loadingCompleter != null) {
      return _loadingCompleter?.future;
    }
    if (_loaded) {
      return;
    }

    _loadingCompleter = Completer<void>();
    try {
      final adapter = this.adapter.modelAdapter;
      if (adapter is GithubModelAdapter) {
        final github = await adapter._getInstance();
        final user = await github.users.getCurrentUser();
        _value = user.toGithubUserModel();
      } else {
        final authAdapter = this.adapter.debugAuthDapter;
        final userId = authAdapter?.userId;
        if (userId == null) {
          throw Exception("User ID is not set.");
        }
        final value =
            this.adapter.appRef.model(GithubUserModel.document(userId));
        await value.load();
        _value = value.value;
      }
      _organizations ??=
          this.adapter.appRef.model(GithubOrganizationModel.collection());
      await _organizations?.reload();
      _loaded = true;
      notifyListeners();
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    } catch (e) {
      _loadingCompleter?.completeError(e);
      _loadingCompleter = null;
      rethrow;
    } finally {
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    }
  }

  /// Reloads the user.
  ///
  /// ユーザーを再ロードします。
  Future<void> reload() async {
    _loaded = false;
    await load();
  }

  /// Selects the organization.
  ///
  /// 組織を選択します。
  void selectOrganization(GithubOrganizationModelDocument organization) {
    _currentOrganization = organization;
    notifyListeners();
  }
}

@immutable
class _$GithubUserControllerQuery {
  const _$GithubUserControllerQuery();

  @useResult
  _$_GithubUserControllerQuery call({GithubModelMasamuneAdapter? adapter}) =>
      _$_GithubUserControllerQuery(
        hashCode.toString(),
        adapter: adapter,
      );
}

@immutable
class _$_GithubUserControllerQuery
    extends ControllerQueryBase<GithubUserController> {
  const _$_GithubUserControllerQuery(this._name, {this.adapter});

  final String _name;

  final GithubModelMasamuneAdapter? adapter;

  @override
  GithubUserController Function() call(Ref ref) {
    return () => GithubUserController(adapter: adapter);
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
