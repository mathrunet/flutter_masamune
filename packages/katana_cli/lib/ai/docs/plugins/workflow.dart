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
""";
  }
}
