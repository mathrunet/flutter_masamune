part of katana_auth;

/// Interface that represents the credentials returned by an auth provider.
/// Implementations specify the details about each auth provider's credential
/// requirements.
///
/// 認証プロバイダーによって返される資格情報を表すインターフェイス。
/// 実装では、各認証プロバイダーの資格情報要件の詳細を指定します。
class Credential {
  /// Interface that represents the credentials returned by an auth provider.
  /// Implementations specify the details about each auth provider's credential
  /// requirements.
  ///
  /// 認証プロバイダーによって返される資格情報を表すインターフェイス。
  /// 実装では、各認証プロバイダーの資格情報要件の詳細を指定します。
  // ignore: public_member_api_docs
  @protected
  const Credential({
    required this.providerId,
    this.signInMethod = "oauth",
    this.token,
    this.accessToken,
    this.secret,
    this.idToken,
  });

  /// The authentication provider ID for the credential. For example,
  /// 'facebook.com', or 'google.com'.
  ///
  /// 資格情報の認証プロバイダー ID。たとえば、「facebook.com」や「google.com」などです。
  final String providerId;

  /// The authentication sign in method for the credential. For example,
  /// 'password', or 'emailLink'. This corresponds to the sign-in method
  /// identifier returned in [fetchSignInMethodsForEmail].
  ///
  /// 資格情報の認証サインイン方法。たとえば、「パスワード」や「emailLink」などです。これは、[fetchSignInMethodsForEmail] で返されるサインイン メソッド識別子に対応します。
  final String signInMethod;

  /// A token used to identify the AuthCredential on native platforms.
  ///
  /// ネイティブ プラットフォームで AuthCredential を識別するために使用されるトークン。
  final int? token;

  /// The OAuth access token associated with the credential if it belongs to an
  /// OAuth provider, such as `facebook.com`, `twitter.com`, etc.
  /// Using the OAuth access token, you can call the provider's API.
  ///
  /// 「facebook.com」、「twitter.com」などの OAuth プロバイダーに属している場合、資格情報に関連付けられたOAuthアクセストークン。
  /// OAuthアクセストークンを使用して、プロバイダーの API を呼び出すことができます。
  final String? accessToken;

  /// Shared Secret.
  ///
  /// 共有シークレット。
  final String? secret;

  /// Id token, used by Apple and others.
  ///
  /// Idトークン。Appleなどで利用されます。
  final String? idToken;

  @override
  String toString() =>
      'AuthCredential(providerId: $providerId, signInMethod: $signInMethod, token: $token, accessToken: $accessToken, secret: $secret, idToken: $idToken)';
}
