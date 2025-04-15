part of '/masamune_ai.dart';

/// The role of the AI.
///
/// AIの役割。
enum AIRole {
  /// The user role.
  ///
  /// ユーザーの役割。
  user,

  /// The model role.
  ///
  /// モデルの役割。
  model,

  /// The system role.
  ///
  /// システムの役割。
  system,

  /// The function role.
  ///
  /// 関数の役割。
  function;

  /// Returns the AI role from the string.
  ///
  /// 文字列からAIの役割を返します。
  static AIRole? fromString(String? value) {
    switch (value) {
      case "user":
        return user;
      case "model":
        return model;
      case "system":
        return system;
      case "function":
        return function;
      default:
        return null;
    }
  }
}
