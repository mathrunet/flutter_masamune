<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Notification Firebase</h1>
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

# Masamune Notification Firebase

## Overview

`masamune_notification_firebase` provides Firebase Cloud Messaging (FCM) integration for Masamune apps. Send and receive push notifications through Firebase.

**Note**: Requires `masamune_notification` for core notification functionality.

## Usage

### Installation

```bash
flutter pub add masamune_notification
flutter pub add masamune_notification_firebase
```

### Register the Adapter

Configure `FirebaseRemoteNotificationMasamuneAdapter` for push notifications.

```dart
// lib/adapter.dart

import 'package:masamune_notification_firebase/masamune_notification_firebase.dart';
import 'package:katana_functions_firebase/katana_functions_firebase.dart';

final functionsAdapter = FirebaseFunctionsAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  region: FirebaseRegion.asiaNortheast1,
);

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  FirebaseRemoteNotificationMasamuneAdapter(
    options: DefaultFirebaseOptions.currentPlatform,  // Firebase config
    functionsAdapter: functionsAdapter,                // For sending via backend
    loggerAdapters: [FirebaseLoggerAdapter()],        // Optional analytics
    androidChannelId: "default_channel",              // Android notification channel
    androidChannelName: "General Notifications",
  ),
];
```

### Initialize Firebase Messaging

Initialize the remote notification controller to handle push notifications:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final remoteNotification = appRef.controller(RemoteNotification.query());

    // Initialize on app start
    remoteNotification.initialize(
      onBackgroundMessage: _backgroundMessageHandler,
      onForegroundMessage: (message) {
        print("Foreground: ${message.notification?.title}");
        // Show dialog, update UI, etc.
      },
      onMessageOpenedApp: (message) {
        print("Opened from notification: ${message.data}");
        // Navigate to specific page
      },
    );

    return MasamuneApp(...);
  }
}

// Top-level function for background messages
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print("Background: ${message.notification?.title}");
}
```

### Request Permissions

Request notification permissions on iOS and Android 13+:

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
          print("Notification permission granted");
        }
      },
      child: const Text("Enable Notifications"),
    );
  }
}
```

### Get FCM Token

Retrieve the device's FCM token for backend registration:

```dart
final remoteNotification = ref.app.controller(RemoteNotification.query());

final token = await remoteNotification.getToken();
print("FCM token: $token");

// Send token to your backend
await saveTokenToBackend(token);

// Listen for token refresh
remoteNotification.onTokenRefresh.listen((newToken) {
  print("Token refreshed: $newToken");
  saveTokenToBackend(newToken);
});
```

### Subscribe to Topics

Subscribe to topics for group notifications:

```dart
// Subscribe
await remoteNotification.subscribeTopic("news");
await remoteNotification.subscribeTopic("promotions");

// Unsubscribe
await remoteNotification.unsubscribeTopic("promotions");
```

### Send Notifications from Backend

Use `SendRemoteNotificationFunctionsAction`:

```dart
final functions = ref.app.functions();

await functions.execute(
  SendRemoteNotificationFunctionsAction(
    title: "New Message",
    body: "You have a new message from John",
    token: recipientToken,  // Specific user
    // Or: topic: "news",  // All subscribed users
    data: {
      "type": "chat",
      "senderId": "user_123",
    },
  ),
);
```

**Backend Implementation**:

```typescript
// Cloud Functions
export const sendNotification = functions.https.onCall(async (data, context) => {
  const message = {
    notification: {
      title: data.title,
      body: data.body,
    },
    data: data.data,
    token: data.token,  // or topic: data.topic
  };

  await admin.messaging().send(message);
  return { success: true };
});
```

### Handle Notification Taps

Navigate users when they tap notifications:

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

### Tips

- Configure Android notification channels in the adapter
- Handle background messages with top-level `@pragma('vm:entry-point')` functions
- Store FCM tokens in your database for targeted notifications
- Use topics for broadcast notifications
- Test on real devices (FCM doesn't work in simulators)

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)