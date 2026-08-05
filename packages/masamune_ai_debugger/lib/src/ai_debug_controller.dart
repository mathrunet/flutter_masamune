part of '/masamune_ai_debugger.dart';

/// Network and incident lifecycle used by [AIDebuggerMasamuneAdapter].
///
/// [AIDebuggerMasamuneAdapter]が使用する通信とインシデントのライフサイクルを管理します。
class AIDebugController {
  /// Creates a controller for an AI debug run.
  ///
  /// AIデバッグ実行用のコントローラーを作成します。
  AIDebugController({
    required this.projectId,
    required this.endpoint,
    required this.apiKey,
    required this.maxSessionsPerHour,
    this.reportHandledErrors = true,
    AIDebugSettings settings = const AIDebugSettings(),
    this.post,
    this.registerRun = AIDebuggerMasamuneAdapter.defaultRegisterRun,
    this.heartbeatCallback = AIDebuggerMasamuneAdapter.defaultHeartbeat,
    this.endRun = AIDebuggerMasamuneAdapter.defaultEndRun,
    this.uploadScreenshot = AIDebuggerMasamuneAdapter.defaultUploadScreenshot,
    AIDebugConfiguredSendRequestCallback? configuredSendRequest,
    AIDebugSendRequestCallback? sendRequest,
    AIDebugConfiguredReportIncidentCallback? configuredReportIncident,
    AIDebugReportIncidentCallback? reportIncident,
    this.uploadEvents = AIDebuggerMasamuneAdapter.defaultUploadEvents,
    this.heartbeatInterval = const Duration(seconds: 30),
  })  : _settings = settings,
        _settingsStore = _AIDebugSettingsStore(projectId, settings),
        sendRequest = configuredSendRequest ??
            (sendRequest == null
                ? AIDebuggerMasamuneAdapter.defaultConfiguredSendRequest
                : (controller, instruction, screenshotNames,
                        {required model, required permissionMode}) =>
                    sendRequest(controller, instruction, screenshotNames)),
        reportIncident = configuredReportIncident ??
            (reportIncident == null
                ? AIDebuggerMasamuneAdapter.defaultConfiguredReportIncident
                : (controller,
                        {required kind,
                        required message,
                        required stackTrace,
                        required timestamp,
                        required metadata,
                        required model,
                        required permissionMode}) =>
                    reportIncident(
                      controller,
                      kind: kind,
                      message: message,
                      stackTrace: stackTrace,
                      timestamp: timestamp,
                      metadata: metadata,
                    ));

  /// Overrides Debug availability with `false` in tests.
  ///
  /// Release/Profile builds remain disabled even when this is set to `true`.
  @visibleForTesting
  static bool? debugModeOverride;

  static bool get _debugEnabled => kDebugMode && (debugModeOverride ?? true);

  /// Project identifier sent to the AI debug API.
  ///
  /// AIデバッグAPIへ送信するプロジェクトID。
  final String projectId;

  /// Endpoint URL available to the configured callbacks.
  ///
  /// 設定済みコールバックが利用できるエンドポイントURL。
  final String endpoint;

  /// API key available to the configured callbacks.
  ///
  /// 設定済みコールバックが利用できるAPIキー。
  final String apiKey;

  /// Maximum sessions per hour supplied to the configured backend.
  ///
  /// 設定済みバックエンドへ渡す1時間あたりの最大セッション数。
  final int maxSessionsPerHour;

  /// Whether to report errors caught by try-catch as incidents.
  ///
  /// If `false`, they are only recorded as breadcrumb logs with a severity of `error` and no incident is raised.
  ///
  /// try-catchでキャッチされたエラーをインシデントとして報告するかどうか。
  ///
  /// `false`の場合は`error`のseverityを持つパンくずログとして記録されるのみで、インシデントは発生しません。
  final bool reportHandledErrors;

  /// Optional transport used instead of the default HTTP client.
  ///
  /// デフォルトのHTTPクライアントの代わりに使用する任意の通信処理。
  final AIDebugPost? post;

  /// Callback that registers the current run.
  ///
  /// 現在の実行を登録するコールバック。
  final AIDebugRegisterRunCallback registerRun;

