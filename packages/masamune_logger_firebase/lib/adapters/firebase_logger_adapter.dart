part of "/masamune_logger_firebase.dart";

/// Firebase Analytics and Performance are available [LoggerAdapter].
///
/// Firebase settings can be specified by passing [options].
///
/// You can specify instances of [FirebaseAnalytics], [FirebaseCrashlytics] or [FirebasePerformance] by passing [analytics], [crashlytics] or [performance].
///
class FirebaseLoggerAdapter extends LoggerAdapter {
  /// Firebase Analytics and Performance are available [LoggerAdapter].
  ///
  /// Firebase settings can be specified by passing [options].
  ///
  /// You can specify instances of [FirebaseAnalytics], [FirebaseCrashlytics] or [FirebasePerformance] by passing [analytics], [crashlytics] or [performance].
  ///
  const FirebaseLoggerAdapter({
    this.options,
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
    FirebasePerformance? performance,
  })  : _analytics = analytics,
        _crashlytics = crashlytics,
        _performance = performance;

  /// [FirebaseOptions] set.
  final FirebaseOptions? options;

  /// The instance of [FirebaseAnalytics] to be used.
  FirebaseAnalytics get analytics {
    return _analytics ?? FirebaseAnalytics.instance;
  }

  final FirebaseAnalytics? _analytics;

  /// The instance of [FirebaseCrashlytics] to be used.
  FirebaseCrashlytics get crashlytics {
    return _crashlytics ?? FirebaseCrashlytics.instance;
  }

  final FirebaseCrashlytics? _crashlytics;

  /// The instance of [FirebaseCrashlytics] to be used.
  FirebasePerformance get performance {
    return _performance ?? FirebasePerformance.instance;
  }

  final FirebasePerformance? _performance;

  /// Intentionally crashes.
  ///
  /// Please use it to send events to FirebaseCrashlytics.
  ///
  void crash() {
    crashlytics.crash();
  }

  @override
  Future<List<LogValue>> logList() => Future.value([]);

  /// Report caught errors to Crashlytics without treating them as custom events.
  @override
  Future<void> error(
    Object exception,
    StackTrace? stackTrace, {
    String? name,
    DynamicMap? parameters,
  }) =>
      crashlytics.recordError(exception, stackTrace, reason: name);

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
    } else {
      _validateCustomName(name, "event");
      if ((parameters?.length ?? 0) > 25) {
        throw ArgumentError.value(parameters?.length, "parameters",
            "At most 25 event parameters are supported.");
      }
      final values = <String, Object>{};
      for (final entry in (parameters ?? <String, dynamic>{}).entries) {
        _validateCustomName(entry.key, "parameter");
        final value = entry.value;
        if (value is String) {
          if (value.length > 100) {
            throw ArgumentError.value(entry.key, "parameters",
                "String values must be at most 100 characters.");
          }
        } else if (value is! num || !value.isFinite) {
          throw ArgumentError.value(entry.key, "parameters",
              "Values must be strings or finite numbers.");
        }
        values[entry.key] = value as Object;
      }
      await analytics.logEvent(
          name: name, parameters: values.isEmpty ? null : values);
    }
  }

  static void _validateCustomName(String name, String label) {
    if (!RegExp(r"^[A-Za-z][A-Za-z0-9_]{0,39}$").hasMatch(name) ||
        name.startsWith("firebase_") ||
        name.startsWith("google_") ||
        name.startsWith("ga_")) {
      throw ArgumentError.value(name, label,
          "Use 1-40 letters, digits or underscores, starting with a letter and without reserved prefixes.");
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
