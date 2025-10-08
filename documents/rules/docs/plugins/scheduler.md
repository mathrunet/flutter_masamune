# スケジューラー

`スケジューラー`は下記のように利用する。

## 概要

`スケジューラー`は指定した時間にFirestoreのドキュメントをコピーしたり、削除したりする仕組みを提供する機能。

Cloud Functionsと連携して、定期的にスケジュールをチェックし、指定された時刻にドキュメントのコピーや削除を実行します。

## 設定方法

### katana.yamlを使用する場合(推奨)

1. `katana.yaml`に下記の設定を追加。

    ```yaml
    # katana.yaml

    # Describe the settings for creating a mechanism to copy Firestore documents at a specified time or to send notifications at a specified time.
    # If you put a schedule such as `every 10 minutes` in [time], it can be executed at the specified time.
    # 指定した時間にFirestoreのドキュメントをコピーしたり、指定した時間に通知を送信したりする仕組みを作成するための設定を記述します。
    # [time]に`every 10 minutes`のようなスケジュールを記述すると指定した時間に実行することができます。
    scheduler:
      enable: true           # スケジューラーを利用する場合false -> trueに変更
      time: every 5 minutes  # スケジュールをチェックする間隔
    ```

2. 下記のコマンドを実行して設定を適用。

    ```bash
    katana apply
    ```

    この方法により、自動的に`masamune_scheduler`パッケージがインストールされ、Cloud Functionsのスケジュール実行コードが生成されます。

3. `lib/adapter.dart`の`masamuneAdapters`に`SchedulerMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_scheduler/masamune_scheduler.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),
        const FunctionsMasamuneAdapter(),
        const ModelAdapter(),

        // スケジューラーのアダプターを追加
        const SchedulerMasamuneAdapter(),
    ];
    ```

### 手動でパッケージを追加する場合

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_scheduler
    ```

2. `lib/adapter.dart`の`masamuneAdapters`に`SchedulerMasamuneAdapter`を追加。

    ```dart
    // lib/adapter.dart

    import 'package:masamune_scheduler/masamune_scheduler.dart';

    /// Masamune adapter.
    ///
    /// The Masamune framework plugin functions can be defined together.
    // TODO: Add the adapters.
    final masamuneAdapters = <MasamuneAdapter>[
        const UniversalMasamuneAdapter(),
        const FunctionsMasamuneAdapter(),
        const ModelAdapter(),
        const SchedulerMasamuneAdapter(),
    ];
    ```

3. バックエンド側のCloud Functionsを手動で実装（後述）。

## 利用方法

### ドキュメントのコピースケジュール

指定した時刻にFirestoreのドキュメントを別のパスにコピーします。下書きを公開する場合などに利用できます。

```dart
class ScheduledPostPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // ドキュメントコピーのスケジュールを作成
        final schedule = ref.app.model(
          ModelCopyDocumentSchedule.collection(),
        ).create();

        await schedule.save(
          ModelCopyDocumentSchedule(
            sourceCollectionPath: "posts",          // コピー元のコレクション
            sourceDocumentId: "draft_123",          // コピー元のドキュメントID
            targetCollectionPath: "posts",          // コピー先のコレクション
            targetDocumentId: "published_123",      // コピー先のドキュメントID
            executeAt: DateTime.now().add(const Duration(hours: 1)),  // 実行時刻
          ),
        );

        print("1時間後に公開予定");
      },
      child: const Text("投稿をスケジュール"),
    );
  }
}
```

### ドキュメントの削除スケジュール

指定した条件に一致するドキュメントを削除します。古いログの削除などに利用できます。

```dart
class LogCleanupPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // 古いログの削除スケジュールを作成
        final deleteScheduleCollection = ref.app.model(
          ModelDeleteDocumentsSchedule.collection(),
        );

        final deleteSchedule = deleteScheduleCollection.create();
        await deleteSchedule.save(
          ModelDeleteDocumentsSchedule(
            collectionPath: "logs",                 // 削除対象のコレクション
            field: "createdAt",                     // 比較するフィールド
            endAt: DateTime.now().subtract(const Duration(days: 30)),  // 30日以前のログを削除
          ),
        );

        print("30日以前のログを削除するスケジュールを作成");
      },
      child: const Text("古いログを削除"),
    );
  }
}
```

### バックエンド実装（Cloud Functions）

`katana apply`を実行すると、Cloud Functionsのスケジュール実行コードが自動生成されます。

手動で実装する場合は以下のようになります：

```typescript
// functions/src/index.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// スケジュールを処理する関数（5分ごとに実行）
export const processSchedules = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();

    // コピースケジュールを処理
    const copySchedules = await admin.firestore()
      .collection('model_copy_document_schedule')
      .where('executeAt', '<=', now)
      .where('executed', '==', false)
      .get();

    for (const doc of copySchedules.docs) {
      const schedule = doc.data();

      try {
        // ドキュメントをコピー
        const sourceDoc = await admin.firestore()
          .collection(schedule.sourceCollectionPath)
          .doc(schedule.sourceDocumentId)
          .get();

        if (sourceDoc.exists) {
          await admin.firestore()
            .collection(schedule.targetCollectionPath)
            .doc(schedule.targetDocumentId)
            .set(sourceDoc.data());

          console.log(`Copied document: ${schedule.sourceDocumentId} -> ${schedule.targetDocumentId}`);
        }

        // 実行済みとしてマーク
        await doc.ref.update({ executed: true, executedAt: now });
      } catch (error) {
        console.error(`Error copying document:`, error);
        await doc.ref.update({ error: error.message });
      }
    }

    // 削除スケジュールを処理
    const deleteSchedules = await admin.firestore()
      .collection('model_delete_documents_schedule')
      .where('executeAt', '<=', now)
      .where('executed', '==', false)
      .get();

    for (const doc of deleteSchedules.docs) {
      const schedule = doc.data();

      try {
        // 条件に一致するドキュメントを削除
        const docsToDelete = await admin.firestore()
          .collection(schedule.collectionPath)
          .where(schedule.field, '<=', schedule.endAt)
          .get();

        const batch = admin.firestore().batch();
        docsToDelete.docs.forEach((doc) => {
          batch.delete(doc.ref);
        });
        await batch.commit();

        console.log(`Deleted ${docsToDelete.size} documents from ${schedule.collectionPath}`);

        // 実行済みとしてマーク
        await doc.ref.update({ executed: true, executedAt: now });
      } catch (error) {
        console.error(`Error deleting documents:`, error);
        await doc.ref.update({ error: error.message });
      }
    }
  });
