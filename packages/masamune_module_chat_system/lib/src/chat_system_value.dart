part of '/masamune_module_chat_system.dart';

/// Value class for chat system.
///
/// チャットシステム用の値クラス。
class ChatSystemValue {
  /// Value class for chat system.
  ///
  /// チャットシステム用の値クラス。
  ChatSystemValue({
    required this.id,
    required this.role,
  });

  /// ID for the chat system.
  ///
  /// チャットシステム用のID。
  final String id;

  /// Role of Chat.
  ///
  /// チャットの役割。
  final ChatSystemRole role;

  /// Text for chat.
  ///
  /// チャット用のテキスト。
  String get text => _text ?? "";
  String? _text;

  /// Display text for chat.
  ///
  /// チャット用の表示テキスト。
  String get displayText => _displayText ?? text;
  String? _displayText;

  /// `true` if currently waiting to be read.
  ///
  /// 現在読み込み待ちの場合`true`。
  bool get waiting => _text == null;

  /// Submission Date.
  ///
  /// 投稿日時。
  DateTime get time => _time ?? DateTime.now();
  DateTime? _time;

  void _set({required String text, DateTime? time}) {
    _text = text;
    _time = time;
  }

  void _error([String? message]) {
    _text = message ?? "ERROR";
    _time = DateTime.now();
  }
}
