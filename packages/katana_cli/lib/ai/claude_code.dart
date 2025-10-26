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
# Masamuneフレームワーク開発ガイド

このドキュメントは、このリポジトリで効率的に開発を行うための包括的なガイドラインです。

## 🎯 最重要原則

### 1. 必ず守るべき鉄則
1. **日本語での応答** → 全てのレスポンスは日本語で記述
2. **手動でのファイル作成禁止** → 必ず`katana code`コマンドでテンプレート生成
3. **段階的な実装とバリデーション** → 1つの実装ごとに必ず`flutter analyze && dart run custom_lint`を実行
${availabeBackground ? """
4. **Gitコマンドは使用禁止** → 必ず`katana git`コマンドを使用" : ""}
5. **生成ファイルは全てコミット** → `.m.dart`, `.g.dart`, `.freezed.dart`, テスト画像を必ず含める
""" : ""}

### 2. 開発フローの絶対的な順序
```
実装 → バリデーション → 修正 → 次の実装
```
この順序を絶対に崩してはいけません。

## 🤖 ドキュメントおよびツールの活用

開発の各フェーズで専門的なサポートを提供するドキュメントやツールが利用可能です。

### 1. Masamuneフレームワーク相談

Masamuneフレームワークに関する詳細なドキュメントを提供します。

- **目的・利用シーン**  
  - フレームワーク機能の使用方法（Model、Page、Controller、Widget、Form等）
  - 実装パターンやベストプラクティス
  - プラグインの使用方法（camera、location、OpenAI、Stripe等）
  - UIコンポーネント（UniversalUI、KatanaUI、フォームウィジェット）
  - ModelFieldValueタイプとその使用方法
  - フレームワーク固有の概念や用語

- **事前に揃える情報**  
  - 問題となっているコード断片や設計案。  
  - 遵守すべきルール・スタイルガイド。

- **AIに求める手順**  
  1. 現状の課題とMasamune規約の突合。  
  2. 該当するルール・ドキュメントの紹介。  
  3. 推奨アプローチや改善案の提示。  
  4. 注意点や追加で確認すべき項目を整理。

- **成果物とチェック**  
  - 具体的なドキュメント参照先が示されているか。  
  - 改善案がMasamuneパターンに合致するか。  
  - 検討すべき追加事項が挙げられているか。

- **参考リソース・コマンド**  
  `documents/rules/docs/**`, 既存実装サンプル, Masamune公式リファレンス

### 2. パッケージ選定

有用やパッケージがあるかどうか調査・評価し、導入手順を提示します。

- **目的・利用シーン**  
  機能実装を効率化するためのMasamuneプラグインや外部Dartパッケージを検討するとき。

- **事前に揃える情報**  
  - 実装したい機能と制約。  
  - プラットフォーム要件（モバイル/ウェブ等）。  
  - セキュリティやメンテナンス要件。

- **AIに求める手順**  
  1. Masamuneプラグインの有無を確認。  
  2. `pub.dev` 等で更新頻度やポイントを比較。  
  3. 導入コストと必要設定を整理。  
  4. 実装サンプルと注意事項を提示。  
  5. 候補が無い場合はMasamune標準実装案を提案。

- **成果物とチェック**  
  - 評価基準（更新頻度・likes等）が明記されているか。  
  - 導入手順が3ステップ程度で理解できるか。  
  - サンプルコードが目的に即しているか。

- **参考リソース・コマンド**  
  `mcp__dart__pub_dev_search`, `mcp__dart__pub`, `documents/rules/docs/plugins/**`, `pubspec.yaml`

### 3. テスト実行・分析

コードに対して適切なテスト実行手順と失敗時の解析方法を提供します。

- **目的・利用シーン**  
  テストの種類ごとに適切な実行手順・エラー解析を行いたいとき。

- **事前に揃える情報**  
  - 対象テストの目的（例: ゴールデン更新、回帰確認）。  
  - テスト対象のパスやタグ。  
  - 必要な環境設定の有無。

- **AIに求める手順**  
  1. テスト種別を判定（UI確認・ゴールデン更新・全体テスト等）。  
  2. 事前準備（差分確認、画像生成先など）の指示。  
  3. 実行コマンドとログ確認ポイントを提示。  
  4. 失敗時の原因分類と再試行条件を整理。  
  5. 成果物（例: ゴールデン画像）の扱い方を示す。

- **成果物とチェック**  
  - コマンドが状況に合っているか。  
  - 失敗時のフローが明確か。  
  - 生成物チェックリストが含まれるか。

- **参考リソース・コマンド**  
  `katana code debug`, `katana test run`, `katana test update`, テストレポートテンプレート


## 3. UI実装支援

画像・Figma・テキスト指示をもとにFlutter/MasamuneでのUI実装手順を提供します。

- **目的・利用シーン**  
  画像・Figma・テキスト指示をもとにUIをFlutter/Masamuneで実装したいとき。

- **事前に揃える情報**  
  - デザイン資産（画像URL、Figmaリンク、テキスト仕様）。  
  - 対象ページやウィジェットの位置。  
  - デザインの制約（テーマ、ブレークポイント等）。

