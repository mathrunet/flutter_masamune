part of '/masamune_ai_debugger.dart';

/// Adds an in-app AI debug console, incident reporting, and performance
/// monitoring to Masamune debug builds.
///
/// Masamuneのデバッグビルドにアプリ内AIデバッグコンソール、インシデント報告、
/// パフォーマンス監視を追加します。
class AIDebuggerMasamuneAdapter extends MasamuneAdapter {
  /// Creates an adapter that provides AI debugging in debug mode.
  ///
  /// The default SamuraiAI callbacks read [endpoint] and [apiKey] from dart
  /// defines. [projectId] is also read from a dart define when omitted. When
  /// replacing the callbacks, those values are only required by callbacks that
  /// use them.
  ///
  /// デバッグモードでAIデバッグ機能を提供するアダプターを作成します。
  /// 既定のSamuraiAIコールバックは[projectId]、[endpoint]、[apiKey]を
  /// dart-defineから読み込みます。コールバックを差し替えた場合、これらの値が
  /// 必要かどうかは各コールバックの実装に依存します。
  AIDebuggerMasamuneAdapter({
    this.projectId =
        const String.fromEnvironment("MASAMUNE_AI_DEBUGGER_PROJECT_ID"),
    this.endpoint =
        const String.fromEnvironment("MASAMUNE_AI_DEBUGGER_ENDPOINT"),
    this.apiKey = const String.fromEnvironment("MASAMUNE_AI_DEBUGGER_API_KEY"),
    this.maxScreenshots = 6,
    this.maxSessionsPerHour = 6,
    this.reportHandledErrors = true,
    this.modelLoadTimeout = const Duration(seconds: 5),
    this.indicatorTimeout = const Duration(seconds: 10),
    this.manualModel = AIDebugModel.opus,
    this.manualPermissionMode = AIDebugPermissionMode.plan,
    this.errorModel = AIDebugModel.opus,
    this.errorPermissionMode = AIDebugPermissionMode.plan,
    this.performanceModel = AIDebugModel.opus,
    this.performancePermissionMode = AIDebugPermissionMode.plan,
    this.contextProvider,
    AIDebugPost? post,
    AIDebugRegisterRunCallback? registerRun,
    AIDebugHeartbeatCallback? heartbeat,
    AIDebugEndRunCallback? endRun,
    AIDebugUploadScreenshotCallback? uploadScreenshot,
    AIDebugSendRequestCallback? sendRequest,
    AIDebugConfiguredSendRequestCallback? configuredSendRequest,
    AIDebugReportIncidentCallback? reportIncident,
    AIDebugConfiguredReportIncidentCallback? configuredReportIncident,
    AIDebugUploadEventsCallback? uploadEvents,
  }) : controller = AIDebugController(
          projectId: projectId,
          endpoint: endpoint,
          apiKey: apiKey,
          maxSessionsPerHour: maxSessionsPerHour,
          reportHandledErrors: reportHandledErrors,
          contextProvider: contextProvider,
          settings: AIDebugSettings(
            manualModel: manualModel,
            manualPermissionMode: manualPermissionMode,
            errorModel: errorModel,
            errorPermissionMode: errorPermissionMode,
            performanceModel: performanceModel,
            performancePermissionMode: performancePermissionMode,
            modelLoadTimeout: modelLoadTimeout,
            indicatorTimeout: indicatorTimeout,
          ),
          post: post,
          registerRun: registerRun ?? defaultRegisterRun,
          heartbeatCallback: heartbeat ?? defaultHeartbeat,
          endRun: endRun ?? defaultEndRun,
          uploadScreenshot: uploadScreenshot ?? defaultUploadScreenshot,
          sendRequest: sendRequest,
          configuredSendRequest: configuredSendRequest,
          reportIncident: reportIncident,
          configuredReportIncident: configuredReportIncident,
          uploadEvents: uploadEvents ?? defaultUploadEvents,
        ) {
    _loggerAdapter = _AIDebugLoggerAdapter(controller);
  }

  /// Project identifier sent to the AI debug API.
  ///
  /// AIデバッグAPIへ送信するプロジェクトID。
  final String projectId;

  /// Endpoint URL used by the default SamuraiAI callbacks.
  ///
  /// 既定のSamuraiAIコールバックが使用するエンドポイントURL。
  final String endpoint;

  /// API key used by the default SamuraiAI callbacks.
  ///
  /// 既定のSamuraiAIコールバックがリクエスト認証に使用するAPIキー。
  final String apiKey;

  /// Maximum number of screenshots retained in the debug console.
  ///
  /// デバッグコンソールに保持するスクリーンショットの最大数。
  final int maxScreenshots;

  /// Maximum sessions per hour sent to the configured backend.
  ///
  /// 設定済みバックエンドへ送信する1時間あたりの最大セッション数。
  final int maxSessionsPerHour;

