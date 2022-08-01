part of masamune_firebase;

/// Defines the authentication provider options.
///
/// Specify a callback that returns [FirebaseAuth] in [provider].
class AuthProviderOptions {
  /// Defines the authentication provider options.
  ///
  /// Specify a callback that returns [FirebaseAuth] in [provider].
  ///
  /// The ID of Auth can be specified in [id],
  /// and the name of Auth can be specified in [title].
  ///
  /// By specifying [provider],
  /// you can define a callback that returns [FirebaseAuth].
  ///
  /// You can specify the summary of Auth with [text].
  const AuthProviderOptions({
    required this.id,
    required this.provider,
    required this.title,
    this.text = "",
  });

  /// Provider ID.
  final String id;

  /// Callback that returns [FirebaseAuth].
  final Future<FirebaseAuthModel> Function(
    BuildContext context,
    Duration timeout,
  ) provider;

  /// Provider title.
  final String title;

  /// Description of the provider.
  final String text;
}
