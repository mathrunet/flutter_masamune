part of '/masamune_picker.dart';

/// Exception thrown when permission is denied.
///
/// 権限が拒否された場合にスローされる例外。
class MasamunePickerPermissionDeniedException implements Exception {
  /// Exception thrown when permission is denied.
  ///
  /// 権限が拒否された場合にスローされる例外。
  const MasamunePickerPermissionDeniedException([this.message]);

  /// The message of the exception.
  ///
  /// 例外のメッセージ。
  final String? message;

  @override
  String toString() => "Permission denied: $message";
}