  /// Whether to report errors caught by try-catch via [Logger.error] as incidents.
  ///
  /// If `false`, they are only recorded as breadcrumb logs with a severity of `error` and no incident is raised.
  ///
  /// [Logger.error]経由でtry-catchでキャッチされたエラーをインシデントとして報告するかどうか。
  ///
  /// `false`の場合は`error`のseverityを持つパンくずログとして記録されるのみで、インシデントは発生しません。
  final bool reportHandledErrors;

  /// Duration after which a model load is reported as a performance incident.
  ///
  /// モデル読込をパフォーマンスインシデントとして報告するまでの時間。
  final Duration modelLoadTimeout;

  /// Duration after which an indicator is reported as a performance incident.
  ///
  /// インジケーター表示をパフォーマンスインシデントとして報告するまでの時間。
  final Duration indicatorTimeout;

  /// Initial model used by manual requests before persisted settings load.
  final AIDebugModel manualModel;

  /// Initial permission mode used by manual requests.
  final AIDebugPermissionMode manualPermissionMode;

  /// Initial model used by unhandled errors.
  final AIDebugModel errorModel;

  /// Initial permission mode used by unhandled errors.
  final AIDebugPermissionMode errorPermissionMode;

  /// Initial model used by performance incidents.
  final AIDebugModel performanceModel;

  /// Initial permission mode used by performance incidents.
  final AIDebugPermissionMode performancePermissionMode;

  /// Supplies page, route, and selected state for manual and automatic sends.
  final AIDebugContextProvider? contextProvider;

  /// Controller that manages AI debug runs, incidents, and requests.
  ///
  /// AIデバッグの実行、インシデント、リクエストを管理するコントローラー。
  final AIDebugController controller;
  late final LoggerAdapter _loggerAdapter;

  FlutterExceptionHandler? _previousFlutterError;
  bool Function(Object, StackTrace)? _previousPlatformError;

  /// Registers a run with the default SamuraiAI API.
  ///
  /// デフォルトのSamuraiAI APIへ実行を登録します。
  static Future<void> defaultRegisterRun(AIDebugController controller) async {
    await _postToSamuraiAI(controller, "/api/app-debug/runs", {
      "runId": controller.runId,
      "projectId": controller.projectId,
      "platform": defaultTargetPlatform.name,
      "flavor": "debug",
      "startedAt": controller.startedAt.toIso8601String(),
      "maxSessionsPerHour": controller.maxSessionsPerHour,
    });
  }

  /// Sends a heartbeat to the default SamuraiAI API.
  ///
  /// デフォルトのSamuraiAI APIへハートビートを送信します。
  static Future<void> defaultHeartbeat(AIDebugController controller) async {
    await _postToSamuraiAI(
      controller,
      "/api/app-debug/runs/${controller.runId}/heartbeat",
      const {},
    );
  }

  /// Ends a run on the default SamuraiAI API.
  ///
  /// デフォルトのSamuraiAI API上の実行を終了します。
  static Future<void> defaultEndRun(AIDebugController controller) async {
    await _postToSamuraiAI(
      controller,
      "/api/app-debug/runs/${controller.runId}/end",
      const {},
    );
  }

  /// Uploads a screenshot to the default SamuraiAI API.
  ///
  /// デフォルトのSamuraiAI APIへスクリーンショットをアップロードします。
  static Future<String> defaultUploadScreenshot(
    AIDebugController controller,
    Uint8List bytes, {
    required String name,
  }) async {
    final result = await _postToSamuraiAI(
      controller,
      "/api/app-debug/runs/${controller.runId}/screenshots",
      {
        "name": name,
        "data": "data:image/png;base64,${base64Encode(bytes)}",
      },
    );
    return ((result["screenshot"] as Map?)?["name"] as String?) ?? "";
  }

  /// Sends an instruction to the default SamuraiAI API.
  ///
  /// デフォルトのSamuraiAI APIへ指示を送信します。
  static Future<String?> defaultSendRequest(
    AIDebugController controller,
    String instruction,
    List<String> screenshotNames,
  ) async {
    final settings = await controller.loadSettings();
    return defaultConfiguredSendRequest(
      controller,
      instruction,
      screenshotNames,
      model: settings.manualModel,
      permissionMode: settings.manualPermissionMode,
    );
  }

  /// Sends an instruction with explicit session settings.
  static Future<String?> defaultConfiguredSendRequest(
    AIDebugController controller,
    String instruction,
    List<String> screenshotNames, {
    required AIDebugModel model,
    required AIDebugPermissionMode permissionMode,
  }) async {
    final context = controller._hasCurrentContext
        ? controller.currentContext
        : await controller.captureContext();
    final result = await _postToSamuraiAI(
      controller,
      "/api/app-debug/runs/${controller.runId}/request",
      {
        "instruction": instruction,
        "screenshotNames": screenshotNames,
        "model": model.name,
        "permissionMode": permissionMode.name,
        if (context != null) "context": context._toJson(),
      },
    );
    return result["sessionId"] as String?;
  }