  /// Callback that sends a heartbeat for the current run.
  ///
  /// 現在の実行のハートビートを送信するコールバック。
  final AIDebugHeartbeatCallback heartbeatCallback;

  /// Callback that ends the current run.
  ///
  /// 現在の実行を終了するコールバック。
  final AIDebugEndRunCallback endRun;

  /// Callback that uploads a screenshot.
  ///
  /// スクリーンショットをアップロードするコールバック。
  final AIDebugUploadScreenshotCallback uploadScreenshot;

  /// Callback that sends an instruction to the AI debugger.
  ///
  /// AIデバッガーへ指示を送信するコールバック。
  final AIDebugConfiguredSendRequestCallback sendRequest;

  /// Callback that reports an exception or performance incident.
  ///
  /// 例外またはパフォーマンスインシデントを報告するコールバック。
  final AIDebugConfiguredReportIncidentCallback reportIncident;

  /// Callback that uploads breadcrumb log events.
  ///
  /// パンくずログイベントをアップロードするコールバック。
  final AIDebugUploadEventsCallback uploadEvents;

  /// Interval between foreground heartbeat requests.
  ///
  /// フォアグラウンドでハートビートを送信する間隔。
  final Duration heartbeatInterval;

  final _AIDebugSettingsStore _settingsStore;
  AIDebugSettings _settings;
  Future<AIDebugSettings>? _settingsLoad;

  /// Current AI Debugger settings.
  AIDebugSettings get settings => _settings;

  /// Loads persisted settings once for this controller.
  Future<AIDebugSettings> loadSettings() {
    final existing = _settingsLoad;
    if (existing != null) return existing;
    final request = _settingsStore.load().then((value) {
      _settings = value;
      return value;
    }).catchError((Object error) {
      debugPrint("AI Debugger settings load failed: $error");
      return _settings;
    });
    _settingsLoad = request;
    return request;
  }

  /// Updates and persists AI Debugger settings.
  Future<void> updateSettings(AIDebugSettings settings) async {
    await loadSettings();
    _settings = settings;
    await _settingsStore.save(settings);
  }

  String _runId = _createRunId();
  DateTime _startedAt = DateTime.now().toUtc();

  Future<Uint8List?> Function()? _capture;
  Future<void>? _registration;
  Future<void>? _heartbeatInFlight;
  Future<void>? _endInFlight;
  final Map<String, DateTime> _reportedErrors = {};
  final List<Map<String, Object?>> _logs = [];
  Timer? _flushTimer;
  Timer? _heartbeatTimer;
  bool _foreground = false;

  /// Identifier of the current AI debug run.
  ///
  /// 現在のAIデバッグ実行ID。
  String get runId => _runId;

  /// UTC timestamp when the current run started.
  ///
  /// 現在の実行を開始したUTC日時。
  DateTime get startedAt => _startedAt;

  /// Attaches the callback used to capture the current app screen.
  ///
  /// 現在のアプリ画面をキャプチャするコールバックを設定します。
  void attachCapture(Future<Uint8List?> Function() capture) =>
      _capture = capture;

  /// Registers the current run with the configured backend.
  ///
  /// 現在の実行を設定済みのバックエンドへ登録します。
  Future<void> register() async {
    if (!_debugEnabled) return;
    final existing = _registration;
    if (existing != null) return existing;
    final registration = _register();
    _registration = registration;
    try {
      await registration;
    } catch (_) {
      if (identical(_registration, registration)) _registration = null;
      rethrow;
    }
  }

  Future<void> _register() async {
    await registerRun(this);
  }

  /// Starts or resumes foreground heartbeat delivery.
  ///
  /// フォアグラウンドでのハートビート送信を開始または再開します。
  Future<void> resume() async {
    if (!_debugEnabled) return;
    _foreground = true;
    _heartbeatTimer?.cancel();
    try {
      await heartbeat();
    } finally {
      _scheduleHeartbeat();
    }
  }

