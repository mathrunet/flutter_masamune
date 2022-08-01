part of masamune_location;

class MobileLocationAdapter extends LocationAdapter {
  @override
  bool get isListened => LocationCore.isListened;

  @override
  bool get isPermitted => LocationCore.isPermitted;

  @override
  Future<void> listen({
    Duration? updateInterval,
    Duration timeout = const Duration(seconds: 60),
  }) {
    return LocationCore.listen(
      updateInterval: updateInterval,
      timeout: timeout,
    );
  }

  @override
  void unlisten() {
    LocationCore.unlisten();
  }

  @override
  LocationCompassData get location => LocationCore.location;

  @override
  void addListener(VoidCallback callback) {
    LocationCore.addListener(callback);
  }

  @override
  void removeListener(VoidCallback callback) {
    LocationCore.removeListener(callback);
  }
}
