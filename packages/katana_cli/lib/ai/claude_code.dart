// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/ai/agents/agents.dart";
import "package:katana_cli/ai/mcp/mcp.dart";
import "package:katana_cli/katana_cli.dart";

/// Add AI Agent using Claude Code.
///
/// Claude Codeを利用したAIエージェント機能を追加します。
class GitClaudeCodeCliAction extends CliCommand with CliActionMixin {
  /// Add AI Agent using Claude Code.
  ///
  /// Claude Codeを利用したAIエージェント機能を追加します。
  const GitClaudeCodeCliAction();

  @override
  String get description =>
      "Add AI Agent using Claude Code. Claude Codeを利用したAIエージェント機能を追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("github").getAsMap("claude_code");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final gh = bin.get("gh", "gh");
    final github = context.yaml.getAsMap("github");
    final claudeCode = github.getAsMap("claude_code");
    final api = claudeCode.getAsMap("api");
    final oauth = claudeCode.getAsMap("oauth");
    final apiKey = api.get("api_key", "");
    final token = oauth.get("token", "");
    final personalAccessToken = claudeCode.get("personal_access_token", "");
    final enableClaudeCodeBackground = claudeCode.get("background", false);
    final model = claudeCode.get("model", "claude-sonnet-4-20250514");
    final uses = claudeCode.get("uses", "anthropics/claude-code-action@beta");

    if (apiKey.isEmpty && token.isEmpty) {
      error(
        "Configuration not found. Please set one of the following: `[claude_code]->[api]->[api_key]`, `[claude_code]->[oauth]->[token]`.",
      );
      return;
    }
    if (apiKey.isNotEmpty) {
      await command(
        "Set Anthropic API Key in `secrets.ANTHROPIC_API_KEY`.",
        [
          gh,
          "secret",
          "set",
          "ANTHROPIC_API_KEY",
          "--body",
          apiKey,
        ],
      );
    } else {
      await command(
        "Set Claude Access Token in `secrets.CLAUDE_CODE_OAUTH_TOKEN`.",
        [
          gh,
          "secret",
          "set",
          "CLAUDE_CODE_OAUTH_TOKEN",
          "--body",
          token,
        ],
      );
    }
    if (personalAccessToken.isNotEmpty) {
      await command(
        "Store `personal_access_token` in `secrets.PERSONAL_ACCESS_TOKEN`.",
        [
          gh,
          "secret",
          "set",
          "PERSONAL_ACCESS_TOKEN",
          "--body",
          personalAccessToken,
        ],
      );
    }
    label("Create claude_code.yaml");
    final gitDir = await findGitDirectory(Directory.current);
    await GitClaudeCodeCliCode(
      model: model,
      actionsRepositoryName: uses,
      workingDirectory: gitDir,
      useApiKey: apiKey.isNotEmpty,
    ).generateFile("claude_code.yaml");
    label("Create AGENTS.md");
    await GitAgentsMarkdownCliCode(
            availabeBackground: enableClaudeCodeBackground)
        .generateFile("AGENTS.md");
    label("Create settings.local.json");
    await const GitClaudeSettingsCliCode().generateFile("settings.local.json");
    label("Create agents");
    await const AgentsAiCode().exec(context);
    label("Create .mcp.json");
    await const McpMcpCode().exec(context);
  }
}

/// Contents of claude_code.yaml.
///
/// claude_code.yamlの中身。
class GitClaudeCodeCliCode extends CliCode {
  /// Contents of claude_code.yaml.
  ///
  /// claude_code.yamlの中身。
  const GitClaudeCodeCliCode({
    required this.model,
    this.actionsRepositoryName,
    this.workingDirectory,
    this.useApiKey = false,
  });

  /// Whether to use the API key.
  ///
  /// APIキーを使用するかどうか。
  final bool useApiKey;

  /// Working Directory.
  ///
  /// ワーキングディレクトリ。
  final Directory? workingDirectory;

