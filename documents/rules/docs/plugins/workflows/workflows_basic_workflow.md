# 基本ワークフロー機能

このドキュメントでは、Masamune Workflowの基本機能であるスケジューラーとアセット管理について詳しく説明します。

## スケジューラー機能

Masamune Workflowには3つのスケジューラー機能が提供されています。これらは自動的にバックエンドで動作し、ワークフローとタスクのライフサイクルを管理します。

### workflowScheduler - ワークフローの自動実行

**概要**
- ワークフローの自動実行を管理するスケジューラー
- 設定された時刻に自動的にタスクを作成

**動作仕様**
- **実行間隔**: 1分ごと
- **監視対象**: `WorkflowModel`の`nextTime`フィールド
- **処理内容**:
  - 現在時刻を過ぎた`nextTime`を持つワークフローを検出
  - 対応するタスクを自動作成
  - 次回実行時刻を更新

**繰り返し設定**
```dart
// 日次実行
workflow.interval = WorkflowInterval.daily;

// 週次実行
workflow.interval = WorkflowInterval.weekly;

// 月次実行
workflow.interval = WorkflowInterval.monthly;

// 1回限りの実行
workflow.interval = WorkflowInterval.once;
```

**実装例**
```dart
// 毎日9:00に実行されるワークフロー
final workflow = await ref.app.model(
  WorkflowModel.collection().create({
    "name": "日次レポート生成",
    "actions": ["analyze_marketing_data", "generate_marketing_pdf"],
    "interval": WorkflowInterval.daily,
    "nextTime": DateTime(2024, 1, 1, 9, 0), // 次回実行時刻
    "enabled": true,
  }),
);
```

### taskScheduler - タスクの実行管理

**概要**
- 待機中のタスクを実行状態に移行
- アクションをバックエンドのキューに追加

**動作仕様**
- **実行間隔**: 1分ごと
- **監視対象**: `status = TaskStatus.waiting`のタスク
- **処理内容**:
  1. 待機中タスクを検出
  2. ステータスを`running`に変更
  3. 各アクションをFirebase Functionsのキューに追加
  4. アクション完了を監視

**タスクのライフサイクル**
```
created → waiting → running → completed
           ↑                      ↓
           ←───── error ─────────←
```

**実装例**
```dart
// タスクのステータスを監視
ref.app.model(TaskModel.document("task_id")).watch(
  onUpdate: (task) {
    switch (task.value?.status) {
      case TaskStatus.waiting:
        print("タスク待機中");
        break;
      case TaskStatus.running:
        print("タスク実行中");
        break;
      case TaskStatus.completed:
        print("タスク完了");
        break;
      case TaskStatus.error:
        print("エラー発生: ${task.value?.error}");
        break;
    }
  },
);
```

### taskCleaner - 完了タスクのクリーンアップ

**概要**
- 完了したタスクの不要データを削除
- ストレージの最適化

**動作仕様**
- **実行タイミング**: タスク完了から24時間後
- **削除対象**:
  - 一時的な処理データ
  - 中間ファイル
  - デバッグログ
- **保持データ**:
  - タスクの基本情報
  - 最終結果
  - 生成されたアセット

**設定例**
```yaml
# katana.yaml
workflow:
  task_retention_days: 7  # タスクデータの保持期間（デフォルト: 7日）
  auto_cleanup: true      # 自動クリーンアップの有効化
```

## アセット取得機能

### asset - アセットデータ取得

**概要**
- 生成されたアセットのメタデータと署名付きURLを取得
- Cloud Storageからの安全なダウンロードリンクを提供

**アクションID**: `asset`

**パラメータ**
```typescript
interface AssetActionParameters {
  data: {
    id: string;  // アセットID（必須）
  }
}
```

**レスポンス**
```typescript
interface AssetActionResponse {
  url: string;         // Cloud Storage内部URL (gs://...)
  public_url: string;  // 公開URL（権限設定が必要）
  content_type: string; // MIMEタイプ
  signedUri: string;   // 署名付きURL（有効期限付き）
  metadata?: {
    size: number;      // ファイルサイズ（バイト）
    created_at: string; // 作成日時
    updated_at: string; // 更新日時
    custom?: any;      // カスタムメタデータ
  }
}
```

