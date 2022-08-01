part of masamune_purchase_stripe;

class StripeConnectAlreadyRegisteredException implements Exception {
  StripeConnectAlreadyRegisteredException([this.message]);
  final Object? message;

  @override
  String toString() {
    final message = this.message;
    if (message == null) {
      return "StripeConnectAlreadyRegisteredException";
    }
    return "StripeConnectAlreadyRegisteredException: $message";
  }
}