  /// Name of the Actions repository to be used.
  ///
  /// 利用するActionsのレポジトリの名前。
  final String? actionsRepositoryName;

  /// Name of the model to be used.
  ///
  /// 利用するモデルの名前。
  final String model;

  @override
  String get name => "claude_code";

  @override
  String get prefix => "claude_code";

  @override
  String get directory {
    final workingPath = Directory.current.difference(workingDirectory);
    return "${workingPath.isEmpty ? "." : workingPath}/.github/workflows";
  }

  @override
  String get description =>
      "Create claude_code.yaml for AI Agent using Claude Code. Claude Codeを利用したAIエージェント機能用のclaude_code.yamlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    final credentials = useApiKey
        ? "anthropic_api_key: \${{secrets.ANTHROPIC_API_KEY}}"
        : "claude_code_oauth_token: \${{secrets.CLAUDE_CODE_OAUTH_TOKEN}}";
    return """
# AI Agent using Claude Code.
# 
# Claude Codeを利用したAIエージェント機能を追加します。
name: Claude Code
on:
    issue_comment:
        types: [created]
    pull_request_review_comment:
        types: [created]
    issues:
        types: [opened, assigned]
    pull_request_review:
        types: [submitted]

jobs:
    claude:
        if: |
            (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
            (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
            (github.event_name == 'pull_request_review' && contains(github.event.review.body, '@claude')) ||
            (github.event_name == 'issues' && (contains(github.event.issue.body, '@claude') || contains(github.event.issue.title, '@claude')))

        runs-on: ubuntu-latest
        timeout-minutes: 120

        permissions:
            contents: write
            pull-requests: write
            issues: write
            id-token: write

        steps:
            # Get PR information for review comments and reviews
            # レビューコメントとレビューの場合のPR情報を取得
            - name: Get PR information
              if: github.event_name == 'pull_request_review_comment' || github.event_name == 'pull_request_review' || github.event_name == 'issue_comment'
              id: pr_info
              run: |
                if [ "\${{ github.event_name }}" = "pull_request_review_comment" ]; then
                  PR_URL="\${{ github.event.comment.pull_request_url }}"
                elif [ "\${{ github.event_name }}" = "pull_request_review" ]; then
                  PR_URL="\${{ github.event.review.pull_request_url }}"
                elif [ "\${{ github.event_name }}" = "issue_comment" ]; then
                  PR_URL="\${{ github.event.issue.pull_request.url }}"
                fi
                PR_NUMBER=\$(echo "\$PR_URL" | grep -o '[0-9]*\$')
                PR_DATA=\$(curl -s -H "Authorization: token \${{ secrets.PERSONAL_ACCESS_TOKEN || github.token }}" \\
                  "https://api.github.com/repos/\${{ github.repository }}/pulls/\$PR_NUMBER")
                echo "head_ref=\$(echo "\$PR_DATA" | jq -r '.head.ref')" >> \$GITHUB_OUTPUT
                echo "head_sha=\$(echo "\$PR_DATA" | jq -r '.head.sha')" >> \$GITHUB_OUTPUT
                echo "head_repo=\$(echo "\$PR_DATA" | jq -r '.head.repo.full_name')" >> \$GITHUB_OUTPUT

            # Checkout repository
            # リポジトリをチェックアウト。
            - name: Checkout repository
              uses: actions/checkout@v4
              timeout-minutes: 10
              with:
                  ref: \${{ steps.pr_info.outputs.head_ref || github.event.pull_request.head.ref || github.ref }}
                  fetch-depth: 1
                  token: \${{secrets.PERSONAL_ACCESS_TOKEN || github.token}}

            # Set up JDK 17.
            # JDK 17のセットアップ
            - name: Set up JDK 17
              timeout-minutes: 10
              uses: actions/setup-java@v4
              with:
                distribution: microsoft
                java-version: "17.0.10"

            # Install flutter.
            # Flutterのインストール。
            - name: Install flutter
              timeout-minutes: 10
              uses: subosito/flutter-action@v2
              with:
                channel: stable
                cache: true

            # Check flutter version.
            # Flutterのバージョン確認。
            - name: Run flutter version
              run: flutter --version
              timeout-minutes: 3

            # Run flutter pub get
            # Flutterのパッケージを取得。
            - name: Run flutter pub get
              run: flutter pub get
              timeout-minutes: 3

            # Creation of the Assets folder.
            # Assetsフォルダの作成。
            - name: Create assets folder
              run: mkdir -p assets
              timeout-minutes: 3

            # katanaコマンドをインストール
            - name: Install katana
              run: flutter pub global activate katana_cli
              timeout-minutes: 3

            # Claude Codeを実行
            - name: Run Claude Code
              id: claude
              timeout-minutes: 120
              env:
                BASH_MAX_TIMEOUT_MS: 1800000
                BASH_DEFAULT_TIMEOUT_MS: 1800000
                GITHUB_TOKEN: \${{secrets.PERSONAL_ACCESS_TOKEN || github.token}}
                CLAUDE_CODE_OAUTH_TOKEN: \${{secrets.CLAUDE_CODE_OAUTH_TOKEN}}              
              uses: $actionsRepositoryName
              with:
                  model: $model
                  timeout_minutes: 120
                  disallowed_tools: "mcp__github_file_ops__commit_files,mcp__github_file_ops__delete_files"
                  allowed_tools: "Bash(katana:*),Bash(git:*),Bash(dart:*),Bash(flutter:*),Bash(find:*),Bash(grep:*),Bash(cat:*),Bash(head:*),Bash(cd:*),Bash(ls:*),Bash(mkdir:*),Bash(chmod:*),Task,Glob,Grep,LS,Read,Edit,MultiEdit,Write,NotebookRead,NotebookEdit,TodoRead,TodoWrite,mcp__github__add_issue_comment,mcp__github__add_pull_request_review_comment,mcp__github__create_branch,mcp__github__create_issue,mcp__github__create_or_update_file,mcp__github__create_pull_request,mcp__github__create_pull_request_review,mcp__github__create_repository,mcp__github__delete_file,mcp__github__fork_repository,mcp__github__get_code_scanning_alert,mcp__github__get_commit,mcp__github__get_file_contents,mcp__github__get_issue,mcp__github__get_issue_comments,mcp__github__get_me,mcp__github__get_pull_request,mcp__github__get_pull_request_comments,mcp__github__get_pull_request_files,mcp__github__get_pull_request_reviews,mcp__github__get_pull_request_status,mcp__github__get_secret_scanning_alert,mcp__github__get_tag,mcp__github__list_branches,mcp__github__list_code_scanning_alerts,mcp__github__list_commits,mcp__github__list_issues,mcp__github__list_pull_requests,mcp__github__list_secret_scanning_alerts,mcp__github__list_tags,mcp__github__merge_pull_request,mcp__github__push_files,mcp__github__search_code,mcp__github__search_issues,mcp__github__search_repositories,mcp__github__search_users,mcp__github__update_issue,mcp__github__update_issue_comment,mcp__github__update_pull_request,mcp__github__update_pull_request_branch,mcp__github__update_pull_request_comment"
                  github_token: \${{secrets.PERSONAL_ACCESS_TOKEN || github.token}}
                  $credentials
""";
  }
}

