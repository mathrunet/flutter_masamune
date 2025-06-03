part of "/masamune_mail.dart";

/// [FunctionsAction] for sending mail from the server side via Sendgrid.
///
/// メールをSendgrid経由でサーバー側から送るための[FunctionsAction]。
///
/// {@macro functions_action}
class SendGridFunctionsAction
    extends FunctionsAction<SendGridFunctionsActionFunctionsActionResponse> {
  /// [FunctionsAction] for sending mail from the server side via Sendgrid.
  ///
  /// メールをSendgrid経由でサーバー側から送るための[FunctionsAction]。
  ///
  /// {@macro functions_action}
  const SendGridFunctionsAction({
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
  String get action => "send_grid";

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
  SendGridFunctionsActionFunctionsActionResponse toResponse(DynamicMap map) {
    return const SendGridFunctionsActionFunctionsActionResponse();
  }
}

/// Response to [FunctionsAction] to send mail from the server side via Sendgrid.
///
/// メールをSendgrid経由でサーバー側から送るための[FunctionsAction]のレスポンス。
class SendGridFunctionsActionFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response to [FunctionsAction] to send mail from the server side via Sendgrid.
  ///
  /// メールをSendgrid経由でサーバー側から送るための[FunctionsAction]のレスポンス。
  const SendGridFunctionsActionFunctionsActionResponse();
}
