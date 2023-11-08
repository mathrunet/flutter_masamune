part of "others.dart";

@pragma("vm:entry-point")
class IOSBackgroundLocationCallbackHandler {
  @pragma("vm:entry-point")
  static Future<void> init(Map<dynamic, dynamic> params) async {
    await _IOSBackgroundLocationRepository.saveAsLog(
      _BackgroundLocationLogType.start.name,
      "",
    );
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(null);
  }

  @pragma("vm:entry-point")
  static Future<void> dispose() async {
    await _IOSBackgroundLocationRepository.saveAsLog(
      _BackgroundLocationLogType.end.name,
      "",
    );
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(null);
  }

  @pragma("vm:entry-point")
  static Future<void> callback(LocationDto locationDto) async {
    await _IOSBackgroundLocationRepository.saveAsLocation(locationDto);
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(locationDto.toJson());
  }

  @pragma("vm:entry-point")
  static Future<void> notification() async {
    debugPrint("NotificationCallback");
  }
}

@pragma("vm:entry-point")
class AndroidBackgroundLocationCallbackHandler {
  @pragma("vm:entry-point")
  static Future<void> init(Map<dynamic, dynamic> params) async {
    await _AndroidBackgroundLocationRepository.saveAsLog(
      _BackgroundLocationLogType.start.name,
      "",
    );
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(null);
  }

  @pragma("vm:entry-point")
  static Future<void> dispose() async {
    await _AndroidBackgroundLocationRepository.saveAsLog(
      _BackgroundLocationLogType.end.name,
      "",
    );
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(null);
  }

  @pragma("vm:entry-point")
  static Future<void> callback(LocationDto locationDto) async {
    await _AndroidBackgroundLocationRepository.saveAsLocation(locationDto);
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(locationDto.toJson());
  }

  @pragma("vm:entry-point")
  static Future<void> notification() async {
    debugPrint("NotificationCallback");
  }
}
