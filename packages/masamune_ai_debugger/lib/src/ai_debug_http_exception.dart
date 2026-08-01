part of '/masamune_ai_debugger.dart';

/// HTTP failure returned by the AI debug API.
///
/// AIデバッグAPIから返されたHTTPエラー。
class AIDebugHttpException implements Exception {
  /// Creates an HTTP exception with [statusCode] and [message].
  ///
  /// [statusCode]と[message]を持つHTTP例外を作成します。
  const AIDebugHttpException(this.statusCode, this.message);

  /// HTTP status code returned by the API.
  ///
  /// APIから返されたHTTPステータスコード。
  final int statusCode;

  /// Error message returned by the API.
  ///
  /// APIから返されたエラーメッセージ。
  final String message;

  @override
  String toString() => "AIDebugHttpException($statusCode): $message";
}
