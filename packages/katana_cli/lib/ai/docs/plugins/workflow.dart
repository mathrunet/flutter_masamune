// Project imports:
import "package:katana_cli/ai/docs/plugin_usage.dart";

/// Contents of workflow.md.
///
/// workflow.mdの中身。
class PluginWorkflowMdCliAiCode extends PluginUsageCliAiCode {
  /// Contents of workflow.md.
  ///
  /// workflow.mdの中身。
  const PluginWorkflowMdCliAiCode();

  @override
  String get name => "Workflow";

  @override
  String get description => "`Workflow`の利用方法";

  @override
  String get globs => "*";

  @override
  String get directory => "docs/plugins";

  @override
  String get excerpt => "`Workflow`はワークフローを管理する機能を提供するプラグイン。";

  @override
  String body(String baseName, String className) {
    return r"""
`Workflow`は下記のように利用する。

## 概要

`masamune_workflow`は、タスク実行のためのワークフロー管理機能を提供するパッケージ。

組織・プロジェクト・ワークフロー・タスク・アクションの階層構造でワークフローを管理し、Firestoreにデータを保存する。

**階層構造:**

```
組織（Organization）
  └── プロジェクト（Project）
        └── ワークフロー（Workflow）
              └── タスク（Task）
                    └── アクション（Action）
```

**注意**: このパッケージはアダプターを使用しません。データモデルのみを提供します。

## 設定方法

1. パッケージをプロジェクトに追加。

    ```bash
    flutter pub add masamune_workflow
    ```

2. 利用するファイルでインポート。

    ```dart
    import 'package:masamune_workflow/masamune_workflow.dart';
    ```

## 利用方法

### 組織の管理

組織を作成・取得します。

```dart
class OrganizationPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    // 組織一覧を取得
    final organizations = ref.app.model(
      WorkflowOrganizationModel.collection(),
    )..load();

    return Scaffold(
      appBar: AppBar(title: Text("組織一覧")),
      body: ListView.builder(
        itemCount: organizations.length,
        itemBuilder: (context, index) {
          final org = organizations[index];
          return ListTile(
            leading: org.value?.icon != null
                ? Image.network(org.value!.icon!)
                : Icon(Icons.business),
            title: Text(org.value?.name ?? ""),
            subtitle: Text(org.value?.description ?? ""),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 新しい組織を作成
          final newOrg = organizations.create();
          await newOrg.save(
            WorkflowOrganizationModel(
              name: "新規組織",
              description: "組織の説明",
              ownerId: ref.app.userId,  // 現在のユーザーをオーナーに設定
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 組織メンバーの管理

組織にメンバーを追加・管理します。

```dart
class MemberManagementPage extends PageScopedWidget {
  const MemberManagementPage({required this.organizationId});

  final String organizationId;

  @override
  Widget build(BuildContext context, PageRef ref) {
    // 組織のメンバー一覧を取得
    final members = ref.app.model(
      WorkflowOrganizationMemberModel.collection(organizationId),
    )..load();

    return Scaffold(
      appBar: AppBar(title: Text("メンバー管理")),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return ListTile(
            title: Text(member.value?.userId ?? ""),
            subtitle: Text(_roleToString(member.value?.role)),
            trailing: PopupMenuButton<WorkflowRole>(
              onSelected: (role) async {
                // ロールを更新
                await member.save(
                  member.value!.copyWith(role: role),
                );
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: WorkflowRole.admin, child: Text("管理者")),
                PopupMenuItem(value: WorkflowRole.editor, child: Text("編集者")),
                PopupMenuItem(value: WorkflowRole.viewer, child: Text("閲覧者")),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 新しいメンバーを追加
          final newMember = members.create();
          await newMember.save(
            WorkflowOrganizationMemberModel(
              role: WorkflowRole.viewer,
              userId: "user_id_to_add",
              organization: WorkflowOrganizationModelRefPath(organizationId),
            ),
          );
        },
        child: Icon(Icons.person_add),
      ),
    );
  }

  String _roleToString(WorkflowRole? role) {
    switch (role) {
      case WorkflowRole.admin:
        return "管理者";
      case WorkflowRole.editor:
        return "編集者";
      case WorkflowRole.viewer:
        return "閲覧者";
      default:
        return "未設定";
    }
  }
}
```

**WorkflowRole列挙型:**

| 値 | 説明 |
|---|---|
| `admin` | 管理者。全ての操作が可能 |
| `editor` | 編集者。編集・実行が可能 |
| `viewer` | 閲覧者。閲覧のみ可能 |

### プロジェクトの管理

組織内でプロジェクトを管理します。

```dart
class ProjectPage extends PageScopedWidget {
  const ProjectPage({required this.organizationId});

  final String organizationId;

  @override
  Widget build(BuildContext context, PageRef ref) {
    // 組織に紐づくプロジェクト一覧を取得
    final projects = ref.app.model(
      WorkflowProjectModel.collection().organization.equal(
        WorkflowOrganizationModelRefPath(organizationId),
      ),
    )..load();

    return Scaffold(
      appBar: AppBar(title: Text("プロジェクト一覧")),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ListTile(
            title: Text(project.value?.name ?? ""),
            subtitle: Text(project.value?.description ?? ""),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 新しいプロジェクトを作成
          final allProjects = ref.app.model(
            WorkflowProjectModel.collection(),
          );
          final newProject = allProjects.create();
          await newProject.save(
            WorkflowProjectModel(
              name: "新規プロジェクト",
              description: "プロジェクトの説明",
              concept: "プロジェクトのコンセプト",
              goal: "達成目標",
              target: "ターゲットユーザー",
              locale: ModelLocale.fromLocale(Locale("ja")),
              organization: WorkflowOrganizationModelRefPath(organizationId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### ワークフローの作成

繰り返し実行可能なワークフローを定義します。

```dart
class WorkflowCreatePage extends PageScopedWidget {
  const WorkflowCreatePage({
    required this.organizationId,
    required this.projectId,
  });

  final String organizationId;
  final String projectId;

  @override
  Widget build(BuildContext context, PageRef ref) {
    final form = ref.page.form(
      WorkflowWorkflowModel.form(
        WorkflowWorkflowModel(
          repeat: WorkflowRepeat.none,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("ワークフロー作成")),
      body: Column(
        children: [
          FormTextField(
            form: form,
            name: WorkflowWorkflowModelKeys.name.name,
            hintText: "ワークフロー名",
          ),
          FormTextField(
            form: form,
            name: WorkflowWorkflowModelKeys.prompt.name,
            hintText: "プロンプト",
            maxLines: 5,
          ),
          FormDropdownField<WorkflowRepeat>(
            form: form,
            name: WorkflowWorkflowModelKeys.repeat.name,
            items: [
              DropdownMenuItem(value: WorkflowRepeat.none, child: Text("繰り返しなし")),
              DropdownMenuItem(value: WorkflowRepeat.daily, child: Text("毎日")),
              DropdownMenuItem(value: WorkflowRepeat.weekly, child: Text("毎週")),
              DropdownMenuItem(value: WorkflowRepeat.monthly, child: Text("毎月")),
            ],
          ),
          FormButton(
            form: form,
            onPressed: () async {
              final workflows = ref.app.model(
                WorkflowWorkflowModel.collection(),
              );
              final newWorkflow = workflows.create();
              await newWorkflow.save(
                form.value.copyWith(
                  organization: WorkflowOrganizationModelRefPath(organizationId),
                  project: WorkflowProjectModelRefPath(projectId),
                  actions: [
                    // 実行するアクションを定義
                    WorkflowActionCommandValue(
                      command: "generate_content",
                      index: 0,
                      data: {"type": "article"},
                    ),
                    WorkflowActionCommandValue(
                      command: "publish",
                      index: 1,
                      data: {"platform": "web"},
                    ),
                  ],
                ),
              );
              context.navigator.pop();
            },
            child: Text("作成"),
          ),
        ],
      ),
    );
  }
}
```

**WorkflowRepeat列挙型:**

| 値 | 説明 |
|---|---|
| `none` | 繰り返しなし（1回のみ実行） |
| `daily` | 毎日実行 |
| `weekly` | 毎週実行 |
| `monthly` | 毎月実行 |

### タスクの実行

ワークフローからタスクを作成し、実行状態を管理します。

```dart
class TaskExecutionPage extends PageScopedWidget {
  const TaskExecutionPage({required this.workflowId});

  final String workflowId;

  @override
  Widget build(BuildContext context, PageRef ref) {
    // ワークフローを取得
    final workflow = ref.app.model(
      WorkflowWorkflowModel.document(workflowId),
    )..load();

    // タスク一覧を取得
    final tasks = ref.app.model(
      WorkflowTaskModel.collection().workflow.equal(
        WorkflowWorkflowModelRefPath(workflowId),
      ),
    )..load();

    return Scaffold(
      appBar: AppBar(title: Text(workflow.value?.name ?? "タスク実行")),
      body: Column(
        children: [
          // タスク一覧
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text("タスク ${task.uid}"),
                  subtitle: Text(_statusToString(task.value?.status)),
                  trailing: _buildStatusIcon(task.value?.status),
                  onTap: () {
                    // タスク詳細ページへ遷移
                  },
                );
              },
            ),
          ),
          // 新規タスク作成ボタン
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                if (workflow.value == null) return;

                final allTasks = ref.app.model(
                  WorkflowTaskModel.collection(),
                );
                final newTask = allTasks.create();
                await newTask.save(
                  WorkflowTaskModel(
                    workflow: WorkflowWorkflowModelRefPath(workflowId),
                    organization: workflow.value!.organization,
                    project: workflow.value!.project,
                    status: WorkflowTaskStatus.waiting,
                    actions: workflow.value!.actions,
                    prompt: workflow.value!.prompt,
                    materials: workflow.value!.materials,
                  ),
                );
              },
              child: Text("新規タスクを作成"),
            ),
          ),
        ],
      ),
    );
  }

  String _statusToString(WorkflowTaskStatus? status) {
    switch (status) {
      case WorkflowTaskStatus.waiting:
        return "待機中";
      case WorkflowTaskStatus.running:
        return "実行中";
      case WorkflowTaskStatus.completed:
        return "完了";
      case WorkflowTaskStatus.failed:
        return "失敗";
      case WorkflowTaskStatus.canceled:
        return "キャンセル";
      default:
        return "不明";
    }
  }

  Widget _buildStatusIcon(WorkflowTaskStatus? status) {
    switch (status) {
      case WorkflowTaskStatus.waiting:
        return Icon(Icons.schedule, color: Colors.grey);
      case WorkflowTaskStatus.running:
        return CircularProgressIndicator();
      case WorkflowTaskStatus.completed:
        return Icon(Icons.check_circle, color: Colors.green);
      case WorkflowTaskStatus.failed:
        return Icon(Icons.error, color: Colors.red);
      case WorkflowTaskStatus.canceled:
        return Icon(Icons.cancel, color: Colors.orange);
      default:
        return Icon(Icons.help_outline);
    }
  }
}
```

**WorkflowTaskStatus列挙型:**

| 値 | 説明 |
|---|---|
| `waiting` | 待機中。実行待ち |
| `running` | 実行中 |
| `completed` | 完了。正常に終了 |
| `failed` | 失敗。エラーが発生 |
| `canceled` | キャンセル。ユーザーにより中止 |

### アクションの管理

タスク内の個別アクションを管理し、ログを記録します。

```dart
class ActionDetailPage extends PageScopedWidget {
  const ActionDetailPage({required this.actionId});

  final String actionId;

  @override
  Widget build(BuildContext context, PageRef ref) {
    // アクションを取得
    final action = ref.app.model(
      WorkflowActionModel.document(actionId),
    )..load();

    return Scaffold(
      appBar: AppBar(title: Text("アクション詳細")),
      body: action.value == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // コマンド情報
                  Text(
                    "コマンド: ${action.value!.command.command}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text("インデックス: ${action.value!.command.index}"),

                  // ステータス
                  SizedBox(height: 16),
                  Text(
                    "ステータス: ${action.value!.status}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  // ログ一覧
                  SizedBox(height: 16),
                  Text(
                    "ログ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...action.value!.log.map((log) => Card(
                    child: ListTile(
                      leading: _buildPhaseIcon(log.phase),
                      title: Text(log.message ?? ""),
                      subtitle: Text(log.time?.dateTime.toString() ?? ""),
                    ),
                  )),

                  // 結果
                  if (action.value!.results != null) ...[
                    SizedBox(height: 16),
                    Text(
                      "結果",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(action.value!.results.toString()),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildPhaseIcon(TaskLogPhase? phase) {
    switch (phase) {
      case TaskLogPhase.start:
        return Icon(Icons.play_arrow, color: Colors.blue);
      case TaskLogPhase.end:
        return Icon(Icons.stop, color: Colors.green);
      case TaskLogPhase.error:
        return Icon(Icons.error, color: Colors.red);
      case TaskLogPhase.warning:
        return Icon(Icons.warning, color: Colors.orange);
      case TaskLogPhase.info:
        return Icon(Icons.info, color: Colors.grey);
      default:
        return Icon(Icons.circle);
    }
  }
}
```

**TaskLogPhase列挙型:**

| 値 | 説明 |
|---|---|
| `start` | 開始ログ |
| `end` | 終了ログ |
| `error` | エラーログ |
| `warning` | 警告ログ |
| `info` | 情報ログ |

**WorkflowActionCommandValue:**

```dart
// アクションコマンドの定義
WorkflowActionCommandValue(
  command: "generate_content",  // コマンド名
  index: 0,                     // 実行順序
  data: {                       // コマンドに渡すデータ
    "type": "article",
    "length": 1000,
  },
)
```

**WorkflowTaskLogValue:**

```dart
// ログの記録
WorkflowTaskLogValue(
  time: ModelTimestamp.now(),
  message: "コンテンツ生成を開始しました",
  action: "generate_content",
  phase: TaskLogPhase.start,
  data: {"input_tokens": 100},
)
```

### 使用量・プランの管理

組織の使用量やキャンペーン、プランを管理します。

```dart
class UsagePage extends PageScopedWidget {
  const UsagePage({required this.organizationId});

  final String organizationId;

  @override
  Widget build(BuildContext context, PageRef ref) {
    // 使用量を取得
    final usage = ref.app.model(
      WorkflowUsageModel.document(organizationId),
    )..load();

    return Scaffold(
      appBar: AppBar(title: Text("使用量")),
      body: usage.value == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "現在の使用量: ${usage.value!.usage}",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text("今月: ${usage.value!.currentMonth}"),
                  Text("バケット残高: ${usage.value!.bucketBalance}"),
                  if (usage.value!.latestPlan != null)
                    Text("プラン: ${usage.value!.latestPlan}"),
                ],
              ),
            ),
    );
  }
}
```

### アセット・ページの管理

ワークフローで生成されたアセットやページを管理します。

```dart
class AssetListPage extends PageScopedWidget {
  const AssetListPage({required this.organizationId});

  final String organizationId;

  @override
  Widget build(BuildContext context, PageRef ref) {
    // アセット一覧を取得
    final assets = ref.app.model(
      WorkflowAssetModel.collection().organization.equal(
        WorkflowOrganizationModelRefPath(organizationId),
      ),
    )..load();

    return Scaffold(
      appBar: AppBar(title: Text("アセット一覧")),
      body: ListView.builder(
        itemCount: assets.length,
        itemBuilder: (context, index) {
          final asset = assets[index];
          return ListTile(
            title: Text(asset.value?.path ?? ""),
            subtitle: Text(asset.value?.mimtType ?? ""),
            trailing: Text(asset.value?.source ?? ""),
          );
        },
      ),
    );
  }
}
```

## モデル一覧

| モデル名 | Firestoreパス | 説明 |
|---------|--------------|------|
| `WorkflowOrganizationModel` | `plugins/workflow/organization` | 組織 |
| `WorkflowOrganizationMemberModel` | `plugins/workflow/organization/:id/member` | 組織メンバー |
| `WorkflowProjectModel` | `plugins/workflow/project` | プロジェクト |
| `WorkflowWorkflowModel` | `plugins/workflow/workflow` | ワークフロー定義 |
| `WorkflowTaskModel` | `plugins/workflow/task` | タスク |
| `WorkflowActionModel` | `plugins/workflow/action` | アクション |
| `WorkflowUsageModel` | `plugins/workflow/organization/:id/usage` | 使用量 |
| `WorkflowCampaignModel` | `plugins/workflow/campaign` | キャンペーン |
| `WorkflowPlanModel` | `plugins/workflow/plan` | プラン |
| `WorkflowCertificateModel` | `plugins/workflow/organization/:id/certificate` | 証明書 |
| `WorkflowAssetModel` | `plugins/workflow/asset` | アセット |
| `WorkflowPageModel` | `plugins/workflow/page` | ページ |
| `WorkflowAddressModel` | `plugins/workflow/address` | アドレス |

## 列挙型一覧

### WorkflowRepeat

| 値 | 説明 |
|---|---|
| `none` | 繰り返しなし |
| `daily` | 毎日 |
| `weekly` | 毎週 |
| `monthly` | 毎月 |

### WorkflowTaskStatus

| 値 | 説明 |
|---|---|
| `waiting` | 待機中 |
| `running` | 実行中 |
| `completed` | 完了 |
| `failed` | 失敗 |
| `canceled` | キャンセル |

### WorkflowRole

| 値 | 説明 |
|---|---|
| `admin` | 管理者 |
| `editor` | 編集者 |
| `viewer` | 閲覧者 |

### TaskLogPhase

| 値 | 説明 |
|---|---|
| `start` | 開始 |
| `end` | 終了 |
| `error` | エラー |
| `warning` | 警告 |
| `info` | 情報 |

## 値型一覧

### WorkflowActionCommandValue

アクションコマンドを定義する値型。

| フィールド | 型 | 説明 |
|-----------|---|------|
| `command` | `String` | コマンド名（必須） |
| `index` | `int` | 実行順序（必須） |
| `data` | `Map<String, dynamic>` | コマンドデータ |

### WorkflowTaskLogValue

タスクログを記録する値型。

| フィールド | 型 | 説明 |
|-----------|---|------|
| `time` | `ModelTimestamp?` | ログ時刻 |
| `message` | `String?` | ログメッセージ |
| `action` | `String?` | 関連アクション |
| `phase` | `TaskLogPhase?` | ログフェーズ |
| `data` | `Map<String, dynamic>?` | ログデータ |

## Tips

- **モデル参照の活用**: `ModelRef`と`RefPath`を使って、モデル間の関連を型安全に管理できる
- **フィルタリング**: `collection().field.equal(value)`でコレクションをフィルタリングして取得できる
- **ローカル開発**: `RuntimeModelAdapter`の`initialValue`に初期データを設定して、Firestore接続なしでテストできる

```dart
RuntimeModelAdapter(
  initialValue: [
    WorkflowOrganizationModelInitialCollection({
      "org_1": WorkflowOrganizationModel(
        name: "テスト組織",
        description: "テスト用の組織",
      ),
    }),
  ],
)
```

- **検索機能**: `@searchParam`が付いたフィールド（例: `WorkflowActionModel.search`）は全文検索に利用できる
- **タイムスタンプ**: `ModelTimestamp.now()`で現在時刻を設定、自動的にFirestoreのサーバータイムスタンプに変換される
- **ロケール**: `ModelLocale`を使って多言語対応のワークフローを構築できる

## バックエンド側の実装

ワークフローの実行にはバックエンド側（Firebase Functions）の実装が必要です。`node_masamune`パッケージ群を使用して、様々な自動化タスクを実行できます。

### Firebase Functionsの設定

1. **パッケージのインストール**

```bash
cd functions
npm install --save masamune_workflow
npm install --save masamune_workflow_asset  # 画像・音声生成機能を使う場合
npm install --save masamune_workflow_marketing  # マーケティング分析機能を使う場合
npm install --save masamune_workflow_sales  # セールスデータ収集機能を使う場合
```

2. **index.tsの設定例**

```typescript
import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";

// 基本ワークフロー機能
import {
  asset,
  taskScheduler,
  taskCleaner,
  workflowScheduler,
} from "masamune_workflow/functions";

// アセット生成機能
import {
  generateImageWithGemini,
  generateAudioWithGoogleTTS,
} from "masamune_workflow_asset/functions";

// マーケティング分析機能
import {
  collectFromGooglePlayConsole,
  collectFromAppStore,
  collectFromFirebaseAnalytics,
  analyzeMarketingData,
  generateMarketingPdf,
  analyzeGithubInit,
  analyzeGithubProcess,
  analyzeGithubSummary,
  researchMarket,
  analyzeMarketResearch,
} from "masamune_workflow_marketing/functions";

// セールス機能
import {
  collectGooglePlayDevelopers,
  collectAppStoreDevelopers,
} from "masamune_workflow_sales/functions";

// Firebase Admin初期化
admin.initializeApp();

// 基本機能のエクスポート
exports.asset = asset;
exports.task_scheduler = taskScheduler;
exports.task_cleaner = taskCleaner;
exports.workflow_scheduler = workflowScheduler;

// アセット生成機能のエクスポート
exports.generate_image_with_gemini = generateImageWithGemini;
exports.generate_audio_with_google_tts = generateAudioWithGoogleTTS;

// マーケティング機能のエクスポート
exports.collect_from_google_play_console = collectFromGooglePlayConsole;
exports.collect_from_app_store = collectFromAppStore;
exports.collect_from_firebase_analytics = collectFromFirebaseAnalytics;
exports.analyze_marketing_data = analyzeMarketingData;
exports.generate_marketing_pdf = generateMarketingPdf;
exports.analyze_github_init = analyzeGithubInit;
exports.analyze_github_process = analyzeGithubProcess;
exports.analyze_github_summary = analyzeGithubSummary;
exports.research_market = researchMarket;
exports.analyze_market_research = analyzeMarketResearch;

// セールス機能のエクスポート
exports.collect_google_play_developers = collectGooglePlayDevelopers;
exports.collect_app_store_developers = collectAppStoreDevelopers;
```

### 基本ワークフロー機能 (masamune_workflow)

#### スケジューラー機能

**workflowScheduler** - ワークフローの自動実行
- **実行間隔**: 1分ごと
- **機能**: `nextTime`が現在時刻を過ぎたワークフローから新しいタスクを自動作成
- **繰り返し設定**: `daily`, `weekly`, `monthly`に対応

**taskScheduler** - タスクの実行管理
- **実行間隔**: 1分ごと
- **機能**: `status=waiting`のタスクを`running`に変更し、アクション実行をキューに追加

**taskCleaner** - 完了タスクのクリーンアップ
- **機能**: 完了したタスクの不要データを削除

#### アセット取得機能

**asset** - アセットデータ取得
- **アクションID**: `asset`
- **パラメータ**:
  ```typescript
  {
    "data": {
      "id": "asset_id"  // アセットID
    }
  }
  ```
- **レスポンス**:
  ```typescript
  {
    "url": "gs://bucket/path/to/asset",
    "public_url": "https://storage.googleapis.com/...",
    "content_type": "image/png",
    "signedUri": "https://storage.googleapis.com/...?signature=..."
  }
  ```

### アセット生成機能 (masamune_workflow_asset)

#### 画像生成 - generate_image_with_gemini

**アクションID**: `generate_image_with_gemini`

**パラメータ**:
```typescript
{
  "prompt": "美しい夕焼けの風景",              // 必須: 生成する画像の説明
  "negative_prompt": "人物、建物",            // 任意: 除外したい要素
  "width": 1024,                            // 任意: 画像幅（デフォルト: 1024）
  "height": 1024,                           // 任意: 画像高さ（デフォルト: 1024）
  "input_image": "gs://bucket/input.jpg",   // 任意: 入力画像（画像から画像生成用）
  "reference_image": "gs://bucket/ref.jpg", // 任意: スタイル参考画像
  "model": "gemini-2.0-flash-exp",         // 任意: 使用モデル
  "seed": 12345,                            // 任意: シード値（再現性のため）
  "output_path": "generated/images",        // 任意: 保存先パス
  "image_type": "illustration"              // 任意: 画像カテゴリ
}
```

**レスポンス**:
```typescript
{
  "results": {
    "imageGeneration": {
      "files": [{
        "width": 1024,
        "height": 1024,
        "format": "png",
        "size": 2048576
      }],
      "inputTokens": 100,
      "outputTokens": 50,
      "cost": 0.005
    }
  },
  "assets": {
    "generatedImage": {
      "url": "gs://bucket/generated/image.png",
      "public_url": "https://storage.googleapis.com/...",
      "content_type": "image/png"
    }
  }
}
```

#### 音声生成 - generate_audio_with_google_tts

**アクションID**: `generate_audio_with_google_tts`

**パラメータ**:
```typescript
{
  "text": "こんにちは、世界",                    // 必須: 読み上げるテキスト
  "voice_name": "ja-JP-Neural2-A",            // 任意: 音声の種類
  "language": "ja-JP",                        // 任意: 言語コード
  "gender": "FEMALE",                         // 任意: 性別 (MALE/FEMALE/NEUTRAL)
  "output_format": "mp3",                     // 任意: 出力形式 (mp3/wav/ogg)
  "speaking_rate": 1.0,                       // 任意: 話速 (0.25-4.0)
  "pitch": 0.0,                               // 任意: ピッチ (-20.0-20.0)
  "volume_gain_db": 0.0,                      // 任意: 音量 (-96.0-16.0)
  "output_path": "generated/audio"            // 任意: 保存先パス
}
```

**レスポンス**:
```typescript
{
  "results": {
    "audioGeneration": {
      "files": [{
        "duration": 3.5,
        "format": "mp3",
        "size": 56320,
        "characters": 12
      }],
      "characters": 12,
      "cost": 0.001
    }
  },
  "assets": {
    "generatedAudio": {
      "url": "gs://bucket/generated/audio.mp3",
      "public_url": "https://storage.googleapis.com/...",
      "content_type": "audio/mpeg"
    }
  }
}
```

### マーケティング分析機能 (masamune_workflow_marketing)

#### アプリストアデータ収集

**collect_from_google_play_console** - Google Playデータ収集

**アクションID**: `collect_from_google_play_console`

**パラメータ**:
```typescript
{
  "packageName": "com.example.app",  // 必須: アプリのパッケージ名
  "startDate": "2024-01-01",        // 任意: 開始日
  "endDate": "2024-01-31"           // 任意: 終了日
}
```

**レスポンス**:
```typescript
{
  "results": {
    "googlePlayData": {
      "downloads": 10000,
      "activeInstalls": 5000,
      "rating": 4.5,
      "ratingCount": 1234,
      "recentReviews": [
        {
          "text": "素晴らしいアプリです",
          "rating": 5,
          "date": "2024-01-15"
        }
      ]
    }
  }
}
```

**collect_from_app_store** - App Storeデータ収集

**アクションID**: `collect_from_app_store`

**パラメータ**:
```typescript
{
  "appId": "123456789",              // 必須: App Store アプリID
  "vendorNumber": "87654321",        // 任意: ベンダー番号
  "startDate": "2024-01-01",         // 任意: 開始日
  "endDate": "2024-01-31"            // 任意: 終了日
}
```

**collect_from_firebase_analytics** - Firebase Analyticsデータ収集

**アクションID**: `collect_from_firebase_analytics`

**パラメータ**:
```typescript
{
  "propertyId": "123456789",         // 必須: GA4プロパティID
  "startDate": "2024-01-01",         // 任意: 開始日
  "endDate": "2024-01-31"            // 任意: 終了日
}
```

**レスポンス**:
```typescript
{
  "results": {
    "analyticsData": {
      "activeUsers": 5000,
      "sessions": 15000,
      "engagementRate": 0.65,
      "averageSessionDuration": 180,
      "events": {
        "screen_view": 50000,
        "purchase": 100
      }
    }
  }
}
```

#### AI分析機能

**analyze_marketing_data** - マーケティングデータのAI分析

**アクションID**: `analyze_marketing_data`

**レスポンス**:
```typescript
{
  "results": {
    "marketingAnalysis": {
      "overallAnalysis": {
        "summary": "全体的に成長傾向",
        "highlights": ["ユーザー数20%増加"],
        "concerns": ["離脱率が上昇傾向"],
        "keyMetrics": {...}
      },
      "improvementSuggestions": [
        {
          "title": "オンボーディング改善",
          "description": "初回起動時の体験を改善",
          "priority": "high",
          "category": "UX",
          "expectedImpact": "離脱率10%減少"
        }
      ],
      "trendAnalysis": {...},
      "reviewAnalysis": {...},
      "competitivePositioning": {...}
    }
  }
}
```

**generate_marketing_pdf** - PDFレポート生成

**アクションID**: `generate_marketing_pdf`

**パラメータ**:
```typescript
{
  "reportType": "monthly",           // 必須: daily/weekly/monthly
  "startDate": "2024-01-01",        // 任意: 開始日
  "endDate": "2024-01-31"           // 任意: 終了日
}
```

**レスポンス**:
```typescript
{
  "assets": {
    "marketingAnalyticsPdf": {
      "url": "gs://bucket/reports/marketing_report.pdf",
      "public_url": "https://storage.googleapis.com/...",
      "content_type": "application/pdf"
    }
  }
}
```

#### GitHub解析機能

**analyze_github_init** - GitHubリポジトリ解析初期化

**アクションID**: `analyze_github_init`

**パラメータ**:
```typescript
{
  "githubRepository": "owner/repo",       // 必須: リポジトリ名
  "githubRepositoryPath": "src"          // 任意: 解析対象パス
}
```

**注意**: このアクションは自動的に複数の`analyze_github_process`アクションをタスクに追加します。

**analyze_github_process** - GitHub解析処理（自動生成）

**アクションID**: `analyze_github_process`

**パラメータ**:
```typescript
{
  "batchIndex": 0  // 自動設定: バッチインデックス
}
```

**analyze_github_summary** - GitHub解析結果生成

**アクションID**: `analyze_github_summary`

**レスポンス**:
```typescript
{
  "results": {
    "githubAnalysis": {
      "repository": "owner/repo",
      "framework": "Flutter",
      "overview": "モバイルアプリケーション",
      "architecture": {...},
      "features": [
        {
          "name": "認証機能",
          "description": "ユーザー認証を管理",
          "relatedFiles": ["auth.dart", "login.dart"]
        }
      ]
    }
  }
}
```

#### 市場調査機能

**research_market** - 市場調査（Gemini + Google検索）

**アクションID**: `research_market`

**パラメータ**:
```typescript
{
  "query": "フィットネスアプリ市場",      // 必須: 調査クエリ
  "region": "日本",                    // 任意: 対象地域
  "includeCompetitors": true           // 任意: 競合分析を含むか
}
```

**レスポンス**:
```typescript
{
  "results": {
    "marketResearch": {
      "marketPotential": {
        "summary": "成長市場",
        "TAM": "1000億円",
        "SAM": "100億円",
        "SOM": "10億円",
        "marketDrivers": [...],
        "barriers": [...],
        "targetSegments": [...]
      },
      "competitorAnalysis": {
        "competitors": [...],
        "marketLandscape": {...},
        "competitiveAdvantages": [...],
        "marketGaps": [...]
      },
      "businessOpportunities": [...]
    }
  }
}
```

**analyze_market_research** - 市場分析戦略生成

**アクションID**: `analyze_market_research`

**レスポンス**:
```typescript
{
  "results": {
    "marketStrategy": {
      "demandForecast": {...},
      "revenueStrategies": [...],
      "trafficStrategies": [...],
      "keyInsights": [...]
    }
  }
}
```

### セールス機能 (masamune_workflow_sales)

#### Google Play開発者情報収集

**アクションID**: `collect_google_play_developers`

**パラメータ（開発者ID指定モード）**:
```typescript
{
  "mode": "developer_ids",
  "developerIds": [
    "5700313618786177705",  // 開発者ID
    "6720847872433251783"
  ],
  "lang": "ja",             // 任意: 言語（デフォルト: ja）
  "country": "jp"           // 任意: 国（デフォルト: jp）
}
```

**パラメータ（カテゴリランキングモード）**:
```typescript
{
  "mode": "category_ranking",
  "categoryConfig": {
    "category": "GAME_ACTION",     // カテゴリID
    "collection": "TOP_FREE",      // コレクション（TOP_FREE/TOP_PAID等）
    "num": 100                     // 取得数（デフォルト: 100）
  },
  "maxCount": 200                  // 最大収集数
}
```

**パラメータ（キーワード検索モード）**:
```typescript
{
  "mode": "search_keyword",
  "searchConfig": {
    "query": "fitness app",        // 検索キーワード
    "num": 50                      // 検索結果数
  },
  "maxCount": 100
}
```

**レスポンス**:
```typescript
{
  "results": {
    "googlePlayDevelopers": {
      "stats": {
        "mode": "category_ranking",
        "targetCount": 100,
        "collectedCount": 95,
        "withEmailCount": 45,
        "savedCount": 45
      },
      "developers": [
        {
          "developerId": "5700313618786177705",
          "developerName": "Example Developer",
          "companyName": "Example Inc.",
          "email": "support@example.com",
          "website": "https://example.com",
          "privacyPolicyUrl": "https://example.com/privacy",
          "address": "Tokyo, Japan",
          "apps": [
            {
              "appId": "com.example.app",
              "title": "Example App",
              "score": 4.5,
              "price": 0,
              "free": true,
              "genre": "Tools"
            }
          ]
        }
      ]
    }
  }
}
```

#### App Store開発者情報収集

**アクションID**: `collect_app_store_developers`

**パラメータ**: Google Playと同様の構造

**レスポンス**:
```typescript
{
  "results": {
    "appStoreDevelopers": {
      "stats": {...},
      "developers": [
        {
          "developerId": 123456789,
          "developerName": "Example Developer",
          "email": "support@example.com",
          "website": "https://example.com",
          "apps": [...]
        }
      ]
    }
  }
}
```

### 認証設定

各サービスの認証情報は、`WorkflowProjectModel`に保存します。

```dart
// Flutter側での認証情報設定例
final project = WorkflowProjectModel(
  // Google認証（Google Play Console、Firebase Analytics等）
  googleServiceAccount: "...",  // サービスアカウントJSON
  googleAccessToken: "...",     // OAuth2アクセストークン
  googleRefreshToken: "...",    // OAuth2リフレッシュトークン

  // GitHub認証
  githubPersonalAccessToken: "ghp_...",  // Personal Access Token

  // App Store Connect認証
  appstoreIssuerId: "...",      // Issuer ID
  appstoreAuthKeyId: "...",     // Key ID
  appstoreAuthKey: "-----BEGIN PRIVATE KEY-----...",  // 秘密鍵
);
```

### 実装例 - 画像生成ワークフロー

```dart
// ワークフロー作成
final workflow = WorkflowWorkflowModel(
  name: "画像生成ワークフロー",
  prompt: "ブログ記事用の画像を生成",
  actions: [
    // 画像を生成
    WorkflowActionCommandValue(
      command: "generate_image_with_gemini",
      index: 0,
      data: {
        "prompt": "美しい自然の風景、プロフェッショナルな写真",
        "width": 1920,
        "height": 1080,
        "output_path": "blog/images",
      },
    ),
    // 音声ナレーションを生成
    WorkflowActionCommandValue(
      command: "generate_audio_with_google_tts",
      index: 1,
      data: {
        "text": "本日のブログ記事をお届けします",
        "voice_name": "ja-JP-Neural2-A",
        "output_format": "mp3",
      },
    ),
  ],
);
```

### 実装例 - マーケティング分析ワークフロー

```dart
// 月次マーケティングレポート生成
final workflow = WorkflowWorkflowModel(
  name: "月次マーケティングレポート",
  repeat: WorkflowRepeat.monthly,
  actions: [
    // Google Playデータ収集
    WorkflowActionCommandValue(
      command: "collect_from_google_play_console",
      index: 0,
      data: {
        "packageName": "com.example.app",
      },
    ),
    // Firebase Analyticsデータ収集
    WorkflowActionCommandValue(
      command: "collect_from_firebase_analytics",
      index: 1,
      data: {
        "propertyId": "123456789",
      },
    ),
    // AI分析
    WorkflowActionCommandValue(
      command: "analyze_marketing_data",
      index: 2,
      data: {},
    ),
    // PDFレポート生成
    WorkflowActionCommandValue(
      command: "generate_marketing_pdf",
      index: 3,
      data: {
        "reportType": "monthly",
      },
    ),
  ],
);
```

### 実装例 - 競合開発者リサーチワークフロー

```dart
// 競合アプリ開発者の情報収集
final workflow = WorkflowWorkflowModel(
  name: "競合開発者リサーチ",
  actions: [
    // カテゴリランキングから開発者情報収集
    WorkflowActionCommandValue(
      command: "collect_google_play_developers",
      index: 0,
      data: {
        "mode": "category_ranking",
        "categoryConfig": {
          "category": "HEALTH_AND_FITNESS",
          "collection": "TOP_FREE",
          "num": 50,
        },
        "maxCount": 100,
      },
    ),
    // App Storeからも収集
    WorkflowActionCommandValue(
      command: "collect_app_store_developers",
      index: 1,
      data: {
        "mode": "category_ranking",
        "categoryConfig": {
          "category": "6013",  // Health & Fitness
          "collection": "TOP_FREE",
          "num": 50,
        },
        "maxCount": 100,
      },
    ),
  ],
);
```

### エラーハンドリング

各アクションは`WorkflowTaskStatus`と`TaskLogPhase`で状態を管理します。

```dart
// アクションのログ確認
final action = ref.app.model(
  WorkflowActionModel.document(actionId),
)..load();

// エラーログの確認
final errorLogs = action.value?.log
  .where((log) => log.phase == TaskLogPhase.error)
  .toList();

if (errorLogs?.isNotEmpty ?? false) {
  for (final log in errorLogs!) {
    print("エラー: ${log.message}");
    print("詳細: ${log.data}");
  }
}
```

### 利用量管理

各アクションの実行コストは`WorkflowUsageModel`で管理されます。

```dart
// 利用量の確認
final usage = ref.app.model(
  WorkflowUsageModel.document(organizationId),
)..load();

// 現在の利用量
print("今月の利用量: ${usage.value?.currentMonth}");
print("バケット残高: ${usage.value?.bucketBalance}");

// プラン制限の確認
final plan = ref.app.model(
  WorkflowPlanModel.document(usage.value?.latestPlan ?? ""),
)..load();

print("月間制限: ${plan.value?.monthlyLimit}");
print("バースト容量: ${plan.value?.burstCapacity}");
```

### Tips - バックエンド実装

- **環境変数**: Firebase Functions環境変数に各種APIキーを設定
  ```bash
  firebase functions:config:set gemini.api_key="YOUR_API_KEY"
  firebase functions:config:set google.tts_credentials="YOUR_CREDENTIALS"
  ```

- **タイムアウト設定**: 長時間実行タスクには適切なタイムアウトを設定
  ```typescript
  export const longRunningTask = functions
    .runWith({ timeoutSeconds: 540, memory: "1GB" })
    .https.onRequest(...);
  ```

- **並列実行**: `analyze_github_process`のように、大量データ処理は並列実行で高速化

- **コスト管理**:
  - Gemini API: 入力/出力トークンに基づく課金
  - Google TTS: 文字数に基づく課金
  - Firebase Functions: 実行時間とメモリに基づく課金

- **セキュリティ**:
  - 認証情報は必ず暗号化して保存
  - APIキーは環境変数で管理
  - Firestoreセキュリティルールで適切なアクセス制御

- **デバッグ**:
  - Firebase Functionsログでアクション実行を確認
  - `TaskLogPhase.info`でカスタムログを記録
  - エミュレータでローカルテスト
""";
  }
}
