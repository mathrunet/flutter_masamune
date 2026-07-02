part of "/masamune_model_cloudflare_kv.dart";

/// FunctionsAction for saving a Cloudflare KV document.
///
/// Cloudflare KVのドキュメントを保存するためのFunctionsAction。
class CloudflareKvPutDocumentFunctionsAction
    extends FunctionsAction<CloudflareKvPutDocumentFunctionsActionResponse> {
  /// FunctionsAction for saving a Cloudflare KV document.
  ///
  /// Cloudflare KVのドキュメントを保存するためのFunctionsAction。
  const CloudflareKvPutDocumentFunctionsAction({
    required this.key,
    required this.value,
    this.action = "kv",
  });

  /// KV key.
  ///
  /// KVのキー。
  final String key;

  /// Value to save.
  ///
  /// 保存する値。
  final DynamicMap value;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.put;

  @override
  String get path => _buildCloudflareKvActionPath(action, "document", key);

  @override
  DynamicMap? toMap() {
    return {"value": value};
  }

  @override
  CloudflareKvPutDocumentFunctionsActionResponse toResponse(DynamicMap map) {
    return CloudflareKvPutDocumentFunctionsActionResponse(
      data: map.getAsMap("data"),
    );
  }
}

/// Response for [CloudflareKvPutDocumentFunctionsAction].
///
/// [CloudflareKvPutDocumentFunctionsAction]のレスポンス。
class CloudflareKvPutDocumentFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response for [CloudflareKvPutDocumentFunctionsAction].
  ///
  /// [CloudflareKvPutDocumentFunctionsAction]のレスポンス。
  const CloudflareKvPutDocumentFunctionsActionResponse({
    required this.data,
  });

  /// Response data.
  ///
  /// レスポンスデータ。
  final DynamicMap data;
}
