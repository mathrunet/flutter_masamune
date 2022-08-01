part of katana_module;

/// Module adapter for setting up analytics.
///
/// [AnalyticsAdapter] can switch the data
/// when the module is used by passing it to [UIMaterialApp].
@immutable
abstract class AnalyticsAdapter extends AdapterModule {
  const AnalyticsAdapter();

  /// Page Observer.
  NavigatorObserver? get observer;

  /// Send an event.
  ///
  /// Enter the event name in [eventName] and define the data in [parameter].
  Future<void> sendEvent({
    required String eventName,
    DynamicMap parameter = const {},
  });
}
