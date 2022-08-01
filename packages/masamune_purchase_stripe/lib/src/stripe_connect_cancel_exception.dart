part of masamune_purchase_stripe;

class StripeConnectCancelException implements Exception {
  StripeConnectCancelException([this.message]);
  final Object? message;

  @override
  String toString() {
    final message = this.message;
    if (message == null) {
      return "StripeConnectCancelException";
    }
    return "StripeConnectCancelException: $message";
  }
}
