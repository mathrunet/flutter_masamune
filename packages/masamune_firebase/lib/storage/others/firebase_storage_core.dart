part of masamune_firebase.storage.others;

/// Class for handling Firebase storage.
///
/// Basically, you specify the [path] of the local file in [upload] and
/// receive the URL after the upload.
///
/// You can then use [Image.network] or similar to display that URL.
class FirebaseStorageCore {
  FirebaseStorageCore._();

  /// Class for handling Firebase storage.
  ///
  /// Basically, you specify the [path] of the local file in [upload] and
  /// receive the URL after the upload.
  ///
  /// If [remotePath] is specified, the file will be uploaded to Firebase Storage with the specified path.
  /// If not specified, the [uuid]. [path] extension will be applied.
  ///
  /// You can then use [Image.network] or similar to display that URL.
  ///
  /// ```
  /// final media = await FirebaseStorageCore.upload("local path");
  /// if(media == null) return;
  /// Image.network(media.url);
  /// ```
  static Future<String> upload(String path, [String? remotePath]) async {
    assert(path.isNotEmpty, "Path is empty.");
    if (path.startsWith("http")) {
      return path;
    }
    final storage = readProvider(
      firebaseStorageProvider(
        remotePath.isEmpty ? "$uuid.${path.split(".").last}" : remotePath!,
      ),
    );
    await storage.upload(path);
    return storage.url;
  }

  /// Class for handling Firebase storage.
  ///
  /// Basically, you specify the [bytes] of the local file in [upload] and
  /// receive the URL after the upload.
  ///
  /// If [remotePath] is specified, the file will be uploaded to Firebase Storage with the specified path.
  ///
  /// You can then use [Image.network] or similar to display that URL.
  ///
  /// ```
  /// final media = await FirebaseStorageCore.uploadWithBytes(bytes, "png");
  /// if(media == null) return;
  /// Image.network(media.url);
  /// ```
  static Future<String> uploadWithBytes(
    String remotePath,
    Uint8List bytes,
  ) async {
    assert(bytes.isNotEmpty, "Bytes is empty.");
    assert(remotePath.isNotEmpty, "Path is empty.");
    final storage = readProvider(firebaseStorageProvider(remotePath));
    await storage.uploadWithBytes(bytes);
    return storage.url;
  }
}
