part of "/masamune_google_cloud.dart";

/// [GoogleTokenAction] for Google Cloud Platform authentication token.
///
/// Google Cloud Platformの認証トークンを取得するための[FunctionsAction]。
class GoogleTokenAction extends FunctionsAction<GoogleTokenActionResponse> {
  /// [GoogleTokenAction] for Google Cloud Platform authentication token.
  ///
  /// Google Cloud Platformの認証トークンを取得するための[FunctionsAction]。
  const GoogleTokenAction();

  @override
  String get action => "google_token";

  @override
  DynamicMap? toMap() {
    return {};
  }

  @override
  GoogleTokenActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $action.");
    }
    return GoogleTokenActionResponse(
      accessToken: map.get("accessToken", ""),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        map.getAsInt("expiresAt"),
      ),
    );
  }
}

/// [GoogleTokenActionResponse] for Google Cloud Platform authentication token.
///
/// Google Cloud Platformの認証トークンを取得するための[GoogleTokenActionResponse]。
class GoogleTokenActionResponse extends FunctionsActionResponse {
  /// [GoogleTokenActionResponse] for Google Cloud Platform authentication token.
  ///
  /// Google Cloud Platformの認証トークンを取得するための[GoogleTokenActionResponse]。
  const GoogleTokenActionResponse({
    required this.accessToken,
    required this.expiresAt,
  });

  /// Access token.
  ///
  /// アクセストークン。
  final String accessToken;

  /// Expires at.
  ///
  /// 有効期限。
  final DateTime expiresAt;
}