  void _scheduleHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    if (!_foreground) return;
    _heartbeatTimer = Timer.periodic(
      heartbeatInterval,
      (_) => unawaited(heartbeat().catchError((Object error) {
        debugPrint("AI Debugger heartbeat failed: $error");
      })),
    );
  }

  /// Stops heartbeat delivery while the app is outside the foreground.
  ///
  /// アプリがフォアグラウンド外にある間、ハートビート送信を停止します。
  void pause() {
    _foreground = false;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Sends one heartbeat, recreating a run that expired or disappeared.
  ///
  /// ハートビートを1回送信し、期限切れまたは消失した実行を再作成します。
  Future<void> heartbeat() {
    if (!_debugEnabled) return Future<void>.value();
    final existing = _heartbeatInFlight;
    if (existing != null) return existing;
    final request = _sendHeartbeat();
    _heartbeatInFlight = request;
    return request.whenComplete(() {
      if (identical(_heartbeatInFlight, request)) _heartbeatInFlight = null;
    });
  }

  Future<void> _sendHeartbeat() async {
    try {
      await register();
      await heartbeatCallback(this);
    } on AIDebugHttpException catch (error) {
      if (error.statusCode != 404 && error.statusCode != 410) rethrow;
      _rotateRun();
      await register();
      await heartbeatCallback(this);
    }
  }

  void _rotateRun() {
    _runId = _createRunId();
    _startedAt = DateTime.now().toUtc();
    _registration = null;
    _endInFlight = null;
  }

  /// Ends the current run. Safe to call more than once.
  ///
  /// 現在の実行を終了します。複数回呼び出しても安全です。
  Future<void> end() {
    if (!_debugEnabled) return Future<void>.value();
    final existing = _endInFlight;
    if (existing != null) return existing;
    pause();
    final request = _end();
    _endInFlight = request;
    return request;
  }

  Future<void> _end() async {
    _flushTimer?.cancel();
    _flushTimer = null;
    try {
      await _heartbeatInFlight;
    } catch (_) {
      // Ending still proceeds when an in-flight heartbeat failed.
    }
    if (_logs.isNotEmpty) {
      try {
        await flushLogs();
      } catch (_) {
        // Run termination remains best effort during application shutdown.
      }
    }
    if (_registration == null) return;
    try {
      await endRun(this);
    } catch (_) {
      // The server-side heartbeat timeout is the shutdown fallback.
    }
  }

  /// Uploads screenshot [bytes] and returns the stored file name.
  ///
  /// スクリーンショットの[bytes]をアップロードし、保存されたファイル名を返します。
  Future<String> upload(Uint8List bytes, {String? name}) async {
    if (!_debugEnabled) return "";
    await register();
    return uploadScreenshot(
      this,
      bytes,
      name: name ?? "screenshot-${DateTime.now().millisecondsSinceEpoch}.png",
    );
  }

  /// Sends an AI [instruction] with the selected [screenshots].
  ///
  /// 選択した[screenshots]とともにAIへの[instruction]を送信します。
  Future<String?> send(
    String instruction,
    List<Uint8List> screenshots, {
    AIDebugModel? model,
    AIDebugPermissionMode? permissionMode,
  }) async {
    if (!_debugEnabled) return null;
    final settings = await loadSettings();
    await register();
    await flushLogs();
    final names = <String>[];
    for (final image in screenshots.take(10)) {
      names.add(await upload(image));
    }
    final redactedInstruction = _redact(instruction);
    return sendRequest(
      this,
      redactedInstruction.substring(
        0,
        math.min(16000, redactedInstruction.length),
      ),
      names.where((name) => name.isNotEmpty).toList(),
      model: model ?? settings.manualModel,
      permissionMode: permissionMode ?? settings.manualPermissionMode,
    );
  }

  /// Reports [error] and its [stackTrace] as an exception incident.
  ///
  /// [error]とその[stackTrace]を例外インシデントとして報告します。
  Future<void> reportError(Object error, StackTrace? stackTrace) async {
    if (!_debugEnabled) return;
    final settings = await loadSettings();
    await _reportIncident(
      kind: "exception",
      message: _redact(error.toString()),
      stackTrace: _redact(stackTrace?.toString() ?? ""),
      model: settings.errorModel,
      permissionMode: settings.errorPermissionMode,
    );
  }

  /// Reports a performance trace that exceeded its configured threshold.
  ///
  /// 設定された閾値を超えたパフォーマンストレースを報告します。
  Future<void> reportPerformanceTrace({
    required String category,
    required String traceName,
    required DateTime startedAt,
    required Duration elapsed,
    required Duration threshold,
  }) async {
    if (!_debugEnabled) return;
    final settings = await loadSettings();
    final redactedTraceName = _redact(traceName);
    await _reportIncident(
      kind: "performance",
      message: "Performance threshold exceeded: $redactedTraceName",
      metadata: {
        "category": category,
        "traceName": redactedTraceName,
        "startedAt": startedAt.toUtc().toIso8601String(),
        "elapsedMs": elapsed.inMilliseconds,
        "thresholdMs": threshold.inMilliseconds,
      },
      model: settings.performanceModel,
      permissionMode: settings.performancePermissionMode,
    );
  }

  Future<void> _reportIncident({
    required String kind,
    required String message,
    String stackTrace = "",
    Map<String, Object?> metadata = const {},
    required AIDebugModel model,
    required AIDebugPermissionMode permissionMode,
  }) async {
    final fingerprintSource = "$kind:$message";
    final fingerprint =
        fingerprintSource.replaceAll(RegExp(r"\d+"), "N").substring(
              0,
              math.min(300, fingerprintSource.length),
            );
    final now = DateTime.now();
    final previous = _reportedErrors[fingerprint];
    if (previous != null &&
        now.difference(previous) < const Duration(minutes: 30)) {
      return;
    }
    _reportedErrors[fingerprint] = now;
    try {
      await register();
      await flushLogs();
      final image = await _capture?.call();
      if (image != null) {
        await upload(
          image,
          name: "$kind-${now.millisecondsSinceEpoch}.png",
        );
      }
      await reportIncident(
        this,
        kind: kind,
        message: message,
        stackTrace: stackTrace,
        timestamp: now,
        metadata: metadata,
        model: model,
        permissionMode: permissionMode,
      );
    } catch (sendError) {
      debugPrint("AI Debugger error report failed: $sendError");
    }
  }

  /// Adds a breadcrumb to the current app run.
  ///
  /// 現在のアプリ実行にパンくずログを追加します。
  void addLog(
    String name,
    Map<String, Object?>? parameters, {
    String severity = "info",
  }) {
    if (!_debugEnabled) return;
    _logs.add({
      "message": _redact("$name ${jsonEncode(parameters ?? const {})}"),
      "severity": severity,
      "timestamp": DateTime.now().toUtc().toIso8601String(),
    });
    if (_logs.length > 200) _logs.removeRange(0, _logs.length - 200);
    if (_logs.length >= 20) {
      unawaited(flushLogs());
    } else {
      _flushTimer ??= Timer(const Duration(seconds: 2), () {
        _flushTimer = null;
        unawaited(flushLogs());
      });
    }
  }

  /// Sends queued breadcrumb logs to the configured backend.
  ///
  /// キューに保持されたパンくずログを設定済みのバックエンドへ送信します。
  Future<void> flushLogs() async {
    if (!_debugEnabled) return;
    if (_logs.isEmpty) return;
    final batch = List<Map<String, Object?>>.from(_logs.take(100));
    _logs.removeRange(0, batch.length);
    try {
      await register();
      await uploadEvents(this, batch);
    } catch (error) {
      _logs.insertAll(0, batch);
      if (_logs.length > 200) _logs.removeRange(200, _logs.length);
      debugPrint("AI Debugger log upload failed: $error");
    }
  }

  static String _createRunId() {
    final random = math.Random();
    return "app-${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(1 << 32).toRadixString(16)}";
  }

  static String _redact(String value) => value
      .replaceAll(RegExp(r"Bearer\s+[A-Za-z0-9._~+/=-]+", caseSensitive: false),
          "Bearer [REDACTED]")
      .replaceAll(
          RegExp(r"(token|api[_-]?key|password|secret)\s*[:=]\s*\S+",
              caseSensitive: false),
          r"$1=[REDACTED]")
      .replaceAll(
          RegExp(r"[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}",
              caseSensitive: false),
          "[REDACTED_EMAIL]");
}
