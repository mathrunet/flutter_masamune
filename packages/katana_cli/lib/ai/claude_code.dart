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
    label("Create CLAUDE.md");
    await const GitClaudeMarkdownCliCode().generateFile("CLAUDE.md");
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

/// Contents of CLAUDE.md.
///
/// CLAUDE.mdの中身。
class GitClaudeMarkdownCliCode extends CliCode {
  /// Contents of CLAUDE.md.
  ///
  /// CLAUDE.mdの中身。
  const GitClaudeMarkdownCliCode({
    this.availabeBackground = false,
  });

  /// Whether to enable background mode.
  ///
  /// バックグラウンドモードを有効にするかどうか。
  final bool availabeBackground;

  @override
  String get name => "CLAUDE";

  @override
  String get prefix => "CLAUDE";

  @override
  String get directory => "";

  @override
  String get description =>
      "Create CLAUDE.md for AI Agent using Claude Code. Claude Codeを利用したAIエージェント機能用のCLAUDE.mdを作成します。";

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
# Masamuneフレームワーク開発ガイド for Claude Code

このドキュメントは、Claude Code (claude.ai/code)がこのリポジトリで効率的に開発を行うための包括的なガイドラインです。

## 🎯 最重要原則

### 1. 必ず守るべき5つの鉄則
1. **手動でのファイル作成禁止** → 必ず`katana code`コマンドでテンプレート生成
2. **段階的な実装とバリデーション** → 1つの実装ごとに必ず`flutter analyze && dart run custom_lint`を実行
3. **エージェントの積極活用** → 各開発フェーズで適切な専門エージェントを使用
4. **UI確認の最適化** → 開発中は`katana code debug`で素早く確認、コミット前に`katana test update`で最終確認
5. **エラーの即時対処** → エラーは後回しにせず、発見次第修正

### 2. 開発フローの絶対的な順序
```
実装 → バリデーション → 修正 → UI確認(katana code debug) → 次の実装
→ ... 実装完了 → 最終テスト(katana test update)
```
この順序を絶対に崩してはいけません。

## 🤖 専門エージェントシステム

開発の各フェーズで専門的なサポートを提供する実装エージェントが利用可能です。これらのエージェントは単なるガイドではなく、実際にコードを生成し、実装を行います。

### 基本エージェント（Core Agents）

#### 1. masamune_framework_advisor
**役割**: Masamuneフレームワーク専門アドバイザーとして、具体的な実装コードを提供

**使用場面**:
- フレームワーク機能の実装方法（Model、Page、Controller、Widget、Form等）
- 実装パターンやベストプラクティスの適用
- ModelFieldValueタイプの使用方法
- フレームワーク固有の概念の実装

**使用例**:
```
「ModelTimestampの使い方を教えてください」
→ 具体的な実装コードと使用例を提供
```

#### 2. package_advisor
**役割**: 最適なパッケージ選定と具体的な実装コードを提供

**使用場面**:
- 機能実装に必要なパッケージの選定
- Masamuneプラグインの優先的な提案
- パッケージの評価（更新頻度、品質指標）
- 実装コストと効果の分析

**評価基準**:
- 最終更新: 6ヶ月以内（1年以上は原則不採用）
- pub.dev: likes数50以上、pub points90以上推奨
- 導入コスト: 3ステップ以内が理想

**使用例**:
```
「位置情報取得機能を実装したい」
→ 適切なパッケージと実装コードを提供
```

#### 3. ui_builder
**役割**: 画像やFigmaデザインからFlutter UIコードを生成

**使用場面**:
- スクリーンショットからのUI実装
- Figmaデザインの変換
- 手書きスケッチの実装
- 既存UIの修正

**使用例**:
```
「この画像からFlutter UIを作成して」
→ MasamuneフレームワークでのUIコードを生成
```

#### 4. ui_debugger
**役割**: UI実装の検証と問題分析を実行

**使用場面**:
- UIの実装検証
- 目標デザインとの差分分析
- flutter_widget_inspector連携
- デバッグ画像生成（katana code debug）

**使用例**:
```
「現在のUIが目標デザインと一致しているか確認」
→ 差分分析と修正提案を提供
```

#### 5. firebase_flutter_debugger
**役割**: FirebaseバックエンドとFlutterフロントエンドの問題を診断・解決

**使用場面**:
- Dartランタイムエラーの調査
- Firebase Functionsログの分析
- Firestoreデータ整合性の確認
- フロントエンド/バックエンド間の問題特定
- 認証・データアクセス関連のトラブルシューティング

**使用例**:
```
「ユーザー登録でエラーが発生しています」
→ Dartエラー、Functionsログ、Firestoreデータを横断調査し根本原因を特定

「Firestoreにデータが正しく保存されていません」
→ フロントエンドのデータ送信とバックエンドの保存処理を検証
```

#### 6. test_runner
**役割**: テストを実際に実行し、結果を分析

**使用場面**:
- ゴールデンテスト更新と実行
- 全体テストの実行
- テストエラーの診断
- 最大3回のリトライループ実行

**使用例**:
```
「UIを変更したのでテストを更新して」
→ katana test updateを実行し、結果を報告
```

### 開発フェーズ別エージェント（Development Phase Agents）

#### 7. initial_development_requirements_analyzer
**役割**: 新規プロジェクトの要件分析と実装計画立案

**使用場面**:
- プロジェクト開始時の要件分析
- 機能要件から実装タスクへの分解
- 技術選定と実装方針の決定
- 必要な設計書のリスト化

**出力**:
- 構造化された実装計画
- 技術スタック選定結果
- 開発フェーズ分け
- リスク分析

#### 8. enhancement_development_requirements_analyzer
**役割**: 既存システムへの機能追加・改修の影響分析

**使用場面**:
- 機能追加の影響範囲特定
- リファクタリング計画
- データ移行の必要性確認
- 既存コードとの整合性確認

**出力**:
- 影響分析レポート
- 段階的実装計画
- リスク評価
- テスト戦略

#### 9. initial_development_designer
**役割**: 設計書を実際に作成

**使用場面**:
- 新規プロジェクトの設計書作成
- Model/Page/Controller設計
- データフロー設計
- テーマ設計

**出力**:
- documents/designs/配下の各種設計書
- 実装可能な詳細設計
- アーキテクチャ定義

#### 10. initial_development_implimenter
**役割**: 設計書に基づいてコードを実装

**使用場面**:
- 新規プロジェクトの実装
- katana codeコマンドでのテンプレート生成
- バリデーションとテスト実行
- 基盤機能の構築

**実行フロー**:
1. katana codeでテンプレート生成
2. 設計書に基づく実装
3. flutter analyze && dart run custom_lint
4. katana test実行
5. エラーがあれば修正（最大3回リトライ）

#### 11. enhancement_development_implimenter
**役割**: 既存システムへの機能追加・改修を実装

**使用場面**:
- 既存プロジェクトへの機能追加
- バグ修正とリファクタリング
- 後方互換性を保った改修
- 回帰テストの実行

**実行フロー**:
1. 影響範囲の確認
2. 段階的な実装
3. 既存テストの確認
4. 新機能テスト追加
5. 回帰テスト実行

## 📋 エージェント活用ワークフロー

### 新規プロジェクト開発フロー
```mermaid
graph LR
    A[要件定義] -->|initial_development_requirements_analyzer| B[要件分析]
    B -->|initial_development_designer| C[設計書作成]
    C -->|initial_development_implimenter| D[実装]
    D -->|test_runner| E[テスト]
    E -->|ui_debugger| F[UI検証]
```

### 機能追加・改修フロー
```mermaid
graph LR
    A[改修要件] -->|enhancement_development_requirements_analyzer| B[影響分析]
    B -->|enhancement_development_implimenter| C[実装]
    C -->|test_runner| D[テスト]
    D -->|ui_debugger| E[検証]
```

### 問題解決フロー
```mermaid
graph LR
    A[問題発生] -->|masamune_framework_advisor| B[解決策確認]
    B -->|package_advisor| C[パッケージ検討]
    C -->|実装| D[修正]
    D -->|test_runner| E[テスト]
```

## 🏗️ アーキテクチャ概要

### 設計パターン
1. **Page-Based Architecture**: `@PagePath`アノテーションによるページ構成
2. **Model-Driven Data**: Freezedモデル + ModelAdapterパターン
3. **Scoped State Management**: `ref.app`（アプリ全体） / `ref.page`（ページスコープ）
4. **Adapter Pattern**: バックエンド切り替え可能（Runtime → Firestore → Local）

### ファイル命名規則
```
Pages:       lib/pages/[name].dart      → [Name]Page クラス
Models:      lib/models/[name].dart     → [Name]Model クラス
Controllers: lib/controllers/[name].dart → [Name]Controller クラス
Widgets:     lib/widgets/[name].dart    → [Name] クラス
```

## 📁 プロジェクト構造

```
flutter_app_gitvibes/
├── .claude/
│   └── agents/              # エージェント定義
│       ├── masamune_framework_advisor.md
│       ├── package_advisor.md
│       ├── ui_builder.md
│       ├── ui_debugger.md
│       ├── test_runner.md
│       ├── initial_development_requirements_analyzer.md
│       ├── enhancement_development_requirements_analyzer.md
│       ├── initial_development_designer.md
│       ├── initial_development_implimenter.md
│       └── enhancement_development_implimenter.md
├── lib/                     # ソースコード
│   ├── pages/              # ページ
│   ├── models/             # データモデル
│   ├── controllers/        # コントローラー
│   └── widgets/            # ウィジェット
├── documents/
│   ├── designs/            # 設計書
│   ├── test/              # ゴールデンテスト画像
│   └── debugs/            # デバッグ画像
└── test/                   # テストコード
```

## 🛠️ 必須コマンドリファレンス

### コード生成
```bash
# テンプレート生成（必ず最初に実行）
katana code page [PageName]
katana code collection [Name]
katana code document [Name]
katana code controller [Name]
katana code widget [Name]
katana code value [Name]

# コード生成
katana code generate
```

### バリデーション（1実装ごとに必須）
```bash
flutter analyze && dart run custom_lint
```

### テスト
```bash
# UI確認用の画像生成（開発中の素早い確認用）
# 出力先: documents/debug/**/*.png
katana code debug [ClassName1],[ClassName2]

# ゴールデンテスト更新（コミット前の最終確認時のみ実行）
# ⚠️ Docker使用のため時間がかかる。完了直前に1度だけ実行すること
# 出力先: documents/test/**/*.png
katana test update [ClassName1],[ClassName2]

# 全テスト実行
katana test run
```

### 最終処理
```bash
# コードフォーマット
dart fix --apply lib && dart format . && flutter pub run import_sorter:main
```

## 💡 実装パターン

### データ読み込み
```dart
@override
Widget build(BuildContext context, PageRef ref) {
  final model = ref.app.model(TestModel.collection())..load();
  // モデルの読み込み/変更時にWidgetが再構築される
}
```

### コントローラー使用
```dart
final controller = ref.page.controller(TestController.query());
// ref.page: ページライフサイクルにスコープ
// ref.app: アプリライフサイクルにスコープ
```

### フォーム
```dart
final form = ref.page.form(LoginValue.form(LoginValue(email: "", password: "")));
// FormTextField, FormButton等と組み合わせて使用
```

## ⚠️ よくあるミスと対処法

### ❌ してはいけないこと
- 手動でのDartファイル作成
- バリデーションをスキップして次の実装に進む
- エージェントを使わずに独自判断で実装
- 開発中に`katana test update`を頻繁に実行（時間がかかる）
- エラーを無視して続行

### ✅ 必ずすること
- `katana code`でのテンプレート生成
- 1実装ごとのバリデーション実行
- 適切なエージェントの選択と使用
- 開発中は`katana code debug`でUI確認（素早い）
- コミット前に`katana test update`で最終確認（1度だけ）
- エラーの即時修正（最大3回リトライ）

## 🔍 トラブルシューティング

### エラーが出た場合の対処順序
1. エラーメッセージを確認
2. 該当エージェントに相談
3. エラー修正を実施
4. `flutter analyze && dart run custom_lint`で再確認
5. 3回失敗したら詳細エラーを出力して停止

### よくあるエラー
- **Missing generated file**: `katana code generate`を実行
- **Type mismatch**: 設計書と実装の型を確認
- **Import error**: `flutter pub add [package_name]`でパッケージ追加
- **Test failure**: `katana test update`でゴールデンテスト更新

## 📚 ドキュメント構造

### 設計書（`documents/rules/designs/`）
- 全体設計、メタデータ、モデル、ページ、コントローラー等の設計テンプレート

### 実装手順（`documents/rules/impls/`）
- 各コンポーネントの詳細な実装手順

### テスト手順（`documents/rules/tests/`）
- テスト実装フローとゴールデンテスト手順

### フレームワークドキュメント（`documents/rules/docs/`）
- Masamuneフレームワークの詳細な使用方法

## 🎓 学習リソース

### 優先順位
1. このドキュメント（CLAUDE.md）
2. 各エージェント定義（.claude/agents/*.md）
3. `documents/rules/docs/katana_cli.md` - CLIコマンド一覧
4. `documents/rules/impls/impl.md` - 実装フロー
5. 各種設計書・実装手順書

## 🚀 効率的な開発のための最重要Tips

1. **エージェントファースト**: 迷ったら適切なエージェントに相談
2. **バリデーションの徹底**: エラーゼロを維持
3. **UI確認の最適化**:
   - 開発中: `katana code debug`で素早く確認（数秒）
   - コミット前: `katana test update`で最終確認（時間がかかるため1度だけ）
4. **段階的実装**: 小さく実装、頻繁にテスト
5. **ドキュメント準拠**: 独自判断せず、ドキュメントとエージェントに従う

---

**重要**: このドキュメントは定期的に更新されます。開発開始前に最新版を確認し、必ず専門エージェントを活用してください。
""";
  }
}
