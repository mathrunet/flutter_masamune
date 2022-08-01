part of masamune_purchase_stripe;

enum StripeCurrency {
  usd,
  jpy,
}

extension StripeCurrencyExtensions on StripeCurrency {
  String get id {
    return toString().replaceAll("StripeCurrency.", "");
  }
}