```

## 実装例: 下書き投稿の予約公開

```dart
class CreatePostPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(PostFormValue.form(PostFormValue()));

    return Scaffold(
      appBar: AppBar(title: Text("投稿作成")),
      body: Column(
        children: [
          FormTextField(
            form: form,
            name: "title",
            hintText: "タイトル",
          ),
          FormTextField(
            form: form,
            name: "content",
            hintText: "本文",
          ),
          FormDateTimeField(
            form: form,
            name: "publishAt",
            hintText: "公開日時",
          ),
          FormButton(
            form: form,
            onPressed: () async {
              // 下書きを保存
              final draftId = uuid();
              final draftPost = ref.app.model(PostModel.collection()).create(draftId);
              await draftPost.save(
                PostModel(
                  title: form.value.title,
                  content: form.value.content,
                  status: "draft",
                ),
              );

              // コピースケジュールを作成
              final schedule = ref.app.model(
                ModelCopyDocumentSchedule.collection(),
              ).create();

              await schedule.save(
                ModelCopyDocumentSchedule(
                  sourceCollectionPath: "posts",
                  sourceDocumentId: draftId,
                  targetCollectionPath: "posts",
                  targetDocumentId: draftId,  // 同じIDで上書き
                  executeAt: form.value.publishAt,
                ),
              );

              context.navigator.pop();
            },
            child: Text("予約投稿"),
          ),
        ],
      ),
    );
  }
}
```

## 実装例: 一時ファイルの自動削除

```dart
class TempFileCleanupPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // 7日以前の一時ファイルを削除するスケジュール
        final schedule = ref.app.model(
          ModelDeleteDocumentsSchedule.collection(),
        ).create();

        await schedule.save(
          ModelDeleteDocumentsSchedule(
            collectionPath: "temp_files",
            field: "createdAt",
            endAt: DateTime.now().subtract(const Duration(days: 7)),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("古い一時ファイルの削除をスケジュールしました")),
        );
      },
      child: Text("一時ファイルをクリーンアップ"),
    );
  }
}
```

## 実装例: 定期的なデータアーカイブ

```dart
class DataArchivePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // 月次でアーカイブコレクションにコピー
        final now = DateTime.now();
        final lastMonth = DateTime(now.year, now.month - 1);
        final archiveCollectionPath = "archives/${lastMonth.year}/${lastMonth.month}";

        // 先月のデータをアーカイブ
        final oldData = await ref.app.model(DataModel.collection())
          .query()
          .where("createdAt", isLessThan: lastMonth)
          .get();

        for (final data in oldData) {
          final schedule = ref.app.model(
            ModelCopyDocumentSchedule.collection(),
          ).create();

          await schedule.save(
            ModelCopyDocumentSchedule(
              sourceCollectionPath: "data",
              sourceDocumentId: data.id,
              targetCollectionPath: archiveCollectionPath,
              targetDocumentId: data.id,
              executeAt: DateTime.now().add(const Duration(minutes: 5)),
            ),
          );
        }

        print("アーカイブスケジュールを作成しました");
      },
      child: Text("データをアーカイブ"),
    );
  }
}
```

### Tips

- `katana apply`でCloud Functionsのコードが自動生成されるため、手動実装は不要
- スケジュールの実行間隔は`katana.yaml`の`time`で設定（例: `every 5 minutes`, `every 1 hours`）
- `executeAt`にはサーバータイムスタンプ（`FieldValue.serverTimestamp()`）を使用すると、タイムゾーンの問題を回避できる
- 実行済みのスケジュールは`executed: true`でマークされるため、重複実行を防げる
- エラー発生時は`error`フィールドにエラーメッセージが記録される
- 下書きの予約公開、古いログの自動削除、定期的なアーカイブなどに活用できる
- Cloud Functionsでリトライやエラーログを実装すると、一時的な障害に対処できる
- `katana_cli`で生成されたモデルを使用すると、型安全にスケジュールを作成できる
