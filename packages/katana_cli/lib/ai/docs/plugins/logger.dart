// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of logger.md.
///
/// logger.mdの中身。
class PluginLoggerMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of logger.md.
  ///
  /// logger.mdの中身。
  const PluginLoggerMdCliAiCode();

  @override
  String get name => "Firebase Analytics / Crashlytics";

  @override
  String get description => "`Firebase Analytics / Crashlytics`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`Firebase Logger`はFirebase AnalyticsとCrashlyticsを統合し、イベントログ、パフォーマンス測定、クラッシュレポートを提供するプラグイン。";

  @override
  String body(String baseName, String className) {
    return """
`Firebase Logger`は下記のように利用する。

## 概要

$excerpt

Firebase Analyticsでユーザー行動を追跡し、Crashlyticsでクラッシュレポートを収集、Firebase Performanceでパフォーマンスを監視できます。

**注意**: Firebase Analyticsを有効化できない場合は、Firebaseコンソールの「プロジェクトの設定」→「統合」→「Google Analytics」のアプリが正常に連携されているかを確認してください。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Enable Firebase Analytics and Firebase Crashlytics.
    # If you are unable to activate Analytics, please check if the "Project Settings" -> "Integration" -> "GoogleAnalytics" application is successfully linked.
    # Firebase AnalyticsとFirebase Crashlyticsを有効にします。
    # Analyticsの有効化が出来ない場合は、「プロジェクトの設定」→「統合」→「GoogleAnalytics」のアプリが正常に連携されているかを確認してください。
    logger:
      enable: true # Firebase Analyticsを利用する場合false -> trueに変更
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`loggerAdapters`と`masamuneAdapters`に設定を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune/masamune.dart';
    import 'package:masamune_logger_firebase/masamune_logger_firebase.dart';

    /// Logger adapters used by the application.
    final loggerAdapters = <LoggerAdapter>[
      const FirebaseLoggerAdapter(),  // Firebaseロガーを追加
    ];

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Firebase Loggerのアダプターを追加
        const FirebaseLoggerMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,  // Firebase設定
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_logger_firebase
    ```

2. `lib/adapter.dart`の`loggerAdapters`と`masamuneAdapters`に設定を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune/masamune.dart';
    import 'package:masamune_logger_firebase/masamune_logger_firebase.dart';

    /// Logger adapters used by the application.
    final loggerAdapters = <LoggerAdapter>[
      const FirebaseLoggerAdapter(),  // Firebaseロガーを追加
    ];

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // Firebase Loggerのアダプターを追加
        const FirebaseLoggerMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,  // Firebase設定
        ),
    ];
    ```

## 主な機能

`FirebaseLoggerMasamuneAdapter`は以下を自動的に提供:

- Firebaseの自動初期化
- `FlutterError`と`PlatformDispatcher`へのCrashlyticsエラーハンドリング接続
- 自動画面トラッキング用のナビゲーションオブザーバー追加
- `FirebaseAnalytics`、`FirebaseCrashlytics`、`FirebasePerformance`インスタンスの公開

アダプターには`FirebaseLoggerMasamuneAdapter.primary`でアクセスできます。

## 利用方法

### イベントのログ記録

Firebase Analyticsにイベントを送信。パッケージは一般的なイベント用に事前構築されたロギング可能なクラスを提供します。

**サインインイベント**:

```dart
// ロガーを取得
final logger = LoggerAdapter.primary.first;

// ユーザーサインインをログ
await logger.send(const FirebaseAnalyticsSignInLoggable(
  userId: "user_123",
  providerId: "google.com",
));

// ユーザー登録をログ
await logger.send(const FirebaseAnalyticsRegisterLoggable(
  userId: "user_456",
));
```

**購入イベント**:

```dart
await logger.send(const FirebaseAnalyticsPurchasedLoggable(
  transactionId: "order-001",
  currency: "USD",
  price: 9.99,
  products: [
    FirebaseAnalyticsPurchaseProduct(
      id: "sku-1",
      name: "プレミアムプラン",
      price: 9.99,
      quantity: 1,
    ),
  ],
));
```

**チュートリアルイベント**:

```dart
// チュートリアル開始
await logger.send(const FirebaseAnalyticsTutorialStartLoggable());

// チュートリアル完了
await logger.send(const FirebaseAnalyticsTutorialEndLoggable());
```

**カスタムイベント**:

```dart
await logger.send(const FirebaseAnalyticsEventLoggable(
  name: "custom_event",
  parameters: {
    "category": "user_action",
    "action": "button_click",
    "value": 123,
  },
));
```

### パフォーマンス監視

パフォーマンストレースで操作時間を測定:

```dart
final logger = LoggerAdapter.primary.first;

// トレースを開始
final trace = logger.trace("load_profile");
await trace.start();

// 測定したい操作を実行
await loadUserProfile();

// トレースを停止
await trace.stop();
```

**カスタムメトリクス付きトレース**:

```dart
final trace = logger.trace("api_request");
await trace.start();

// カスタムメトリクスを追加
trace.setMetric("response_size", 1024);
trace.incrementMetric("request_count", 1);

await apiRequest();
await trace.stop();
```

### Crashlytics

クラッシュレポートはアダプター登録時に自動的にキャプチャされます。アダプターは`FlutterError.onError`と`PlatformDispatcher.onError`にフックします。

**Crashlytics連携テスト**:

```dart
// テストクラッシュを強制(テスト用のみ!)
final logger = FirebaseLoggerAdapter.primary;
await logger.crash();
```

**手動エラーレポート**:

```dart
try {
  // コード実行
  throw Exception("テストエラー");
} catch (e, stackTrace) {
  await FirebaseCrashlytics.instance.recordError(
    e,
    stackTrace,
    reason: "手動でキャプチャされたエラー",
  );
}
```

**カスタムキーの設定**:

```dart
// ユーザー情報を設定
await FirebaseCrashlytics.instance.setUserIdentifier("user_123");

// カスタムキーを追加
await FirebaseCrashlytics.instance.setCustomKey("user_level", 5);
await FirebaseCrashlytics.instance.setCustomKey("subscription", "premium");
```

### ユーザープロパティの設定

Firebase Analyticsでユーザー属性を追跡:

```dart
final analytics = FirebaseLoggerMasamuneAdapter.primary.analytics;

// ユーザープロパティを設定
await analytics.setUserProperty(
  name: "subscription_type",
  value: "premium",
);

await analytics.setUserProperty(
  name: "user_category",
  value: "power_user",
);
```

### 画面トラッキング

画面遷移は自動的に追跡されますが、手動でも記録可能:

```dart
final analytics = FirebaseLoggerMasamuneAdapter.primary.analytics;

await analytics.logScreenView(
  screenName: "product_detail",
  screenClass: "ProductDetailPage",
);
```

## 利用可能なイベントクラス

### ユーザー関連

- `FirebaseAnalyticsSignInLoggable`: ユーザーサインイン
- `FirebaseAnalyticsRegisterLoggable`: ユーザー登録
- `FirebaseAnalyticsSignOutLoggable`: ユーザーサインアウト

### 購入関連

- `FirebaseAnalyticsPurchasedLoggable`: 商品購入
- `FirebaseAnalyticsSubscribeLoggable`: サブスクリプション購読
- `FirebaseAnalyticsUnsubscribeLoggable`: サブスクリプション解約

### チュートリアル関連

- `FirebaseAnalyticsTutorialStartLoggable`: チュートリアル開始
- `FirebaseAnalyticsTutorialEndLoggable`: チュートリアル完了

### その他

- `FirebaseAnalyticsEventLoggable`: カスタムイベント
- `FirebaseAnalyticsShareLoggable`: コンテンツ共有
- `FirebaseAnalyticsSearchLoggable`: 検索実行

## Firebase Console設定

1. **Firebase Analyticsの有効化**:
   - Firebase Console → プロジェクトの設定 → 統合
   - Google Analyticsアプリを連携

2. **Crashlyticsの有効化**:
   - Firebase Console → Crashlytics
   - 「Crashlyticsを有効にする」をクリック

3. **Firebase Performanceの有効化**:
   - Firebase Console → Performance Monitoring
   - Performance Monitoringを有効化

## トラブルシューティング

### Analytics イベントが表示されない

**原因**: Google Analyticsが正しく連携されていない

**解決方法**:
1. Firebase Console → プロジェクトの設定 → 統合
2. Google Analyticsのステータスを確認
3. 未連携の場合は「リンク」をクリックして連携

### Crashlytics レポートが送信されない

**原因**: Crashlyticsが初期化されていない、またはデバッグモードで実行中

**解決方法**:
1. `FirebaseLoggerMasamuneAdapter`が正しく登録されているか確認
2. リリースビルドで実行してテスト
3. Firebase Consoleで数分待ってから確認

### パフォーマンストレースが表示されない

**原因**: Firebase Performanceが有効化されていない

**解決方法**:
1. Firebase Console → Performance Monitoring
2. Performance Monitoringを有効化
3. 初回のデータ表示には24時間かかる場合あり

## 実装例: 完全なログ戦略

```dart
class AppLogger {
  static final logger = LoggerAdapter.primary.first;

  // ユーザーアクションのログ
  static Future<void> logUserAction(String action, Map<String, dynamic>? params) async {
    await logger.send(FirebaseAnalyticsEventLoggable(
      name: action,
      parameters: params,
    ));
  }

  // エラーのログ
  static Future<void> logError(
    dynamic error,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
    );
  }

  // パフォーマンス測定
  static Future<T> measurePerformance<T>(
    String name,
    Future<T> Function() operation,
  ) async {
    final trace = logger.trace(name);
    await trace.start();

    try {
      final result = await operation();
      await trace.stop();
      return result;
    } catch (e) {
      await trace.stop();
      rethrow;
    }
  }
}

// 使用例
await AppLogger.logUserAction("button_click", {"button_id": "purchase"});

await AppLogger.measurePerformance("load_products", () async {
  return await loadProducts();
});
```

### Tips

- Analytics イベントは一般的な名前を使用(Firebase定義のイベント名を優先)
- Crashlyticsにはカスタムキーでコンテキスト情報を追加
- パフォーマンストレースは重要な操作のみに使用(過剰使用を避ける)
- デバッグビルドではAnalyticsを無効化してテストデータの混入を防ぐ
- ユーザープロパティは25個まで、各値は36文字以内
- イベントパラメータは25個まで、各値は100文字以内
""";
  }
}
