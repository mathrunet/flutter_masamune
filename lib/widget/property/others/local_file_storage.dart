part of masamune.property.others;

/// Class for uploading local files.
class LocalFileStorage {
  LocalFileStorage._();

  /// Temporary paths ([path]) in local files are placed in a persistent directory and
  /// made available until the app deletes them.
  ///
  /// The path after application placement is returned.
  static Future<String> upload(String path, [String? folderPath]) async {
    folderPath = folderPath?.trimString("/") ?? "";
    if (folderPath.isEmpty) {
      return path;
    }
    return "$folderPath/$path";
  }
}
