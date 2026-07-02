part of "/masamune_model_cloudflare_kv.dart";

String _buildCloudflareKvActionPath(
  String action,
  String type,
  String key,
) {
  return Uri(
    pathSegments: [
      ...action.split("/").where((segment) => segment.isNotEmpty),
      type,
      ...key.split("/").where((segment) => segment.isNotEmpty),
    ],
  ).toString();
}

/// FunctionsAction for reading a Cloudflare KV document.
///
/// Cloudflare KVのドキュメントを読み込むためのFunctionsAction。
class CloudflareKvGetDocumentFunctionsAction
    extends FunctionsAction<CloudflareKvGetDocumentFunctionsActionResponse> {
  /// FunctionsAction for reading a Cloudflare KV document.
  ///
  /// Cloudflare KVのドキュメントを読み込むためのFunctionsAction。
  const CloudflareKvGetDocumentFunctionsAction({
    required this.key,
    this.action = "kv",
  });

  /// KV key.
  ///
  /// KVのキー。
  final String key;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.get;

  @override
  String get path => _buildCloudflareKvActionPath(action, "document", key);

  @override
  DynamicMap? toMap() {
    return null;
  }

  @override
  CloudflareKvGetDocumentFunctionsActionResponse toResponse(DynamicMap map) {
    return CloudflareKvGetDocumentFunctionsActionResponse(
      data: map.getAsMap("data"),
    );
  }
}

/// Response for [CloudflareKvGetDocumentFunctionsAction].
///
/// [CloudflareKvGetDocumentFunctionsAction]のレスポンス。
class CloudflareKvGetDocumentFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response for [CloudflareKvGetDocumentFunctionsAction].
  ///
  /// [CloudflareKvGetDocumentFunctionsAction]のレスポンス。
  const CloudflareKvGetDocumentFunctionsActionResponse({
    required this.data,
  });

  /// Response data.
  ///
  /// レスポンスデータ。
  final DynamicMap data;
}
