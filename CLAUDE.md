# Masamuneフレームワーク開発ガイド

このドキュメントは、このリポジトリで効率的に開発を行うための包括的なガイドラインです。

## 🎯 最重要原則

### 1. 必ず守るべき鉄則
1. **日本語での応答** → 全てのレスポンスは日本語で記述
2. **手動でのファイル作成禁止** → 必ず`katana code`コマンドでテンプレート生成
3. **段階的な実装とバリデーション** → 1つの実装ごとに必ず`flutter analyze && dart run custom_lint`を実行


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
  `katana code debug`, `katana test debug`, `katana test update`, テストレポートテンプレート


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
   katana test debug
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
katana test debug

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
katana test debug
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
