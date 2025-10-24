// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of remote_notification.md.
///
/// remote_notification.mdの中身。
class PluginRemoteNotificationMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of remote_notification.md.
  ///
  /// remote_notification.mdの中身。
  const PluginRemoteNotificationMdCliAiCode();

  @override
  String get name => "リモートPUSH通知";

  @override
  String get description => "`リモートPUSH通知`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`リモートPUSH通知`はFirebase Cloud Messaging(FCM)を利用してサーバーから端末にPUSH通知を送信する機能。";

  @override
  String body(String baseName, String className) {
    return """
`リモートPUSH通知`は下記のように利用する。

## 概要

$excerpt

Firebase Cloud Messaging(FCM)を利用してバックエンドから端末にプッシュ通知を送信します。

**注意**: `masamune_notification`パッケージがコア機能として必要です。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Enable Firebase Messaging.
    # Specify ChannelNotificationId for Android in [channel_id].
    # Specify an image path in [android_notification_icon] to set a notification icon for Android for whiteout.
    # Firebase Messagingを有効にします。
    # [channel_id]にAndroid用のChannelNotificationIdを指定してください。
    # [android_notification_icon]に画像パスを指定するとAndroid用の白抜き用の通知アイコンを設定できます。
    messaging:
      enable: true # リモート通知を利用する場合false -> trueに変更
      channel_id: default_channel # Android用のチャンネルID
      android_notification_icon: "@mipmap/ic_launcher" # Android用の通知アイコン
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

3. `lib/adapter.dart`の`masamuneAdapters`に`FirebaseRemoteNotificationMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_notification_firebase/masamune_notification_firebase.dart';
    import 'package:katana_functions_firebase/katana_functions_firebase.dart';

    final functionsAdapter = FirebaseFunctionsAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      region: FirebaseRegion.asiaNortheast1,
    );

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // リモートPUSH通知のアダプターを追加。
        FirebaseRemoteNotificationMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,  // Firebase設定
          functionsAdapter: functionsAdapter,                // バックエンド送信用
          loggerAdapters: [FirebaseLoggerAdapter()],        // オプション(分析用)
          androidChannelId: "default_channel",              // Android通知チャンネル
          androidChannelName: "一般通知",
        ),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_notification
    flutter pub add masamune_notification_firebase
    flutter pub add katana_functions_firebase
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`FirebaseRemoteNotificationMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_notification_firebase/masamune_notification_firebase.dart';
    import 'package:katana_functions_firebase/katana_functions_firebase.dart';

    final functionsAdapter = FirebaseFunctionsAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      region: FirebaseRegion.asiaNortheast1,
    );

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // リモートPUSH通知のアダプターを追加。
        FirebaseRemoteNotificationMasamuneAdapter(
          options: DefaultFirebaseOptions.currentPlatform,  // Firebase設定
          functionsAdapter: functionsAdapter,                // バックエンド送信用
          loggerAdapters: [FirebaseLoggerAdapter()],        // オプション(分析用)
          androidChannelId: "default_channel",              // Android通知チャンネル
          androidChannelName: "一般通知",
        ),
    ];
    ```

## 利用方法

### Firebase Messagingの初期化

リモート通知コントローラーを初期化してプッシュ通知を処理します:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final remoteNotification = appRef.controller(RemoteNotification.query());

    // アプリ起動時に初期化
    remoteNotification.initialize(
      onBackgroundMessage: _backgroundMessageHandler,
      onForegroundMessage: (message) {
        print("フォアグラウンド: \${message.notification?.title}");
        // ダイアログ表示やUI更新など
      },
      onMessageOpenedApp: (message) {
        print("通知から開封: \${message.data}");
        // 特定ページへ遷移
      },
    );

    return MasamuneApp(...);
  }
}

// バックグラウンドメッセージ用のトップレベル関数
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print("バックグラウンド: \${message.notification?.title}");
}
```

### 通知権限のリクエスト

iOSおよびAndroid 13以降で通知権限をリクエストします:

```dart
class PermissionPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final notification = ref.app.controller(RemoteNotification.query());

    return ElevatedButton(
      onPressed: () async {
        final granted = await notification.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        if (granted) {
          print("通知権限が許可されました");
        }
      },
      child: const Text("通知を有効にする"),
    );
  }
}
```

### FCMトークンの取得

バックエンド登録用にデバイスのFCMトークンを取得します:

```dart
final remoteNotification = ref.app.controller(RemoteNotification.query());

final token = await remoteNotification.getToken();
print("FCMトークン: \$token");

// バックエンドにトークンを送信
await saveTokenToBackend(token);

// トークンのリフレッシュを監視
remoteNotification.onTokenRefresh.listen((newToken) {
  print("トークン更新: \$newToken");
  saveTokenToBackend(newToken);
});
```

### トピックの購読

グループ通知用にトピックを購読します:

```dart
// 購読
await remoteNotification.subscribeTopic("news");
await remoteNotification.subscribeTopic("promotions");

// 購読解除
await remoteNotification.unsubscribeTopic("promotions");
```

### バックエンドから通知を送信

`SendRemoteNotificationFunctionsAction`を使用します:

```dart
final functions = ref.app.functions();

await functions.execute(
  SendRemoteNotificationFunctionsAction(
    title: "新着メッセージ",
    body: "Johnさんから新しいメッセージが届きました",
    token: recipientToken,  // 特定のユーザー
    // または: topic: "news",  // 購読しているすべてのユーザー
    data: {
      "type": "chat",
      "senderId": "user_123",
    },
  ),
);
```

**バックエンド実装例**:

```typescript
// Cloud Functions
export const sendNotification = functions.https.onCall(async (data, context) => {
  const message = {
    notification: {
      title: data.title,
      body: data.body,
    },
    data: data.data,
    token: data.token,  // または topic: data.topic
  };

  await admin.messaging().send(message);
  return { success: true };
});
```

### 通知タップの処理

通知をタップしたユーザーを特定のページに遷移させます:

```dart
remoteNotification.initialize(
  onMessageOpenedApp: (message) {
    final data = message.data;

    if (data['type'] == 'chat') {
      context.router.push(ChatPage.query(userId: data['senderId']));
    }
  },
);
```

### フォアグラウンド通知のカスタマイズ

アプリがフォアグラウンドの場合の通知表示をカスタマイズします:

```dart
remoteNotification.initialize(
  onForegroundMessage: (message) {
    final notification = message.notification;

    // カスタムダイアログやスナックバーを表示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("\${notification?.title}: \${notification?.body}"),
        action: SnackBarAction(
          label: "開く",
          onPressed: () {
            // 特定のページに遷移
          },
        ),
      ),
    );
  },
);
```

### 通知バッジの管理

アプリアイコンのバッジ数を管理します:

```dart
// バッジ数を設定
await remoteNotification.setBadgeCount(5);

// バッジをクリア
await remoteNotification.setBadgeCount(0);
```

### データペイロードの処理

通知データからカスタム情報を取得して処理します:

```dart
remoteNotification.initialize(
  onMessageOpenedApp: (message) {
    final data = message.data;
    final type = data['type'];
    final itemId = data['itemId'];

    switch (type) {
      case 'order':
        context.router.push(OrderDetailPage.query(orderId: itemId));
        break;
      case 'message':
        context.router.push(ChatPage.query(chatId: itemId));
        break;
      case 'reminder':
        context.router.push(ReminderPage.query(reminderId: itemId));
        break;
    }
  },
);
```

### プラットフォーム設定

**Android**: `android/app/src/main/AndroidManifest.xml`にチャンネル設定を追加:

```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="default_channel" />
```

**iOS**: プッシュ通知の機能をXcodeで有効化し、APNs証明書をFirebase Consoleに登録。

### Tips

- アダプターでAndroid通知チャンネルを設定してください
- バックグラウンドメッセージは`@pragma('vm:entry-point')`を付けたトップレベル関数で処理してください
- ターゲット通知のためにFCMトークンをデータベースに保存してください
- ブロードキャスト通知にはトピックを使用してください
- 実機でテストしてください(FCMはシミュレータでは動作しません)
- データペイロードは文字列型のみ対応しているため、JSON文字列として送信してください
- フォアグラウンドとバックグラウンドで通知の表示方法が異なることに注意してください
""";
  }
}
