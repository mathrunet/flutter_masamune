part of 'others.dart';

/// StorageAdapter] for uploading & downloading OpenAI files.
///
/// Specify the purpose of use by [purpose].
///
/// Basically, [remoteRelativePathOrId] specifies the file ID for everything.
///
/// OpenAIのファイルをアップロード＆ダウンロードするための[StorageAdapter]。
///
/// [purpose]によって利用目的を指定してください。
///
/// 基本的に[remoteRelativePathOrId]はすべてファイルIDを指定します。
class OpenAIStorageAdapter extends StorageAdapter {
  /// StorageAdapter] for uploading & downloading OpenAI files.
  ///
  /// Specify the purpose of use by [purpose].
  ///
  /// Basically, [remoteRelativePathOrId] specifies the file ID for everything.
  ///
  /// OpenAIのファイルをアップロード＆ダウンロードするための[StorageAdapter]。
  ///
  /// [purpose]によって利用目的を指定してください。
  ///
  /// 基本的に[remoteRelativePathOrId]はすべてファイルIDを指定します。
  const OpenAIStorageAdapter({
    this.purpose = OpenAIFilePurpose.assistants,
  });

  /// Intended use of the file.
  ///
  /// ファイルの利用目的。
  final OpenAIFilePurpose purpose;

  Map<String, String> get _header {
    return {
      "Content-Type": "application/json",
      "OpenAI-Beta": "assistants=v1",
      "Authorization": "Bearer ${OpenAIMasamuneAdapter.primary.apiKey}",
    };
  }

  @override
  Future<void> delete(String remoteRelativePathOrId) async {
    final res = await Api.delete(
      "https://api.openai.com/v1/files/$remoteRelativePathOrId",
      headers: _header,
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to delete document.");
    }
  }

  @override
  Future<LocalFile> download(
    String remoteRelativePathOrId, [
    String? localRelativePath,
  ]) async {
    final res = await Api.post(
      "https://api.openai.com/v1/files/$remoteRelativePathOrId/content",
      headers: _header,
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to download file.");
    }
    final bytes = res.bodyBytes;
    final tmpPath = localRelativePath;
    final tmpDir = await getTemporaryDirectory();
    final filePath = "${tmpDir.path}/$tmpPath";
    final file = File(filePath);
    final parents = file.parent;
    if (!parents.existsSync()) {
      await parents.create(recursive: true);
    }
    await file.writeAsBytes(bytes);
    return LocalFile(path: Uri.parse(filePath), bytes: bytes);
  }

  @override
  Future<Uri> fetchDownloadURI(String remoteRelativePathOrId) {
    throw UnsupportedError("This function is not supported.");
  }

  @override
  Future<Uri> fetchPublicURI(String remoteRelativePathOrId) {
    throw UnsupportedError("This function is not supported.");
  }

  @override
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePathOrId, {
    String? mimeType,
  }) async {
    final file = File(localFullPath);
    final bytes = file.existsSync() ? await file.readAsBytes() : null;
    final res = await Api.post(
      "https://api.openai.com/v1/files",
      headers: _header,
      body: jsonEncode({
        "file": localFullPath,
        "purpose": purpose.id,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to upload file.");
    }
    final json = jsonDecodeAsMap(utf8.decode(res.bodyBytes));
    final id = json.get("id", "");
    if (id.isNotEmpty) {
      throw Exception("Failed to fetch id.");
    }
    return RemoteFile(
      path: Uri(path: id),
      bytes: bytes,
    );
  }

  @override
  Future<RemoteFile> uploadWithBytes(
    Uint8List uploadFileByte,
    String remoteRelativePathOrId, {
    String? mimeType,
  }) async {
    final tmpId = uuid();
    final tmpDir = await getTemporaryDirectory();
    final filePath = "${tmpDir.path}/$tmpId";
    final file = File(filePath);
    if (file.existsSync()) {
      await file.delete();
    }
    await file.writeAsBytes(uploadFileByte);
    final res = await Api.post(
      "https://api.openai.com/v1/files",
      headers: _header,
      body: jsonEncode({
        "file": filePath,
        "purpose": purpose.id,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to upload file.");
    }
    final json = jsonDecodeAsMap(utf8.decode(res.bodyBytes));
    final id = json.get("id", "");
    if (id.isNotEmpty) {
      throw Exception("Failed to fetch id.");
    }
    return RemoteFile(
      path: Uri(path: id),
      bytes: uploadFileByte,
    );
  }
}
