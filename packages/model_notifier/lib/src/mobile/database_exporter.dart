part of model_notifier.mobile;

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
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      _scheduled = false;
      compute<_ComputeMessaging, void>(
        (message) async {
          final json = jsonEncode(_unsupportedObjectFilter(message.data)).toAES(
            message.fileName.last().toSHA1(),
          );
          await File(message.fileName).writeAsString(json);
        },
        _ComputeMessaging(fileName: fileName, data: data),
      );
    });
  }

  /// Import from a file with [fileName].
  ///
  /// No encryption is specifically performed.
  static Future<DynamicMap> import(String fileName) async {
    return await compute<String, DynamicMap>(
      (fileName) async {
        final file = File(fileName);
        if (!file.existsSync()) {
          throw Exception("This file [$fileName] is not found.");
        }
        final json = await file.readAsString();
        return jsonDecodeAsMap(json.fromAES(fileName.last().toSHA1()), {});
      },
      fileName,
    );
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

@immutable
class _ComputeMessaging {
  const _ComputeMessaging({required this.fileName, required this.data});
  final String fileName;
  final DynamicMap data;
}
