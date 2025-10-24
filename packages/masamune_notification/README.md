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

## Overview

`masamune_notification` is the base package for notification functionality in Masamune apps. It provides:
- Abstract notification controllers (`RemoteNotification`, `LocalNotification`)
- Notification models for scheduling and persistence
- Functions actions for backend integration
- Runtime adapters for testing

**Note**: This is the base package. You'll also need concrete implementations:
- `masamune_notification_firebase` for Firebase Cloud Messaging (push notifications)
- `masamune_notification_local` for local notifications

## Usage

### Installation

```bash
flutter pub add masamune_notification
flutter pub add masamune_notification_firebase  # For remote push notifications
flutter pub add masamune_notification_local     # For local notifications
```

### Concrete Implementations

This base package provides the interfaces. Use concrete implementations for actual functionality:

**Firebase Cloud Messaging** (`masamune_notification_firebase`)
- Provides `FirebaseRemoteNotificationMasamuneAdapter`
- Handles push notifications from Firebase
- See `masamune_notification_firebase` package for setup

**Local Notifications** (`masamune_notification_local`)
- Provides `MobileLocalNotificationMasamuneAdapter`
- Schedules local notifications on device
- See `masamune_notification_local` package for setup

**Runtime Adapters** (Testing)
- `RuntimeRemoteNotificationMasamuneAdapter` - Mock remote notifications
- `RuntimeLocalNotificationMasamuneAdapter` - Mock local notifications

### Notification Controllers

The package provides two main controllers:

**RemoteNotification Controller**:
- Handles push notifications (requires implementation adapter)
- Get FCM tokens
- Subscribe to topics
- Handle foreground/background messages

**LocalNotification Controller**:
- Schedules local notifications (requires implementation adapter)
- Request permissions
- Show immediate notifications
- Cancel scheduled notifications

### Notification Models

**LocalNotificationScheduleModel**: Persist local notification schedules

```dart
final schedule = LocalNotificationScheduleModel(
  localNotificationScheduleId: "reminder-1001",
  notificationId: 1001,
  title: "Daily Reminder",
  body: "Don't forget to exercise!",
  scheduledAt: DateTime.now().add(Duration(days: 1)),
  repeatSettings: LocalNotificationRepeatSettings.daily(),
);

// Save to database
final doc = ref.app.model(
  LocalNotificationScheduleModel.collection(),
).create();
await doc.save(schedule);
```

**RemoteNotificationScheduleModel**: Schedule remote push notifications via backend

```dart
final remoteSchedule = RemoteNotificationScheduleModel(
  remoteNotificationScheduleId: "promo-001",
  title: "Special Offer",
  body: "Check out our new features!",
  scheduledAt: DateTime.now().add(Duration(hours: 2)),
  target: NotificationTarget.topic("all-users"),
);

await remoteSchedule.save();
```

### Functions Actions

**SendRemoteNotificationFunctionsAction**: Send push notifications from backend

```dart
final functions = ref.app.functions();

await functions.execute(
  SendRemoteNotificationFunctionsAction(
    title: "Breaking News",
    body: "Important update available.",
    token: userToken,  // or use topic/condition
    data: {"articleId": "abc123"},
  ),
);
```

### For Implementation Details

See the implementation-specific packages:
- `masamune_notification_firebase` - Firebase Cloud Messaging setup and usage
- `masamune_notification_local` - Local notification scheduling and display

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)