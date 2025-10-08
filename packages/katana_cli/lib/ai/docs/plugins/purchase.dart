// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of purchase.md.
///
/// purchase.mdの中身。
class PluginPurchaseMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of purchase.md.
  ///
  /// purchase.mdの中身。
  const PluginPurchaseMdCliAiCode();

  @override
  String get name => "アプリ内課金";

  @override
  String get description => "`アプリ内課金`の利用方法";

  @override
  String get globs => "*";

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

Google Play、App Storeの課金システムと連携して、サブスクリプション、非消費型、消費型のアイテムを販売できます。

**注意**: `masamune_purchase`パッケージがコア機能として必要です。モバイル課金には`masamune_purchase_mobile`も必要です。

## 設定方法

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_purchase
    flutter pub add masamune_purchase_mobile
    flutter pub add katana_functions_firebase  # バックエンド検証用
    flutter pub add katana_model_firestore     # 購入データ保存用
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`MobilePurchaseMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_purchase_mobile/masamune_purchase_mobile.dart';
    import 'package:katana_functions_firebase/katana_functions_firebase.dart';
    import 'package:katana_model_firestore/katana_model_firestore.dart';

    final functionsAdapter = FirebaseFunctionsAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      region: FirebaseRegion.asiaNortheast1,
    );

    final modelAdapter = FirestoreModelAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // アプリ内課金のアダプターを追加。
        MobilePurchaseMasamuneAdapter(
          products: const [
            // サブスクリプション商品
            PurchaseProduct.subscription(
              productId: "premium_monthly",              // App Store/Play Consoleと一致させる
              title: LocalizedValue("プレミアム月額プラン"),
              description: LocalizedValue("すべての機能を利用可能"),
              period: PurchaseSubscriptionPeriod.month,
            ),

            // 非消費型(買い切り)
            PurchaseProduct.nonConsumable(
              productId: "lifetime_unlock",
              title: LocalizedValue("永久アクセス"),
            ),

            // 消費型(コイン、クレジット)
            PurchaseProduct.consumable(
              productId: "coin_pack_100",
              title: LocalizedValue("100コイン"),
              amount: 100,
            ),
          ],
          onRetrieveUserId: () => currentUserId,    // 現在の認証済みユーザーID
          functionsAdapter: functionsAdapter,       // バックエンド検証用
          modelAdapter: modelAdapter,               // 購入データ保存用
          initializeOnBoot: true,                   // アプリ起動時に自動初期化
        ),
    ];
    ```

**重要**: 商品IDはGoogle Play ConsoleとApp Store Connectで設定したものと完全に一致させる必要があります。

## 利用方法

### 商品の表示と購入

`Purchase`コントローラーを使用して利用可能な商品を読み込み、表示します:

```dart
class StorePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final purchase = ref.app.controller(Purchase.query());

    // ページ読み込み時に初期化
    ref.page.on(
      initOrUpdate: () {
        purchase.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("ストア")),
      body: purchase.initialized
          ? ListView.builder(
              itemCount: purchase.products.length,
              itemBuilder: (context, index) {
                final product = purchase.products[index];

                return ListTile(
                  title: Text(product.title.value),
                  subtitle: Text(product.description.value),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      try {
                        await purchase.purchase(
                          product: product,
                          onDone: () {
                            print("購入完了！");
                            // 成功ダイアログを表示
                          },
                        );
                      } catch (e) {
                        print("購入失敗: \$e");
                        // エラーダイアログを表示
                      }
                    },
                    child: Text(product.price ?? "購入"),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
```

### 購入の復元

ユーザーが以前の購入を復元できるようにします:

```dart
ElevatedButton(
  onPressed: () async {
    await purchase.restore();
    print("購入を復元しました");
  },
  child: const Text("購入を復元"),
)
```

### バックエンド検証

Cloud Functionsで購入レシートをGoogle PlayまたはApp Storeで検証する必要があります:

**Android検証(TypeScript)**:

