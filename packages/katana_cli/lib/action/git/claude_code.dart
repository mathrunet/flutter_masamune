// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";
import "package:katana_cli/ai/docs/katana_ui_usage.dart";
import "package:katana_cli/ai/docs/model_field_value_usage.dart";
import "package:katana_cli/ai/docs/plugin_usage.dart";
import "package:katana_cli/ai/docs/universal_ui_usage.dart";
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
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

**Note for Claude Code Users**: This repository uses the Masamune Framework for Flutter development. The primary development instructions are written in Japanese below. Key points for Claude Code:

## Essential Commands

### Code Quality & Testing
```bash
# Run analyzer and linter (MUST pass before committing)
flutter analyze && dart run custom_lint

# Format code
dart fix --apply lib && dart format . && flutter pub run import_sorter:main

# Update golden test screenshots
katana test update [ClassName1],[ClassName2],...

# Run all tests
katana test run
```

### Code Generation
```bash
# Watch mode for automatic code generation (run in separate terminal)
katana code watch

# Manual code generation
katana code generate

# Generate specific templates
katana code page [PageName]        # Create page
katana code collection [Name]      # Create collection model
katana code document [Name]        # Create document model
katana code controller [Name]      # Create controller
katana code value [Name]          # Create form value
katana code widget [Name]         # Create widget
```

### Git Operations (Use katana commands, not git directly)
```bash
# Commit changes
katana git commit --message="message" [files...]

# Create pull request
katana git pull_request --target="master" --source="branch" --title="title" --body="description" [screenshots...]

# Add PR comment
katana git pull_request_comment --message="comment" [screenshots...]
```

### Monorepo Management (Melos)
```bash
# Bootstrap packages
melos bootstrap

# Run command across all packages
melos run analyze
melos run format
melos run fix
```

## Architecture Overview

