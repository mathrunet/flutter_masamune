// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/ai/agents/agents.dart";
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


### 2. 開発フローの絶対的な順序
```
実装 → バリデーション → 修正 → 次の実装
```
この順序を絶対に崩してはいけません。

## 🤖 専用エージェントの活用

開発の各フェーズで専門的なサポートを提供する複数のエージェントが利用可能です。

### 1. Masamune Framework Helper Agent
Masamuneフレームワークに関する詳細な質問がある場合に使用します。

#### 使用するべき場面
- フレームワーク機能の使用方法（Model、Page、Controller、Widget、Form等）
- 実装パターンやベストプラクティス
- プラグインの使用方法（camera、location、OpenAI、Stripe等）
- UIコンポーネント（UniversalUI、KatanaUI、フォームウィジェット）
- ModelFieldValueタイプとその使用方法
- フレームワーク固有の概念や用語

#### 使用例
```
「ModelTimestampの使い方を教えてください」
「FormTextFieldの実装方法は？」
「Pageの状態管理はどうやるの？」
```

### 2. Design Implementation Guide Agent
設計書から実装への移行をサポートします。

#### 使用するべき場面
- 設計書に基づいた実装開始時
- 既存設計からの実装アプローチの明確化
- 実装順序やフローの確認

#### 使用例
```
「設計書を作成したので、ユーザー認証機能の実装を始めたい」
「ModelとControllerの実装方法がわからない」
「次に何を実装すればいいですか？」
```

### 3. Design Rules Guide Agent
設計書作成のガイダンスを提供します。

#### 使用するべき場面
- 各種設計書（Page、Model、Controller等）の作成方法
- 設計書の構造とフォーマットの確認
- 設計ルールと規約の明確化

#### 使用例
```
「Pageの設計書を作成する手順は？」
「Controller設計書のメソッド定義の書き方は？」
「Model設計書でフィールドの型指定方法は？」
```

### 4. Implementation Rules Guide Agent
実装ルールとコーディングパターンをガイドします。

#### 使用するべき場面
- 特定コンポーネントの実装手順確認
- ステップバイステップの実装ガイダンス
- 実装のベストプラクティス

#### 使用例
```
「Controllerのメソッドを実装する手順を教えて」
「新しいPageを作成する手順は？」
「ModelのtoTile拡張メソッドの実装方法は？」
```

### 5. Test Rules Guide Agent
テストの作成と実行をサポートします。

#### 使用するべき場面
- テストの書き方とルール
- ゴールデンテストのスクリーンショット生成
- `katana test`コマンドのトラブルシューティング

#### 使用例
```
「新しいPageのテストはどう書けばいい？」
「katana test updateでエラーが出た」
「プロジェクトのテストフローを教えて」
```

### 6. Flutter Widget Inspector Agent
実行中のアプリケーションのウィジェット状態を検査します。

#### 使用するべき場面
- ウィジェットツリーの確認
- ウィジェットのプロパティ検査
- ホットリロードの実行と状態確認
- デバッグ時のレイアウト問題調査

#### 使用例
```
「現在の画面のWidgetツリーを教えて」
「Containerのpaddingとmarginを確認して」
「ホットリロードしてからTextFieldのパラメーターを確認」
```

### 7. Firebase Flutter Debugger Agent
FirebaseバックエンドとFlutterフロントエンドの問題を診断・解決します。

#### 使用するべき場面
- Dartランタイムエラーの調査
- Firebase Functionsログの分析
- Firestoreデータ整合性の確認
- フロントエンド/バックエンド間の問題特定
- 認証・データアクセス関連のトラブルシューティング

#### 使用例
```
「ユーザー登録でエラーが発生しています」
「Firestoreにデータが正しく保存されていません」
「Firebase Functionsのログを確認して」
「認証後のデータ取得に失敗します」
```

### 8. Figma to Flutter UI Agent
Figmaデザインを本番環境対応のFlutter UIに変換します。

#### 使用するべき場面
- FigmaデザインからのFlutter UI生成
- デザインシステムの実装
- Figmaコンポーネントの実装
- デザイン仕様に基づくページ作成

#### 使用例
```
「Figmaのログイン画面からFlutter UIを作成してください」
「Figmaのユーザープロフィールカードを実装したい」
「ダッシュボード画面をFigmaデザインから作成して」
```

### 9. Image to Flutter UI Agent
画像（スクリーンショット、モックアップ、スケッチ）からFlutter UIを作成します。

#### 使用するべき場面
- スクリーンショットからのUI再現
- デザインモックアップの実装
- 手書きスケッチの実装
- 参照画像を使ったUI修正

#### 使用例
```
「このスクリーンショットからFlutterのUIを作成してください」
「この手書きデザインをFlutterで実装してください」
「現在のUIをこの画像のように修正してください」
```

### 10. Package Finder Agent
機能実装に最適なパッケージを発見・推奨します。

#### 使用するべき場面
- 新機能実装前のパッケージ調査
- ゼロから実装すべきか既存パッケージを使うべきかの判断
- Masamuneプラグインの確認
- 適切なDart/Flutterパッケージの検索

#### 使用例
```
「位置情報取得機能を実装したいのですが、使えるパッケージは？」
「カメラ機能を自分で作るべきでしょうか？」
「Stripe決済を実装したい」
「OpenAI APIを使った機能を作りたい」
```

### 11. Notion Requirements Analyzer Agent
Notionの要件を分析し、実装ステップに変換します。

#### 使用するべき場面
- Notionページからの要件抽出
- プロジェクト要件の構造化
- 不足情報の特定と質問
- 実装計画の作成

#### 使用例
```
「このNotionページのタスクを実装したいです」
「Notionにまとめた要件から実装を始めたい」
「Notionの内容で足りているか確認してください」
```

