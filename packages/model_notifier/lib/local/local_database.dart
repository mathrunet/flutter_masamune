part of model_notifier;

/// Local database.
class LocalDatabase {
  const LocalDatabase._();
  // ignore: prefer_final_fields
  static LocalStore _db = LocalStore(
    onInitialize: () async {
      await Prefs.initialize();
      try {
        if (Config.isIOS) {
          _db._data = await DatabaseExporter.import(
            "${Config.libraryDirectory}/${"local://".toSHA1()}",
          );
        } else {
          _db._data = await DatabaseExporter.import(
            "${Config.documentDirectory}/${"local://".toSHA1()}",
          );
        }
      } catch (e) {
        _db._data = {};
      }
    },
    onSaved: () async {
      if (Config.isIOS) {
        await DatabaseExporter.export(
          "${Config.libraryDirectory}/${"local://".toSHA1()}",
          _db._data,
        );
      } else {
        await DatabaseExporter.export(
          "${Config.documentDirectory}/${"local://".toSHA1()}",
          _db._data,
        );
      }
    },
    onDeleted: () async {
      if (Config.isIOS) {
        await DatabaseExporter.export(
          "${Config.libraryDirectory}/${"local://".toSHA1()}",
          _db._data,
        );
      } else {
        await DatabaseExporter.export(
          "${Config.documentDirectory}/${"local://".toSHA1()}",
          _db._data,
        );
      }
    },
  );

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
