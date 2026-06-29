part of "others.dart";

/// [StorageAdapter] for handling files with Cloudflare R2.
///
/// [download] is not available on web platforms.
///
/// You can use `https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media` with [fetchPublicURI].
///
/// It is possible to obtain temporary tokens and perform read/write operations by using it in conjunction with `@mathrunet/masamune_cloudflare_cloudflare`.
///
/// Cloudflare R2でファイルを扱うための[StorageAdapter]。
///
/// Webのプラットフォームでは[download]が利用できません。
///
/// [fetchPublicURI]で`https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media`が利用可能です。
///
/// `@mathrunet/masamune_cloudflare_cloudflare`と併用して、一時トークンの取得や読み書きを行うことが可能です。
@immutable
class CloudflareStorageAdapter extends StorageAdapter {
  /// [StorageAdapter] for handling files with Cloudflare R2.
  ///
  /// [download] is not available on web platforms.
  ///
  /// You can use `https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media` with [fetchPublicURI].
  ///
  /// It is possible to obtain temporary tokens and perform read/write operations by using it in conjunction with `@mathrunet/masamune_cloudflare_cloudflare`.
  ///
  /// Cloudflare R2でファイルを扱うための[StorageAdapter]。
  ///
  /// Webのプラットフォームでは[download]が利用できません。
  ///
  /// [fetchPublicURI]で`https://firebasestorage.googleapis.com/v0/b/storageBucket/o/remoteRelativePath?alt=media`が利用可能です。
  ///
  /// `@mathrunet/masamune_cloudflare_cloudflare`と併用して、一時トークンの取得や読み書きを行うことが可能です。
  const CloudflareStorageAdapter({
    FunctionsAdapter? functionsAdapter,
  }) : _functionsAdapter = functionsAdapter;

  /// Functions adapter for obtaining and reading/writing temporary tokens.
  ///
  /// トークンの取得や読み書きを行うためのFunctionsアダプター。
  FunctionsAdapter get functionsAdapter {
    return _functionsAdapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _functionsAdapter;

  @override
  Future<void> delete(String remoteRelativePathOrId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<LocalFile> download(String remoteRelativePathOrId,
      [String? localRelativePath]) {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePathOrId) {
    // TODO: implement fetchDownloadURI
    throw UnimplementedError();
  }

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePathOrId) {
    // TODO: implement fetchPublicURI
    throw UnimplementedError();
  }

  @override
  Future<RemoteFile> upload(String localFullPath, String remoteRelativePathOrId,
      {String? mimeType}) {
    // TODO: implement upload
    throw UnimplementedError();
  }

  @override
  Future<RemoteFile> uploadWithBytes(
      Uint8List uploadFileByte, String remoteRelativePathOrId,
      {String? mimeType}) {
    // TODO: implement uploadWithBytes
    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return functionsAdapter.hashCode;
  }
}
