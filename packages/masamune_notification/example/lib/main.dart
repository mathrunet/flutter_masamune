// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_notification/masamune_notification.dart';

const pushNotificationAdapter = RuntimeRemoteNotificationMasamuneAdapter(
  androidNotificationChannelId: "masamune_firebase_messaging_channel",
  androidNotificationChannelTitle: "Important Notification",
  androidNotificationChannelDescription:
      "This notification channel is used for important notifications.",
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  final notification = RemoteNotification();

  @override
  void initState() {
    super.initState();
    notification.listen();
    notification.addListener(_handledOnUpdate);
  }

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
          await notification.send(
            title: "Notification",
            text: "Notification text",
            topic: "Topic Name",
          );
        },
        child: const Icon(Icons.person),
      ),
    );
  }
}
