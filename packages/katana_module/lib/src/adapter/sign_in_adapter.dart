part of katana_module;

/// Abstract class for creating adapters for sign-in.
@immutable
abstract class SignInAdapter extends AdapterModule {
  const SignInAdapter();

  /// Provider ID.
  String get provider;

  /// If `true`, display.
  bool get visible => true;

  /// Sign in with sns account.
  Future<void> signIn();

  /// Sign out with sns account.
  Future<void> signOut();
}
