// Copyright (c) 2025 mathru. All rights reserved.

// Dart imports:
import "dart:convert";
import "dart:typed_data";

// Package imports:
import "package:masamune/masamune.dart";

/// Operation names for Cloudflare R2 storage worker.
///
/// Cloudflare R2 Storage Workerで利用する操作名。
enum CloudflareStorageOperation {
  /// Download bytes.
  ///
  /// バイト列をダウンロードします。
  get,

  /// Upload bytes.
  ///
  /// バイト列をアップロードします。
  put,

  /// Delete object.
  ///
  /// オブジェクトを削除します。
  delete,

  /// Create a limited download URL.
  ///
  /// 限定ダウンロードURLを作成します。
  downloadUrl;
}

/// FunctionsAction for Cloudflare R2 storage worker.
///
/// Cloudflare R2 Storage Worker用のFunctionsAction。
class CloudflareStorageFunctionsAction
    extends FunctionsAction<CloudflareStorageFunctionsActionResponse> {
  /// FunctionsAction for Cloudflare R2 storage worker.
  ///
  /// Cloudflare R2 Storage Worker用のFunctionsAction。
  const CloudflareStorageFunctionsAction({
    required this.storagePath,
    required this.operation,
    this.action = "storage_cloudflare",
    this.meta,
    this.binary,
    this.expiresIn,
  });

  /// Storage object path.
  ///
  /// Storageのオブジェクトパス。
  final String storagePath;

  /// Operation.
  ///
  /// 操作。
  final CloudflareStorageOperation operation;

  /// Metadata.
  ///
  /// メタデータ。
  final DynamicMap? meta;

  /// Binary.
  ///
  /// バイナリ。
  final Uint8List? binary;

  /// Limited download URL expiration in seconds.
  ///
  /// 限定ダウンロードURLの有効期限（秒）。
  final int? expiresIn;

  @override
  final String action;

  @override
  String get path => action;

  @override
  ApiMethod get method => ApiMethod.post;

  @override
  DynamicMap? toMap() {
    final normalizedPath = storagePath.trimQuery().trimString("/");
    assert(normalizedPath.isNotEmpty, "Path is empty.");
    assert(
      operation == CloudflareStorageOperation.get ||
          operation == CloudflareStorageOperation.delete ||
          operation == CloudflareStorageOperation.downloadUrl ||
          binary.isNotEmpty,
      "If the operation is put, data is required.",
    );
    return {
      "operation": operation.name,
      "path": normalizedPath,
      if (binary != null) "binary": base64Encode(binary!),
      if (meta != null) "meta": meta,
      if (expiresIn != null) "expiresIn": expiresIn,
    };
  }

  @override
  CloudflareStorageFunctionsActionResponse toResponse(DynamicMap map) {
    final status = map.getAsInt("status");
    final meta = map.getAsMap("meta");
    final binarySource = map.get("binary", "");
    final binary = binarySource.isEmpty ? null : base64Decode(binarySource);
    return CloudflareStorageFunctionsActionResponse(
      status: status,
      path: storagePath,
      meta: meta.isEmpty ? null : meta,
      binary: binary,
    );
  }
}

/// Response for [CloudflareStorageFunctionsAction].
///
/// [CloudflareStorageFunctionsAction]のレスポンス。
class CloudflareStorageFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [CloudflareStorageFunctionsAction].
  ///
  /// [CloudflareStorageFunctionsAction]のレスポンス。
  const CloudflareStorageFunctionsActionResponse({
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

  /// Metadata.
  ///
  /// メタデータ。
  final DynamicMap? meta;

  /// Binary.
  ///
  /// バイナリ。
  final Uint8List? binary;
}
