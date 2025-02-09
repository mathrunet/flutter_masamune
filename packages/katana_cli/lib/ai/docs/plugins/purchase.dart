// Project imports:
import 'package:katana_cli/ai/docs/plugin_usage.dart';

/// Contents of purchase.mdc.
///
/// purchase.mdcの中身。
class PluginPurchaseMdcCliAiCode extends PluginUsageCliAiCode {
  /// Contents of purchase.mdc.
  ///
  /// purchase.mdcの中身。
  const PluginPurchaseMdcCliAiCode();

  @override
  String get name => "アプリ内課金";

  @override
  String get description => "`アプリ内課金`の利用方法";

  @override
  String get globs => "katana.yaml, lib/adapter.dart";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`アプリ内課金`はGooglePlayやAppStore内で提供される課金機能。消費型、非消費型、サプスクリプションの課金アイテムを利用可能。";

  @override
  String body(String baseName, String className) {
    return """
`アプリ内課金`は下記のように利用する。

## 概要

$excerpt

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Configure settings for store billing.
    # ストア課金を行う場合の設定を行います。
    purchase:
      # Setting this to `true` will install the billing package for testing.
      # ここを`true`にするとテスト用の課金パッケージがインストールされます。
      enable: true # アプリ内課金を利用する場合false -> trueに変更

      # Configure settings for Google Play billing.
      # Follow the steps below to configure the settings.
      # 1. Create a service account with permissions to GooglePlayConsole based on the URL below.
      #    https://mathru.notion.site/Android-1d4a60948a1446d7a82c010d96417a3d?pvs=4
      #    ※ You need to create an OAuth consent screen. Please create it from the following URL.
      #    https://console.cloud.google.com/apis/credentials/consent
      # 2. Set `enable` to `true`.
      # 3. Set the topic ID for the notification to `pubsub_topic`.
      # 4. Run `katana apply` to deploy the app and server.
      # GooglePlayの課金を行う場合の設定を行います。
      # 下記の手順で設定を行います。
      # 1. 下記URLを元にGooglePlayConsoleに権限があるサービスアカウントを作成します。
      #    https://mathru.notion.site/Android-1d4a60948a1446d7a82c010d96417a3d?pvs=4
      #    ※OAuthの同意画面を作成する必要があります。下記のURLから作成してください。
      #    https://console.cloud.google.com/apis/credentials/consent
      # 2. `enable`を`true`にします。
      # 3. 通知用のトピックIDを`pubsub_topic`に設定します。
      # 4. `katana apply`を実行しアプリとサーバーのデプロイを行います。
      google_play:
        enable: true # GooglePlayの課金を利用する場合false -> trueに変更
        pubsub_topic: purchasing

      # Configure settings for AppStore billing.
      # Follow the steps below to configure the settings.
      # 1. Register your tax information and bank account to activate [Subscription]->[Paid Apps] in the AppStore.
      # 2. Get it from [AppStore]->[App Info]->[Shared Secret for App] and put it in `shared_secret`.
      # AppStoreの課金を行う場合の設定を行います。
      # 下記の手順で設定を行います。
      # 1. AppStoreの[契約]->[有料App]をアクティブにするように税務情報や銀行口座を登録します。
      # 2. AppStoreの[アプリ]->[App情報]->[App用共有シークレット]から取得して`shared_secret`に記載します。
      app_store:
        enable: true # AppStoreの課金を利用する場合false -> trueに変更
        shared_secret: # AppStoreの共有シークレットを記載。
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

        // アプリ内課金のアダプターを追加。
        const PurchaseMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// アプリ内課金のコントローラーを取得。
final purchase = ref.app.controller(Purchase.query());

// 商品一覧を取得。
final products = await purchase.queryProducts(
  // 商品IDの一覧。
  productIds: [
    "product_1",
    "product_2",
    "product_3",
  ],
);

// 商品を購入。
final transaction = await purchase.purchase(
  // 商品ID。
  productId: "product_1",
);

// 購入が完了したかどうかを確認。
if (transaction.status == PurchaseStatus.purchased) {
  // 購入が完了した場合の処理。
  print("Purchase completed");
  
  // 消費型アイテムの場合は消費する。
  await purchase.consume(transaction);
}

// サブスクリプションの有効期限を確認。
final subscription = await purchase.checkSubscription(
  // 商品ID。
  productId: "subscription_1",
);
if (subscription != null) {
  print("Subscription expires at: \${subscription.expiryDate}");
}

// 購入履歴を取得。
final history = await purchase.queryPurchaseHistory();
for (final transaction in history) {
  print("Product ID: \${transaction.productId}");
  print("Purchase Date: \${transaction.purchaseDate}");
}

// 購入をリストア。
final restoredTransactions = await purchase.restore();
for (final transaction in restoredTransactions) {
  print("Restored Product ID: \${transaction.productId}");
}
```
""";
  }
}
