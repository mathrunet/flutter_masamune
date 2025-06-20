# ローカルPUSH通知

`ローカルPUSH通知`は下記のように利用する。

## 概要

`ローカルPUSH通知`は端末内に閉じたPUSH通知機能。通知を行う日時と内容を設定して端末内で設定後、設定した日時に通知を行う。

## 設定方法

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Implement local PUSH.
    # ローカルPUSHを実装します。
    local_notification:
      enable: true # ローカルPUSH通知を利用する場合false -> trueに変更
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

        // ローカルPUSH通知のアダプターを追加。（ランタイム・テスト用）
        const RuntimeLocalNotificationMasamuneAdapter(),
    ];
    ```

## 利用方法

```dart
// ローカルPUSH通知のコントローラーを取得。
final notification = ref.app.controller(LocalNotification.query());

// 通知を送信。
await notification.show(
  // 通知のID。
  id: "notification_1",
  // タイトル。
  title: "通知のタイトル",
  // 本文。
  body: "通知の本文",
  // 通知を表示する日時。
  scheduledDate: Clock.now().add(const Duration(minutes: 5)),
  // 通知のチャンネル。
  channel: const NotificationChannel(
    // チャンネルのID。
    id: "channel_1",
    // チャンネルの名前。
    name: "通知チャンネル1",
    // チャンネルの説明。
    description: "通知チャンネル1の説明",
    // 通知の重要度。
    importance: NotificationImportance.high,
  ),
);

// 通知をキャンセル。
await notification.cancel("notification_1");

// すべての通知をキャンセル。
await notification.cancelAll();
```
