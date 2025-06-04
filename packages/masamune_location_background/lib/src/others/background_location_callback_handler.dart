part of "others.dart";

/// Handler for background location callback.
///
/// バックグラウンド位置情報のコールバックハンドラー。
@pragma("vm:entry-point")
class IOSBackgroundLocationCallbackHandler {
  /// Initialize the background location callback handler.
  ///
  /// バックグラウンド位置情報のコールバックハンドラーを初期化します。
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

  /// Dispose the background location callback handler.
  ///
  /// バックグラウンド位置情報のコールバックハンドラーを破棄します。
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

  /// Handle the background location callback.
  ///
  /// バックグラウンド位置情報のコールバックを処理します。
  @pragma("vm:entry-point")
  static Future<void> callback(LocationDto locationDto) async {
    await _IOSBackgroundLocationRepository.saveAsLocation(locationDto);
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(locationDto.toJson());
  }

  /// Handle the background location notification.
  ///
  /// バックグラウンド位置情報の通知を処理します。
  @pragma("vm:entry-point")
  static Future<void> notification() async {
    debugPrint("NotificationCallback");
  }
}

/// Handler for background location callback.
///
/// バックグラウンド位置情報のコールバックハンドラー。
@pragma("vm:entry-point")
class AndroidBackgroundLocationCallbackHandler {
  /// Initialize the background location callback handler.
  ///
  /// バックグラウンド位置情報のコールバックハンドラーを初期化します。
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

  /// Dispose the background location callback handler.
  ///
  /// バックグラウンド位置情報のコールバックハンドラーを破棄します。
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

  /// Handle the background location callback.
  ///
  /// バックグラウンド位置情報のコールバックを処理します。
  @pragma("vm:entry-point")
  static Future<void> callback(LocationDto locationDto) async {
    await _AndroidBackgroundLocationRepository.saveAsLocation(locationDto);
    // final send =
    //     IsolateNameServer.lookupPortByName(BackgroundLocation._isolateName);
    // send?.send(locationDto.toJson());
  }

  /// Handle the background location notification.
  ///
  /// バックグラウンド位置情報の通知を処理します。
  @pragma("vm:entry-point")
  static Future<void> notification() async {
    debugPrint("NotificationCallback");
  }
}
