part of masamune_location_background.others;

const _kBackgroundLocationRepositoryId = "backgroundlocation://";
const _kTypeKey = "type";
const _kTimeKey = "time";
const _kMessageKey = "msg";

enum _BackgroundLocationLogType {
  start,
  end,
  location;
}

class _IOSBackgroundLocationRepository {
  const _IOSBackgroundLocationRepository._();

  static Future<void> saveAsLog(String type, String message) async {
    await save({
      _kTypeKey: type,
      _kTimeKey: DateTime.now().millisecondsSinceEpoch,
      _kMessageKey: message,
    });
  }

  static Future<void> saveAsLocation(LocationDto location) async {
    await save({
      _kTypeKey: _BackgroundLocationLogType.location.name,
      ...location.toLocationData().toJson(),
    });
  }

  static Future<List<LocationData>?> loadAsLocations() async {
    final logs = await load();
    return logs
        .split("\n")
        .mapAndRemoveEmpty((e) {
          if (e.isEmpty) {
            return null;
          }
          final json = e.toJsonMap();
          if (json.isEmpty) {
            return null;
          }
          return json;
        })
        .where(
          (e) =>
              e.get(_kTypeKey, "") == _BackgroundLocationLogType.location.name,
        )
        .toList()
        .sortTo(
          (a, b) => a.getAsInt("timestamp", 0) - b.getAsInt("timestamp", 0),
        )
        .mapAndRemoveEmpty((item) => LocationData.fromJson(item));
  }

  static Future<LocationData?> loadAsLatestLocation() async {
    final logs = await load();
    final latest = logs.split("\n").mapAndRemoveEmpty((e) {
      if (e.isEmpty) {
        return null;
      }
      final json = e.toJsonMap();
      if (json.isEmpty) {
        return null;
      }
      return json;
    }).lastWhereOrNull((item) {
      return item.get(_kTypeKey, "") ==
          _BackgroundLocationLogType.location.name;
    });
    if (latest == null) {
      return null;
    }
    return LocationData.fromJson(latest);
  }

  static Future<void> save(Map<String, dynamic> value) async {
    final file = await _getTempLogFile();
    await file.writeAsString("${value.toJsonString()}\n",
        mode: FileMode.append);
  }

  static Future<String> load() async {
    final file = await _getTempLogFile();
    return file.readAsString();
  }

  static Future<File> _getTempLogFile() async {
    final directory = Directory.systemTemp;
    final file = File(
      "${directory.path}/${_kBackgroundLocationRepositoryId.toSHA1()}",
    );
    if (!await file.exists()) {
      await file.writeAsString("");
    }
    return file;
  }

  static Future<void> clear() async {
    final file = await _getTempLogFile();
    await file.writeAsString("");
  }
}

class _AndroidBackgroundLocationRepository {
  const _AndroidBackgroundLocationRepository._();

  static Future<void> saveAsLog(String type, String message) async {
    await save({
      _kTypeKey: type,
      _kTimeKey: DateTime.now().millisecondsSinceEpoch,
      _kMessageKey: message,
    });
  }

  static Future<void> saveAsLocation(LocationDto location) async {
    await save({
      _kTypeKey: _BackgroundLocationLogType.location.name,
      ...location.toLocationData().toJson(),
    });
  }

  static Future<List<LocationData>?> loadAsLocations() async {
    final logs = await load();
    return logs
        .split("\n")
        .mapAndRemoveEmpty((e) {
          if (e.isEmpty) {
            return null;
          }
          final json = e.toJsonMap();
          if (json.isEmpty) {
            return null;
          }
          return json;
        })
        .where(
          (e) =>
              e.get(_kTypeKey, "") == _BackgroundLocationLogType.location.name,
        )
        .toList()
        .sortTo(
          (a, b) => a.getAsInt("timestamp", 0) - b.getAsInt("timestamp", 0),
        )
        .mapAndRemoveEmpty((item) => LocationData.fromJson(item));
  }

  static Future<LocationData?> loadAsLatestLocation() async {
    final logs = await load();
    final latest = logs.split("\n").mapAndRemoveEmpty((e) {
      if (e.isEmpty) {
        return null;
      }
      final json = e.toJsonMap();
      if (json.isEmpty) {
        return null;
      }
      return json;
    }).lastWhereOrNull((item) {
      return item.get(_kTypeKey, "") ==
          _BackgroundLocationLogType.location.name;
    });
    if (latest == null) {
      return null;
    }
    return LocationData.fromJson(latest);
  }

  static Future<void> save(Map<String, dynamic> value) async {
    final file = await _getTempLogFile();
    await file.writeAsString("${value.toJsonString()}\n",
        mode: FileMode.append);
  }

  static Future<String> load() async {
    final file = await _getTempLogFile();
    return await file.readAsString();
  }

  static Future<File> _getTempLogFile() async {
    final directory = await getTemporaryDirectory();
    final file = File(
      "${directory.path}/${_kBackgroundLocationRepositoryId.toSHA1()}",
    );
    if (!await file.exists()) {
      await file.writeAsString("");
    }
    return file;
  }

  static Future<void> clear() async {
    final file = await _getTempLogFile();
    await file.writeAsString("");
  }
}
