# Masamuneフレームワーク開発ガイド v2.0

## 🚨 絶対原則（P0）

### 必ず守るべき鉄則
1. **日本語応答必須** → 全てのレスポンスは日本語で記述
2. **katana code必須** → 手動でのファイル作成は絶対禁止
3. **段階的バリデーション** → 1実装ごとに`flutter analyze && dart run custom_lint`実行
4. **全生成ファイルコミット** → `.m.dart`, `.g.dart`, `.freezed.dart`, テスト画像必須
5. **例外の分類必須** → 想定内は型付き`on`、想定外は最後の型なし`catch`で分離し、想定外は`appLogger.error`で報告（再送出時を除く）

### 開発フローの絶対順序
```
実装 → バリデーション → 修正 → 次の実装
```
この順序を絶対に崩さない。エラーは即座に対処。

### 例外処理の絶対原則

- 想定内エラーは`on XxxException catch`で型ごとに処理する
- 型付きcatchを置いたtryは、最後に`catch (e, stackTrace)`を置く
- 最後の型なしcatchで処理を継続する場合は、捕捉した同じ値を`await appLogger.error(e, stackTrace)`へ渡す
- `rethrow`または`throw`で上位へ伝播する場合は、グローバルハンドラーで報告されるため`appLogger.error`は不要
- 型なしcatch内の`if (e is XxxException)`で想定内エラーを振り分けない

詳細は`ref:masamune`の例外処理規約を正本とする。

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

### 完了前の必須作業
```bash
# 1. コードフォーマット
dart fix --apply lib && dart format . && flutter pub run import_sorter:main

# 2. バリデーション（エラー0必須）
flutter analyze && dart run custom_lint

# 3. UI更新時：ゴールデンテスト更新
katana test update [更新したクラス名]

# 4. 全体テスト実行
katana test debug

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
| **AI Debugger導入** | `katana code debuggable` |
| **プラグイン適用** | `katana apply` |
| **バリデーション** | `flutter analyze && dart run custom_lint` |
| **フォーマット** | `dart fix --apply lib && dart format .` |
| **インポート整理** | `flutter pub run import_sorter:main` |
| **テスト更新** | `katana test update [class]` |
| **テスト実行** | `katana test debug` |
| **Functions deploy** | `katana deploy functions` |


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

※詳細は`~/.claude/agents/*.md`を参照

## 🔌 MCPサーバー活用ガイド（P1）

### MCPサーバー概要
Masamuneフレームワークでは、Claude CodeのMCP（Model Context Protocol）サーバーを積極的に活用して、
開発効率を大幅に向上させることを推奨します。以下のMCPサーバーを利用可能です。

### 利用可能なMCPサーバー

| サーバー | 主要機能 | 活用シーン |
|---------|---------|-----------|
| **mcp__dart** | pub検索, エラー解析, テスト実行 | パッケージ選定, デバッグ |
| **mcp__github** | Issue/PR, コード検索 | 実装例検索, PR管理 |
| **mcp__notion** | ページ操作, DB操作 | 仕様書参照, タスク管理 |
| **mcp__firebase** | プロジェクト管理, Crashlytics | セットアップ, エラー分析 |

### エージェント別MCPサーバー活用マトリックス

| エージェント | dart | github | notion | firebase | 主な用途 |
|-------------|------|--------|--------|----------|----------|
| **package_advisor** | ✓ | ✓ | - | - | pub.dev検索、類似実装検索 |
| **firebase_flutter_debugger** | ✓ | - | - | ✓ | エラー解析、ログ調査 |
| **masamune_framework_advisor** | ✓ | ✓ | ✓ | - | ドキュメント参照、実装例検索 |
| **ui_builder** | - | ✓ | ✓ | - | デザイン仕様参照、UI実装例検索 |
| **test_runner** | ✓ | - | - | - | テスト実行、エラー解析 |
| **ui_debugger** | ✓ | - | ✓ | - | ウィジェット解析、デザイン仕様確認 |

### MCPサーバー利用の注意点
- MCPツール優先使用（手動操作を避ける）
- 認証情報：GitHubは`secrets.yaml`、Firebaseは`firebase login`
- 必要最小限のAPI呼び出し、キャッシュ活用

### 📎 URL認識とMCPサーバー自動選択

URL提示時は以下の表に従ってMCPサーバーを選択：

| URL形式 | 使用MCPツール | 用途 |
|---------|--------------|-----|
| `notion.so/...` | `mcp__notion__API-retrieve-a-page` | ページ/仕様書取得 |
| `github.com/.../issues/` | `mcp__github__issue_read` | Issue内容取得 |
| `github.com/.../pull/` | `mcp__github__pull_request_read` | PR内容取得 |
| `github.com/.../blob/` | `mcp__github__get_file_contents` | ファイル取得 |
| `console.firebase.google.com/` | `mcp__firebase__*` | プロジェクト設定 |

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


## 📋 よく使う実装パターン（P1）

### 主要パターン一覧
```dart
// 認証
await appAuth.signIn(EmailAndPasswordSignInAuthProvider(
  email: "user@example.com", password: "password123"
));
await appAuth.signIn(const FirebaseGoogleSignInAuthProvider());

// Firestore CRUD
final col = ref.app.model(TestModel.collection())..load();
final doc = col.create(uuid());
await doc.save(TestModel(name: "Test"));
await doc.delete();

// ストレージ
final picker = ref.page.controller(Picker.query());
final image = await picker.pickSingle();
final uri = await image.uploadToPublic(userId);

// 通知
await Notification.send(
  title: "通知", text: "本文",
  target: ModelTokenNotificationTargetQuery(tokens: [token])
);

// 決済
final purchase = ref.app.controller(Purchase.query());
await purchase.purchase(
  product: PurchaseProduct.consumable(productId: "item_100")
);

// リアルタイム監視
final model = ref.app.model(TestModel.collection(
  adapter: ListenableFirestoreModelAdapter()
))..load();
```

## 🌐 マルチプラットフォーム対応（P2）
```dart
// レスポンシブ
UniversalColumn(breakpoint: Breakpoint.sm, children: [...]);
// プラットフォーム判定
if (PlatformInfo().isIOS) { /* iOS処理 */ }
```

### フォーム実装
```dart
final form = ref.page.form(LoginValue.form());
FormTextField(
  form: form, hintText: "メール",
  onSaved: (v) => form.value = form.value.copyWith(email: v),
  validator: (v) => v.isEmpty ? "必須" : null,
);
FormButton(
  form: form, text: "ログイン",
  onPressed: () async {
    if (form.validate() != null) {
      await appAuth.signIn(EmailAndPasswordSignInAuthProvider(
        email: form.value.email, password: form.value.password
      ));
    }
  },
);
```

## 非同期処理の待機（P2）
```dart
executeGuarded(context, () async {
  // 非同期処理
  Modal.alert(context, title: "完了", onSubmit: () => context.router.pop());
}, onError: (e, s) => Modal.alert(context, title: "エラー"));
```

## 状態管理パターン（P2）
```dart
// ref.app: アプリ全体
final user = ref.app.model(UserModel.document(userId));
// ref.page: ページ内
final form = ref.page.form(LoginValue.form());
// ref.widget: ウィジェット内
final anim = ref.widget.watch(AnimationController());
```


---

**重要**: このドキュメントは定期的に更新されます。開発開始前に最新版を確認してください。
**バージョン**: 2.0 - Firebase Functions/Node.js Masamune対応版
