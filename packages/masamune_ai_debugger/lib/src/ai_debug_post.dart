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

/// A bounded snapshot of the app state attached to a debug request.
///
/// デバッグ依頼へ添付する、サイズ制限済みのアプリ状態スナップショット。
@immutable
class AIDebugContextSnapshot {
  /// Creates an app context snapshot.
  const AIDebugContextSnapshot({
    this.pageName,
    this.route,
    this.widgetTree,
    this.values = const {},
  });

  /// Human-readable current page name.
  final String? pageName;

  /// Current route path or route name.
  final String? route;

  /// Optional widget tree supplied by a custom provider.
  ///
  /// When omitted, AI Debugger captures the app widget hierarchy.
  final String? widgetTree;

  /// Explicitly selected JSON-compatible diagnostic values.
  final Map<String, Object?> values;

  bool get _isEmpty =>
      (pageName == null || pageName!.isEmpty) &&
      (route == null || route!.isEmpty) &&
      (widgetTree == null || widgetTree!.isEmpty) &&
      values.isEmpty;

  Map<String, Object?> _toJson() {
    final sanitizer = _AIDebugContextSanitizer();
    return {
      if (pageName != null && pageName!.isNotEmpty)
        "pageName": sanitizer.text(pageName!, maxLength: 200),
      if (route != null && route!.isNotEmpty)
        "route": sanitizer.text(route!, maxLength: 1000),
      if (widgetTree != null && widgetTree!.isNotEmpty)
        "widgetTree": sanitizer.text(widgetTree!, maxLength: 16000),
      if (values.isNotEmpty) "values": sanitizer.value(values),
    };
  }
}

/// Supplies page, route, and explicitly selected state at send time.
///
/// 送信時点のページ、ルート、明示的に選択した状態を提供します。
typedef AIDebugContextProvider = FutureOr<AIDebugContextSnapshot?> Function();

/// A purchase product exposed by the AI debugger's debug purchase UI.
///
/// AIデバッガーのデバッグ課金UIに表示する課金商品です。
@immutable
class AIDebugPurchaseProduct {
  /// Creates a purchase product for debug operations.
  ///
  /// デバッグ操作用の課金商品を作成します。
  const AIDebugPurchaseProduct({
    required this.id,
    required this.label,
  });

  /// Identifier used to resolve the app's actual purchase product.
  ///
  /// アプリ側の実際の課金商品を解決するためのID。
  final String id;

  /// Label displayed in the AI debugger UI.
  ///
  /// AIデバッガーUIに表示するラベル。
  final String label;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIDebugPurchaseProduct && other.id == id;
}

/// Signs in a debug user with an email address and password.
typedef AIDebugLoginCallback = FutureOr<void> Function(
  String email,
  String password,
);

/// Signs out the current debug user.
typedef AIDebugLogoutCallback = FutureOr<void> Function();

/// Returns whether a debug user is currently signed in.
typedef AIDebugIsLoggedInCallback = bool Function();

/// Returns the purchase products available to the debug purchase UI.
typedef AIDebugPurchaseProductsCallback = List<AIDebugPurchaseProduct>
    Function();

/// Forces the supplied product into a purchased state.
typedef AIDebugPurchaseCallback = FutureOr<void> Function(
  AIDebugPurchaseProduct product,
);

/// Removes the supplied product from the purchased state.
typedef AIDebugCancelPurchaseCallback = FutureOr<void> Function(
  AIDebugPurchaseProduct product,
);

/// Returns whether the supplied product is currently purchased.
typedef AIDebugIsPurchasedCallback = bool Function(
  AIDebugPurchaseProduct product,
);

class _AIDebugContextSanitizer {
  static final RegExp _sensitiveKey = RegExp(
    r"authorization|cookie|token|api[_-]?key|password|secret|private[_-]?key",
    caseSensitive: false,
  );

  int _remainingCharacters = 24000;

  String text(String source, {int maxLength = 4000}) {
    if (_remainingCharacters <= 0) return "[TRUNCATED]";
    final redacted = AIDebugController._redact(source);
    final length = math.min(
      redacted.length,
      math.min(maxLength, _remainingCharacters),
    );
    _remainingCharacters -= length;
    return redacted.substring(0, length);
  }

  Object? value(Object? source, {int depth = 0, String? key}) {
    if (key != null && _sensitiveKey.hasMatch(key)) return "[REDACTED]";
    if (source == null || source is bool || source is num) return source;
    if (source is String) return text(source);
    if (depth >= 5) return text(source.toString(), maxLength: 500);
    if (source is Map) {
      final result = <String, Object?>{};
      for (final entry in source.entries.take(50)) {
        final entryKey = text(entry.key.toString(), maxLength: 200);
        result[entryKey] = value(
          entry.value,
          depth: depth + 1,
          key: entryKey,
        );
        if (_remainingCharacters <= 0) break;
      }
      return result;
    }
    if (source is Iterable) {
      final result = <Object?>[];
      for (final item in source.take(50)) {
        result.add(value(item, depth: depth + 1));
        if (_remainingCharacters <= 0) break;
      }
      return result;
    }
    return text(source.toString(), maxLength: 1000);
  }
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
