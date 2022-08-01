part of model_notifier;

/// Runtime database.
class RuntimeDatabase {
  const RuntimeDatabase._();
  // ignore: prefer_final_fields
  static LocalStore _db = LocalStore();
  // ignore: prefer_final_fields
  static List<String> _registeredPath = [];

  /// Register new mock [data].
  static void registerMockData(Map<String, DynamicMap> data) {
    if (data.isEmpty) {
      return;
    }
    for (final tmp in data.entries) {
      if (_registeredPath.contains(tmp.key)) {
        continue;
      }
      _registeredPath.add(tmp.key);
      _db.addMockDocument(tmp.key, tmp.value);
    }
  }

  /// Export data to a file with [fileName].
  ///
  /// No encryption is specifically performed.
  static Future<void> export(String fileName) async {
    await DatabaseExporter.export(fileName, _db._data);
  }

  /// Import from a file with [fileName].
  ///
  /// No encryption is specifically performed.
  static Future<void> import(String fileName) async {
    final data = await DatabaseExporter.import(fileName);
    await _db.replace(data);
  }
}
