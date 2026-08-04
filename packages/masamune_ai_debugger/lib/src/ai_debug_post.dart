part of '/masamune_ai_debugger.dart';

/// Models available to AI Debugger sessions.
///
/// AI Debuggerセッションで利用できるモデル。
enum AIDebugModel {
  /// Fastest model.
  haiku,

  /// Balanced model.
  sonnet,

  /// High-capability model.
  opus,

  /// Highest-capability model.
  mythos,
}

/// Permission modes available to AI Debugger sessions.
///
/// AI Debuggerセッションで利用できる権限モード。
enum AIDebugPermissionMode {
  /// Investigate and wait for plan approval before editing.
  plan,

  /// Investigate, edit, and verify without a plan approval pause.
  bypassPermissions,
}

/// Persisted AI Debugger session and performance settings.
///
/// 永続化されるAI Debuggerのセッション・性能設定。
@immutable
class AIDebugSettings {
  /// Creates AI Debugger settings.
  const AIDebugSettings({
    this.manualModel = AIDebugModel.opus,
    this.manualPermissionMode = AIDebugPermissionMode.plan,
    this.errorModel = AIDebugModel.opus,
    this.errorPermissionMode = AIDebugPermissionMode.plan,
    this.performanceModel = AIDebugModel.opus,
    this.performancePermissionMode = AIDebugPermissionMode.plan,
    this.modelLoadTimeout = const Duration(seconds: 5),
    this.indicatorTimeout = const Duration(seconds: 10),
  });

  /// Model used by manual requests.
  final AIDebugModel manualModel;

  /// Permission mode used by manual requests.
  final AIDebugPermissionMode manualPermissionMode;

  /// Model used by unhandled error incidents.
  final AIDebugModel errorModel;

  /// Permission mode used by unhandled error incidents.
  final AIDebugPermissionMode errorPermissionMode;

  /// Model used by performance incidents.
  final AIDebugModel performanceModel;

  /// Permission mode used by performance incidents.
  final AIDebugPermissionMode performancePermissionMode;

  /// Model load threshold.
  final Duration modelLoadTimeout;

  /// Indicator display threshold.
  final Duration indicatorTimeout;

  /// Returns a copy with selected values replaced.
  AIDebugSettings copyWith({
    AIDebugModel? manualModel,
    AIDebugPermissionMode? manualPermissionMode,
    AIDebugModel? errorModel,
    AIDebugPermissionMode? errorPermissionMode,
    AIDebugModel? performanceModel,
    AIDebugPermissionMode? performancePermissionMode,
    Duration? modelLoadTimeout,
    Duration? indicatorTimeout,
  }) =>
      AIDebugSettings(
        manualModel: manualModel ?? this.manualModel,
        manualPermissionMode: manualPermissionMode ?? this.manualPermissionMode,
        errorModel: errorModel ?? this.errorModel,
        errorPermissionMode: errorPermissionMode ?? this.errorPermissionMode,
        performanceModel: performanceModel ?? this.performanceModel,
        performancePermissionMode:
            performancePermissionMode ?? this.performancePermissionMode,
        modelLoadTimeout: modelLoadTimeout ?? this.modelLoadTimeout,
        indicatorTimeout: indicatorTimeout ?? this.indicatorTimeout,
      );

  Map<String, Object?> _toJson() => {
        "manualModel": manualModel.name,
        "manualPermissionMode": manualPermissionMode.name,
        "errorModel": errorModel.name,
        "errorPermissionMode": errorPermissionMode.name,
        "performanceModel": performanceModel.name,
        "performancePermissionMode": performancePermissionMode.name,
        "modelLoadTimeoutMs": modelLoadTimeout.inMilliseconds,
        "indicatorTimeoutMs": indicatorTimeout.inMilliseconds,
      };

  static AIDebugSettings _fromJson(
    Map<String, Object?> json,
    AIDebugSettings fallback,
  ) {
    T enumValue<T extends Enum>(Object? value, List<T> values, T defaultValue) {
      final name = value?.toString();
      return values.firstWhere(
        (item) => item.name == name,
        orElse: () => defaultValue,
      );
    }

    Duration durationValue(Object? value, Duration defaultValue) {
      final milliseconds = value is num ? value.toInt() : null;
      if (milliseconds == null || milliseconds <= 0) return defaultValue;
      return Duration(milliseconds: milliseconds);
    }

    return AIDebugSettings(
      manualModel: enumValue(
        json["manualModel"],
        AIDebugModel.values,
        fallback.manualModel,
      ),
      manualPermissionMode: enumValue(
        json["manualPermissionMode"],
        AIDebugPermissionMode.values,
        fallback.manualPermissionMode,
      ),
      errorModel: enumValue(
        json["errorModel"],
        AIDebugModel.values,
        fallback.errorModel,
      ),
      errorPermissionMode: enumValue(
        json["errorPermissionMode"],
        AIDebugPermissionMode.values,
        fallback.errorPermissionMode,
      ),
      performanceModel: enumValue(
        json["performanceModel"],
        AIDebugModel.values,
        fallback.performanceModel,
      ),
      performancePermissionMode: enumValue(
        json["performancePermissionMode"],
        AIDebugPermissionMode.values,
        fallback.performancePermissionMode,
      ),
      modelLoadTimeout: durationValue(
        json["modelLoadTimeoutMs"],
        fallback.modelLoadTimeout,
      ),
      indicatorTimeout: durationValue(
        json["indicatorTimeoutMs"],
        fallback.indicatorTimeout,
      ),
    );
  }
}

class _AIDebugSettingsStore {
  _AIDebugSettingsStore(this.projectId, this.fallback);

  final String projectId;
  final AIDebugSettings fallback;

  String get _key {
    final suffix = projectId.isEmpty ? "default" : projectId;
    return "masamune_ai_debugger.settings.v2.$suffix";
  }

  Future<AIDebugSettings> load() async {
    final preferences = await SharedPreferences.getInstance();
    final source = preferences.getString(_key);
    if (source == null || source.isEmpty) return fallback;
    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map) return fallback;
      return AIDebugSettings._fromJson(
        Map<String, Object?>.from(decoded),
        fallback,
      );
    } catch (_) {
      return fallback;
    }
  }

  Future<void> save(AIDebugSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, jsonEncode(settings._toJson()));
  }
}

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

/// Sends an instruction with its selected model and permission mode.
///
/// 選択されたモデルと権限モードを指定して指示を送信します。
typedef AIDebugConfiguredSendRequestCallback = Future<String?> Function(
  AIDebugController controller,
  String instruction,
  List<String> screenshotNames, {
  required AIDebugModel model,
  required AIDebugPermissionMode permissionMode,
});

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

/// Reports an incident with its selected model and permission mode.
///
/// 選択されたモデルと権限モードを指定してインシデントを報告します。
typedef AIDebugConfiguredReportIncidentCallback = Future<void> Function(
  AIDebugController controller, {
  required String kind,
  required String message,
  required String stackTrace,
  required DateTime timestamp,
  required Map<String, Object?> metadata,
  required AIDebugModel model,
  required AIDebugPermissionMode permissionMode,
});
