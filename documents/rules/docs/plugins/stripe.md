# Stripe決済

`Stripe決済`は下記のように利用する。

## 概要

`Stripe決済`はStripeを使用した柔軟な決済機能を提供するプラグイン。サーバー側で金額を決定する決済や、定期購読、3Dセキュア認証に対応。

バックエンドと連携してStripeの決済を処理し、購入履歴をデータベースに保存します。

**注意**: `masamune_purchase_stripe`パッケージはバックエンド連携(Cloud Functions等)が必要です。

## 設定方法

### katana.yamlを使用する場合(推奨)

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

      # Set to `true` if you want to apply Stripe settings.
      # Stripeの設定を適用する場合は`true`にしてください。
      apply_stripe_settings: false

      # Secret key for Stripe's API.
      # You can obtain keys for the test and production environments at the following URLs
      # StripeのAPI用シークレットキー。
      # 下記のURLからテスト環境用と本番環境用のキーを取得できます。
      # Production environment
      # https://dashboard.stripe.com/apikeys
      # Development enveironment
      # https://dashboard.stripe.com/test/apikeys
      secret_key: # StripeのAPIキーを記載

      # URL scheme for returning from Stripe's WebView.
      # It must be set to the same settings as the application side.
      # StripeのWebViewから戻る際のURLスキーム。
      # アプリ側と同じ設定にする必要があります。
      url_scheme: # URLスキーム(例: yourapp://stripe)を記載

      # Specify the email provider for use with Stripe's 3D Secure authentication.
      # Specify `sendgrid` if you use SendGrid.
      # Also, please set up various e-mail settings.
      # Stripeの3Dセキュア認証で利用するためのメールプロバイダーを指定します。
      # SendGridを利用する場合は`sendgrid`を指定してください。
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
          success: # 成功時のURL
          failure: # 失敗時のURL
        ja:
          success: # 成功時のURL
          failure: # 失敗時のURL
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`StripePurchaseMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_purchase_stripe/masamune_purchase_stripe.dart';
    import 'package:katana_functions_firebase/katana_functions_firebase.dart';
    import 'package:katana_model_firestore/katana_model_firestore.dart';

    final functionsAdapter = FirebaseFunctionsAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      region: FirebaseRegion.asiaNortheast1,
    );

    final modelAdapter = const FirestoreModelAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Stripe決済のアダプターを追加
        StripePurchaseMasamuneAdapter(
          callbackURLSchemeOrHost: Uri.parse('yourapp://stripe'), // 3Dセキュアのリダイレクト用
          supportEmail: 'support@example.com',                    // サポートメールアドレス
          functionsAdapter: functionsAdapter,                     // バックエンド連携用
          modelAdapter: modelAdapter,                             // データ永続化用
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_purchase_stripe
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`StripePurchaseMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_purchase_stripe/masamune_purchase_stripe.dart';
    import 'package:katana_functions_firebase/katana_functions_firebase.dart';
    import 'package:katana_model_firestore/katana_model_firestore.dart';

    final functionsAdapter = FirebaseFunctionsAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      region: FirebaseRegion.asiaNortheast1,
    );

    final modelAdapter = const FirestoreModelAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Stripe決済のアダプターを追加
        StripePurchaseMasamuneAdapter(
          callbackURLSchemeOrHost: Uri.parse('yourapp://stripe'), // 3Dセキュアのリダイレクト用
          supportEmail: 'support@example.com',                    // サポートメールアドレス
          functionsAdapter: functionsAdapter,                     // バックエンド連携用
          modelAdapter: modelAdapter,                             // データ永続化用
        ),
    ];
    ```

## 利用方法

### Stripeカスタマーと支払い方法の作成

```dart
class PaymentSetupPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final functions = ref.app.functions();

    return ElevatedButton(
      onPressed: () async {
        try {
          // Stripeカスタマーと支払い方法を作成・更新
          await functions.execute(
            StripeActionCreateCustomerAndPayment(
              email: 'user@example.com',
              paymentMethodId: 'pm_xxx',  // Stripe.jsまたはモバイルSDKから取得
            ),
          );
          print("支払い方法が保存されました");
        } catch (e) {
          print("支払い方法の保存に失敗: $e");
        }
      },
      child: const Text("支払い方法を保存"),
    );
  }
}
```

### 購入の処理

```dart
Future<void> purchasePremium(PageRef ref) async {
  final functions = ref.app.functions();

  try {
    final result = await functions.execute(
      StripeActionCreatePurchase(
        amount: 1200,                           // 最小通貨単位での金額(例: セント)
        currency: StripeCurrency.jpy,          // 通貨
        description: 'プレミアムプラン - 月額', // 購入の説明
        metadata: {                             // オプションのメタデータ
          'plan': 'premium',
          'period': 'monthly',
        },
      ),
    );

    print("購入成功: ${result.purchaseId}");
    // 成功ページへ遷移
  } on StripePaymentException catch (e) {
    print("決済失敗: ${e.message}");
    // エラーダイアログを表示
  }
}
```

### 購入履歴の追跡

生成されたモデルを使用して購入と支払いステータスを追跡:

```dart
class PurchaseHistoryPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    // ユーザーの購入履歴を読み込み
    final purchases = ref.app.model(
      StripePurchaseModel.collection(userId: currentUserId),
    )..load();

    return ListView.builder(
      itemCount: purchases.length,
      itemBuilder: (context, index) {
        final purchase = purchases[index].value;
        return ListTile(
          title: Text(purchase?.description ?? ''),
          subtitle: Text('${purchase?.amount} ${purchase?.currency}'),
          trailing: Text(purchase?.status ?? ''),
        );
      },
    );
  }
}
```

## バックエンド実装

Cloud Functionsでのストライプ連携実装例:

```typescript
// Cloud Functions
export const stripe = functions.https.onCall(async (data, context) => {
  const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

  switch (data.action) {
    case "create_customer_and_payment":
      // Stripeカスタマーを作成して支払い方法を紐付け
      const customer = await stripe.customers.create({
        email: data.email,
      });
      await stripe.paymentMethods.attach(data.paymentMethodId, {
        customer: customer.id,
      });
      return { customerId: customer.id };

    case "create_purchase":
      // PaymentIntentを作成
      const paymentIntent = await stripe.paymentIntents.create({
        amount: data.amount,
        currency: data.currency,
        description: data.description,
        metadata: data.metadata,
      });
      return { purchaseId: paymentIntent.id };
  }
});
```

## プラットフォーム設定

**iOS**: Info.plistにURLスキームを追加:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>yourapp</string>
    </array>
  </dict>
</array>
```

**Android**: AndroidManifest.xmlにインテントフィルターを追加:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="yourapp" android:host="stripe" />
</intent-filter>
```

### Tips

- Stripeダッシュボードでテストキーと本番キーを管理
- 3Dセキュア認証にはカスタマーサポートメールが必要
- 購入履歴はFirestoreなどのデータベースに自動保存
- メタデータを活用してプランや期間などの情報を記録
- セキュリティのため、APIキーはバックエンドで管理
```
