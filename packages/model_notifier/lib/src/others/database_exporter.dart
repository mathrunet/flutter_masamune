part of model_notifier.others;

/// A class that allows the contents of a database to be exported or imported into other files or other persistent information.
class DatabaseExporter {
  DatabaseExporter._();

  static bool _scheduled = false;

  /// Export [data] to a file with [fileName].
  ///
  /// No encryption is specifically performed.
  static Future<void> export(String fileName, DynamicMap data) async {
    if (_scheduled) {
      return;
    }
    _scheduled = true;
    WidgetsBinding.instance.scheduleFrameCallback((_) async {
      _scheduled = false;
      await Prefs.initialize();
      final json = jsonEncode(data);
      Prefs.set(fileName.toSHA1(), json);
    });
  }

  /// Import from a file with [fileName].
  ///
  /// No encryption is specifically performed.
  static Future<DynamicMap> import(String fileName) async {
    await Prefs.initialize();
    final json = Prefs.get(fileName.toSHA1(), "");
    return jsonDecodeAsMap(json, {});
  }
}
