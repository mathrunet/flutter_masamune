part of masamune;

/// SNS login adapter for mock.
class MockSignInAdapter extends SignInAdapter {
  const MockSignInAdapter({
    this.visible = true,
  });

  /// Provider ID.
  @override
  String get provider => "mock";

  /// If `true`, display.
  @override
  final bool visible;

  /// Sign in with sns account.
  @override
  Future<void> signIn() => Future.value();

  /// Sign out with sns account.
  @override
  Future<void> signOut() => Future.value();
}
