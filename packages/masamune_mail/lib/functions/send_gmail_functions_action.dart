part of '/masamune_mail.dart';

/// [FunctionsAction] for sending Gmail from the server side.
///
/// Gmailをサーバー側から送るための[FunctionsAction]。
///
/// {@macro functions_action}
class SendGmailFunctionsAction
    extends FunctionsAction<SendGmailFunctionsActionFunctionsActionResponse> {
  /// [FunctionsAction] for sending Gmail from the server side.
  ///
  /// Gmailをサーバー側から送るための[FunctionsAction]。
  ///
  /// {@macro functions_action}
  const SendGmailFunctionsAction({
    required this.from,
    required this.to,
    required this.title,
    required this.content,
  });

  /// The address from which the email was sent.
  ///
  /// メールの送信元アドレス。
  final String from;

  /// The address to which the email is sent.
  ///
  /// メールの送信先アドレス。
  final String to;

  /// Email Title.
  ///
  /// メールのタイトル。
  final String title;

  /// Email Content.
  ///
  /// メールの内容。
  final String content;

  @override
  String get action => "gmail";

  @override
  DynamicMap? toMap() {
    return {
      "from": from,
      "to": to,
      "title": title,
      "content": content,
    };
  }

  @override
  SendGmailFunctionsActionFunctionsActionResponse toResponse(DynamicMap map) {
    return const SendGmailFunctionsActionFunctionsActionResponse();
  }
}

/// [FunctionsAction] response to send Gmail from the server side.
///
/// Gmailをサーバー側から送るための[FunctionsAction]のレスポンス。
class SendGmailFunctionsActionFunctionsActionResponse
    extends FunctionsActionResponse {
  /// [FunctionsAction] response to send Gmail from the server side.
  ///
  /// Gmailをサーバー側から送るための[FunctionsAction]のレスポンス。
  const SendGmailFunctionsActionFunctionsActionResponse();
}
