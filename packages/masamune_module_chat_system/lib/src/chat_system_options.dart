part of '/masamune_module_chat_system.dart';

/// Options for the chat itself.
///
/// チャット自体のオプション。
@immutable
class ChatSystemOptions {
  const ChatSystemOptions({
    this.assistantId,
    this.autoListenFromPerson = true,
    this.instruction,
    this.locale,
    this.firstMessage,
  });

  /// Assistant ID.
  ///
  /// アシスタントID。
  final String? assistantId;

  /// true` if you want to wait for the user to speak automatically after the AI speaks.
  ///
  /// AIが話した後に自動でユーザーの発話を待つ場合は`true`。
  final bool autoListenFromPerson;

  /// Specifies the first instruction.
  ///
  /// 最初の命令を指定します。
  final String? instruction;

  /// Specifies the locale.
  ///
  /// ロケールを指定します。
  final Locale? locale;

  /// Specifies the first message.
  ///
  /// 最初のメッセージを指定します。
  final String? firstMessage;

  @override
  int get hashCode =>
      assistantId.hashCode ^
      autoListenFromPerson.hashCode ^
      instruction.hashCode ^
      locale.hashCode ^
      firstMessage.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
