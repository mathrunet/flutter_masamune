part of masamune;

/// SNS login adapter for mock.
class MockSignInAdapter extends SNSSignInAdapter {
  const MockSignInAdapter();

  /// Provider ID.
  @override
  String get provider => "mock";

  /// Sign in with sns account.
  @override
  Future<void> signIn() => Future.value();
}
