<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Notification Local</h1>
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

# Masamune Notification Local

## Overview

`masamune_notification_local` provides local notification functionality for Masamune apps. Schedule and display notifications on the device without a backend.

**Note**: Requires `masamune_notification` for core notification functionality.

## Usage

### Installation

```bash
flutter pub add masamune_notification
flutter pub add masamune_notification_local
```

### Register the Adapter

Configure `MobileLocalNotificationMasamuneAdapter` for local notifications.

```dart
// lib/adapter.dart

import 'package:masamune_notification_local/masamune_notification_local.dart';

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const MobileLocalNotificationMasamuneAdapter(
    androidNotificationIcon: "@mipmap/ic_launcher",  // App icon for notifications
    requestAlertPermissionOnInitialize: true,        // Request alert permission on init
    requestSoundPermissionOnInitialize: true,        // Request sound permission
    requestBadgePermissionOnInitialize: true,        // Request badge permission
  ),
];
```

### Initialize Local Notifications

Initialize the local notification controller:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localNotification = appRef.controller(LocalNotification.query());

    // Initialize on app start
    localNotification.initialize(
      onTap: (notificationId, payload) {
        print("Notification $notificationId tapped with: $payload");
        // Navigate or handle tap
      },
    );

    return MasamuneApp(...);
  }
}
```

### Show Immediate Notification

Display a notification right away:

```dart
class ReminderPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final notification = ref.app.controller(LocalNotification.query());

    return ElevatedButton(
      onPressed: () async {
        await notification.show(
          notificationId: 100,
          title: "Task Complete",
          body: "You've finished all your tasks!",
          payload: "task_complete",  // Optional data
        );
      },
      child: const Text("Show Notification"),
    );
  }
}
```

### Schedule Future Notifications

Schedule notifications for a specific time:

```dart
// Schedule a one-time notification
await notification.schedule(
  notificationId: 1001,
  title: "Meeting Reminder",
  body: "Team meeting starts in 10 minutes",
  scheduledDate: DateTime.now().add(Duration(minutes: 10)),
  androidAllowWhileIdle: true,  // Show even in Doze mode
  payload: "meeting_123",
);
```

### Repeating Notifications

Schedule daily, weekly, or custom repeating notifications:

```dart
// Daily reminder
await notification.schedule(
  notificationId: 2001,
  title: "Daily Exercise",
  body: "Time for your daily workout!",
  scheduledDate: DateTime(2025, 10, 8, 9, 0),  // 9:00 AM
  repeatSettings: LocalNotificationRepeatSettings.daily(),
);

// Weekly reminder
await notification.schedule(
  notificationId: 2002,
  title: "Weekly Report",
  body: "Submit your weekly report",
  scheduledDate: DateTime(2025, 10, 13, 17, 0),  // Friday 5:00 PM
  repeatSettings: LocalNotificationRepeatSettings.weekly(),
);
```

### Cancel Notifications

```dart
// Cancel specific notification
await notification.cancel(1001);

// Cancel all notifications
await notification.cancelAll();
```

### Persist Schedules with Models

Use `LocalNotificationScheduleModel` for long-term storage:

```dart
final schedule = LocalNotificationScheduleModel(
  localNotificationScheduleId: "daily-reminder",
  notificationId: 3001,
  title: "Morning Meditation",
  body: "Start your day with 10 minutes of meditation",
  scheduledAt: DateTime(2025, 10, 8, 7, 0),
  repeatSettings: LocalNotificationRepeatSettings.daily(),
);

// Save to database
final doc = ref.app.model(
  LocalNotificationScheduleModel.collection(),
).create();
await doc.save(schedule);
```

### Platform Configuration

**Android**: Add notification icon to resources:

```xml
<!-- android/app/src/main/res/drawable/ic_notification.xml -->
<!-- Or use @mipmap/ic_launcher -->
```

**iOS**: Request permissions at runtime (automatically handled by adapter if enabled).

### Tips

- Call `initializeTimeZones()` before scheduling to ensure correct timing
- Use `androidAllowWhileIdle` for critical reminders
- Provide unique notification IDs to manage multiple notifications
- Test with different time zones and device settings
- Cancel old notifications when rescheduling to avoid duplicates

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)