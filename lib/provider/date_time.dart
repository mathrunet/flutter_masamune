part of masamune;

/// The provider of the DateTime.
AutoDisposeProviderFamily<DateTime, DateTime> dateTimeProvider() {
  return AutoDisposeProviderFamily<DateTime, DateTime>((_, dateTime) {
    return dateTime;
  });
}