```dart
// Cloud Functions
import { google } from 'googleapis';

export const validateAndroidPurchase = functions.https.onCall(async (data, context) => {
  const { packageName, productId, purchaseToken } = data;

  // Google Play Billing APIで検証
  const androidPublisher = google.androidpublisher('v3');
  const response = await androidPublisher.purchases.products.get({
    packageName,
    productId,
    token: purchaseToken,
    auth: googleAuth,
  });

  const isValid = response.data.purchaseState === 0;  // 0 = 購入済み

  if (isValid) {
    // ユーザーに権限を付与
    await grantPurchase(data.userId, productId);
  }

  return { result: isValid };
});
```

**iOS検証(TypeScript)**:

```dart
// Cloud Functions
export const validateIosPurchase = functions.https.onCall(async (data, context) => {
  const { receiptData, productId } = data;

  // App Store Server APIで検証
  const response = await axios.post(
    'https://buy.itunes.apple.com/verifyReceipt',  // テスト時はsandbox URL
    {
      'receipt-data': receiptData,
      'password': process.env.APP_STORE_SHARED_SECRET,
    }
  );

  const isValid = response.data.status === 0;

  if (isValid) {
    await grantPurchase(data.userId, productId);
  }

  return { result: isValid };
});
```

**StoreKit 2サポート**: アダプターは自動的にStoreKit v1/v2を検出し、適切なペイロード(`transactionId`、`receiptData`、`storeKitVersion`)を送信します。

### ユーザー権限の確認

購入モデルをクエリしてユーザーアクセスを確認します:

```dart
class PremiumFeaturePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final purchaseUser = ref.app.model(
      PurchaseUserModel.document(userId: currentUserId),
    )..load();

    final hasPremium = purchaseUser.value?.hasPremiumAccess ?? false;

    return hasPremium
        ? PremiumContent()
        : UpgradePrompt();
  }
}
```

### カスタムデリゲート

購入ライフサイクルイベント用のデリゲートを提供します:

```dart
// 消費型購入(コイン、クレジット)
class CoinsDelegate extends ConsumablePurchaseDelegate {
  @override
  Future<void> onDelivered({
    required PurchaseProduct product,
    required double amount,
  }) async {
    await userRepository.addCoins(currentUserId, amount.toInt());
  }
}

// サブスクリプション購入
class PremiumDelegate extends SubscriptionPurchaseDelegate {
  @override
  Future<void> onActivated({required PurchaseProduct product}) async {
    await userRepository.setPremiumStatus(currentUserId, true);
  }

  @override
  Future<void> onExpired({required PurchaseProduct product}) async {
    await userRepository.setPremiumStatus(currentUserId, false);
  }
}
```

デリゲートをアダプターに渡します:

```dart
MobilePurchaseMasamuneAdapter(
  products: [...],
  consumableDelegate: CoinsDelegate(),
  subscriptionDelegate: PremiumDelegate(),
  ...
)
```

### プラットフォーム設定

**Google Play Console**:
1. Play Consoleでアプリ内商品を作成
2. 商品IDをメモ
3. API アクセス用のサービスアカウントを設定
4. 署名済みビルドを内部テストトラックにアップロード

**App Store Connect**:
1. App Store Connectでアプリ内課金を作成
2. 商品IDをメモ
3. 銀行情報と税務情報を設定
4. テスト用のサンドボックステスターアカウントを作成

### テスト

**Android**: Play Consoleの内部テストトラックを使用

```dart
MobilePurchaseMasamuneAdapter(
  products: [...],
  automaticallyConsumeOnAndroid: true,  // テスト用に自動消費
)
```

**iOS**: サンドボックステスターまたはStoreKit Configurationファイルを使用

```dart
MobilePurchaseMasamuneAdapter(
  products: [...],
  iosSandboxTesting: true,  // サンドボックスモードを有効化
)
```

### トラブルシューティング

- 商品IDがコードとストア設定で完全に一致していることを確認してください
- ストアコンソールで商品が「アクティブ」状態になっていることを確認してください
- バックエンドのFunctionsがデプロイされアクセス可能であることを確認してください
- サブスクリプション復元用に復元機能をテストしてください
- 購入の例外をユーザーフレンドリーなエラーメッセージで適切に処理してください
""";
  }
}
