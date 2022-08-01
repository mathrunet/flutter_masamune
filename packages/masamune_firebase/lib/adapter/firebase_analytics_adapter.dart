part of masamune_firebase;

@immutable
class FirebaseAnalyticsAdapter extends AnalyticsAdapter {
  const FirebaseAnalyticsAdapter({
    this.prefix = "",
  });

  final String prefix;

  @override
  NavigatorObserver? get observer => FirebaseAnalyticsCore.observer;

  @override
  Future<void> sendEvent({
    required String eventName,
    DynamicMap parameter = const {},
  }) {
    return FirebaseAnalyticsCore.sendEvent(
      eventName: "$prefix$eventName",
      parameter: parameter,
    );
  }
}
