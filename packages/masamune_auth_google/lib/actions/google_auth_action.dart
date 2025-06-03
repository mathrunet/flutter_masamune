part of "/masamune_auth_google.dart";

/// [AuthAction] for Google.
///
/// Google用の[AuthAction]。
class GoogleAuthAction extends AuthAction {
  /// [AuthAction] for Google.
  ///
  /// Google用の[AuthAction]。
  const GoogleAuthAction();

  @override
  Future<void> onSignOut() async {
    final google = GoogleSignIn();
    await google.signOut();
  }
}