/// Contents of settings.local.json.
///
/// settings.local.jsonの中身。
class GitClaudeSettingsCliCode extends CliCode {
  /// Contents of settings.local.json.
  ///
  /// settings.local.jsonの中身。
  const GitClaudeSettingsCliCode();

  @override
  String get name => "settings.local";

  @override
  String get prefix => "settings.local";

  @override
  String get directory => ".claude";

  @override
  String get description =>
      "Create settings.local.json for AI Agent using Claude Code. Claude Codeを利用したAIエージェント機能用のsettings.local.jsonを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
{
  "permissions": {
    "allow": [
      "Bash(katana apply:*)",
      "Bash(katana code:*)",
      "Bash(flutter packages pub run build_runner build:*)",
      "Bash(flutter clean:*)",
      "Bash(flutter pub:*)",
      "Bash(flutter analyze:*)",
      "Bash(flutter test:*)",
      "Bash(grep:*)",
      "Bash(mv:*)",
      "Bash(dart run:*)",
      "Bash(katana test:*)",
      "Bash(dart fix:*)",
      "Bash(dart format:*)",
      "mcp__{servername}"
    ],
    "deny": []
  }
}
""";
  }
}

/// Contents of AGENTS.md.
///
/// AGENTS.mdの中身。
class GitAgentsMarkdownCliCode extends CliCode {
  /// Contents of AGENTS.md.
  ///
  /// AGENTS.mdの中身。
  const GitAgentsMarkdownCliCode({
    this.availabeBackground = false,
  });

  /// Whether to enable background mode.
  ///
  /// バックグラウンドモードを有効にするかどうか。
  final bool availabeBackground;

  @override
  String get name => "AGENTS";

  @override
  String get prefix => "AGENTS";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create AGENTS.md for AI agent functionality. AIエージェント機能用のAGENTS.mdを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
# Masamuneフレームワーク開発ガイド v2.0

## 🚨 絶対原則（P0）

### 必ず守るべき鉄則
1. **日本語応答必須** → 全てのレスポンスは日本語で記述
2. **katana code必須** → 手動でのファイル作成は絶対禁止
3. **段階的バリデーション** → 1実装ごとに`flutter analyze && dart run custom_lint`実行
${availabeBackground ? """4. **katana git使用** → git直接コマンドは使用禁止
5. **全生成ファイルコミット** → `.m.dart`, `.g.dart`, `.freezed.dart`, テスト画像必須""" : """4. **全生成ファイルコミット** → `.m.dart`, `.g.dart`, `.freezed.dart`, テスト画像必須"""}

### 開発フローの絶対順序
```
実装 → バリデーション → 修正 → 次の実装
```
この順序を絶対に崩さない。エラーは即座に対処。

## 🎯 開発フロー（P0）

### 基本サイクル
1. `katana code [type] [name]`でテンプレート生成
2. 実装を記述
3. `flutter analyze && dart run custom_lint`でバリデーション
4. エラーがあれば修正して再実行
5. UI変更時は`katana test update [ClassName]`
6. 次のコンポーネントへ

### 新規機能追加フロー
```bash
# 1. テンプレート生成
katana code page [PageName]          # ページ作成
katana code collection [Name]        # コレクション作成
katana code document [Name]          # ドキュメント作成
katana code controller [Name]        # コントローラー作成
katana code widget [Name]            # ウィジェット作成
katana code value [Name]             # フォーム値作成

# 2. コード生成（Freezed/JsonSerializable）
katana code generate

# 3. 実装とバリデーション（各コンポーネントごと）
flutter analyze && dart run custom_lint

# 4. UI更新時のテスト
katana test update [ClassName1],[ClassName2]
```

### Firebase Functions実装フロー
```bash
# 1. Functions生成
katana code server call [Name]      # 関数直接呼び出し
katana code server request [Name]   # HTTPリクエスト
katana code server schedule [Name]  # スケジューラー
katana code server firestore [Name] # Firestoreトリガー

# 2. サーバー側実装
# firebase/functions/src/[name].tsのprocessメソッド実装
# Node.js Masamuneパッケージ活用:
# - masamune_auth: 認証処理
# - masamune_firestore: データベース操作
# - masamune_notification: 通知送信
# - masamune_mail_sendgrid: メール送信
# - masamune_purchase_stripe: 決済処理
# - masamune_ai_openai: AI連携

# 3. クライアント側実装
# lib/functions/[name].dartでFunctionsAction/Response定義
final response = await appFunction.execute(
  TestFunctionsAction(
    companyId: "xxx",
    userId: "yyy",
  ),
);

# 4. デプロイ
katana deploy functions
```

### katana.yaml設定とkatana apply
```yaml
# katana.yaml例
name: myapp
package: com.example.myapp

# プラグイン設定（自動インストール）
firebase:
  enable: true
  firestore:
    enable: true
  auth:
    enable: true
    google: true
    apple: true
  functions:
    enable: true

# プラグイン例
purchase:
  enable: true
  type: stripe

# 適用コマンド（全設定を自動反映）
katana apply
```

### ${availabeBackground ? "コミット前" : "完了前"}の必須作業
```bash
# 1. コードフォーマット
dart fix --apply lib && dart format . && flutter pub run import_sorter:main

# 2. バリデーション（エラー0必須）
flutter analyze && dart run custom_lint

# 3. UI更新時：ゴールデンテスト更新
katana test update [更新したクラス名]

# 4. 全体テスト実行
katana test run
${availabeBackground ? """
# 5. コミット
katana git commit --message="コミットメッセージ" [ファイル...]

# 6. PR作成/更新
katana git pull_request --target="master" --source="branch" --title="タイトル" --body="説明"
""" : ""}
```

## 🛠️ コマンド早見表（P0）

### 頻出コマンド
| タスク | コマンド |
|--------|----------|
| **ページ作成** | `katana code page [name]` |
| **モデル作成** | `katana code collection/document [name]` |
| **コントローラー** | `katana code controller [name]` |
| **ウィジェット** | `katana code widget [name]` |
| **フォーム値** | `katana code value [name]` |
| **Functions作成** | `katana code server call/request/schedule/firestore [name]` |
| **コード生成** | `katana code generate` |
| **プラグイン適用** | `katana apply` |
| **バリデーション** | `flutter analyze && dart run custom_lint` |
| **フォーマット** | `dart fix --apply lib && dart format .` |
| **インポート整理** | `flutter pub run import_sorter:main` |
| **テスト更新** | `katana test update [class]` |
| **テスト実行** | `katana test run` |
| **Functions deploy** | `katana deploy functions` |

### 基本パターンコード
```dart
// Model読み込み
final model = ref.app.model(TestModel.collection())..load();

// Document取得
final doc = ref.app.model(TestModel.document("docId"))..load();

// Controller使用
final controller = ref.page.controller(TestController.query());

// Form使用
final form = ref.page.form(LoginValue.form());

// Functions実行
final response = await appFunction.execute(TestFunctionsAction());

// ModelFieldValue例
ModelLocalizedValue({"ja": "日本語", "en": "English"})  // 多言語
ModelGeoValue(latitude: 35.6762, longitude: 139.6503)  // 位置情報
ModelSearch(["keyword1", "keyword2"])                   // 検索用
ModelTimestamp(DateTime.now())                          // タイムスタンプ
```

## 🤖 エージェント選択ガイド（P1）

### 状況別エージェントマトリックス
| 状況 | エージェント | 目的 |
|------|-------------|------|
| **フレームワーク質問** | `masamune_framework_advisor` | 実装方法・ルール確認 |
| **パッケージ検討** | `package_advisor` | 最適パッケージ選定 |
| **UI実装** | `ui_builder` | デザインからコード生成 |
| **UIデバッグ** | `ui_debugger` | デザイン差分検出 |
| **テスト実行** | `test_runner` | テスト実行・分析 |
| **Firebase問題** | `firebase_flutter_debugger` | 連携問題解決 |

### 各エージェント概要
- **masamune_framework_advisor**: Model/Page/Controller/Widget/Form/プラグイン使用方法、ModelFieldValue活用
- **package_advisor**: Masamuneプラグイン確認、pub.dev検索、npm packages検討
- **ui_builder**: デザイン資産からUI実装、UniversalUI活用、レスポンシブ対応
- **ui_debugger**: 実装UIとデザイン比較、差分検出、修正提案
- **test_runner**: ゴールデンテスト更新、テスト実行、エラー解析
- **firebase_flutter_debugger**: Auth/Firestore/Functions連携デバッグ、ログ確認

※詳細は`.claude/agents/*.md`を参照

## 🏗️ アーキテクチャ要点（P1）

### 設計パターン
- **Page-Based**: `@PagePath`アノテーションによるルーティング
- **Model-Driven**: Freezed + ModelAdapterパターン
- **Scoped State**: `ref.app`（アプリ全体） / `ref.page`（ページスコープ）
- **Adapter Pattern**: Runtime → Firestore → Local切替可能

### ファイル規則
```
lib/pages/[name].dart        → [Name]Page クラス
lib/models/[name].dart       → [Name]Model クラス
lib/controllers/[name].dart  → [Name]Controller クラス
lib/widgets/[name].dart      → [Name] クラス
lib/functions/[name].dart    → [Name]FunctionsAction クラス
firebase/functions/src/[name].ts → process関数実装
```

### ModelFieldValue活用
| タイプ | 用途 | 例 |
|--------|------|-----|
| **ModelLocalizedValue** | 多言語対応 | `{"ja": "日本語", "en": "English"}` |
| **ModelGeoValue** | 位置情報 | `latitude: 35.6762, longitude: 139.6503` |
| **ModelSearch** | 検索用キーワード | `["keyword1", "keyword2"]` |
| **ModelTimestamp** | タイムスタンプ | `DateTime.now()` |
| **ModelUri** | URI/URL | `Uri.parse("https://example.com")` |
| **ModelImageUri** | 画像URI | Storage連携、キャッシュ対応 |
| **ModelVideoUri** | 動画URI | Storage連携、サムネイル対応 |
| **ModelCounter** | カウンター | インクリメント/デクリメント対応 |
| **ModelRef** | ドキュメント参照 | 他ドキュメントへのリファレンス |

## 📚 ドキュメント参照マップ（P2）

### 実装時の参照先
- **全体フロー**: `documents/rules/impls/impl.md`
- **Model実装**: `documents/rules/docs/model_usage.md`
- **Page実装**: `documents/rules/impls/page_impl.md`
- **Widget実装**: `documents/rules/impls/widget_impl.md`
- **Controller実装**: `documents/rules/impls/controller_impl.md`
- **Functions実装**: `documents/rules/docs/functions_usage.md`
- **Form実装**: `documents/rules/docs/form/**`
- **UI実装**: `documents/rules/docs/katana_ui/**`, `documents/rules/docs/universal_ui/**`
- **プラグイン**: `documents/rules/docs/plugins/**`
- **CLI詳細**: `documents/rules/docs/katana_cli.md`

### Firebase Functions側の実装
- **Node.jsパッケージ**: `node_masamune/packages/**`
- **実装例**: `firebase/functions/src/**`

## ⚠️ エラー対処表（P1）

### よくあるエラーと解決策
| エラー | 原因 | 解決コマンド |
|--------|------|-------------|
| **Freezed生成エラー** | 古い生成ファイル | `katana code generate` |
| **Analyze警告** | フォーマット不適合 | `dart fix --apply lib` |
| **Custom lint エラー** | ルール違反 | エラー箇所を修正 |
| **Import順序エラー** | インポート未整理 | `flutter pub run import_sorter:main` |
| **Test失敗** | ゴールデン不一致 | `katana test update [class]`後に再実行 |
| **Functions エラー** | 型不一致 | Action/Responseの型定義確認 |
| **ModelAdapter エラー** | 初期化忘れ | `main.dart`でAdapter設定確認 |
| **Form validation** | バリデーター未設定 | FormValidatorを適用 |

### ❌ 禁止事項
- git add/commit直接実行
- 手動Dartファイル作成
- バリデーションスキップ
- 生成ファイル(.m.dart等)のコミット忘れ
- UI変更後のゴールデンテスト更新忘れ
- 新しいFunctions()インスタンス作成（appFunction使用必須）

## 🔧 トラブルシューティング（P2）

### デバッグ手順
1. エラーメッセージ確認
2. 該当箇所修正
3. `flutter analyze && dart run custom_lint`
4. 解決しない場合：`dart fix --apply lib`
5. Functions問題：`firebase functions:log`確認
6. Firestore問題：Firestoreコンソールでルール/インデックス確認

## 💡 効率的な開発Tips（P2）

1. **テスト画像は必ず確認** - UIのズレを見逃さない
2. **エラーは即座に対処** - 後回しにすると複雑化する
3. **ドキュメントを参照** - 不明点は`documents/rules/`配下を確認
${availabeBackground ? """4. **小さな単位でコミット** - 機能ごとに細かくコミットする
5. **PR作成時にスクリーンショット添付** - レビューを効率化""" : """4. **katana applyで環境構築自動化** - 手動設定を避ける"""}

## 📋 よく使う実装パターン（P1）

### 認証フロー実装
```dart
// ソーシャルログイン
await Auth.signIn(GoogleAuthQuery.signIn());
await Auth.signIn(AppleAuthQuery.signIn());

// メール/パスワード認証
await Auth.signIn(EmailAndPasswordAuthQuery.signIn(
  email: "user@example.com",
  password: "password123",
));

// サインアウト
await Auth.signOut();

// ユーザー情報取得
final user = Auth.userId;  // ユーザーID
final isSignedIn = Auth.isSignedIn;  // サインイン状態
```

### Firestoreデータ操作
```dart
// Create
final newModel = TestModel(
  id: uuid(),
  name: "Test",
  createdAt: ModelTimestamp(DateTime.now()),
);
await newModel.save();

// Read (Collection)
final collection = ref.app.model(TestModel.collection())..load();
for (final item in collection) {
  print(item.name);
}

// Update
model.name = "Updated Name";
await model.save();

// Delete
await model.delete();

// Query with Filter
final query = TestModel.collection().equal("status", "active");
final filtered = ref.app.model(query)..load();
```

### ストレージ操作
```dart
// 画像アップロード
final image = await ImagePicker().pickImage(source: ImageSource.gallery);
if (image != null) {
  final uri = await Storage.upload(
    "users/\${Auth.userId}/profile.jpg",
    File(image.path),
  );
  model.profileImage = ModelImageUri(uri);
  await model.save();
}

// ファイルダウンロード
final file = await Storage.download(uri);
```

### 通知実装
```dart
// プッシュ通知送信（Functions側）
await Notification.send(
  title: "新着メッセージ",
  body: "メッセージが届きました",
  tokens: [userToken],
  data: {"type": "message", "id": messageId},
);

// アプリ内通知表示
ref.page.showSnackBar("保存しました");
ref.page.showDialog(
  title: "確認",
  text: "削除してもよろしいですか？",
  submitText: "削除",
  onSubmit: () async {
    await model.delete();
  },
);
```

### 決済フロー（Stripe）
```dart
// 単発購入
final purchase = ref.app.purchase();
await purchase.purchase(
  productId: "product_123",
  onSuccess: (transaction) {
    // 購入成功処理
  },
);

// サブスクリプション
await purchase.subscribe(
  productId: "subscription_monthly",
  onSuccess: (transaction) {
    // サブスク開始処理
  },
);

// 購入履歴確認
final purchased = await purchase.isPurchased("product_123");
```

### リアルタイム同期
```dart
// リアルタイム監視
final model = ref.app.model(
  TestModel.collection(),
  listen: true,  // リアルタイム監視ON
)..load();

// 変更を即座に反映
model.addListener(() {
  // データ変更時の処理
});
```

## 🌐 マルチプラットフォーム対応（P2）

### UniversalUI使用例
```dart
// レスポンシブデザイン
UniversalColumn(
  breakpoint: Breakpoint.sm,  // スマホサイズで縦並び
  children: [
    // スマホ: 縦並び
    // タブレット以上: 横並び
  ],
);

// プラットフォーム別分岐
if (UniversalPlatform.isIOS) {
  // iOS専用処理
} else if (UniversalPlatform.isAndroid) {
  // Android専用処理
} else if (UniversalPlatform.isWeb) {
  // Web専用処理
}

// 画面サイズ取得
final size = MediaQuery.of(context).size;
final isSmall = size.width < 600;
```

### フォーム実装
```dart
// フォーム定義
@freezed
@formValue
class LoginValue with _\$LoginValue {
  const factory LoginValue({
    @Default("") String email,
    @Default("") String password,
  }) = _LoginValue;
}

// フォーム使用
final form = ref.page.form(LoginValue.form());

FormTextField(
  form: form,
  hintText: "メールアドレス",
  onSaved: (value) => form.value = form.value.copyWith(email: value),
  validator: FormValidator.email(),
);

FormButton(
  form: form,
  text: "ログイン",
  onPressed: () async {
    if (!form.validate()) return;
    await Auth.signIn(EmailAndPasswordAuthQuery.signIn(
      email: form.value.email,
      password: form.value.password,
    ));
  },
);
```

## 🔄 状態管理パターン（P2）

### Scopedパターン使い分け
```dart
// アプリ全体で共有（ref.app）
final globalSettings = ref.app.watch(SettingsProvider());
final userProfile = ref.app.model(UserModel.document(Auth.userId));

// ページ内でのみ有効（ref.page）
final pageController = ref.page.controller(PageController());
final tempForm = ref.page.form(TempValue.form());

// ウィジェット内での管理（ref.widget）
final animationController = ref.widget.animation(
  AnimationController(duration: Duration(seconds: 1)),
);
```

### ライフサイクル管理
```dart
@override
void onInit() {
  super.onInit();
  // 初期化処理
  _loadInitialData();
}

@override
void onDispose() {
  // クリーンアップ処理
  _controller.dispose();
  super.onDispose();
}
```

## ⚡ パフォーマンス最適化（P2）

### 最適化のポイント
1. **遅延読み込み**: `load()`は必要時のみ実行
2. **ページネーション**: 大量データは`limitTo()`で分割
3. **画像最適化**: `ModelImageUri`でキャッシュ活用
4. **ウィジェット最適化**: `const`コンストラクタ活用
5. **ビルド最適化**: 不要な再ビルドを避ける

```dart
// ページネーション例
final query = TestModel.collection()
  .orderBy("createdAt", desc: true)
  .limitTo(20);
final models = ref.app.model(query)..load();

// 次ページ読み込み
if (models.canLoadNext) {
  await models.loadNext();
}
```

## 🎓 学習リソース

### 優先順位
1. このドキュメント（AGENTS.md）
2. `documents/rules/docs/katana_cli.md` - CLIコマンド一覧
3. `documents/rules/impls/impl.md` - 実装フロー
4. `documents/rules/docs/functions_usage.md` - Functions実装
5. 各プラグインドキュメント（`documents/rules/docs/plugins/**`）
6. ModelFieldValueドキュメント（`documents/rules/docs/model_field_value/**`）
7. UIコンポーネント（`documents/rules/docs/katana_ui/**`, `documents/rules/docs/universal_ui/**`）

---

**重要**: このドキュメントは定期的に更新されます。開発開始前に最新版を確認してください。
**バージョン**: 2.0 - Firebase Functions/Node.js Masamune対応版
""";
  }
}
