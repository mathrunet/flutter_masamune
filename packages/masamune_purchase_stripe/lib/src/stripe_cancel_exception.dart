part of masamune_purchase_stripe;

class StripeCancelException implements Exception {
  StripeCancelException([this.message]);
  final Object? message;

  @override
  String toString() {
    final message = this.message;
    if (message == null) {
      return "StripeCancelException";
    }
    return "StripeCancelException: $message";
  }
}
