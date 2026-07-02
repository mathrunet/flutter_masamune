part of "/masamune_model_cloudflare_kv.dart";

/// FunctionsAction for deleting a Cloudflare KV document.
///
/// Cloudflare KVのドキュメントを削除するためのFunctionsAction。
class CloudflareKvDeleteDocumentFunctionsAction
    extends FunctionsAction<CloudflareKvDeleteDocumentFunctionsActionResponse> {
  /// FunctionsAction for deleting a Cloudflare KV document.
  ///
  /// Cloudflare KVのドキュメントを削除するためのFunctionsAction。
  const CloudflareKvDeleteDocumentFunctionsAction({
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
  ApiMethod get method => ApiMethod.delete;

  @override
  String get path => _buildCloudflareKvActionPath(action, "document", key);

  @override
  DynamicMap? toMap() {
    return null;
  }

  @override
  CloudflareKvDeleteDocumentFunctionsActionResponse toResponse(DynamicMap map) {
    return CloudflareKvDeleteDocumentFunctionsActionResponse(
      data: map.getAsMap("data"),
    );
  }
}

/// Response for [CloudflareKvDeleteDocumentFunctionsAction].
///
/// [CloudflareKvDeleteDocumentFunctionsAction]のレスポンス。
class CloudflareKvDeleteDocumentFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response for [CloudflareKvDeleteDocumentFunctionsAction].
  ///
  /// [CloudflareKvDeleteDocumentFunctionsAction]のレスポンス。
  const CloudflareKvDeleteDocumentFunctionsActionResponse({
    required this.data,
  });

  /// Response data.
  ///
  /// レスポンスデータ。
  final DynamicMap data;
}
