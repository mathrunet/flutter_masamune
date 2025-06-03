part of "/masamune_purchase_stripe.dart";

/// Passed if the stripe account is already registered [Exception].
///
/// ストライプのアカウントがすでに登録済みの場合に渡される[Exception]。
class StripeAlreadyRegisteredException implements Exception {
  /// Passed if the stripe account is already registered [Exception].
  ///
  /// ストライプのアカウントがすでに登録済みの場合に渡される[Exception]。
  StripeAlreadyRegisteredException([this.message]);

  /// Error message.
  ///
  /// エラーメッセージ。
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
