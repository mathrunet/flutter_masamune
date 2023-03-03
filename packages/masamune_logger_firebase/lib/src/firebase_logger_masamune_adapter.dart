part of masamune_logger_firebase;

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
    this.options,
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
    FirebasePerformance? performance,
    List<LoggerAdapter> loggerAdapters = const [],
  })  : _analytics = analytics,
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

  /// [FirebaseOptions] set.
  ///
  /// 設定されている[FirebaseOptions]。
  final FirebaseOptions? options;

  @override
  final bool runZonedGuarded = true;

  @override
  FutureOr<void> onPreRunApp() async {
    await FirebaseCore.initialize(options: options);
    if (!kIsWeb) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FirebaseLoggerMasamuneAdapter>(
      adapter: this,
      onInit: onInitScope,
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
  List<LoggerAdapter> get loggerAdapters => [
        FirebaseLoggerAdapter(
          options: options,
          analytics: analytics,
          crashlytics: crashlytics,
          performance: performance,
        ),
      ];
}