**使用例**

```dart
// 1. アセットの取得と表示
final task = await ref.app.model(TaskModel.document("task_id")).load();
final assetId = task.value?.response["assets"]["generatedImage"];

// アセット情報を取得
final assetAction = await ref.app.model(
  ActionModel.collection().create({
    "type": "asset",
    "data": {
      "id": assetId,
    },
  }),
);

// 署名付きURLから画像を表示
final signedUrl = assetAction.response["signedUri"];
Image.network(signedUrl);
```

```dart
// 2. 複数アセットの一括取得
Future<List<String>> getAssetUrls(List<String> assetIds) async {
  final urls = <String>[];

  for (final assetId in assetIds) {
    final action = await ref.app.model(
      ActionModel.collection().create({
        "type": "asset",
        "data": {"id": assetId},
      }),
    );

    urls.add(action.response["signedUri"]);
  }

  return urls;
}
```

**署名付きURLの有効期限**
- デフォルト: 1時間
- 最大: 7日間
- カスタム設定可能

```typescript
// Firebase Functions側でのカスタム設定
const signedUrlOptions = {
  action: 'read',
  expires: Date.now() + 3600 * 1000, // 1時間後に期限切れ
};
```

## エラーハンドリング

### スケジューラーのエラー処理

```dart
// ワークフローエラーの監視
ref.app.model(WorkflowModel.collection()).documents.watch(
  onUpdate: (workflows) {
    for (final workflow in workflows) {
      if (workflow.value?.lastError != null) {
        // エラー通知
        NotificationService.send(
          "ワークフローエラー: ${workflow.value?.name}",
          workflow.value?.lastError,
        );
      }
    }
  },
);
```

### アセット取得のエラー処理

```dart
try {
  final action = await ref.app.model(
    ActionModel.collection().create({
      "type": "asset",
      "data": {"id": assetId},
    }),
  );

  if (action.status == ActionStatus.error) {
    throw Exception(action.error);
  }

  return action.response["signedUri"];
} catch (e) {
  // エラー処理
  if (e.toString().contains("not found")) {
    print("アセットが見つかりません");
  } else if (e.toString().contains("permission denied")) {
    print("アクセス権限がありません");
  } else {
    print("予期しないエラー: $e");
  }
}
```

## パフォーマンス最適化

### スケジューラーの最適化

1. **バッチ処理**
   - 複数のワークフローを一括処理
   - データベースアクセスを最小化

2. **インデックス設定**
   ```firestore
   // Firestoreインデックス
   workflows: nextTime ASC, enabled DESC
   tasks: status ASC, created_at ASC
   ```

3. **並列実行**
   - タスクアクションの並列実行
   - 最大同時実行数の制御

### アセット管理の最適化

1. **CDN配信**
   ```yaml
   # katana.yaml
   workflow:
     asset_cdn: true
     cdn_region: asia-northeast1
   ```

2. **キャッシュ戦略**
   ```dart
   // クライアント側キャッシュ
   CachedNetworkImage(
     imageUrl: signedUrl,
     cacheManager: CustomCacheManager(),
     maxAge: Duration(days: 7),
   );
   ```

3. **プリフェッチ**
   ```dart
   // 事前にアセットURLを取得
   Future<void> prefetchAssets(List<String> assetIds) async {
     await Future.wait(
       assetIds.map((id) => getAssetUrl(id)),
     );
   }
   ```

## まとめ

基本ワークフロー機能は、Masamune Workflowの中核となる機能です。スケジューラーによる自動化と、安全なアセット管理により、複雑なワークフローを効率的に実行できます。

### 次のステップ
- [アセット生成機能](asset_generation.dart) - 画像・音声・テキストの生成
- [マーケティング分析機能](marketing_analytics.dart) - データ分析とレポート生成
- [メインドキュメントに戻る](../workflow.dart)
