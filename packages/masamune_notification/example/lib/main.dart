// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:masamune_notification/masamune_notification.dart";

/// Push notification adapter configuration for the application.
///
/// This adapter configures the runtime remote notification functionality
/// with Android-specific channel settings for important notifications.
///
/// アプリケーション用のプッシュ通知アダプター設定。
///
/// このアダプターは重要な通知用のAndroid固有のチャンネル設定で
/// ランタイムリモート通知機能を設定します。
const pushNotificationAdapter = RuntimeRemoteNotificationMasamuneAdapter(
  androidNotificationChannelId: "masamune_firebase_messaging_channel",
  androidNotificationChannelTitle: "Important Notification",
  androidNotificationChannelDescription:
      "This notification channel is used for important notifications.",
);

/// Entry point of the application.
///
/// Initializes and runs the Masamune app with push notification functionality.
/// The app demonstrates how to send and receive remote notifications.
///
/// アプリケーションのエントリーポイント。
///
/// プッシュ通知機能を含むMasamuneアプリを初期化し実行します。
/// このアプリはリモート通知の送受信方法を実演します。
void main() {
  runApp(const MyApp());
}

/// Root application widget.
///
/// Sets up the MasamuneApp with push notification adapter and basic theming.
/// Configures the app to handle remote notifications.
///
/// ルートアプリケーションウィジェット。
///
/// プッシュ通知アダプターと基本テーマを使用してMasamuneAppをセットアップします。
/// リモート通知を処理するようにアプリを設定します。
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  ///
  /// [MyApp]を作成します。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MasamuneApp(
      home: const NotificationPage(),
      title: "Flutter Demo",
      masamuneAdapters: const [pushNotificationAdapter],
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    );
  }
}

/// Main page widget for demonstrating push notification functionality.
///
/// This widget provides a user interface for sending and displaying
/// remote notifications. Shows received notification content and
/// allows users to send test notifications.
///
/// プッシュ通知機能を実演するためのメインページウィジェット。
///
/// このウィジェットはリモート通知の送信と表示のためのユーザーインターフェースを提供します。
/// 受信した通知内容を表示し、ユーザーがテスト通知を送信できるようにします。
class NotificationPage extends StatefulWidget {
  /// Creates a [NotificationPage].
  ///
  /// [NotificationPage]を作成します。
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() => NotificationPageState();
}

/// State class for [NotificationPage].
///
/// Manages the remote notification instance and handles notification events.
/// Automatically starts listening for notifications when initialized
/// and properly disposes resources when the widget is destroyed.
///
/// [NotificationPage]のStateクラス。
///
/// リモート通知インスタンスを管理し、通知イベントを処理します。
/// 初期化時に通知の監視を自動的に開始し、ウィジェットが破棄される際に
/// リソースを適切に解放します。
class NotificationPageState extends State<NotificationPage> {
  /// Remote notification instance for handling push notifications.
  ///
  /// Manages notification listening, sending, and state management
  /// for both incoming and outgoing notifications.
  ///
  /// プッシュ通知を処理するためのリモート通知インスタンス。
  ///
  /// 着信および発信通知の通知監視、送信、状態管理を管理します。
  final notification = RemoteNotification();

  @override
  void initState() {
    super.initState();
    notification.listen();
    notification.addListener(_handledOnUpdate);
  }

  /// Handles notification state updates.
  ///
  /// Called when a new notification is received or when the notification
  /// state changes. Triggers a UI rebuild to display the latest notification data.
  ///
  /// 通知状態の更新を処理します。
  ///
  /// 新しい通知を受信した際や通知状態が変更された際に呼び出されます。
  /// 最新の通知データを表示するためにUIの再構築をトリガーします。
  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    notification.removeListener(_handledOnUpdate);
    notification.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Demo")),
      body: ListView(
        children: [
          // Display received notification content if available
          if (notification.value != null) ...[
            ListTile(
              title: Text(notification.value!.title),
            ),
            ListTile(
              title: Text(notification.value!.text),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _sendTestNotification();
        },
        child: const Icon(Icons.person),
      ),
    );
  }

  /// Sends a test notification to the specified topic.
  ///
  /// Creates and sends a sample notification with predefined title and text
  /// to demonstrate the notification sending functionality.
  ///
  /// 指定されたトピックにテスト通知を送信します。
  ///
  /// 通知送信機能を実演するために、事前定義されたタイトルとテキストで
  /// サンプル通知を作成し送信します。
  Future<void> _sendTestNotification() async {
    await notification.send(
      title: "Notification",
      text: "Notification text",
      target: const TopicNotificationTargetQuery(topic: "Topic Name"),
    );
  }
}
