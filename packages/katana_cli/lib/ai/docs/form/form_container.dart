// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_container.md.
///
/// form_container.mdの中身。
class KatanaFormContainerMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_container.md.
  ///
  /// form_container.mdの中身。
  const KatanaFormContainerMdCliAiCode();

  @override
  String get name => "`FormContainer`の利用方法";

  @override
  String get description =>
      "`FormStyle`の適用やバリデーションを行うためのコンテナウィジェットである`FormContainer`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`FormStyle`を適用するためのコンテナウィジェット。パディング、背景色、ボーダー、影などのスタイルを統一的に管理できます。また、任意の値のバリデーションを行うことができます。";

  @override
  String body(String baseName, String className) {
    return """
`FormContainer`は下記のように利用する。

## 概要

$excerpt

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormContainer`は他のフォームウィジェットを囲んで使用します。`validator`を使用する場合は、`FormController`を渡す必要があります。

```dart
final formController = FormController();

// FormControllerと組み合わせてバリデーションを行う
FormContainer(
  form: formController,
  validator: () {
    if (formController.value.someCondition) {
      return "エラーメッセージ";
    }
    return null;
  },
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
  ),
  child: Column(
    children: [
      FormTextField(...),
      FormPasswordBuilder(...),
    ],
  ),
);
```

## 基本的な利用方法

```dart
FormContainer(
  style: const FormStyle(
    padding: EdgeInsets.all(24.0),
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    elevation: 4.0,
    border: Border.all(
      color: Colors.grey[300],
      width: 1.0,
    ),
  ),
  child: Column(
    children: [
      FormTextField(...),
      FormPasswordBuilder(...),
      FormRatingBar(...),
    ],
  ),
);
```

## バリデーションの利用方法

```dart
FormContainer(
  form: formController,
  validator: () {
    // 他のフィールドの値を参照してバリデーション
    if (formController.value.password != formController.value.confirmPassword) {
      return "パスワードが一致しません";
    }
    return null;
  },
  style: const FormStyle(
    padding: EdgeInsets.all(24.0),
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  child: Column(
    children: [
      FormTextField(
        labelText: "パスワード",
        form: formController,
        initialValue: formController.value.password,
        onSaved: (value) => formController.value.copyWith(password: value),
      ),
      FormTextField(
        labelText: "パスワード（確認）",
        form: formController,
        initialValue: formController.value.confirmPassword,
        onSaved: (value) => formController.value.copyWith(confirmPassword: value),
      ),
    ],
  ),
);
```

## 無効化状態の利用方法

```dart
FormContainer(
  enabled: false,  // 子ウィジェットすべてが無効化される
  style: const FormStyle(
    padding: EdgeInsets.all(24.0),
    backgroundColor: Colors.grey[200],
  ),
  child: Column(
    children: [
      FormTextField(...),
      FormPasswordBuilder(...),
    ],
  ),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormContainer(
  prefix: FormAffixStyle(
    icon: Icon(Icons.info),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.arrow_forward),
    iconColor: Colors.grey,
  ),
  labelText: "ユーザー情報",
  hintText: "必要事項を入力してください",
  style: const FormStyle(
    padding: EdgeInsets.all(24.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  child: Column(
    children: [
      FormTextField(...),
      FormTextField(...),
    ],
  ),
);
```

## カスタムサイズとアライメントの利用方法

```dart
FormContainer(
  width: 400,
  height: 300,
  alignment: Alignment.topLeft,
  style: const FormStyle(
    padding: EdgeInsets.all(24.0),
    backgroundColor: Colors.white,
  ),
  child: Column(
    children: [
      FormTextField(...),
      FormTextField(...),
    ],
  ),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。`validator`を使用する場合は必須です。
- `validator`: バリデーション関数。他のフィールドの値を参照してバリデーションを行います。定義する場合は`form`パラメータも定義する必要があります。
- `enabled`: 有効/無効。`false`の場合、子ウィジェットが無効化されます。デフォルトは`true`です。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインを定義します。
- `child`: 子ウィジェット。スタイルを適用する対象のウィジェットを指定します。
- `prefix`: プレフィックス。コンテナの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。コンテナの右側に表示する追加要素（`FormAffixStyle`）。
- `labelText`: ラベルテキスト。コンテナのラベルを設定します。
- `hintText`: ヒントテキスト。コンテナのヒントを設定します。
- `errorText`: エラーテキスト。明示的にエラーメッセージを表示します。
- `counterText`: カウンターテキスト。文字数カウンターなどのテキストを表示します。
- `width`: コンテナの幅。
- `height`: コンテナの高さ。
- `padding`: 外側の余白。コンテナの外側のパディングを設定します。
- `contentPadding`: 内側の余白。コンテナの内側のパディングを設定します。
- `alignment`: 子要素の配置。コンテナ内での子要素の位置を設定します。

### `FormStyle`で設定可能なプロパティ
- `backgroundColor`: コンテナの背景色
- `color`: テキストの色
- `subColor`: サブテキストの色
- `errorColor`: エラーテキストの色
- `disabledColor`: 無効化時のテキストの色
- `borderColor`: 境界線の色
- `borderWidth`: 境界線の太さ
- `borderStyle`: 境界線のスタイル（`FormInputBorderStyle.outline`、`FormInputBorderStyle.underline`、`FormInputBorderStyle.none`）
- `borderRadius`: 境界線の角丸設定
- `border`: カスタム境界線
- `disabledBorder`: 無効化時のカスタム境界線
- `errorBorder`: エラー時のカスタム境界線
- `padding`: コンテナの外側のパディング
- `contentPadding`: コンテナの内側のパディング
- `width`: コンテナの幅
- `height`: コンテナの高さ
- `textStyle`: テキストスタイル
- `errorTextStyle`: エラーテキストスタイル
- `textAlign`: テキストの配置
- `textAlignVertical`: テキストの垂直配置
- `prefix`: プレフィックススタイル
- `suffix`: サフィックススタイル

## 注意点

- 子ウィジェットで個別に`FormStyle`を指定すると、そのスタイルが優先されます。
- `enabled`パラメータは子ウィジェットすべてに影響します。
- バリデーションは`validator`パラメータを使用して定義します。その場合は`form`パラメータも定義する必要があります。
- `form`と`validator`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `validator`は他のフィールドのバリデーション後に実行されるため、他のフィールドの値を参照できます。
- `FormContainer`内の`FormStyleScope`により、子ウィジェットに`FormStyle`が適用されます。
- `width`、`height`、`padding`、`contentPadding`、`alignment`は個別に指定することも、`style`内で指定することも可能です。個別指定が優先されます。
- `errorText`を明示的に設定すると、`validator`の結果に関わらずそのエラーテキストが表示されます。

## ベストプラクティス

1. アプリ全体で統一したデザインを適用するために`FormContainer`を使用する
2. 関連するフォームフィールドをグループ化してセマンティックな構造を作る
3. 階層構造を活用して効率的にスタイルを管理する
4. 複数フィールドにまたがるバリデーション（例：パスワード確認）は`FormContainer`の`validator`を使用する
5. `enabled`を使用してフォーム全体の有効/無効を一括制御する
6. `FormStyle`を再利用可能な定数として定義し、複数の`FormContainer`で共有する
7. `prefix`や`suffix`を使用してセクションにアイコンや説明を追加する
8. `labelText`を使用してセクションのタイトルを明確にする

## 利用シーン

- フォームのグループ化（ユーザー情報セクション、住所セクションなど）
- セクション別のスタイル適用
- 共通デザインの一括適用
- フォームのレイアウト管理
- デザインテーマの実装
- 複数フィールドにまたがるバリデーション（パスワード確認、日付範囲チェックなど）
- フォーム全体の有効/無効の切り替え
- カード形式のフォームレイアウト
- セクションごとの視覚的な分離
""";
  }
}
