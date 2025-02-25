part of '/masamune_ai.dart';

/// The exception that occurs when the AI role is invalid.
///
/// AIの役割が無効な場合に発生する例外。
class InvalidAIRoleException implements Exception {
  /// The exception that occurs when the AI role is invalid.
  ///
  /// AIの役割が無効な場合に発生する例外。
  const InvalidAIRoleException([this.message]);

  /// The message of the exception.
  ///
  /// 例外のメッセージ。
  final String? message;

  @override
  String toString() {
    return "$runtimeType: $message";
  }
}