### 12. Text Requirements Analyzer Agent
テキスト形式の要件を分析し、実装ステップに分解します。

#### 使用するべき場面
- テキスト要件からの実装計画作成
- 曖昧な要件の明確化
- 機能仕様の構造化
- 実装ステップの生成

#### 使用例
```
「ECサイトを作りたいです。商品一覧、カート、決済が必要です」
「タスク管理アプリを作りたいんですが、どんな機能が必要？」
「このREADMEの機能を実装したい」
```

### 13. Masamune Plugin Guide Agent
Masamuneフレームワークのプラグイン選択と使用をガイドします。

#### 使用するべき場面
- 特定機能向けプラグインの検索
- プラグインの使用方法確認
- 機能要件に最適なプラグインの選定

#### 使用例
```
「写真撮影機能を実装したいが、どのプラグインを使えばいい？」
「Stripe決済のMasamuneプラグインはある？」
「katana_cameraプラグインの使い方を教えて」
```

これらのエージェントは、開発の各段階で専門的なサポートを提供し、効率的な開発を支援します。

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

## 📋 開発タスク別ワークフロー

### 1️⃣ 新規機能追加

#### 手順
1. **テンプレート生成**
   ```bash
   katana code page [PageName]      # ページ作成
   katana code collection [Name]    # コレクションモデル作成
   katana code document [Name]      # ドキュメントモデル作成
   katana code controller [Name]    # コントローラー作成
   katana code widget [Name]        # ウィジェット作成
   katana code value [Name]         # フォーム値作成
   ```

2. **実装（1コンポーネントずつ）**
   - 実装を記述
   - 即座にバリデーション実行:
     ```bash
     flutter analyze && dart run custom_lint
     ```
   - エラーがあれば修正して再実行

3. **UI更新時のテスト**
   ```bash
   katana test update [ClassName1],[ClassName2]
   ```
   - 生成された画像を確認（`documents/test/**/*.png`）

4. **次のコンポーネントへ**
   - 2-3を繰り返す

### 2️⃣ バグ修正・改修

#### 手順
1. **問題の特定と修正**
2. **即座にバリデーション**
   ```bash
   flutter analyze && dart run custom_lint
   ```
3. **UI変更があれば画像更新**
   ```bash
   katana test update [影響のあるクラス名]
   ```
4. **全体テスト実行**
   ```bash
   katana test run
   ```

### 3️⃣ 完了前の必須作業

#### 完全な手順（順序厳守）
```bash
# 1. コードフォーマット
dart fix --apply lib && dart format . && flutter pub run import_sorter:main

# 2. バリデーション（エラー0必須）
flutter analyze && dart run custom_lint

# 3. UI更新時のみ：ゴールデンテスト更新
katana test update [更新したクラス名]

# 4. 全体テスト実行
katana test run

# 5. エラーがあれば1から再実行



## 🛠️ 必須コマンドリファレンス

### コード生成・監視
```bash
# 手動生成
katana code generate
```

### テスト関連
```bash
# ゴールデンテスト更新（UI変更時必須）
katana test update [ClassName1],[ClassName2]

# 全テスト実行
katana test run
```

## 💡 コーディングパターン

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

## 📚 設計書・ドキュメント構造

### 設計書（`documents/rules/designs/`）
- `design.md`: 全体設計フロー
- `metadata_design.md`: メタデータ設計
- `controller_design.md`: コントローラー設計
- `model_design.md`: モデル設計
- `plugin_design.md`: プラグイン設計
- `theme_design.md`: テーマ設計
- `widget_design.md`: ウィジェット設計
- `page_design.md`: ページ設計

### 実装手順（`documents/rules/impls/`）
- `impl.md`: 実装フロー全体
- 各コンポーネント別の詳細実装手順

### テスト手順（`documents/rules/tests/`）
- `test.md`: テスト実装フロー
- `page_test.md`: ページテスト
- `model_extension_test.md`: モデル拡張テスト
- `widget_test.md`: ウィジェットテスト

### 技術ドキュメント（`documents/rules/docs/`）
- 命名規則、技術スタック、用語集
- `katana_cli.md`: CLIコマンド詳細
- フレームワーク各機能の使用方法
- プラグイン別の詳細ガイド
- フォーム関連ウィジェットの使用方法
- UIコンポーネントの使用方法
- ModelFieldValue各種の使用方法

## ⚠️ よくあるミスと対処法

### ❌ してはいけないこと
- `git add`, `git commit`の直接実行
- 手動でのDartファイル作成
- バリデーションをスキップして次の実装に進む
- 生成ファイルをコミットし忘れる
- UI変更後にゴールデンテスト更新を忘れる

### ✅ 必ずすること
- `katana code`でのテンプレート生成
- 1実装ごとのバリデーション実行


## 🔍 デバッグ・トラブルシューティング

### エラーが出た場合の対処順序
1. エラーメッセージを確認
2. 該当箇所を修正
3. `flutter analyze && dart run custom_lint`で再確認
4. それでも解決しない場合は`dart fix --apply lib`を試す



## 🚀 効率的な開発のためのTips

1. **テスト画像は必ず確認** - UIのズレを見逃さない
2. **エラーは即座に対処** - 後回しにすると複雑化する
3. **ドキュメントを参照** - 不明点は`documents/rules/`配下を確認


## 🎓 学習リソース

### 優先順位
1. このドキュメント（CLAUDE.md）
2. `documents/rules/docs/katana_cli.md` - CLIコマンド一覧
3. `documents/rules/impls/impl.md` - 実装フロー
4. 各種設計書・実装手順書

---

**重要**: このドキュメントは定期的に更新されます。開発開始前に最新版を確認してください。
""";
  }
}
