part of masamune_firebase;

/// Class for handling Firebase analytics.
@immutable
class FirebaseAnalyticsCore {
  const FirebaseAnalyticsCore._();

  static FirebaseAnalytics get _analytics {
    return FirebaseAnalytics.instance;
  }

  /// Page Observer.
  static final NavigatorObserver observer = DefaultFirebaseAnalyticsObserver();

  /// Send an event.
  ///
  /// Enter the event name in [eventName] and define the data in [parameter].
  static Future<void> sendEvent({
    required String eventName,
    DynamicMap parameter = const {},
  }) async {
    return _analytics.logEvent(name: eventName, parameters: parameter);
  }
}

/// A [NavigatorObserver] that sends events to Firebase Analytics when the
/// currently active [ModalRoute] changes.
///
/// When a route is pushed or popped, and if [routeFilter] is true,
/// [nameExtractor] is used to extract a name  from [RouteSettings] of the now
/// active route and that name is sent to Firebase.
///
/// The following operations will result in sending a screen view event:
/// ```dart
/// Navigator.pushNamed(context, '/contact/123');
///
/// Navigator.push<void>(context, MaterialPageRoute(
///   settings: RouteSettings(name: '/contact/123'),
///   builder: (_) => ContactDetail(123)));
///
/// Navigator.pushReplacement<void>(context, MaterialPageRoute(
///   settings: RouteSettings(name: '/contact/123'),
///   builder: (_) => ContactDetail(123)));
///
/// Navigator.pop(context);
/// ```
///
/// To use it, add it to the `navigatorObservers` of your [Navigator], e.g. if
/// you're using a [MaterialApp]:
/// ```dart
/// MaterialApp(
///   home: MyAppHome(),
///   navigatorObservers: [
///     FirebaseAnalyticsObserver(analytics: service.analytics),
///   ],
/// );
/// ```
///
/// You can also track screen views within your [ModalRoute] by implementing
/// [RouteAware<ModalRoute<dynamic>>] and subscribing it to [FirebaseAnalyticsObserver]. See the
/// [RouteObserver<ModalRoute<dynamic>>] docs for an example.
class DefaultFirebaseAnalyticsObserver
    extends RouteObserver<ModalRoute<dynamic>> {
  /// Creates a [NavigatorObserver] that sends events to [FirebaseAnalytics].
  ///
  /// When a route is pushed or popped, [nameExtractor] is used to extract a
  /// name from [RouteSettings] of the now active route and that name is sent to
  /// Firebase. Defaults to `defaultNameExtractor`.
  ///
  /// If a [PlatformException] is thrown while the observer attempts to send the
  /// active route to [analytics], `onError` will be called with the
  /// exception. If `onError` is omitted, the exception will be printed using
  /// `debugPrint()`.
  DefaultFirebaseAnalyticsObserver({
    this.nameExtractor = defaultNameExtractor,
    this.routeFilter = defaultRouteFilter,
    Function(PlatformException error)? onError,
  }) : _onError = onError;

  final ScreenNameExtractor nameExtractor;
  final RouteFilter routeFilter;
  final void Function(PlatformException error)? _onError;

  Future<void> _sendScreenView(Route<dynamic> route) async {
    final String? screenName = nameExtractor(route.settings);
    if (screenName != null) {
      await FirebaseCore.initialize();
      FirebaseAnalytics.instance
          .setCurrentScreen(screenName: screenName)
          .catchError(
        (Object error) {
          final _onError = this._onError;
          if (_onError == null) {
            debugPrint('$FirebaseAnalyticsObserver: $error');
          } else {
            _onError(error as PlatformException);
          }
        },
        test: (Object error) => error is PlatformException,
      );
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (routeFilter(route)) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && routeFilter(newRoute)) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null &&
        routeFilter(previousRoute) &&
        routeFilter(route)) {
      _sendScreenView(previousRoute);
    }
  }
}
