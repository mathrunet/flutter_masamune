part of masamune_purchase_stripe;

class StripeAlreadyRegisteredException implements Exception {
  StripeAlreadyRegisteredException([this.message]);
  final Object? message;

  @override
  String toString() {
    final message = this.message;
    if (message == null) {
      return "StripeAlreadyRegisteredException";
    }
    return "StripeAlreadyRegisteredException: $message";
  }
}
