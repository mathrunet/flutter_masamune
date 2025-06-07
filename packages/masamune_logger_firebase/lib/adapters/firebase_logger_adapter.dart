part of "/masamune_logger_firebase.dart";

/// Firebase Analytics and Performance are available [LoggerAdapter].
///
/// Firebase settings can be specified by passing [options].
///
/// You can specify instances of [FirebaseAnalytics], [FirebaseCrashlytics] or [FirebasePerformance] by passing [analytics], [crashlytics] or [performance].
///
/// FirebaseのAnalyticsとPerformanceを利用できる[LoggerAdapter]。
///
/// [options]を渡すとFirebaseの設定を指定することが可能です。
///
/// [analytics]や[crashlytics]、[performance]を渡すと[FirebaseAnalytics]や[FirebaseCrashlytics]、[FirebasePerformance]のインスタンスを指定可能です。
class FirebaseLoggerAdapter extends LoggerAdapter {
  /// Firebase Analytics and Performance are available [LoggerAdapter].
  ///
  /// Firebase settings can be specified by passing [options].
  ///
  /// You can specify instances of [FirebaseAnalytics], [FirebaseCrashlytics] or [FirebasePerformance] by passing [analytics], [crashlytics] or [performance].
  ///
  /// FirebaseのAnalyticsとPerformanceを利用できる[LoggerAdapter]。
  ///
  /// [options]を渡すとFirebaseの設定を指定することが可能です。
  ///
  /// [analytics]や[crashlytics]、[performance]を渡すと[FirebaseAnalytics]や[FirebaseCrashlytics]、[FirebasePerformance]のインスタンスを指定可能です。
  const FirebaseLoggerAdapter({
    this.options,
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
    FirebasePerformance? performance,
  })  : _analytics = analytics,
        _crashlytics = crashlytics,
        _performance = performance;

  /// [FirebaseOptions] set.
  ///
  /// 設定されている[FirebaseOptions]。
  final FirebaseOptions? options;

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

  /// Intentionally crashes.
  ///
  /// Please use it to send events to FirebaseCrashlytics.
  ///
  /// 意図的にクラッシュさせます。
  ///
  /// FirebaseCrashlyticsにイベントを送る際にご利用ください。
  void crash() {
    crashlytics.crash();
  }

  @override
  Future<List<LogValue>> logList() => Future.value([]);

