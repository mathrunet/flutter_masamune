part of '/masamune_purchase_stripe.dart';

/// Passed if the processing of a stripe is canceled [Exception].
///
/// ストライプの処理がキャンセルされた場合に渡される[Exception]。
class StripeCancelException implements Exception {
  /// Passed if the processing of a stripe is canceled [Exception].
  ///
  /// ストライプの処理がキャンセルされた場合に渡される[Exception]。
  StripeCancelException([this.message]);

  /// Error message.
  ///
  /// エラーメッセージ。
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
