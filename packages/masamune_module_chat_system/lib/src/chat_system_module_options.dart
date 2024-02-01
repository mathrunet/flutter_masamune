part of '/masamune_module_chat_system.dart';

/// Option to use [ChatSystemModule].
///
/// [ChatSystemModule]を利用するためのオプション。
@immutable
class ChatSystemModuleOptions extends ModuleOptions {
  /// Option to use [ChatSystemModule].
  ///
  /// [ChatSystemModule]を利用するためのオプション。
  const ChatSystemModuleOptions({
    this.defaultAssistantId,
    this.defaultInstruction,
    this.locale,
  });

  /// Assistant ID.
  ///
  /// アシスタントID。
  final String? defaultAssistantId;

  /// Specifies the first instruction.
  ///
  /// 最初の命令を指定します。
  final String? defaultInstruction;

  /// Specifies the locale.
  ///
  /// ロケールを指定します。
  final Locale? locale;

  @override
  int get hashCode =>
      defaultAssistantId.hashCode ^
      defaultInstruction.hashCode ^
      locale.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
