part of "/masamune_purchase_stripe.dart";

/// Defines the mail settings for the stripe.
///
/// ストライプのメールの設定を定義します。
@immutable
class StripeMail {
  /// Defines the mail settings for the stripe.
  ///
  /// ストライプのメールの設定を定義します。
  const StripeMail({
    required this.title,
    required this.from,
    this.to,
    required this.content,
  });

  /// Email Title.
  ///
  /// メールタイトル。
  final String title;

  /// The email address of the sender.
  ///
  /// 送信元のメールアドレス。
  final String from;

  /// The email address of the recipient.
  ///
  /// 送信先のメールアドレス。
  final String? to;

  /// Email Content.
  ///
  /// メールコンテンツ。
  final String content;
}
