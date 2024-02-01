part of '/masamune_module_chat_system.dart';

/// Chat system status.
///
/// チャットシステムのステータス。
enum ChatSystemStatus {
  /// Idle state.
  ///
  /// アイドル状態。
  idle,

  /// AI is thinking.
  ///
  /// AIが考え中。
  aiThink,

  /// AI is speaking.
  ///
  /// AIが話している。
  aiSpeak,

  /// User speaks.
  ///
  /// ユーザーが話している。
  personSpeak,

  /// Waiting for user input.
  ///
  /// ユーザーの入力待ち。
  personWait,

  /// After the user's utterance.
  ///
  /// ユーザーの発話後。
  personSpoke,

  /// End of conversation.
  ///
  /// 会話の終了。
  finished;
}
