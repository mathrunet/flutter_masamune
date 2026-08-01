part of '/masamune_ai_debugger.dart';

/// Testable transport used by [AIDebugController].
///
/// [AIDebugController]が使用するテスト可能な通信処理。
typedef AIDebugPost = Future<Map<String, Object?>> Function(
  String url,
  Map<String, String> headers,
  Map<String, Object?> body,
);

/// Registers an AI debugger run.
///
/// AIデバッガーの実行を登録します。
typedef AIDebugRegisterRunCallback = Future<void> Function(
  AIDebugController controller,
);

/// Sends a heartbeat for an AI debugger run.
///
/// AIデバッガーの実行に対するハートビートを送信します。
typedef AIDebugHeartbeatCallback = Future<void> Function(
  AIDebugController controller,
);

/// Ends an AI debugger run.
///
/// AIデバッガーの実行を終了します。
typedef AIDebugEndRunCallback = Future<void> Function(
  AIDebugController controller,
);

/// Uploads a screenshot and returns its provider-specific identifier.
///
/// スクリーンショットをアップロードし、プロバイダー固有のIDを返します。
typedef AIDebugUploadScreenshotCallback = Future<String> Function(
  AIDebugController controller,
  Uint8List bytes, {
  required String name,
});

/// Sends an instruction and returns an optional provider-specific session ID.
///
/// 指示を送信し、任意のプロバイダー固有セッションIDを返します。
typedef AIDebugSendRequestCallback = Future<String?> Function(
  AIDebugController controller,
  String instruction,
  List<String> screenshotNames,
);

/// Reports an exception or performance incident.
///
/// 例外またはパフォーマンスインシデントを報告します。
typedef AIDebugReportIncidentCallback = Future<void> Function(
  AIDebugController controller, {
  required String kind,
  required String message,
  required String stackTrace,
  required DateTime timestamp,
  required Map<String, Object?> metadata,
});

/// Uploads a batch of log events.
///
/// ログイベントのバッチをアップロードします。
typedef AIDebugUploadEventsCallback = Future<void> Function(
  AIDebugController controller,
  List<Map<String, Object?>> events,
);