  @override
  Future<void> send(String name, {DynamicMap? parameters}) async {
    if (name == RouteLoggerEvent.push.toString()) {
      final route = parameters.get(RouteLoggerEvent.newRouteKey, "");
      try {
        await analytics.logScreenView(screenName: route);
      } catch (e) {
        debugPrint(e.toString());
      }
    } else if (name == RouteLoggerEvent.pop.toString()) {
      final route = parameters.get(RouteLoggerEvent.newRouteKey, "");
      try {
        await analytics.logScreenView(screenName: route);
      } catch (e) {
        debugPrint(e.toString());
      }
    } else if (name == RouteLoggerEvent.replace.toString()) {
      final route = parameters.get(RouteLoggerEvent.newRouteKey, "");
      try {
        await analytics.logScreenView(screenName: route);
      } catch (e) {
        debugPrint(e.toString());
      }
    } else if (name == AuthLoggerEvent.register.toString()) {
      final userId = parameters.get(AuthLoggerEvent.userIdKey, "");
      final providerId = parameters.get(AuthLoggerEvent.providerKey, "");
      await analytics.logSignUp(signUpMethod: providerId);
      await analytics.setUserId(id: userId);
    } else if (name == AuthLoggerEvent.registerOrSignIn.toString()) {
      final userId = parameters.get(AuthLoggerEvent.userIdKey, "");
      final providerId = parameters.get(AuthLoggerEvent.providerKey, "");
      await analytics.logSignUp(signUpMethod: providerId);
      await analytics.logLogin(loginMethod: providerId);
      await analytics.setUserId(id: userId);
    } else if (name == AuthLoggerEvent.signIn.toString()) {
      final userId = parameters.get(AuthLoggerEvent.userIdKey, "");
      final providerId = parameters.get(AuthLoggerEvent.providerKey, "");
      await analytics.logLogin(loginMethod: providerId);
      await analytics.setUserId(id: userId);
    } else if (name == FirebaseAnalyticsLoggerEvent.adShown.toString()) {
      final platform = parameters.get(
          FirebaseAnalyticsLoggerEvent.platformKey, nullOfString);
      final source =
          parameters.get(FirebaseAnalyticsLoggerEvent.sourceKey, nullOfString);
      final format =
          parameters.get(FirebaseAnalyticsLoggerEvent.formatKey, nullOfString);
      final id = parameters.get(FirebaseAnalyticsLoggerEvent.idKey, "");
      final value =
          parameters.get(FirebaseAnalyticsLoggerEvent.valueKey, nullOfDouble);
      final currency = parameters.get(
          FirebaseAnalyticsLoggerEvent.currencyKey, nullOfString);
      await analytics.logAdImpression(
        adPlatform: platform,
        adSource: source,
        adFormat: format,
        adUnitName: id,
        value: value,
        currency: currency,
      );
    } else if (name == FirebaseAnalyticsLoggerEvent.purchased.toString()) {
      final products = parameters
          .getAsList<DynamicMap>(FirebaseAnalyticsLoggerEvent.productsKey);
      final value =
          parameters.get(FirebaseAnalyticsLoggerEvent.priceKey, nullOfDouble);
      final currency = parameters.get(
          FirebaseAnalyticsLoggerEvent.currencyKey, nullOfString);
      final transactionId = parameters.get(
          FirebaseAnalyticsLoggerEvent.transactionIdKey, nullOfString);
      await analytics.logPurchase(
        currency: currency,
        value: value,
        transactionId: transactionId,
        items: products
            .map(
              (e) => AnalyticsEventItem(
                itemId: e.get(FirebaseAnalyticsLoggerEvent.idKey, ""),
                itemName:
                    e.get(FirebaseAnalyticsLoggerEvent.nameKey, nullOfString),
                itemCategory: e.get(
                    FirebaseAnalyticsLoggerEvent.categoryKey, nullOfString),
                currency: parameters.get(
                    FirebaseAnalyticsLoggerEvent.currencyKey, nullOfString),
                price: e.get(FirebaseAnalyticsLoggerEvent.priceKey, 0.0),
                quantity: e.get(FirebaseAnalyticsLoggerEvent.quantityKey, 1),
              ),
            )
            .toList(),
      );
    } else if (name == FirebaseAnalyticsLoggerEvent.refund.toString()) {
      final products = parameters
          .getAsList<DynamicMap>(FirebaseAnalyticsLoggerEvent.productsKey);
      final value =
          parameters.get(FirebaseAnalyticsLoggerEvent.priceKey, nullOfDouble);
      final currency = parameters.get(
          FirebaseAnalyticsLoggerEvent.currencyKey, nullOfString);
      final transactionId = parameters.get(
          FirebaseAnalyticsLoggerEvent.transactionIdKey, nullOfString);
      await analytics.logRefund(
        currency: currency,
        value: value,
        transactionId: transactionId,
        items: products
            .map(
              (e) => AnalyticsEventItem(
                itemId: e.get(FirebaseAnalyticsLoggerEvent.idKey, ""),
                itemName:
                    e.get(FirebaseAnalyticsLoggerEvent.nameKey, nullOfString),
                itemCategory: e.get(
                    FirebaseAnalyticsLoggerEvent.categoryKey, nullOfString),
                currency: parameters.get(
                    FirebaseAnalyticsLoggerEvent.currencyKey, nullOfString),
                price: e.get(FirebaseAnalyticsLoggerEvent.priceKey, 0.0),
                quantity: e.get(FirebaseAnalyticsLoggerEvent.quantityKey, 1),
              ),
            )
            .toList(),
      );
    } else if (name == FirebaseAnalyticsLoggerEvent.tutorialStart.toString()) {
      await analytics.logTutorialBegin();
    } else if (name == FirebaseAnalyticsLoggerEvent.tutorialEnd.toString()) {
      await analytics.logTutorialComplete();
    }
  }

  @override
  LoggerTraceValue trace(String name) {
    return _FirebaseLoggerTraceValue._(name, this, performance.newTrace(name));
  }
}

class _FirebaseLoggerTraceValue extends LoggerTraceValue {
  _FirebaseLoggerTraceValue._(super.name, super.adapter, this.trace);
  final Trace trace;

  @override
  Future<void> start(DateTime startTime) {
    return trace.start();
  }

  @override
  Future<void> stop(DateTime startTime, DateTime endTime) {
    return trace.stop();
  }
}
