part of "/masamune_model_cloudflare_kv.dart";

/// FunctionsAction for reading a Cloudflare KV document as a collection.
///
/// Cloudflare KVのドキュメントをコレクションとして読み込むためのFunctionsAction。
class CloudflareKvGetCollectionFunctionsAction
    extends FunctionsAction<CloudflareKvGetCollectionFunctionsActionResponse> {
  /// FunctionsAction for reading a Cloudflare KV document as a collection.
  ///
  /// Cloudflare KVのドキュメントをコレクションとして読み込むためのFunctionsAction。
  const CloudflareKvGetCollectionFunctionsAction({
    required this.key,
    this.nearest,
    this.limit,
    this.action = "kv",
  });

  /// KV key.
  ///
  /// KVのキー。
  final String key;

  /// Vector search condition.
  final DynamicMap? nearest;

  /// Maximum number of results.
  final int? limit;

  @override
  final String action;

  @override
  ApiMethod get method => ApiMethod.get;

  @override
  String get path => _buildCloudflareKvActionPath(
        action,
        "collection",
        key,
        queryParameters: {
          if (nearest != null) "nearest": jsonEncode(nearest),
          if (limit != null) "limit": limit!.toString(),
        },
      );

  @override
  DynamicMap? toMap() {
    return null;
  }

  @override
  CloudflareKvGetCollectionFunctionsActionResponse toResponse(DynamicMap map) {
    return CloudflareKvGetCollectionFunctionsActionResponse(
      data: map.getAsMap("data"),
    );
  }
}

/// Response for [CloudflareKvGetCollectionFunctionsAction].
///
/// [CloudflareKvGetCollectionFunctionsAction]のレスポンス。
class CloudflareKvGetCollectionFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response for [CloudflareKvGetCollectionFunctionsAction].
  ///
  /// [CloudflareKvGetCollectionFunctionsAction]のレスポンス。
  const CloudflareKvGetCollectionFunctionsActionResponse({
    required this.data,
  });

  /// Response data.
  ///
  /// レスポンスデータ。
  final DynamicMap data;
}
