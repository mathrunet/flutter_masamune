part of "others.dart";

/// [StorageAdapter] for handling files with Cloudflare R2.
///
/// Cloudflare R2でファイルを扱うための[StorageAdapter]。
@immutable
class CloudflareStorageAdapter extends StorageAdapter {
  /// [StorageAdapter] for handling files with Cloudflare R2.
  ///
  /// Cloudflare R2でファイルを扱うための[StorageAdapter]。
  const CloudflareStorageAdapter({
    required this.publicBaseUrl,
    FunctionsAdapter? functionsAdapter,
    this.action = "storage_cloudflare",
    this.downloadUrlExpiresIn = const Duration(hours: 1),
  }) : _functionsAdapter = functionsAdapter;

  /// Public base URL configured in Cloudflare R2.
  ///
  /// Cloudflare R2で設定した公開ベースURL。
  final String publicBaseUrl;

  /// Worker action route.
  ///
  /// Workerのアクションルート。
  final String action;

  /// Limited download URL expiration.
  ///
  /// 限定ダウンロードURLの有効期限。
  final Duration downloadUrlExpiresIn;

  /// Functions adapter for reading and writing R2 objects through Workers.
  ///
  /// Workers経由でR2オブジェクトを読み書きするためのFunctionsアダプター。
  FunctionsAdapter get functionsAdapter {
    return _functionsAdapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _functionsAdapter;

  static const _platformInfo = PlatformInfo();

  @override
  Future<void> delete(String remoteRelativePathOrId) async {
    final response = await _execute(
      remoteRelativePathOrId,
      CloudflareStorageOperation.delete,
    );
    if (response.status >= 400) {
      throw Exception("Failed to delete: ${response.status}");
    }
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePathOrId, [
    String? localRelativePath,
  ]) async {
    final response = await _execute(
      remoteRelativePathOrId,
      CloudflareStorageOperation.get,
    );
    if (response.status >= 400) {
      throw Exception("Failed to download: ${response.status}");
    }
    final bytes = response.binary;
    if (bytes == null) {
      throw Exception("Downloaded data is empty.");
    }
    if (localRelativePath.isNotEmpty) {
      final localFullPath = await _fetchURI(localRelativePath!);
      final localFile = File(localFullPath);
      await localFile.parent.create(recursive: true);
      await localFile.writeAsBytes(bytes);
      return LocalFile(
        path: Uri.parse(localFullPath),
        bytes: bytes,
      );
    }
    return LocalFile(bytes: bytes);
  }

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePathOrId) async {
    final response = await _execute(
      remoteRelativePathOrId,
      CloudflareStorageOperation.downloadUrl,
    );
    final uri = response.meta?.get("downloadUri", "") ?? "";
    if (uri.isEmpty) {
      throw Exception("Download URI is empty.");
    }
    return Uri.parse(uri);
  }

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePathOrId) async {
    return Uri.parse(
      "${publicBaseUrl.trimQuery().trimString("/")}/${_normalizePath(remoteRelativePathOrId)}",
    );
  }

  @override
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePathOrId, {
    String? mimeType,
  }) async {
    assert(localFullPath.isNotEmpty, "Path is empty.");
    if (localFullPath.startsWith("http")) {
      return RemoteFile(path: Uri.parse(localFullPath));
    }
    final file = File(localFullPath);
    if (!file.existsSync()) {
      throw Exception("File is not found.");
    }
    return uploadWithBytes(
      await file.readAsBytes(),
      remoteRelativePathOrId,
      mimeType: mimeType,
    );
  }

  @override
  Future<RemoteFile> uploadWithBytes(
    Uint8List uploadFileByte,
    String remoteRelativePathOrId, {
    String? mimeType,
  }) async {
    assert(uploadFileByte.isNotEmpty, "Bytes is empty.");
    final response = await _execute(
      remoteRelativePathOrId,
      CloudflareStorageOperation.put,
      binary: uploadFileByte,
      meta: {
        if (mimeType != null) "contentType": mimeType,
      },
    );
    if (response.status >= 400) {
      throw Exception("Failed to upload: ${response.status}");
    }
    return RemoteFile(path: await fetchPublicURI(remoteRelativePathOrId));
  }

  Future<CloudflareStorageFunctionsActionResponse> _execute(
    String remoteRelativePathOrId,
    CloudflareStorageOperation operation, {
    Uint8List? binary,
    DynamicMap? meta,
  }) {
    return functionsAdapter.execute(
      CloudflareStorageFunctionsAction(
        action: action,
        storagePath: _normalizePath(remoteRelativePathOrId),
        operation: operation,
        binary: binary,
        meta: meta,
        expiresIn: downloadUrlExpiresIn.inSeconds,
      ),
    );
  }

  String _normalizePath(String path) {
    return path.trimQuery().trimString("/");
  }

  Future<String> _fetchURI(String fileRelativePath) async =>
      "${await _documentDirectory}/$fileRelativePath";

  static Future<String?> get _documentDirectory async {
    if (_platformInfo.isIOS) {
      return (await _platformInfo.getLibraryDirectory()).path;
    } else {
      return (await _platformInfo.getApplicationDocumentsDirectory()).path;
    }
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return publicBaseUrl.hashCode ^
        action.hashCode ^
        downloadUrlExpiresIn.hashCode ^
        functionsAdapter.hashCode;
  }
}
