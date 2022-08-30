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
      final json = jsonEncode(_unsupportedObjectFilter(data));
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

  static DynamicMap _unsupportedObjectFilter(DynamicMap data) {
    final filtered = <String, dynamic>{};
    for (final entry in data.entries) {
      var val = entry.value;
      if (val == null) {
        continue;
      }
      if (val is num && (val.isNaN || val.isInfinite)) {
        continue;
      }
      if (val is DynamicMap) {
        val = _unsupportedObjectFilter(val);
      }
      filtered[entry.key] = val;
    }
    return filtered;
  }
}
