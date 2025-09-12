part of "/masamune_storage_functions.dart";

/// FunctionsAction for uploading files to storage.
///
/// ストレージにファイルをアップロードするためのFunctionsAction。
class StorageFunctionsAction
    extends FunctionsAction<StorageFunctionsActionResponse> {
  /// FunctionsAction for uploading files to storage.
  ///
  /// ストレージにファイルをアップロードするためのFunctionsAction。
  const StorageFunctionsAction({
    required this.bucketName,
    required this.path,
    required this.method,
    this.action = "storage_firebase",
    this.meta,
    this.binary,
  });

  /// Bucket name.
  ///
  /// バケット名。
  final String bucketName;

  /// Path.
  ///
  /// パス。
  @override
  final String path;

  /// Meta data for Post and Put.
  ///
  /// PostやPutのメタデータ。
  final DynamicMap? meta;

  /// Binary.
  ///
  /// バイナリ。
  final Uint8List? binary;

  @override
  final ApiMethod method;

  @override
  final String action;

  @override
  DynamicMap? toMap() {
    final bucketName = this.bucketName.trimQuery().trimString("/");
    final path = this.path.trimQuery().trimString("/");
    assert(
        method == ApiMethod.get ||
            method == ApiMethod.delete ||
            binary.isNotEmpty,
        "If the method is POST or PUT, data is required.");
    assert(bucketName.isNotEmpty, "Bucket name is empty.");
    assert(path.isNotEmpty, "Path is empty.");
    return {
      "method": method.name,
      "path": "$bucketName/$path",
      if (binary != null) "data": base64Encode(binary!),
      if (meta != null) "meta": meta,
    };
  }

  @override
  StorageFunctionsActionResponse toResponse(DynamicMap map) {
    final status = map.getAsInt("status");
    final meta = map.getAsMap("meta");
    final data = map.get("data", "");
    final binary = data.isEmpty ? null : base64Decode(data);
    return StorageFunctionsActionResponse(
      status: status,
      path: path,
      meta: meta.isEmpty ? null : meta,
      binary: binary,
    );
  }
}

/// Response for [StorageFunctionsAction].
///
/// [StorageFunctionsAction]のレスポンス。
class StorageFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [StorageFunctionsAction].
  ///
  /// [StorageFunctionsAction]のレスポンス。
  const StorageFunctionsActionResponse({
    required this.status,
    required this.path,
    this.meta,
    this.binary,
  });

  /// Path.
  ///
  /// パス。
  final String path;

  /// Status.
  ///
  /// ステータス。
  final int status;

  /// Data.
  ///
  /// データ。
  final DynamicMap? meta;

  /// Binary.
  ///
  /// バイナリ。
  final Uint8List? binary;
}
