import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of stripe.mdc.
///
/// stripe.mdcの中身。
class PluginStripeMdcCliAiCode extends PluginUsageCliAiCode {
  /// Contents of stripe.mdc.
  ///
  /// stripe.mdcの中身。
  const PluginStripeMdcCliAiCode();

  @override
  String get name => "Stripe決済";

  @override
  String get description => "`Stripe決済`の利用方法";

  @override
  String get globs => "katana.yaml, lib/adapter.dart";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`Stripe決済`は金額をシステム側で決定する決済やユーザー間での決済を利用する場合の機能を提供するプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`Stripe決済`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Configure billing settings for Stripe.
    # Stripeの課金設定を行います。
    stripe:
      # Set to `true` if you use Stripe.
      # Stripeを利用する場合は`true`にしてください。
      enable: true # Stripe決済を利用する場合false -> trueに変更

      # Set to `true` if you use Stripe Connect.
      # Stripeコネクトを利用する場合は`true`にしてください。
      enable_connect: false

      # Secret key for Stripe's API.
      # You can obtain keys for the test and production environments at the following URLs
      # StripeのAPI用シークレットキー。
      # 下記のURLからテスト環境用と本番環境用のキーを取得できます。
      # Production environment
      # https://dashboard.stripe.com/apikeys
      # Development enveironment
      # https://dashboard.stripe.com/test/apikeys
      secret_key: # StripeのAPIキーを記載。

      # URL scheme for returning from Stripe's WebView.
      # It must be set to the same settings as the application side.
      # StripeのWebViewから戻る際のURLスキーム。
      # アプリ側と同じ設定にする必要があります。
      url_scheme: # URLスキームを記載。

      # Specify the email provider for use with Stripe's 3D Secure authentication.
      # Specify `sendgrid` if you use SendGrid or `gmail` if you use Gmail.
      # Also, please set up various e-mail settings.
      # Stripeの3Dセキュア認証で利用するためのメールプロバイダーを指定します。
      # SendGridを利用する場合は`sendgrid`、Gmailを利用する場合は`gmail`を指定してください。
      # また、各種メールの設定を行ってください。
      email_provider: sendgrid

      # Set up a redirect page for 3D Secure.
      # Under each language code, [success] and [failure] should include the URL for success and failure.
      # Adding a language code allows you to include the URL for that language.
      # 3Dセキュア用のリダイレクトページを設定します。
      # 各言語コードの下に[success]と[failure]には成功時、失敗時のURLを記載してください。
      # 言語コードを追加するとその言語のURLを記載することができます。
      three_d_secure_redirect_page:
        en:
          success: # 成功時のURLを記載。
          failure: # 失敗時のURLを記載。
        ja:
          success: # 成功時のURLを記載。
          failure: # 失敗時のURLを記載。
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`MasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Stripe決済のアダプターを追加。
        const StripeMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// Stripe決済のコントローラーを取得。
final stripe = ref.app.controller(Stripe.query());

// カード情報を登録。
final card = await stripe.createCard(
  // カード番号。
  number: "4242424242424242",
  // 有効期限（月）。
  expMonth: 12,
  // 有効期限（年）。
  expYear: 2025,
  // セキュリティコード。
  cvc: "123",
);

// 支払いを実行。
final payment = await stripe.createPayment(
  // 支払い金額（円）。
  amount: 1000,
  // 通貨。
  currency: "jpy",
  // カードID。
  cardId: card.id,
  // 支払いの説明。
  description: "テスト決済",
);

// 支払いが完了したかどうかを確認。
if (payment.status == StripePaymentStatus.succeeded) {
  // 支払いが完了した場合の処理。
  print("Payment completed");
}

// 支払い履歴を取得。
final history = await stripe.getPaymentHistory();
for (final payment in history) {
  print("Payment ID: \${payment.id}");
  print("Amount: \${payment.amount}");
  print("Status: \${payment.status}");
}

// 定期支払いを作成。
final subscription = await stripe.createSubscription(
  // プランID。
  planId: "plan_1",
  // カードID。
  cardId: card.id,
);

// 定期支払いをキャンセル。
await stripe.cancelSubscription(subscription.id);

// Stripe Connectを利用して他のユーザーに支払いを行う。
final transfer = await stripe.createTransfer(
  // 支払い金額（円）。
  amount: 1000,
  // 通貨。
  currency: "jpy",
  // 支払い先のStripe ConnectのアカウントID。
  destinationAccountId: "acct_1234567890",
);
```
""";
  }
}
