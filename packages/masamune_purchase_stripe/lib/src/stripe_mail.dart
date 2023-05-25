part of masamune_purchase_stripe;

@immutable
class StripeMail {
  const StripeMail({
    required this.title,
    required this.from,
    this.to,
    required this.content,
  });

  final String title;
  final String from;
  final String? to;
  final String content;
}