### Monorepo Structure
This is a **monorepo** managed by [Melos](https://melos.invertase.dev/) containing 80+ Flutter packages for the Masamune Framework. All packages are in `packages/` directory.

### Core Packages
- `katana_cli`: CLI tool for code generation and project management
- `katana_model`: NoSQL database abstraction (Firestore-like structure)
- `katana_router`: Routing with deep linking support
- `katana_scoped`: State management similar to flutter_hooks
- `katana_form`: Form building and validation
- `katana_auth`: Authentication abstraction
- `katana_storage`: File storage abstraction
- `katana_theme`: Theme management with code generation
- `katana_localization`: i18n using YAML files
- `masamune`: Main package combining all features
- `masamune_universal_ui`: Responsive UI widgets

### Design Pattern
The framework uses **code generation** extensively:
- Templates created via `katana code [type] [name]`
- Additional code generated via `build_runner` (freezed, json_serializable)
- Most models, pages, controllers use generated code (`.m.dart`, `.g.dart`, `.freezed.dart` files)

### Key Architectural Concepts

1. **Page-Based Architecture**: Pages are created with `@PagePath` annotation and routing queries
2. **Model-Driven Data**: All data uses Freezed models with ModelAdapter pattern for backend switching
3. **Scoped State Management**: State managed via `ref.app` (app-wide) or `ref.page` (page-scoped)
4. **Adapter Pattern**: Database, Auth, Storage can switch backends by changing adapters (Runtime → Firestore → Local)

### Testing Requirements
- Golden tests for UI components (screenshots in `documents/test/**/*.png`)
- Must run `katana test update` after UI changes
- Must run `katana test run` before committing
- Zero errors/warnings from `flutter analyze && dart run custom_lint`

## Development Workflow

### IMPORTANT: Iterative Development with Validation
When implementing features, you MUST:
1. Implement ONE component at a time
2. After EACH component, run: `flutter analyze && dart run custom_lint`
3. If UI changed, run: `katana test update [ClassName]` and verify screenshot
4. Fix any errors before continuing to next component
5. Repeat until all components complete

### Before Committing (MANDATORY)
Execute these steps in order:
1. `dart fix --apply lib && dart format . && flutter pub run import_sorter:main`
2. `flutter analyze && dart run custom_lint` (must have zero errors)
3. `katana test update [ClassNames]` (if UI components changed)
4. `katana test run` (must pass all tests)
5. If step 2-4 have errors, go back to step 1
6. `katana git commit --message="msg" [files...]`
7. `katana git pull_request` or `katana git pull_request_comment` if background task

## Critical Rules

1. **NEVER use `git` commands directly** - Always use `katana git` commands
2. **NEVER skip the validation loop** - Run analyze/lint after EACH implementation step
3. **ALWAYS use katana CLI for file generation** - Don't manually create Pages/Models/Controllers
4. **ALWAYS commit generated files** - Include `.m.dart`, `.g.dart`, `.freezed.dart`, test images
5. **Code in Japanese documentation** - Most detailed rules are in Japanese in this file below

## File Naming Patterns
- Pages: `lib/pages/[name].dart` → `[Name]Page` class
- Models: `lib/models/[name].dart` → `[Name]Model` class
- Controllers: `lib/controllers/[name].dart` → `[Name]Controller` class
- Widgets: `lib/widgets/[name].dart` → `[Name]` class

## Common Patterns

### Loading Data
```dart
@override
Widget build(BuildContext context, PageRef ref) {
  final model = ref.app.model(TestModel.collection())..load();
  // Widget rebuilds when model loads or changes
}
```

### Using Controllers
```dart
final controller = ref.page.controller(TestController.query());
// ref.page: scoped to page lifecycle
// ref.app: scoped to app lifecycle
```

### Forms
```dart
final form = ref.page.form(LoginValue.form(LoginValue(email: "", password: "")));
// Use with FormTextField, FormButton, etc.
```

---

# 基本ルール (Japanese - Primary Documentation)

- レスポンスはすべて日本語で回答してください。
- 与えられた業務に対して`開発`か`マーケティング・企画`、`営業・広報`、`経理`のいずれかの業務に該当するかを判断し、該当する業務に対するルールを遵守してください。

## `開発`時

### `開発`時の手順

#### 新規アプリ開発時

1. `documents/rules/designs/design.md`を参考に要件定義から各種設計書を作成。
   - 要件定義が指示として与えられない場合は`requirements.md`を参照。
2. 作成した各種設計書を元に`documents/rules/impls/impls.md`を参考にしながらアプリケーションの開発を実施。
3. `documents/rules/tests/tests.md`を参考にしながら各種テストを実施。
4. `flutter analyze && dart run custom_lint`を実行してErrorやWarningがないか確認。ErrorやWarningが発生していた場合は修正を実施して再度実行。ErrorやWarningがなくなるまで繰り返す。
5. `katana test update`を実行してゴールデンテスト用のスクリーンショット画像を作成。
6. `katana test run`を実行してテストが全てパスするか確認。
7. バックグランドでの実行の場合、`katana git commit`を実行して変更をコミット。
8. バックグランドでの実行の場合、`katana git pull_request`を実行してPRを作成、既存のPRがある場合は`katana git pull_request_comment`でコメントを追加。

#### 新規機能追加時

1. 要件定義から実装を実施。
    - 実装中に`flutter analyze && dart run custom_lint`や`katana test update`を実行してエラーがないか確認しながら１つずつ実装。
2. `flutter analyze && dart run custom_lint`を実行してErrorやWarningがないか確認。ErrorやWarningが発生していた場合は修正を実施して再度実行。ErrorやWarningがなくなるまで繰り返す。
3. 画面の作成や変更を行った場合は`katana test update`を実行してゴールデンテスト用のスクリーンショット画像を更新。
4. `katana test run`を実行してテストが全てパスするか確認。
5. バックグランドでの実行の場合、`katana git commit`を実行して変更をコミット。
6. バックグランドでの実行の場合、`katana git pull_request`を実行してPRを作成、既存のPRがある場合は`katana git pull_request_comment`でコメントを追加。

#### 改修、もしくはバグ修正

1. 要件から改修を実施。
   - 実装中に`flutter analyze && dart run custom_lint`や`katana test update`を実行してエラーがないか確認しながら１つずつ実装。
2. `flutter analyze && dart run custom_lint`を実行してErrorやWarningがないか確認。ErrorやWarningが発生していた場合は修正を実施して再度実行。ErrorやWarningがなくなるまで繰り返す。
3. 画面の作成や変更を行った場合は`katana test update`を実行してゴールデンテスト用のスクリーンショット画像を更新。
4. `katana test run`を実行してテストが全てパスするか確認。
5. バックグランドでの実行の場合、`katana git commit`を実行して変更をコミット。
6. バックグランドでの実行の場合、`katana git pull_request`を実行してPRを作成。

### `開発`時全般に関わるルール

- Dart言語とFlutterフレームワークで開発を行う。
- Flutter内のフレームワークであるMasamuneフレームワークを利用。
- 詳しいルールは下記の`documents/rules/**/*.md`を参照。
    - `documents/rules/designs`: 設計書作成に関する手順
        - `metadata_design.md`: MetaData設計書の作成手順
        - `controller_design.md`: Controller設計書の作成手順
        - `model_design.md`: Model設計書の作成手順
        - `plugin_design.md`: プラグイン設計書の作成手順
        - `theme_design.md`: Theme設計書の作成手順
        - `widget_design.md`: Widget設計書の作成手順
        - `page_design.md`: Page設計書の作成手順
    - `documents/rules/impls`: 設計書を用いた新規実装に関する手順
        - `impl.md`: 全体の設計書実装フロー
        - `metadata_impl.md`: MetaData実装手順
        - `plugin_impl.md`: プラグイン実装手順
        - `theme_impl.md`: Theme実装手順
        - `model_impl.md`: Model実装手順
        - `controller_impl.md`: Controllerの一連の実装手順 
        - `controller_creation.md`: Controllerの新規作成
        - `controller_method_creation.md`: Controllerの各メソッドの作成手順
        - `controller_method_impl.md`: Controllerの各メソッドの中身の実装手順
        - `widget_impl.md`: Widget実装の一連の手順
        - `widget_creation.md`: Widget新規作成手順
        - `widget_logic_impl.md`: Widgetロジック実装手順
        - `widget_ui_impl.md`: WidgetUI実装手順
        - `page_impl.md`: Page実装の一連の手順
        - `page_creation.md`: Page新規作成手順
        - `page_logic_impl.md`: Pageロジック実装手順
        - `page_ui_impl.md`: PageUI実装手順
        - `router_impl.md`: ルーター実装手順
        - `mock_data_impl.md`: モックデータ実装手順
    - `documents/rules/tests`: テストの実装手順
        - `test.md`: 全体のテスト実装フロー
        - `page_test.md`: Pageテストの実装手順
        - `model_extension_test.md`: ModelのtoTile拡張メソッドのテスト実装手順
        - `widget_test.md`: Widgetテストの実装手順
    - `documents/rules/docs`: Masamuneフレームワークを利用する上での実装上のルール
        - `design_document.md`: 利用する設計書一覧
        - `technology_stack.md`: 技術スタック一覧
        - `terminology.md`: 用語・専門用語一覧
        - `naming_convention.md`: 命名規則
        - `file_structure.md`: ファイル・フォルダ構成
        - `katana_cli.md`: katanaコマンドの一覧と使用方法
        - `primitive_types.md`: プリミティブタイプ一覧
        - `flutter_types.md`: Flutter/Dartのタイプ一覧
        - `page_types.md`: Pageタイプの一覧
        - `model_field_value_usage.md`: ModelFieldValueの使用方法
        - `model_usage.md`: Model使用方法
        - `model_filter_conditions.md`: Modelのフィルター条件
        - `plugin_usage.md`: プラグインの使用方法
        - `form_usage.md`: フォームの使用方法
        - `universal_ui_usage.md`: UniversalUIの使用方法
        - `katana_ui_usage.md`: KatanaUIの使用方法
        - `flutter_widgets.md`: Flutterウィジェット
        - `modal_usage.md`: モーダルの使用方法
        - `theme_usage.md`: テーマの使用方法
        - `router_usage.md`: ルーターの使用方法
        - `state_management_usage.md`: 状態管理の使用方法
        - `transition_usage.md`: 画面遷移の使用方法
        - `enum_usage.md`: `Enum`の実装方法
        - `functions_usage.md`: Functions使用方法
        - `plugins/`: 各種プラグインの使用方法詳細
${kPluginList.entries.map((e) => "            - `${e.key.toSnakeCase()}.md`: ${e.value.name}").join("\n")}
        - `form/`: フォーム関連ウィジェットの詳細使用方法
${kFormList.entries.map((e) => "            - `${e.key.toSnakeCase()}.md`: ${e.value.name}").join("\n")}
        - `katana_ui/`: KatanaUIウィジェットの詳細使用方法
${kKatanaUiList.entries.map((e) => "            - `${e.key.toSnakeCase()}.md`: ${e.value.name}").join("\n")}
        - `universal_ui/`: UniversalUIウィジェットの詳細使用方法
${kUniversalUiList.entries.map((e) => "            - `${e.key.toSnakeCase()}.md`: ${e.value.name}").join("\n")}
        - `model_field_value/`: ModelFieldValue各種の詳細使用方法
${kModelFieldValueList.entries.map((e) => "            - `${e.key.toSnakeCase()}.md`: ${e.value.name}").join("\n")}
- Gitのコミットは必ず`katana git commit`コマンドを用いて行うこと
    - ファイルのステージングおよびGitのコミット
        ```bash
        katana git commit --message="コミットメッセージ" [コミット対象のファイル1] [コミット対象のファイル2] ...
        ```
- 新規PullRequestの作成は必ず`katana git pull_request`コマンドを用いて行うこと
    - PullRequestの作成
        ```bash
        katana git pull_request --target="マージ先のブランチ" --source="マージ元のブランチ" --title="PullRequestのタイトル" --body="PullRequestの説明（改行は`\n`で行う）" [PullRequestの説明に加えるスクリーンショットのファイル1] [PullRequestの説明に加えるスクリーンショットのファイル2] ...
        ```
- 既存のPullRequestへのコメントは必ず`katana git pull_request_comment`コマンドを用いて行うこと
    - PullRequestの作成
        ```bash
        katana git pull_request_comment --message="PullRequestに対するコメント（改行は`\n`で行う）" [PullRequestのコメントに加えるスクリーンショットのファイル1] [PullRequestのコメントに加えるスクリーンショットのファイル2] ...
        ```
    - その他、`katana`コマンドの使い方については`documents/rules/docs/katana_cli.md`に記載。

### 作業実施時のルール

- `Page`、`Model`、`Enum`、`Widget`、`Controller`等のDartファイルの作成は`katana`コマンドを用いて作成すること
    - `katana`コマンドの使い方については`documents/rules/docs/katana_cli.md`に記載。

- 作業実施時、下記の実施を徹底すること。
    - 1つの実装が完了したときに毎回必ず下記のコマンドを実行してコードにErrorやWarningがないかをチェック。ErrorやWarningがある場合はそれらに対処した後、再度実行。ErrorやWarningがなくなるまで繰り返す。

        ```bash
        flutter analyze && dart run custom_lint
        ```

    - 1つの`Page`や`Widget`、`Model`の`toTile`のエクステンションの更新や作成が完了したときに毎回下記のコマンドを実行して生成された画像を読み込み、確認し、コードにErrorやWarningがないか、またUIにズレがないかをチェック。ErrorやWarning、UIにズレがある場合はそれらに対処した後、再度実行。ErrorやWarning、UIにズレがなくなるまで繰り返す。画像は`documents/test/**/*.png`に出力される。

        ```bash
        katana test update [テスト対象のクラス名],[テスト対象のクラス名],...
        ```

        - 例:
            ```bash
            katana test update TestPage,TestWidget,TestModel
            ```

### 作業完了後のルール

- 作業実施後、コミット前に必ず下記を実施しコードの品質と安全性を保つ。
    1. 下記のコマンドを実施してコードのフォーマットを行う。
        ```bash
        dart fix --apply lib && dart format . && flutter pub run import_sorter:main
        ```

    2. 下記のコマンドを実施してコードのバリデーションを行う。ErrorやWarningがあれば修正して再度実行。ErrorやWarningがなくなるまで繰り返す。

        ```bash
        flutter analyze && dart run custom_lint
        ```

    3. `Page`や`Widget`、`Model`の`toTile`のエクステンションの更新が行われていた場合は、下記のコマンドを実施してゴールデンテスト用の画像を更新する。ErrorやWarningがあれば修正して再度実行。ErrorやWarningがなくなるまで繰り返す。

        - 各種UIが更新されているにも関わらずこのステップが実行されない場合は`katana test run`でエラーになります。

        ```bash
        katana test update [テスト対象のクラス名],[テスト対象のクラス名],...
        ```

        - 例:
            ```bash
            katana test update TestPage,TestWidget,TestModel
            ```

    4. 下記のコマンドを実施して全体のテストを行う。ErrorやWarningがあれば修正して再度実行。
    ErrorやWarningがなくなるまで繰り返す。
        ```bash
        katana test run
        ```

    5. 1〜4のステップでErrorやWarningが発生した場合は、再度1からステップをやり直す。ErrorやWarningが無くなるまで繰り返す。

    6. バックグランドで指示が与えられ動作している場合は、下記コマンドで変更をCommit&Push。クライアント側で動作している場合は終了。
        
        ```bash
        katana git commit --message="コミットメッセージ" [コミット対象のファイル1] [コミット対象のファイル2] ...
        ```

        - 変更したファイルおよび下記のファイルも必ず含める。基本的には.gitignoreで除外されているファイル以外で生成・変更されたファイルはすべてコミット。
            - `katana code **`で生成した、もしくは変更したファイル
            - `katana code generate`で生成した、もしくは変更されたファイル
            - `katana test update`で生成した、もしくは変更されたファイル
    
    7. バックグランドで指示が与えられ動作しておりPullRequestを新しく作成する場合は、下記のコマンドでPullRequestを作成。

        ```bash
        katana git pull_request --target="マージ先のブランチ" --source="マージ元のブランチ" --title="PullRequestのタイトル" --body="PullRequestの説明（改行は`\n`で行う）" [PullRequestの説明に加えるスクリーンショットのファイル1] [PullRequestの説明に加えるスクリーンショットのファイル2] ...
        ```

        - 6のコミットの中`katana test update`で生成した画像(`documents/test/**/*.png`)を「PullRequestの説明に加えるスクリーンショットのファイル」として指定する。

    8. PullRequestがすでに作成されており、さらにコメントを追加したい場合は下記のコマンドを用いてコメントを追加。

        ```bash
        katana git pull_request_comment --comment="PullRequestのコメント" --target="マージ先のブランチ" --source="マージ元のブランチ" [PullRequestのコメントに加えるスクリーンショットのファイル1] [PullRequestのコメントに加えるスクリーンショットのファイル2] ...
        ```

        - 6のコミットの中`katana test update`で生成した画像(`documents/test/**/*.png`)を「PullRequestのコメントに加えるスクリーンショットのファイル」として指定する。

## `マーケティング・企画`時

- ルールはまだありません。

## `営業・広報`時

- ルールはまだありません。

## `経理`時

- ルールはまだありません。

""";
  }
}
