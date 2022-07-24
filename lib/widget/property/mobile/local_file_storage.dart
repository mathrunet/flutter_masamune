part of masamune.property.mobile;

/// Class for uploading local files.
class LocalFileStorage {
  LocalFileStorage._();

  /// Temporary paths ([path]) in local files are placed in a persistent directory and
  /// made available until the app deletes them.
  ///
  /// The path after application placement is returned.
  static Future<String> upload(String path, [String? folderPath]) async {
    folderPath = folderPath?.trimString("/");
    if (folderPath.isNotEmpty) {
      folderPath = "$folderPath/";
    }
    final file = File(path);
    if (!file.existsSync()) {
      return "$folderPath$path";
    }
    final fileName = path.last();
    final rename = "${Config.documentDirectory}/$folderPath$fileName";
    await file.rename(rename);
    return rename;
  }
}
