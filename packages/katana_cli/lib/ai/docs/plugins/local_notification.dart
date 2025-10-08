// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of local_notification.md.
///
/// local_notification.mdの中身。
class PluginLocalNotificationMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of local_notification.md.
  ///
  /// local_notification.mdの中身。
  const PluginLocalNotificationMdCliAiCode();

  @override
  String get name => "ローカルPUSH通知";

  @override
  String get description => "`ローカルPUSH通知`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt =>
      "`ローカルPUSH通知`は端末内に閉じたPUSH通知機能。通知を行う日時と内容を設定して端末内で設定後、設定した日時に通知を行う。";

  @override
  String body(String baseName, String className) {
    return """
`ローカルPUSH通知`は下記のように利用する。

## 概要

$excerpt

バックエンドを必要とせず、デバイス上でスケジュールして通知を表示します。

**注意**: `masamune_notification`パッケージがコア機能として必要です。

## 設定方法

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_notification
    flutter pub add masamune_notification_local
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`MobileLocalNotificationMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_notification_local/masamune_notification_local.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),

        // ローカルPUSH通知のアダプターを追加。
        const MobileLocalNotificationMasamuneAdapter(
          androidNotificationIcon: "@mipmap/ic_launcher",  // 通知用のアプリアイコン
          requestAlertPermissionOnInitialize: true,        // 初期化時にアラート権限をリクエスト
          requestSoundPermissionOnInitialize: true,        // 音声権限をリクエスト
          requestBadgePermissionOnInitialize: true,        // バッジ権限をリクエスト
        ),
    ];
    ```

## 利用方法

### ローカル通知の初期化

ローカル通知コントローラーを初期化します:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localNotification = appRef.controller(LocalNotification.query());

    // アプリ起動時に初期化
    localNotification.initialize(
      onTap: (notificationId, payload) {
        print("通知 \$notificationId がタップされました: \$payload");
        // ナビゲーションやタップ処理
      },
    );

    return MasamuneApp(...);
  }
}
```

### 即座に通知を表示

すぐに通知を表示します:

```dart
class ReminderPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final notification = ref.app.controller(LocalNotification.query());

    return ElevatedButton(
      onPressed: () async {
        await notification.show(
          notificationId: 100,
          title: "タスク完了",
          body: "すべてのタスクが完了しました！",
          payload: "task_complete",  // オプションのデータ
        );
      },
      child: const Text("通知を表示"),
    );
  }
}
```

### 将来の通知をスケジュール

特定の時間に通知をスケジュールします:

```dart
// 一度だけの通知をスケジュール
await notification.schedule(
  notificationId: 1001,
  title: "ミーティングのリマインダー",
  body: "チームミーティングが10分後に始まります",
  scheduledDate: DateTime.now().add(Duration(minutes: 10)),
  androidAllowWhileIdle: true,  // Dozeモードでも表示
  payload: "meeting_123",
);
```

### 繰り返し通知

毎日、毎週、またはカスタムの繰り返し通知をスケジュールします:

```dart
// 毎日のリマインダー
await notification.schedule(
  notificationId: 2001,
  title: "毎日の運動",
  body: "今日も運動する時間です！",
  scheduledDate: DateTime(2025, 10, 8, 9, 0),  // 9:00 AM
  repeatSettings: LocalNotificationRepeatSettings.daily(),
);

// 毎週のリマインダー
await notification.schedule(
  notificationId: 2002,
  title: "週次レポート",
  body: "週次レポートを提出してください",
  scheduledDate: DateTime(2025, 10, 13, 17, 0),  // 金曜日 5:00 PM
  repeatSettings: LocalNotificationRepeatSettings.weekly(),
);
```

### 通知のキャンセル

```dart
// 特定の通知をキャンセル
await notification.cancel(1001);

// すべての通知をキャンセル
await notification.cancelAll();
```

### モデルを使用したスケジュールの永続化

長期保存には`LocalNotificationScheduleModel`を使用します:

```dart
final schedule = LocalNotificationScheduleModel(
  localNotificationScheduleId: "daily-reminder",
  notificationId: 3001,
  title: "朝の瞑想",
  body: "10分間の瞑想で一日を始めましょう",
  scheduledAt: DateTime(2025, 10, 8, 7, 0),
  repeatSettings: LocalNotificationRepeatSettings.daily(),
);

// データベースに保存
final doc = ref.app.model(
  LocalNotificationScheduleModel.collection(),
).create();
await doc.save(schedule);
```

### プラットフォーム設定

**Android**: リソースに通知アイコンを追加:

```xml
<!-- android/app/src/main/res/drawable/ic_notification.xml -->
<!-- または @mipmap/ic_launcher を使用 -->
```

**iOS**: 実行時に権限をリクエスト（有効にした場合、アダプターが自動的に処理）。

### Tips

- 正確なタイミングを保証するため、スケジューリング前に`initializeTimeZones()`を呼び出してください
- 重要なリマインダーには`androidAllowWhileIdle`を使用してください
- 複数の通知を管理するために一意の通知IDを提供してください
- 異なるタイムゾーンやデバイス設定でテストしてください
- 再スケジューリング時に重複を避けるため、古い通知をキャンセルしてください
""";
  }
}