- **AIに求める手順**  
  1. デザイン資産から構成要素・レイアウトを抽出。  
  2. 既存UIとの差分があれば整理。  
  3. `katana code` など生成手順と実装指針を提示。  
  4. スタイルや状態管理での注意点を明記。  
  5. テスト・デバッグ画像の確認方法を示す。

- **成果物とチェック**  
  - レイアウト構造が明文化されているか。  
  - コード例がMasamuneの慣習に沿っているか。  
  - 確認手順（デバッグ/テスト）が含まれるか。

- **参考リソース・コマンド**  
  デザインツール連携、`katana code page`, `katana code widget`, `documents/rules/docs/ui/**`

## 4. UIデバッグ

UI実装済みの画面とデザイン指示の差分を検出し、修正手順を提供します。

- **目的・利用シーン**  
  実装済みUIとデザインの差異を検出し、修正点を明確にしたいとき。

- **事前に揃える情報**  
  - 目標UI資料（画像・Figma・テキスト）。  
  - 実装を確認できるスクリーンショットやWidgetツリー。  
  - 再現手順。

- **AIに求める手順**  
  1. 目標UIと現状を比較する観点を列挙。  
  2. Widgetツリーやスタイル属性の差異を分析。  
  3. 問題がない場合は合格声明、ある場合は詳細なフィードバックを提示。  
  4. 修正手順（コード変更・検証方法）を提案。  
  5. 追加で取るべきスクリーンショットやテストを案内。

- **成果物とチェック**  
  - 問題点がカテゴリ別に整理されているか。  
  - 修正提案が具体的なコード・プロパティに触れているか。  
  - 検証フローが示されているか。

- **参考リソース・コマンド**  
  Flutter Inspector, `katana code debug`, デバッグ画像出力手順

## 5. Firebase連携デバッグ

FirebaseとFlutter間の不具合を切り分け、解決策を見つけます。

- **目的・利用シーン**  
  Firebase（Auth/Firestore/Functions等）とFlutter間の不具合を切り分け、解決策を見つけたいとき。

- **事前に揃える情報**  
  - 発生しているエラー内容・ログ。  
  - 該当するFlutterコードとFirebase設定。  
  - 既に試した対処。

- **AIに求める手順**  
  1. 初期情報をもとに原因候補を整理。  
  2. フロント（Dart）側のエラー解析と修正案を提示。  
  3. Firebase Functionsログ・設定の確認ポイントを示す。  
  4. Firestoreデータ構造・権限の検証手順をまとめる。  
  5. 修正後に実施すべき検証と報告内容を提案。

- **成果物とチェック**  
  - 原因候補が網羅的か（DartとFirebase双方）。  
  - 修正案に具体的なステップがあるか。  
  - 再発防止策や検証手順が記載されているか。

- **参考リソース・コマンド**  
  Firebaseコンソール, `firebase functions:log`, Firestoreデータビューア, `documents/rules/docs/firebase/**`


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

### 3️⃣ ${availabeBackground ? "コミット前の必須作業" : "完了前の必須作業"}

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

${availabeBackground ? """
# 6. コミット（バックグラウンド実行時のみ）
katana git commit --message="コミットメッセージ" [ファイル...]

# 7. PR作成または更新（バックグラウンド実行時のみ）
katana git pull_request --target="master" --source="branch" --title="タイトル" --body="説明"
# または既存PRへのコメント
katana git pull_request_comment --message="コメント" [スクリーンショット...]
```
""" : ""}

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
${availabeBackground ? """
- `katana git`コマンドの使用
- 全ての生成ファイルをコミットに含める
- PR作成時にスクリーンショットを添付
""" : ""}

## 🔍 デバッグ・トラブルシューティング

### エラーが出た場合の対処順序
1. エラーメッセージを確認
2. 該当箇所を修正
3. `flutter analyze && dart run custom_lint`で再確認
4. それでも解決しない場合は`dart fix --apply lib`を試す

${availabeBackground ? """
## 📝 コミットメッセージ規則

### 形式
```
[種別]: 簡潔な説明

詳細な説明（必要に応じて）
```

### 種別の例
- `feat`: 新機能追加
- `fix`: バグ修正
- `refactor`: リファクタリング
- `docs`: ドキュメント更新
- `test`: テスト追加・修正
- `chore`: その他の変更
""" : ""}

## 🚀 効率的な開発のためのTips

1. **テスト画像は必ず確認** - UIのズレを見逃さない
2. **エラーは即座に対処** - 後回しにすると複雑化する
3. **ドキュメントを参照** - 不明点は`documents/rules/`配下を確認
${availabeBackground ? """
4. **小さな単位でコミット** - 機能ごとに細かくコミットする
""" : ""}

## 🎓 学習リソース

### 優先順位
1. このドキュメント（AGENTS.md）
2. `documents/rules/docs/katana_cli.md` - CLIコマンド一覧
3. `documents/rules/impls/impl.md` - 実装フロー
4. 各種設計書・実装手順書

---

**重要**: このドキュメントは定期的に更新されます。開発開始前に最新版を確認してください。
""";
  }
}
