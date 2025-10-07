<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Notification</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Masamune Notification

## Usage

These packages provide a unified notification stack:

- `masamune_notification` – core models, controllers, and runtime adapters
- `masamune_notification_firebase` – Firebase Cloud Messaging integration
- `masamune_notification_local` – local notifications (mobile devices)

Install the packages you need.

```bash
flutter pub add masamune_notification
flutter pub add masamune_notification_firebase
flutter pub add masamune_notification_local
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

### Register Adapters

Set up adapters for remote and/or local notifications. The example below configures Firebase for remote notifications and Flutter Local Notifications for local scheduling.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  const FunctionsMasamuneAdapter(),
  const ModelAdapter(),
  const SchedulerMasamuneAdapter(),

  FirebaseRemoteNotificationMasamuneAdapter(
    functionsAdapter: const FunctionsMasamuneAdapter(),
    loggerAdapters: [FirebaseLoggerAdapter()],
    androidChannelId: "default_channel",
    androidChannelName: "General",
  ),

  MobileLocalNotificationMasamuneAdapter(
    androidNotificationIcon: "@mipmap/ic_launcher",
    requestAlertPermissionOnInitialize: true,
    requestSoundPermissionOnInitialize: true,
    requestBadgePermissionOnInitialize: true,
  ),
];
```

`FirebaseRemoteNotificationMasamuneAdapter` delivers push notifications through FCM, while `MobileLocalNotificationMasamuneAdapter` schedules local notifications via `flutter_local_notifications`.

### Initialize Notifications

Use the `RemoteNotification` and `LocalNotification` controllers to initialize services, request permissions, and handle incoming messages.

```dart
final remoteNotification = ref.app.controller(RemoteNotification.query());
final localNotification = ref.app.controller(LocalNotification.query());

await remoteNotification.initialize(
  onBackgroundMessage: backgroundHandler,
  onForegroundMessage: (message) {
    debugPrint("Foreground notification: ${message.notification?.title}");
  },
);

await localNotification.initialize();
```

### Request Permissions

On iOS (and Android 13+), request notification permissions explicitly.

```dart
await remoteNotification.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);

await localNotification.requestPermission();
```

### Handling Tokens

Retrieve the FCM token for backend registration or topic subscriptions.

```dart
final token = await remoteNotification.getToken();
debugPrint("FCM token: $token");

await remoteNotification.subscribeTopic("global-news");
```

### Scheduling Local Notifications

Use `LocalNotification.schedule` to create user-facing reminders. Combine with `masamune_scheduler` models when you need persistence.

```dart
await localNotification.schedule(
  notificationId: 1001,
  title: "Reminder",
  body: "Stand up and stretch!",
  scheduledDate: DateTime.now().add(const Duration(minutes: 15)),
  androidAllowWhileIdle: true,
);
```

Persist schedules using `LocalNotificationScheduleModel` for long-term storage.

```dart
final schedule = LocalNotificationScheduleModel(
  localNotificationScheduleId: "reminder-1001",
  notificationId: 1001,
  title: "Reminder",
  body: "Daily meditation",
  scheduledAt: DateTime.now().add(const Duration(days: 1)),
  repeatSettings: const LocalNotificationRepeatSettings.daily(),
);

await schedule.save();
```

`RemoteNotificationScheduleModel` works similarly for remote notifications, orchestrating push payloads via Functions.

### Sending Remote Notifications via Functions

Trigger push notifications with the provided Functions action.

```dart
await functions.execute(
  SendRemoteNotificationFunctionsAction(
    title: "Breaking News",
    body: "Important update available.",
    token: targetToken,
    data: {
      "type": "news",
      "articleId": "abc123",
    },
  ),
);
```

Implement the server-side handler to call FCM using the Admin SDK (Node.js, Dart, etc.).

### Logging

`NotificationLoggerEvent` integrates with your logger adapters to track notification delivery, taps, and scheduling events. Use it to build analytics dashboards or audit trails.

### Tips

- Configure platform-specific settings: notification icons, categories, foreground presentation options.
- Ensure timezone data (`initializeTimeZones()`) is loaded when scheduling local notifications.
- Handle background messages by registering `FirebaseMessaging.onBackgroundMessage` in the top-level entry point.
- Combine with `masamune_purchase` or other modules to trigger notifications based on domain events.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)