  /// Reports an incident to the default SamuraiAI API.
  ///
  /// デフォルトのSamuraiAI APIへインシデントを報告します。
  static Future<void> defaultReportIncident(
    AIDebugController controller, {
    required String kind,
    required String message,
    required String stackTrace,
    required DateTime timestamp,
    required Map<String, Object?> metadata,
  }) async {
    final settings = await controller.loadSettings();
    final performance = kind == "performance";
    await defaultConfiguredReportIncident(
      controller,
      kind: kind,
      message: message,
      stackTrace: stackTrace,
      timestamp: timestamp,
      metadata: metadata,
      model: performance ? settings.performanceModel : settings.errorModel,
      permissionMode: performance
          ? settings.performancePermissionMode
          : settings.errorPermissionMode,
    );
  }

  /// Reports an incident with explicit session settings.
  static Future<void> defaultConfiguredReportIncident(
    AIDebugController controller, {
    required String kind,
    required String message,
    required String stackTrace,
    required DateTime timestamp,
    required Map<String, Object?> metadata,
    required AIDebugModel model,
    required AIDebugPermissionMode permissionMode,
  }) async {
    final context = controller._hasCurrentContext
        ? controller.currentContext
        : await controller.captureContext();
    final result = await _postToSamuraiAI(
      controller,
      "/api/app-debug/runs/${controller.runId}/incidents",
      {
        "kind": kind,
        "message": message,
        "stackTrace": stackTrace,
        "timestamp": timestamp.toUtc().toIso8601String(),
        if (metadata.isNotEmpty) "metadata": metadata,
        "model": model.name,
        "permissionMode": permissionMode.name,
        if (context != null) "context": context._toJson(),
      },
    );
    if (result["sessionCreated"] == true) {
      controller._notifyIncidentSessionCreated(
        kind,
        result["sessionId"]?.toString() ?? "",
      );
    }
  }

  /// Uploads log events to the default SamuraiAI API.
  ///
  /// デフォルトのSamuraiAI APIへログイベントをアップロードします。
  static Future<void> defaultUploadEvents(
    AIDebugController controller,
    List<Map<String, Object?>> events,
  ) async {
    await _postToSamuraiAI(
      controller,
      "/api/app-debug/runs/${controller.runId}/events",
      {"events": events},
    );
  }

  static Future<Map<String, Object?>> _postToSamuraiAI(
    AIDebugController controller,
    String path,
    Map<String, Object?> body,
  ) async {
    if (!AIDebugController._debugEnabled) return const {};
    if (controller.projectId.isEmpty) {
      throw StateError("MASAMUNE_AI_DEBUGGER_PROJECT_ID is not configured");
    }
    final base = controller.endpoint.replaceFirst(RegExp(r"/+$"), "");
    if (base.isEmpty) {
      throw StateError("MASAMUNE_AI_DEBUGGER_ENDPOINT is not configured");
    }
    if (controller.apiKey.isEmpty) {
      throw StateError("MASAMUNE_AI_DEBUGGER_API_KEY is not configured");
    }
    final url = "$base$path";
    final headers = {
      "content-type": "application/json",
      "x-api-key": controller.apiKey,
    };
    final customPost = controller.post;
    if (customPost != null) return customPost(url, headers, body);
    final response = await Api.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    final decoded =
        response.body.isEmpty ? <String, Object?>{} : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map ? decoded["error"] : null;
      throw AIDebugHttpException(
        response.statusCode,
        message?.toString() ?? "AI Debugger HTTP ${response.statusCode}",
      );
    }
    return Map<String, Object?>.from(decoded as Map);
  }

  @override
  bool get runZonedGuarded => kDebugMode;

  @override
  double get priority => 5;

  @override
  List<LoggerAdapter> get loggerAdapters =>
      kDebugMode ? <LoggerAdapter>[_loggerAdapter] : const [];

  @override
  FutureOr<void> onPreRunApp(WidgetsBinding binding) {
    if (!kDebugMode) {
      return Future<void>.value();
    }
    _previousFlutterError = FlutterError.onError;
    FlutterError.onError = (details) {
      _previousFlutterError?.call(details);
      unawaited(controller.reportError(details.exception, details.stack));
    };
    _previousPlatformError = ui.PlatformDispatcher.instance.onError;
    ui.PlatformDispatcher.instance.onError = (error, stack) {
      final handled = _previousPlatformError?.call(error, stack) ?? false;
      unawaited(controller.reportError(error, stack));
      return handled;
    };
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (kDebugMode) unawaited(controller.reportError(error, stackTrace));
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    if (!kDebugMode) return app;
    return _AIDebugOverlay(
      controller: controller,
      maxScreenshots: maxScreenshots,
      child: app,
    );
  }
}
