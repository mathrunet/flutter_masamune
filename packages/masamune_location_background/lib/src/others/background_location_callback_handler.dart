part of masamune_location_background.others;

@pragma("vm:entry-point")
class BackgroundLocationCallbackHandler {
  @pragma("vm:entry-point")
  static Future<void> init(Map<dynamic, dynamic> params) async {
    await _BackgroundLocationRepository.saveAsLog(
      _BackgroundLocationLogType.start.name,
      "",
    );
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(null);
  }

  @pragma("vm:entry-point")
  static Future<void> dispose() async {
    await _BackgroundLocationRepository.saveAsLog(
      _BackgroundLocationLogType.end.name,
      "",
    );
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(null);
  }

  @pragma("vm:entry-point")
  static Future<void> callback(LocationDto locationDto) async {
    await _BackgroundLocationRepository.saveAsLocation(locationDto);
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(locationDto.toJson());
  }

  @pragma("vm:entry-point")
  static Future<void> notification() async {
    debugPrint("NotificationCallback");
  }
}
