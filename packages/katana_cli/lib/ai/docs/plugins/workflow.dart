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
    return """
`Workflow`は下記のように利用する。

## 概要

$excerpt

組織・プロジェクト・ワークフロー・タスク・アクションの階層構造でワークフローを管理し、Firestoreにデータを保存する。

**階層構造:**

```
組織（Organization）
  └── プロジェクト（Project）
        └── ワークフロー（Workflow）
              └── タスク（Task）
                    └── アクション（Action）
```

## データ継承とその理由

### なぜ各階層でIDを継承するのか

タスク作成時に組織ID・プロジェクトIDを継承する理由：

1. **権限チェック**: タスク実行時に組織/プロジェクトレベルの権限を確認
2. **使用量追跡**: 組織/プロジェクト単位でのAPI使用量を計算
3. **フィルタリング**: 組織/プロジェクト別のタスク一覧表示
4. **課金処理**: 組織単位での課金管理

### 継承フロー図

```
組織（設定：APIキー、制限値）
  ↓ 継承
プロジェクト（設定：サービスアカウント、環境変数）
  ↓ 継承
ワークフロー（設定：アクション配列、プロンプト）
  ↓ 継承
タスク（実行：継承した設定で各アクションを実行）
```

### タスク作成時の継承関係

| フィールド | 継承元 | 目的 |
|-----------|--------|------|
| `organization` | ワークフロー | 権限管理、組織別フィルタリング |
| `project` | ワークフロー | プロジェクト別分析 |
| `actions` | ワークフロー | 実行するアクション定義 |
| `prompt` | ワークフロー | タスク固有のプロンプト |
| `materials` | ワークフロー | アクション実行に必要な素材 |

**注意**: このパッケージはアダプターを使用しません。データモデルのみを提供します。

## 設定方法

1. `katana.yaml`にワークフロー設定を追加。

    使用したい機能の`enable`を`true`にしてください。

    ```yaml
    firebase:
      project_id: your_project_id
      firestore:
        enable: true
      functions:
        enable: true

      workflow:
        # アセット生成機能
        generate_audio_with_google_tts:
          enable: false
        generate_image_with_gemini:
          enable: false
        generate_text_from_multimodal:
          enable: false

        # マーケティング分析機能
        research_market:
          enable: false
        collect_from_app_store:
          enable: false
        collect_from_google_play_console:
          enable: false
        collect_from_firebase_analytics:
          enable: false
        analyze_marketing_data:
          enable: false
        analyze_github:
          enable: false
        analyze_market_research:
          enable: false
        generate_marketing_pdf:
          enable: false
        generate_marketing_markdown:
          enable: false

        # セールス機能
        collect_google_play_developers:
          enable: false
        collect_app_store_developers:
          enable: false
    ```

2. `katana apply`コマンドを実行して設定を自動適用。

    ```bash
    katana apply
    ```

    このコマンドにより以下が自動実行されます:
    - Flutter側に`masamune_workflow`パッケージを追加
    - NPM側に有効化されたワークフロー用パッケージを追加
    - Firebase Functionsの`index.ts`を自動更新（importsとfunctionsを追加）
    - Firebase Functionsのデプロイをリクエスト

3. 利用するファイルでインポート。

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
      WorkflowOrganizationMemberModel.collection(organizationId: organizationId),
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
                  title: Text("タスク \${task.uid}"),
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
                    "コマンド: \${action.value!.command.command}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text("インデックス: \${action.value!.command.index}"),

                  // ステータス
                  SizedBox(height: 16),
                  Text(
                    "ステータス: \${action.value!.status}",
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

## アクション実行の詳細

### 実行順序と依存関係

1. **アクションの実行順序**: `WorkflowActionCommandValue.index`の昇順で順次実行
2. **データの受け渡し**: 前のアクションの`results`を次のアクションが参照可能
3. **エラー処理**: 1つのアクションが失敗すると、タスク全体が`failed`になり、残りのアクションは実行されない

### アクション実行フロー

```
タスクステータス: waiting
    ↓
タスクステータス: running（taskSchedulerによって開始）
    ↓
アクション1実行（index: 0）
    ├─成功→ results保存 → アクション2へ
    └─失敗→ タスクステータス: failed（処理中断）
    ↓
アクション2実行（index: 1）
    ├─成功→ results保存 → アクション3へ
    └─失敗→ タスクステータス: failed（処理中断）
    ↓
全アクション完了
    ↓
タスクステータス: completed
```

### アクションログの構造

各アクションは`WorkflowTaskLogValue`の配列でログを記録：

| フェーズ | 記録タイミング | 用途 |
|----------|--------------|------|
| `start` | アクション開始時 | 開始時刻記録 |
| `info` | 処理中 | 進捗状況記録 |
| `warning` | 警告発生時 | 非致命的な問題記録 |
| `error` | エラー発生時 | エラー詳細記録 |
| `end` | アクション完了時 | 終了時刻、結果記録 |

## アクション間のデータ受け渡し

### データフローの3つの要素

#### 1. materials（素材）
ワークフロー定義時に設定する静的な素材データ。全アクションから参照可能。

```dart
// ワークフロー定義時
materials: {
  "images": ["gs://bucket/product1.jpg"],
  "documents": ["gs://bucket/spec.pdf"],
}
```

#### 2. assets（成果物）
アクション実行結果として生成される成果物。Firestoreの`plugins/workflow/asset`に保存される。

```typescript
// アクション実行結果
{
  "assets": {
    "generatedImage": {
      "url": "gs://bucket/generated/image.png",
      "public_url": "https://storage.googleapis.com/...",
      "content_type": "image/png"
    }
  }
}
```

#### 3. results（結果）
アクション実行のメタデータと結果データ。次のアクションが参照可能。

```typescript
{
  "results": {
    "imageGeneration": {
      "inputTokens": 100,
      "outputTokens": 50,
      "cost": 0.005,
      "generatedText": "生成された説明文..."
    }
  }
}
```

### アクション間のデータ受け渡しパターン

#### パターン1: assetsを次のアクションで参照

アクション1で生成した画像を、アクション2で使用する例：

```dart
final workflow = WorkflowWorkflowModel(
  name: "画像加工ワークフロー",
  actions: [
    // アクション1: 画像生成
    WorkflowActionCommandValue(
      command: "generate_image_with_gemini",
      index: 0,
      data: {
        "prompt": "美しい風景",
      },
    ),
    // アクション2: 生成した画像を取得して加工
    // ※バックエンド側で前のアクションのassetsを自動的に参照可能
    WorkflowActionCommandValue(
      command: "process_image",
      index: 1,
      data: {
        // 前のアクションのassets.generatedImageを参照
        "input_asset_key": "generatedImage",
      },
    ),
  ],
);
```

#### パターン2: resultsを次のアクションのパラメータに利用

マーケティング分析の例（バックエンド実装）：

```typescript
// Firebase Functions側での実装例
export const analyze_marketing_data = Functions.action({
  process: async (context) => {
    // 前のアクションのresultsを取得
    const previousActions = await context.task.getPreviousActions();
    const googlePlayData = previousActions[0]?.results?.googlePlayData;
    const analyticsData = previousActions[1]?.results?.analyticsData;

    // 統合分析
    const analysis = await analyzeData(googlePlayData, analyticsData);

    return {
      results: {
        marketingAnalysis: analysis,
      },
    };
  },
});
```

#### パターン3: materialsとassetsの組み合わせ

```dart
final workflow = WorkflowWorkflowModel(
  name: "商品説明生成",
  materials: {
    "images": ["gs://bucket/product1.jpg"],  // 事前に用意した素材
  },
  actions: [
    // アクション1: 商品画像から特徴抽出
    WorkflowActionCommandValue(
      command: "generate_text_from_multimodal",
      index: 0,
      data: {
        "prompt": "商品の特徴を箇条書きで抽出",
      },
      // materials.imagesを自動参照
    ),
    // アクション2: 抽出した特徴を元に音声ナレーション生成
    WorkflowActionCommandValue(
      command: "generate_audio_with_google_tts",
      index: 1,
      data: {
        // 前のアクションのresults.textGeneration.generatedTextを参照
        "use_previous_text": true,
      },
    ),
  ],
);
```

### データ参照の実装詳細

バックエンド側（Firebase Functions）では、以下のようにアクション間のデータを参照：

```typescript
// 現在のアクションから前のアクションのデータにアクセス
const context = {
  task: {
    // タスクに設定されたmaterials
    materials: task.materials,

    // 前のアクションの結果を取得
    getPreviousActions: async () => {
      return task.actions.filter(a => a.index < currentAction.index);
    },

    // 前のアクションのassetsを取得
    getPreviousAssets: async () => {
      const previousAction = task.actions[currentAction.index - 1];
      return previousAction?.assets;
    },
  },
};
```

**注意**: 具体的な実装はバックエンドのアクションハンドラーによって異なります。上記はconceptual exampleです。

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
                    "現在の使用量: \${usage.value!.usage}",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text("今月: \${usage.value!.currentMonth}"),
                  Text("バケット残高: \${usage.value!.bucketBalance}"),
                  if (usage.value!.latestPlan != null)
                    Text("プラン: \${usage.value!.latestPlan}"),
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

## モデル間の関係図

### 階層構造とRefPath参照

```
WorkflowOrganizationModel（組織）
  ├── WorkflowOrganizationMemberModel（サブコレクション：組織メンバー）
  ├── WorkflowUsageModel（サブコレクション：使用量）
  ├── WorkflowCertificateModel（サブコレクション：証明書）
  │
  └─RefPath参照→ WorkflowProjectModel（プロジェクト）
      │
      └─RefPath参照→ WorkflowWorkflowModel（ワークフロー）
          │
          └─RefPath参照→ WorkflowTaskModel（タスク）
              │
              └─配列→ WorkflowActionModel（アクション）
```

**凡例**:
- `├──`: サブコレクション（親の削除で自動削除される）
- `─RefPath参照→`: RefPathによる参照（親が削除されても残る）
- `─配列→`: ドキュメント内の配列として保存

### サブコレクション vs ルートコレクション + RefPath

| パターン | Firestoreパス | 使用ケース | 例 |
|----------|--------------|-----------|-----|
| **サブコレクション** | `parent/:id/child` | 親と密結合、親削除で自動削除が必要 | 組織メンバー、使用量 |
| **ルートコレクション + RefPath** | `child`（RefPathフィールド保持） | 横断検索が必要、複数の親を持つ可能性 | プロジェクト、ワークフロー、タスク |

この設計により、以下が可能になります：
- プロジェクトを異なる組織間で移動
- タスクの横断検索（全組織のタスクを一覧表示）
- 柔軟な権限管理（RefPathを使った条件付きアクセス）

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

## 参照パス（RefPath）について

### RefPathとは

`RefPath`は、Firestoreドキュメント間の参照を型安全に管理するためのMasamuneフレームワークの仕組みです。FirestoreのReference型をラップし、型安全性と使いやすさを提供します。

### RefPath型の一覧

| RefPath型 | 参照先 | 使用例 |
|----------|--------|--------|
| `WorkflowOrganizationModelRefPath` | 組織ドキュメント | プロジェクト、メンバー、タスク等が組織を参照 |
| `WorkflowProjectModelRefPath` | プロジェクトドキュメント | ワークフロー、タスク等がプロジェクトを参照 |
| `WorkflowWorkflowModelRefPath` | ワークフロードキュメント | タスクがワークフローを参照 |

### RefPathの役割と利点

1. **型安全性**: コンパイル時に誤った参照を検出
   ```dart
   // ❌ コンパイルエラー: 型が一致しない
   project.organization = WorkflowProjectModelRefPath(projectId);

   // ✅ 正しい: 適切な型を使用
   project.organization = WorkflowOrganizationModelRefPath(organizationId);
   ```

2. **クエリフィルタリング**: 特定の親に属するドキュメントを効率的に取得
   ```dart
   // 特定組織のプロジェクトのみ取得
   final projects = ref.app.model(
     WorkflowProjectModel.collection()
       .organization.equal(WorkflowOrganizationModelRefPath(organizationId))
   );
   ```

3. **データ整合性**: 親子関係の明確化と整合性チェック
   ```dart
   // タスク作成時に親の存在を確認
   if (workflow.value == null) {
     throw Exception("ワークフローが存在しません");
   }
   ```

4. **権限管理**: Firestoreセキュリティルールでの参照チェック
   ```javascript
   // Firestoreセキュリティルール例
   match /plugins/workflow/task/{taskId} {
     allow read: if request.auth.uid ==
       get(resource.data.organization).data.ownerId;
   }
   ```

### RefPathの実装パターン

```dart
// 1. RefPath作成
final orgRef = WorkflowOrganizationModelRefPath(organizationId);

// 2. モデルに設定
final project = WorkflowProjectModel(
  name: "新プロジェクト",
  organization: orgRef,  // RefPathを設定
);

// 3. RefPathを使ったフィルタリング
final projects = ref.app.model(
  WorkflowProjectModel.collection()
    .organization.equal(orgRef)  // 同じ組織のプロジェクトのみ
);

// 4. RefPathからIDを取得
final orgId = project.organization?.id;  // 組織IDを取得
```

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

ワークフロー機能は`katana apply`コマンドで自動設定されます。手動設定は不要です。

**自動設定の内容:**

1. **パッケージの自動追加**
   - `masamune_workflow`（基本機能、常に追加）
   - 有効化されたワークフロー機能に応じて以下を自動追加:
     - `masamune_workflow_asset`（画像・音声生成機能）
     - `masamune_workflow_marketing`（マーケティング分析機能）
     - `masamune_workflow_sales`（セールスデータ収集機能）

2. **index.tsの自動更新**
   - インポート文の自動追加
   - 関数エクスポートの自動追加
   - 基本ワークフロー機能（`workflowScheduler`、`taskScheduler`、`taskCleaner`、`asset`）を常に追加
   - 有効化された各ワークフロー機能の関数を追加

**自動生成されるindex.tsの例:**

以下は全ての機能を有効化した場合の例です（参考用）。

```typescript
import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";

// 基本ワークフロー機能（自動追加）
import * as workflow from "@mathrunet/masamune_workflow";

// アセット生成機能（自動追加）
import * as workflow_asset from "@mathrunet/masamune_workflow_asset";

// マーケティング分析機能（自動追加）
import * as workflow_marketing from "@mathrunet/masamune_workflow_marketing";

// セールス機能（自動追加）
import * as workflow_sales from "@mathrunet/masamune_workflow_sales";

// Firebase Admin初期化
admin.initializeApp();

// Masamune
const m = workflow.Masamune();

// 関数のデプロイ（自動エクスポート）
m.deploy(
  exports,
  ["us-central1"],
  [
    // 基本ワークフロー機能
    workflow.Functions.workflowScheduler(),
    workflow.Functions.taskScheduler(),
    workflow.Functions.taskCleaner(),
    workflow.Functions.asset(),
    // アセット生成機能
    workflow_asset.Functions.generateImageWithGemini(),
    workflow_asset.Functions.generateAudioWithGoogleTTS(),
    // マーケティング分析機能
    workflow_marketing.Functions.researchMarket(),
    workflow_marketing.Functions.collectFromAppStore(),
    workflow_marketing.Functions.collectFromGooglePlayConsole(),
    workflow_marketing.Functions.collectFromFirebaseAnalytics(),
    workflow_marketing.Functions.analyzeMarketingData(),
    workflow_marketing.Functions.analyzeGithub(),
    workflow_marketing.Functions.analyzeMarketResearch(),
    workflow_marketing.Functions.generateMarketingPdf(),
    workflow_marketing.Functions.generateMarketingMarkdown(),
    // セールス機能
    workflow_sales.Functions.collectGooglePlayDevelopers(),
    workflow_sales.Functions.collectAppStoreDevelopers(),
  ],
);
```

**注意:**
- 上記は参考例です。実際には`katana.yaml`で有効化した機能のみが追加されます。
- `index.ts`を手動で編集する必要はありません。`katana apply`が自動的に更新します。
- 既存の`index.ts`に他のFunctionsがある場合、それらは保持されます。

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

#### マルチモーダル入力からテキスト生成 - generate_text_from_multimodal

画像、動画、音声、ドキュメントなど複数のメディアファイルを総合的に分析し、Gemini APIを使用してテキストを生成します。`action.materials`フィールドにメディア素材を配置し、プロンプトと組み合わせて高度なテキスト生成が可能です。

**アクションID**: `generate_text_from_multimodal`

##### action.materialsフィールド

メディア素材は`action.materials`フィールドに配置します：

| フィールド | 型 | 説明 |
|----------|-----|------|
| images | string[] | 画像ファイルのgs:// URLリスト |
| videos | string[] | 動画ファイルのgs:// URLリスト |
| audio | string[] | 音声ファイルのgs:// URLリスト |
| documents | string[] | ドキュメントファイルのgs:// URLリスト |

##### パラメータ (ActionCommand.data)

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| prompt | string | ✓ | メイン生成プロンプト |
| system_prompt | string | | システムインストラクション |
| output_format | string | | 出力形式 ("text" または "markdown"、デフォルト: "text") |
| max_tokens | number | | 最大トークン数（デフォルト: 8192） |
| temperature | number | | 生成温度（0.0-2.0、デフォルト: 0.7） |
| model | string | | Geminiモデル（デフォルト: gemini-2.0-flash-exp） |
| region | string | | GCPリージョン（デフォルト: us-central1） |

##### サポートされているメディア形式

| カテゴリ | サポート形式 |
|---------|------------|
| 画像 | JPEG, PNG, GIF, WebP, BMP |
| 動画 | MP4, MPEG, MOV, AVI, FLV, MPG, WebM, WMV, 3GPP |
| 音声 | WAV, MP3, MPEG, AIFF, AAC, OGG, FLAC |
| ドキュメント | PDF, TXT, Markdown |

##### レスポンス

```typescript
{
  "results": {
    "textGeneration": {
      "files": [{
        "path": "generated-texts/xxx.txt",
        "content_type": "text/plain",
        "size": 1024
      }],
      "generatedText": "生成されたテキスト内容...",
      "inputTokens": 500,
      "outputTokens": 300,
      "cost": 0.0225,
      "processedMaterials": {
        "images": 2,
        "videos": 1,
        "audio": 1,
        "documents": 1
      }
    }
  },
  "assets": {
    "generatedText": {
      "url": "gs://bucket/generated-texts/xxx.txt",
      "public_url": "https://storage.googleapis.com/...",
      "content_type": "text/plain"
    }
  }
}
```

##### 実装例

**商品説明文生成ワークフロー**：

```dart
final workflow = WorkflowWorkflowModel(
  name: "商品説明文生成",
  prompt: "商品画像と動画から魅力的な説明文を作成",
  materials: {
    "images": [
      "gs://bucket/products/product-photo1.jpg",
      "gs://bucket/products/product-photo2.jpg",
      "gs://bucket/products/product-photo3.jpg"
    ],
    "videos": [
      "gs://bucket/products/demo-video.mp4"
    ],
    "audio": [
      "gs://bucket/products/customer-review.mp3"
    ]
  },
  actions: [
    WorkflowActionCommandValue(
      command: "generate_text_from_multimodal",
      index: 0,
      data: {
        "prompt": \"\"\"
提供された画像、動画、音声レビューを基に、以下の要素を含む商品説明文を作成してください：

1. 商品の主要な特徴（画像から読み取れる内容）
2. 使用方法とデモンストレーション（動画の内容）
3. 実際のユーザーの声（音声レビューの要約）
4. 商品のメリットとユニークセリングポイント

文体：親しみやすく、購買意欲を高める内容
文字数：800-1200文字程度
\"\"\",
        "system_prompt": "あなたはECサイトの商品説明文を作成する専門のコピーライターです。視覚的要素と音声情報を総合的に分析し、魅力的な商品説明を作成してください。",
        "output_format": "markdown",
        "max_tokens": 2000,
        "temperature": 0.8
      }
    )
  ]
);
```

**マルチメディアコンテンツ分析ワークフロー**：

```dart
final workflow = WorkflowWorkflowModel(
  name: "プレゼンテーション資料分析",
  prompt: "プレゼン資料の総合分析レポート作成",
  materials: {
    "images": [
      "gs://bucket/presentation/slide1.png",
      "gs://bucket/presentation/slide2.png",
      "gs://bucket/presentation/slide3.png"
    ],
    "videos": [
      "gs://bucket/presentation/demo.mp4"
    ],
    "documents": [
      "gs://bucket/presentation/notes.pdf"
    ]
  },
  actions: [
    WorkflowActionCommandValue(
      command: "generate_text_from_multimodal",
      index: 0,
      data: {
        "prompt": \"\"\"
プレゼンテーション資料を分析し、以下の形式でレポートを作成してください：

# プレゼンテーション分析レポート

## 1. 概要
- プレゼンの主題とメッセージ
- ターゲット・オーディエンス

## 2. スライド内容の要約
- 各スライドの主要ポイント
- 視覚的要素の効果

## 3. デモンストレーション内容
- 動画で示された機能や特徴
- デモの有効性評価

## 4. 改善提案
- プレゼンテーションの強化ポイント
- 追加すべき要素
\"\"\",
        "output_format": "markdown",
        "max_tokens": 4096,
        "temperature": 0.5
      }
    )
  ]
);
```

**ストーリー生成ワークフロー**：

```dart
final workflow = WorkflowWorkflowModel(
  name: "ビジュアルストーリー作成",
  prompt: "画像と音楽からストーリーを生成",
  materials: {
    "images": [
      "gs://bucket/story/scene1.jpg",
      "gs://bucket/story/scene2.jpg",
      "gs://bucket/story/scene3.jpg",
      "gs://bucket/story/scene4.jpg"
    ],
    "audio": [
      "gs://bucket/story/bgm.mp3"
    ]
  },
  actions: [
    WorkflowActionCommandValue(
      command: "generate_text_from_multimodal",
      index: 0,
      data: {
        "prompt": \"\"\"
提供された画像を順番に見て、BGMの雰囲気も考慮しながら、
これらを繋げた物語を創作してください。

- ジャンル：ファンタジー
- 文体：小説風
- 長さ：2000文字程度
- 各画像をシーンとして必ず含める
- BGMの雰囲気を文章に反映させる
\"\"\",
        "system_prompt": "あなたは創造的な物語作家です。視覚的要素と音楽から感じる雰囲気を統合し、読者を引き込む物語を創作してください。",
        "output_format": "text",
        "max_tokens": 3000,
        "temperature": 0.9
      }
    )
  ]
);
```

##### コスト計算

Gemini 2.0 Flash Experimentalの料金体系：
- 入力トークン: \$0.075 / 1M トークン
- 出力トークン: \$0.30 / 1M トークン

マルチモーダル入力の場合、メディアファイルはトークンに変換されます：
- 画像: 約258トークン/画像（1024x1024の場合）
- 動画: フレーム数×258トークン（サンプリングレートによる）
- 音声: 約25トークン/秒

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
    print("エラー: \${log.message}");
    print("詳細: \${log.data}");
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
print("今月の利用量: \${usage.value?.currentMonth}");
print("バケット残高: \${usage.value?.bucketBalance}");

// プラン制限の確認
final plan = ref.app.model(
  WorkflowPlanModel.document(usage.value?.latestPlan ?? ""),
)..load();

print("月間制限: \${plan.value?.monthlyLimit}");
print("バースト容量: \${plan.value?.burstCapacity}");
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
