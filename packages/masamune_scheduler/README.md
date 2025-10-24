<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Scheduler</h1>
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

# Masamune Scheduler

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_scheduler
```

Run `flutter pub get` when editing `pubspec.yaml` manually.

### Register the Adapter

Configure scheduler queries alongside other Masamune adapters. The scheduler works with Functions to copy or delete documents on a schedule.

```dart
// lib/adapter.dart

/// Masamune adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  const FunctionsMasamuneAdapter(),
  const ModelAdapter(),
  const SchedulerMasamuneAdapter(),
];
```

Ensure you have set up Masamune Models for your app because scheduler queries operate on them.

### Define Schedules

Use the provided schedule models to set up copy/delete operations triggered by server commands.

**Copy Document Schedule**:

```dart
class ScheduledPostPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Schedule a document copy (e.g., publish draft at specific time)
        final schedule = ref.app.model(
          ModelCopyDocumentSchedule.collection(),
        ).create();
        
        await schedule.save(
          ModelCopyDocumentSchedule(
            sourceCollectionPath: "posts",
            sourceDocumentId: "draft_123",
            targetCollectionPath: "posts",
            targetDocumentId: "published_123",
            executeAt: DateTime.now().add(const Duration(hours: 1)),
          ),
        );
        
        print("Scheduled to publish in 1 hour");
      },
      child: const Text("Schedule Post"),
    );
  }
}
```

**Delete Documents Schedule**:

```dart
// Schedule deletion of old logs
final deleteScheduleCollection = ref.app.model(
  ModelDeleteDocumentsSchedule.collection(),
);

final deleteSchedule = deleteScheduleCollection.create();
await deleteSchedule.save(
  ModelDeleteDocumentsSchedule(
    collectionPath: "logs",
    field: "createdAt",
    endAt: DateTime.now().subtract(const Duration(days: 30)),  // Delete logs older than 30 days
  ),
);
```

### Backend Implementation

Your Cloud Functions should periodically check for pending schedules and execute them:

**Scheduled Function Example**:

```typescript
// Cloud Functions (runs every 5 minutes)
export const processSchedules = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    
    // Find pending copy schedules
    const copySchedules = await admin.firestore()
      .collection('model_copy_document_schedule')
      .where('executeAt', '<=', now)
      .where('executed', '==', false)
      .get();
    
    for (const doc of copySchedules.docs) {
      const schedule = doc.data();
      
      // Copy document
      const sourceDoc = await admin.firestore()
        .collection(schedule.sourceCollectionPath)
        .doc(schedule.sourceDocumentId)
        .get();
      
      if (sourceDoc.exists) {
        await admin.firestore()
          .collection(schedule.targetCollectionPath)
          .doc(schedule.targetDocumentId)
          .set(sourceDoc.data());
      }
      
      // Mark as executed
      await doc.ref.update({ executed: true });
    }
    
    // Process delete schedules similarly...
  });
```

**Alternative: Server Command Pattern**:

```dart
// Client creates a command for the server to process
final command = ModelServerCommandCopyDocumentSchedule(
  scheduleId: copySchedule.id,
);
await command.save();
```

Your backend queries pending commands and executes them.

### Tips

- Combine with `katana_cli` generated models to ensure type safety.
- Store schedule metadata in Firestore/Database for auditing.
- Implement retries and error logging in your Functions to handle transient failures.
- Use server timestamps (`FieldValue.serverTimestamp()`) for consistent scheduling across time zones.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)