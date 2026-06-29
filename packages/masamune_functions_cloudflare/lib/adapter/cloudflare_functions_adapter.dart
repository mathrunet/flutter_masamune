part of "/masamune_functions_cloudflare.dart";

/// An adapter for returning server-side processing using Cloudflare Workers.
///
/// You can simplify server-side implementation by using npm's `@mathrunet/masamune_cloudflare`.
///
/// While [AuthAdapter] is used for authentication, it is fundamentally assumed that authentication will be performed on the backend side.
///
/// In the Masamune framework, security is generally ensured by utilizing [FirebaseAuthAdapter].
///
/// Cloudflare Workersを利用してサーバー側の処理を返すためのアダプター。
///
/// npmの`@mathrunet/masamune_cloudflare`を利用することでサーバー側の実装を簡略化することができます。
///
/// 認証は[AuthAdapter]を利用しますが、基本的にバックエンド側で認証を行うことを想定しています。
///
/// Masamuneフレームワークでは基本的に[FirebaseAuthAdapter]を利用することでセキュリティを担保します。
class CloudflareFunctionsAdapter extends FunctionsAdapter {
  /// An adapter for returning server-side processing using Cloudflare Workers.
  ///
  /// You can simplify server-side implementation by using npm's `@mathrunet/masamune_cloudflare`.
  ///
  /// While [AuthAdapter] is used for authentication, it is fundamentally assumed that authentication will be performed on the backend side.
  ///
  /// In the Masamune framework, security is generally ensured by utilizing [FirebaseAuthAdapter].
  ///
  /// Cloudflare Workersを利用してサーバー側の処理を返すためのアダプター。
  ///
  /// npmの`@mathrunet/masamune_cloudflare`を利用することでサーバー側の実装を簡略化することができます。
  ///
  /// 認証は[AuthAdapter]を利用しますが、基本的にバックエンド側で認証を行うことを想定しています。
  ///
  /// Masamuneフレームワークでは基本的に[FirebaseAuthAdapter]を利用することでセキュリティを担保します。
  const CloudflareFunctionsAdapter({
    required this.endpoint,
    AuthAdapter? authAdapter,
  }) : _authAdapter = authAdapter;

  /// Auth adapter used for authentication.
  ///
  /// 認証に利用するAuthアダプター。
  AuthAdapter get authAdapter {
    return _authAdapter ?? AuthAdapter.primary;
  }

  final AuthAdapter? _authAdapter;

  @override
  final String endpoint;

  @override
  Future<TResponse> execute<TResponse>(
      FunctionsAction<TResponse> action) async {
    try {
      return await action.execute((map) async {
        try {} catch (e) {
          debugPrint(e.toString());
          rethrow;
        }
        return {};
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  int get hashCode => endpoint.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
