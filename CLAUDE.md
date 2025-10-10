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
