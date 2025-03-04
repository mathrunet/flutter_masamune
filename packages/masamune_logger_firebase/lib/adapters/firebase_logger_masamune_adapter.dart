part of '/masamune_logger_firebase.dart';

/// [MasamuneAdapter] for using Firebase Crashlytics and Firebase Analytics.
///
/// As for Firebase Crashlytics, it is configured to supplement errors during app crashes (including in and out of Flutter).
///
/// As for Firebase Analytics, we will pass a [FirebaseLoggerAdapter] to log screen transitions and events.
///
/// Firebase settings can be specified by passing [options].
///
/// You can specify instances of [FirebaseAnalytics], [FirebaseCrashlytics] or [FirebasePerformance] by passing [analytics], [crashlytics] or [performance].
///
/// Firebase CrashlyticsとFirebase Analyticsを利用するための[MasamuneAdapter]。
///
/// Firebase Crashlyticsに関してはアプリクラッシュ時（Flutter内外含む）のエラーを補足するように設定を行います。
///
/// Firebase Analyticsに関しては、[FirebaseLoggerAdapter]を渡すようにし、画面遷移やイベントをロギングします。
///
/// [options]を渡すとFirebaseの設定を指定することが可能です。
///
/// [analytics]や[crashlytics]、[performance]を渡すと[FirebaseAnalytics]や[FirebaseCrashlytics]、[FirebasePerformance]のインスタンスを指定可能です。
class FirebaseLoggerMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for using Firebase Crashlytics and Firebase Analytics.
  ///
  /// As for Firebase Crashlytics, it is configured to supplement errors during app crashes (including in and out of Flutter).
  ///
  /// As for Firebase Analytics, we will pass a [FirebaseLoggerAdapter] to log screen transitions and events.
  ///
  /// Firebase settings can be specified by passing [options].
  ///
  /// You can specify instances of [FirebaseAnalytics], [FirebaseCrashlytics] or [FirebasePerformance] by passing [analytics], [crashlytics] or [performance].
  ///
  /// Firebase CrashlyticsとFirebase Analyticsを利用するための[MasamuneAdapter]。
  ///
  /// Firebase Crashlyticsに関してはアプリクラッシュ時（Flutter内外含む）のエラーを補足するように設定を行います。
  ///
  /// Firebase Analyticsに関しては、[FirebaseLoggerAdapter]を渡すようにし、画面遷移やイベントをロギングします。
  ///
  /// [options]を渡すとFirebaseの設定を指定することが可能です。
  ///
  /// [analytics]や[crashlytics]、[performance]を渡すと[FirebaseAnalytics]や[FirebaseCrashlytics]、[FirebasePerformance]のインスタンスを指定可能です。
  const FirebaseLoggerMasamuneAdapter({
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.linuxOptions,
    this.windowsOptions,
    this.macosOptions,
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
    FirebasePerformance? performance,
    List<LoggerAdapter> loggerAdapters = const [],
  })  : _analytics = analytics,
        _options = options,
        _crashlytics = crashlytics,
        _performance = performance;

  /// The instance of [FirebaseAnalytics] to be used.
  ///
  /// 使用する[FirebaseAnalytics]のインスタンス。
  FirebaseAnalytics get analytics {
    return _analytics ?? FirebaseAnalytics.instance;
  }

  final FirebaseAnalytics? _analytics;

  /// The instance of [FirebaseCrashlytics] to be used.
  ///
  /// 使用する[FirebaseCrashlytics]のインスタンス。
  FirebaseCrashlytics get crashlytics {
    return _crashlytics ?? FirebaseCrashlytics.instance;
  }

  final FirebaseCrashlytics? _crashlytics;

  /// The instance of [FirebaseCrashlytics] to be used.
  ///
  /// 使用する[FirebasePerformance]のインスタンス。
  FirebasePerformance get performance {
    return _performance ?? FirebasePerformance.instance;
  }

  final FirebasePerformance? _performance;

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  @override
  final bool runZonedGuarded = true;

  @override
  double get priority => 10.0;

  @override
  FutureOr<void> onPreRunApp(WidgetsBinding binding) async {
    await FirebaseCore.initialize(options: options);
    if (!kIsWeb) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
    return super.onPreRunApp(binding);
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FirebaseLoggerMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  List<NavigatorObserver> get navigatorObservers => [
        FirebaseAnalyticsObserver(analytics: analytics),
      ];

  @override
  List<LoggerAdapter> get loggerAdapters => [
        FirebaseLoggerAdapter(
          options: options,
          analytics: analytics,
          crashlytics: crashlytics,
          performance: performance,
        ),
      ];
}
