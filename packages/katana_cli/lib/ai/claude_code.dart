// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of CLAUDE.md.
///
/// CLAUDE.mdの中身。
class GitAgentsMarkdownCliCode extends CliCode {
  /// Contents of CLAUDE.md.
  ///
  /// CLAUDE.mdの中身。
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
      "Create CLAUDE.md for AI agent functionality. AIエージェント機能用のCLAUDE.mdを作成します。";

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
${availabeBackground ? """
4. **katana git使用** → git直接コマンドは使用禁止
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
katana test debug
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
| **テスト実行** | `katana test debug` |
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
ModelLocalizedValue(LocalizedValue([
  LocalizedLocaleValue(Locale("ja", "JP"), "こんにちは"),
  LocalizedLocaleValue(Locale("en", "US"), "Hello"),
  LocalizedLocaleValue(Locale("fr", "FR"), "Bonjour"),
]))  // 多言語
ModelGeoValue(latitude: 35.6762, longitude: 139.6503)   // 位置情報
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

## 🔌 MCPサーバー活用ガイド（P1）

### MCPサーバー概要
Masamuneフレームワークでは、Claude CodeのMCP（Model Context Protocol）サーバーを積極的に活用して、
開発効率を大幅に向上させることを推奨します。以下のMCPサーバーを利用可能です。

### 利用可能なMCPサーバー

#### 1. mcp__dart - Dart/Flutter開発支援
**主な機能**:
- `pub.dev`パッケージ検索（`mcp__dart__pub_dev_search`）
- パッケージ管理（`mcp__dart__pub`）
- Dartエラー解析（`mcp__dart__get_runtime_errors`）
- ウィジェットツリー取得（`mcp__dart__get_widget_tree`）
- コード解析（`mcp__dart__analyze_files`）
- シンボル解決（`mcp__dart__resolve_workspace_symbol`）
- テスト実行（`mcp__dart__run_tests`）
- プロジェクト作成（`mcp__dart__create_project`）

**活用シーン**:
- パッケージ選定時に`package_advisor`エージェントと連携
- Dartエラーのデバッグ時に`firebase_flutter_debugger`エージェントと連携
- コード解析やリファクタリング時
- テストの実行と結果解析

#### 2. mcp__github - GitHub連携機能
**主な機能**:
- Issue/PR操作（作成、更新、コメント追加）
- コード検索（`mcp__github__search_code`）
- リポジトリ検索（`mcp__github__search_repositories`）
- ブランチ操作（作成、マージ、削除）
- ファイル操作（作成、更新、削除）
- PRレビュー機能（Copilotレビュー含む）

**活用シーン**:
- 類似実装コードの検索時
- パッケージ選定時に`package_advisor`エージェントと連携
- 自動PR作成やIssue管理
- コードレビューの自動化
- ベストプラクティスの参照

#### 3. mcp__notion - Notion連携機能
**主な機能**:
- Notionページの読み取り・作成・更新
- データベースクエリとレコード操作
- コメント管理
- ユーザー・チーム情報取得
- ページ移動・複製

**活用シーン**:
- 仕様書や設計書の参照
- 要件定義書からの実装生成
- タスク管理との連携
- ドキュメント自動生成
- プロジェクト進捗管理

#### 4. mcp__firebase - Firebase連携機能
**主な機能**:
- プロジェクト管理（作成、一覧、設定）
- アプリ管理（iOS/Android/Web）
- Firebase初期化（`firebase_init`）
- セキュリティルール管理
- Crashlytics分析（エラー解析、レポート生成）
- 環境設定管理

**活用シーン**:
- Firebaseプロジェクトのセットアップ
- Firebase Functionsのデバッグ時に`firebase_flutter_debugger`エージェントと連携
- Crashlyticsエラー分析とデバッグ
- セキュリティルールの検証と更新
- プロジェクト構成の確認

### エージェント別MCPサーバー活用マトリックス

| エージェント | dart | github | notion | firebase | 主な用途 |
|-------------|------|--------|--------|----------|----------|
| **package_advisor** | ✓ | ✓ | - | - | pub.dev検索、類似実装検索 |
| **firebase_flutter_debugger** | ✓ | - | - | ✓ | エラー解析、ログ調査 |
| **masamune_framework_advisor** | ✓ | ✓ | ✓ | - | ドキュメント参照、実装例検索 |
| **ui_builder** | - | ✓ | ✓ | - | デザイン仕様参照、UI実装例検索 |
| **test_runner** | ✓ | - | - | - | テスト実行、エラー解析 |
| **ui_debugger** | ✓ | - | ✓ | - | ウィジェット解析、デザイン仕様確認 |

### MCPサーバー活用の推奨フロー

1. **プロジェクト開始時**:
   - `mcp__firebase`でFirebaseプロジェクトを作成・初期化
   - `mcp__github`でリポジトリ構成を確認
   - `mcp__notion`で要件定義書を参照

2. **実装時**:
   - `mcp__dart`でパッケージ検索と依存関係管理
   - `mcp__github`で類似実装を検索
   - `mcp__notion`で仕様書を確認しながら実装

3. **デバッグ時**:
   - `mcp__dart`でエラー解析とウィジェットツリー確認
   - `mcp__firebase`でCrashlyticsレポート分析
   - `mcp__github`で既知の問題を検索

4. **テスト・デプロイ時**:
   - `mcp__dart`でテスト実行
   - `mcp__github`でPR作成とレビュー
   - `mcp__firebase`でデプロイ設定確認

### 注意事項

1. **MCPサーバーの優先使用**:
   - 可能な限りMCPサーバーのツールを使用し、手動操作を避ける
   - エージェントはMCPサーバーを積極的に活用して効率化を図る

2. **認証情報の管理**:
   - GitHubトークンは`secrets.yaml`に記載
   - Firebase認証は`firebase login`コマンドで実施
   - Notion APIキーは環境変数で管理

3. **パフォーマンス考慮**:
   - 必要なMCPサーバーのみを使用
   - 大量のAPI呼び出しは避ける
   - キャッシュを有効活用

### 📎 URL認識とMCPサーバー自動選択ガイド

開発中にURL（Notion、GitHub、Firebase等）が提示された場合、以下のフローでMCPサーバーを活用して情報を取得します。

#### 1. URL形式による自動判別

| URL形式 | 対象サービス | 使用MCPサーバー | 主な取得情報 |
|---------|-------------|----------------|-------------|
| `https://www.notion.so/...` | Notion | `mcp__notion` | ページ内容、データベース、仕様書 |
| `https://github.com/[org]/[repo]...` | GitHub | `mcp__github` | リポジトリ情報、Issue、PR、コード |
| `https://console.firebase.google.com/...` | Firebase | `mcp__firebase` | プロジェクト設定、Crashlytics |
| `https://firebase.google.com/...` | Firebase Docs | WebFetch | 公式ドキュメント |

#### 2. URL別の処理フロー

##### Notion URL（`https://www.notion.so/...`）の場合

**目的**: 仕様書、設計書、要件定義書の内容を取得して実装に反映

**処理手順**:
1. URLからページIDまたはデータベースIDを抽出
2. `mcp__notion__API-retrieve-a-page`でページ内容を取得
3. データベースの場合は`mcp__notion__API-query-data-source`でレコード一覧を取得
4. 取得した情報を実装仕様として解釈
5. 必要に応じて`katana code`コマンドでテンプレート生成

**活用例**:
```
ユーザー: 「このNotion仕様書を元に実装してください https://www.notion.so/xxx...」

処理フロー:
1. mcp__notion__API-retrieve-a-page でページ内容取得
2. 仕様内容を分析（画面構成、データモデル、機能要件）
3. katana code page [PageName] でページテンプレート生成
4. katana code collection [ModelName] でモデル生成
5. 仕様に沿った実装
```

##### GitHub URL（`https://github.com/...`）の場合

**目的**: リポジトリの実装例、Issue、PRの内容を参照

**処理手順**:
1. URLの種類を判別（リポジトリ/Issue/PR/ファイル/コード検索）
2. 適切なMCPツールを選択：
   - リポジトリ: `mcp__github__search_repositories`
   - Issue: `mcp__github__issue_read`
   - PR: `mcp__github__pull_request_read`
   - ファイル: `mcp__github__get_file_contents`
   - コード検索: `mcp__github__search_code`
3. 取得した情報を実装の参考にする

**活用例**:
```
ユーザー: 「このリポジトリの実装を参考にして https://github.com/mathrunet/flutter_masamune」

処理フロー:
1. mcp__github__get_file_contents で対象ファイル取得
2. mcp__github__search_code で類似実装検索
3. ベストプラクティスを抽出
4. Masamuneフレームワークの規約に沿って実装
```

##### Firebase URL（`https://console.firebase.google.com/...`）の場合

**目的**: Firebaseプロジェクトの設定確認、Crashlyticsエラー分析

**処理手順**:
1. URLからプロジェクトID、画面種別を抽出
2. 画面種別に応じた処理：
   - プロジェクト設定: `mcp__firebase-mcp-server__firebase_get_project`
   - Crashlytics: `mcp__firebase-mcp-server__crashlytics_get_issue`
   - セキュリティルール: `mcp__firebase-mcp-server__firebase_get_security_rules`
3. 取得した情報を元にデバッグや設定変更を提案

**活用例**:
```
ユーザー: 「このCrashlyticsエラーを解決して https://console.firebase.google.com/project/xxx/crashlytics」

処理フロー:
1. mcp__firebase-mcp-server__crashlytics_get_issue でエラーレポート取得
2. スタックトレースを分析
3. 該当コード箇所を特定
4. 修正案を提案
5. flutter analyze && dart run custom_lint で検証
```

#### 3. 複数URL提示時の処理

複数のURLが同時に提示された場合、以下の優先順位で処理：

1. **Notion URL（仕様書）** - 実装の大本となる情報
2. **GitHub URL（実装例）** - 実装パターンの参考
3. **Firebase URL（環境設定）** - インフラ・デバッグ情報

**処理例**:
```
ユーザー:
「Notion仕様書: https://www.notion.so/xxx
 参考実装: https://github.com/yyy
 で機能を実装してください」

処理フロー:
1. mcp__notion__API-retrieve-a-page で仕様書内容取得
2. mcp__github__search_code で参考実装検索
3. 仕様と参考を統合した実装計画を作成
4. katana codeコマンドで順次実装
```

#### 4. MCPサーバーツール選択の判断基準

URL提示時に使用するMCPツールの選択基準：

| 状況 | 選択すべきツール | 理由 |
|------|----------------|------|
| Notionページ全体が必要 | `mcp__notion__API-retrieve-a-page` | ページ全体のコンテンツ取得 |
| Notionデータベース検索 | `mcp__notion__API-query-data-source` | フィルタ・ソート可能 |
| GitHub特定ファイル | `mcp__github__get_file_contents` | 直接ファイル内容取得 |
| GitHub実装パターン検索 | `mcp__github__search_code` | コードベース全体から検索 |
| FirebaseプロジェクトID不明 | `mcp__firebase-mcp-server__firebase_list_projects` | プロジェクト一覧から特定 |
| Crashlyticsエラー分析 | `mcp__firebase-mcp-server__crashlytics_get_issue` | エラー詳細分析 |

#### 5. エラーハンドリング

URL処理時のエラー対処：

**Notion URLエラー**:
- ページが見つからない → ページIDの再確認、アクセス権限確認
- データベースが空 → データベース構造のみ参照して実装

**GitHub URLエラー**:
- リポジトリがプライベート → 公開リポジトリでの代替検索
- ファイルが存在しない → ブランチ・パス確認

**Firebase URLエラー**:
- プロジェクトアクセス不可 → `firebase login`で再認証
- Crashlyticsデータなし → 手動でのログ確認を提案

#### 6. URL活用のベストプラクティス

1. **URL提示時の追加情報**:
   - Notion: 「仕様書の○○セクションを参照」等の具体的な指示
   - GitHub: 「この実装パターンを参考に」等の活用方法
   - Firebase: 「このエラーを解決」等の目的明記

2. **MCPサーバーの効率的な使用**:
   - 必要最小限の情報取得（ページ全体ではなく必要部分のみ）
   - キャッシュ活用（同じURLへの複数回アクセスを避ける）

3. **セキュリティ考慮**:
   - プライベート情報を含むURLの取り扱いに注意
   - 認証トークンは環境変数・secrets.yamlで管理

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
| **ModelDate** | 日付 | `DateTime.now()` |
| **ModelTime** | 時間 | `DateTime.now()` |
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
| **Form validation** | バリデーター未設定 | validatorフィールドを適用 |

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
${availabeBackground ? """
4. **小さな単位でコミット** - 機能ごとに細かくコミットする
5. **PR作成時にスクリーンショット添付** - レビューを効率化""" : """4. **katana applyで環境構築自動化** - 手動設定を避ける"""}

## 📋 よく使う実装パターン（P1）

### 認証フロー実装
```dart
// ソーシャルログイン
await appAuth.signIn(const FirebaseGoogleSignInAuthProvider());
await appAuth.signIn(const AppleSignInAuthProvider());

// メール/パスワード認証
await appAuth.signIn(EmailAndPasswordSignInAuthProvider(
  email: "user@example.com",
  password: "password123",
));

// サインアウト
await appAuth.signOut();

// ユーザー情報取得
final user = appAuth.userId;  // ユーザーID
final isSignedIn = appAuth.isSignedIn;  // サインイン状態
```

### Firestoreデータ操作
```dart
// Create
final collection = ref.app.model(TestModel.collection());
final id = uuid();
final document = collection.create(id);
final newModel = TestModel(
  name: "Test",
  createdAt: ModelTimestamp(DateTime.now()),
);
await document.save(newModel);

// Read (Collection)
final collection = ref.app.model(TestModel.collection().limitTo(100))..load();
for (final document in collection) {
  print(document.value?.name ?? "");
}

// Update
final copiedModel = docment.value?.copyWith(
  name: "Updated Name",
) ?? TestModel(
  name: "Updated Name",
  createdAt: ModelTimestamp(DateTime.now()),
);
await docment.save(copiedModel);

// Delete
await docment.delete();

// Query with Filter
final query = TestModel.collection().status.equal(StatusEnum.active).limitTo(100);
final filtered = ref.app.model(query)..load();
```

### ストレージ操作
```dart
// 画像アップロード
final userId = appAuth.userId;
final user = ref.app.model(UserModel.document(userId));
await user.load();
final picker = ref.page.controller(Picker.query());
final pickedImage = await picker.pickSingle();
if(pickedImage.uri != null) {
  final uploadedUri = await pickedImage.uploadToPublic(
    userId,
    limitSize: profileImageSizeLimit,
  );
  await user.save(user.value?.copyWith(
    profileImage:  ModelImageUri(uploadedUri),
  ));
}

// ファイルダウンロード
final storageQuery = StorageQuery(relativeRemotePath);
final storage = Storage(storageQuery);
final localFile = await storage.download(relativeLocalPath);
```

### 通知実装
```dart
// プッシュ通知送信
final pushNotification = appRef.controller(RemoteNotification.query());
pushNotification.
await Notification.send(
  title: "新着メッセージ",
  text: "メッセージが届きました",
  target: ModelTokenNotificationTargetQuery(
    tokens: [userToken]
  ),
  link: Uri(path: "/messages/\$messageId"),
  sound: NotificationSound.defaultSound,
);

// アプリ内通知表示
Modal.confirm(
  title: "確認",
  text: "削除してもよろしいですか？",
  submitText: "削除",
  cancelText: "キャンセル",
  onSubmit: () async {
    await model.delete();
  },
  onCancel: () {
    context.router.pop();
  }
);
Modal.confirm(
  title: "完了",
  text: "削除が完了しました。",
  submitText: "戻る",
  onSubmit: () {
    context.router.pop();
  },
);
```

### 決済フロー（アプリ内課金）
```dart
final purchase = ref.app.controller(Purchase.query());
// ページ読み込み時に初期化
ref.page.on(
  initOrUpdate: () {
    purchase.initialize();
  },
);
// 単発購入
final comsumableProduct = PurchaseProduct.consumable(
  productId: "coin_pack_100",              // App Store/Play Consoleと一致させる
  title: LocalizedValue("100コイン"),
  amount: 100,
);
// サブスクリプション
final subscriptionProduct = PurchaseProduct.subscription(
  productId: "premium_monthly",
  title: LocalizedValue("プレミアム月額プラン"),
  description: LocalizedValue("すべての機能を利用可能"),
  period: PurchaseSubscriptionPeriod.month,
);
try {
  await purchase.purchase(
    product: comsumableProduct // もしくはsubscriptionProduct,
    onDone: () {
      print("購入完了！");
      // 成功ダイアログを表示
    },
  );
} catch (e) {
  print("購入失敗: \$e");
  // エラーダイアログを表示
}

// 購入履歴確認
final purchase = ref.app.controller(Purchase.query());
final product = purchase.products.firstWhereOrNull(
  (e) => e.productId == "premium_monthly",
);
final hasActiveSubscription = product?.value?.active ?? false;
```

### リアルタイム同期
```dart
// リアルタイム監視用のFirestoreModelAdapter
final modelAdapter = ListenableFirestoreModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform
);
// リアルタイム監視
final model = ref.app.model(
  TestModel.collection(
    adapter: listenableModelAdapter, // リアルタイム監視ON※refが発行されているページは自動的に監視対象に加えられ変更があれば画面が更新される。
  ),
)..load();
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
final platformInfo = PlatformInfo();
if (platformInfo.isIOS) {
  // iOS専用処理
} else if (platformInfo.isAndroid) {
  // Android専用処理
} else if (platformInfo.isWeb) {
  // Web専用処理
}

// 画面サイズ取得
final size = context.mediaQuery.size;
final isSmall = size.width < 600;
```

### フォーム実装
```dart
// フォーム定義（`katana code value login`で作成）
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
  validator: (value) { // ValidationはflutterのTextFormFieldなどと同じ。nullを返せば正常でエラーの場合はエラー文を返す。
    if(value.isEmpty){
      return "メールアドレスが入力されていません。";
    }
    return null;
  },
);

FormButton(
  form: form,
  text: "ログイン",
  onPressed: () async {
    final value = form.validate(); // Validationに成功すれば値が返却される。
    if (value == null){ // nullの場合はvalidationに失敗。
       return;
    }
    await appAuth.signIn(EmailAndPasswordSignInAuthProvider(
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
final userProfile = ref.app.model(UserModel.document(Auth.userId));
final pickerController = ref.app.controller(Picker.query()); // MasamuneパッケージプラグインのコントローラーはcontrollerにControllerQueryを渡す。

// ページ内でのみ有効（ref.page）
final pageController = ref.page.watch(PageController()); // ChangeNotifierを継承したFlutterフレームワーク内のコントローラーはwatchを利用。
final pushNotificationController = ref.page.controller(PushNotificationController.query()); // `katana code controller xxx`で作成したMasamuneフレームワークのコントローラーはcontrollerにControllerQueryを渡す。
final tempForm = ref.page.form(TempValue.form()); // フォームはformを利用。

// ウィジェット内での管理（ref.widget）
final animationController = ref.widget.watch(
  AnimationController(duration: Duration(seconds: 1)),
);
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
  .createdAt.orderByDesc()
  .limitTo(20);
final models = ref.app.model(query)..load();

// 次ページ読み込み
if (models.canNext) {
  await models.next();
}
```

## 🎓 学習リソース

### 優先順位
1. このドキュメント（CLAUDE.md）
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
