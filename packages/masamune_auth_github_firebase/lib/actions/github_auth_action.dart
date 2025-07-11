part of "/masamune_auth_github_firebase.dart";

/// [AuthAction] for Github.
///
/// Github用の[AuthAction]。
class GithubAuthAction extends AuthAction {
  /// [AuthAction] for Github.
  ///
  /// Github用の[AuthAction]。
  const GithubAuthAction();

  @override
  Future<void> onSignOut() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_kGitHubAccessTokenKey.toSHA1());
  }
}
