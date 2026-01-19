// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_checkbox.md.
///
/// form_checkbox.mdの中身。
class KatanaFormCheckboxMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_checkbox.md.
  ///
  /// form_checkbox.mdの中身。
  const KatanaFormCheckboxMdCliAiCode();

  @override
  String get name => "`FormCheckbox`の利用方法";

  @override
  String get description => "フォームのチェックボックスを表示するための`FormCheckbox`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`Checkbox`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`Checkbox`の値を管理可能。ラベル付きチェックボックスやカスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormCheckbox`は下記のように利用する。

## 概要

$excerpt

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormCheckbox(
        initialValue: formController.value.checked,
        onSaved: (value) => formController.value.copyWith(checked: value),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormCheckbox(
  form: formController,
  initialValue: formController.value.checked,
  onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## 基本的な利用方法

```dart
FormCheckbox(
  form: formController,
  initialValue: formController.value.checked,
  onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormCheckbox(
  initialValue: true,
  onChanged: (value) {
    print(value);
  },
);
```

## ラベル付きチェックボックスの利用方法

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    labelText: "利用規約に同意する",
    onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## バリデーション付きの利用方法

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    labelText: "利用規約に同意する",
    validator: (value) {
      if (value != true) {
        return "利用規約への同意が必要です";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## カスタムデザインの適用

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    style: const FormStyle(
      padding: EdgeInsets.all(8.0),
      backgroundColor: Colors.grey[200],
      activeBackgroundColor: Colors.blue,
      activeColor: Colors.white,
    ),
    onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## 読み取り専用（readOnly）の利用方法

```dart
FormCheckbox(
  form: formController,
  initialValue: formController.value.checked,
  labelText: "利用規約に同意する",
  readOnly: true,  // 表示のみで変更不可
  onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## カスタムラベルウィジェットの利用方法

```dart
FormCheckbox(
  form: formController,
  initialValue: formController.value.checked,
  labelWidget: Row(
    children: [
      Text("利用規約に同意する "),
      TextButton(
        onPressed: () {
          // 利用規約を表示
        },
        child: Text("詳細を見る"),
      ),
    ],
  ),
  onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## プレフィックス・サフィックス付きチェックボックス

```dart
FormCheckbox(
  form: formController,
  initialValue: formController.value.checked,
  labelText: "利用規約に同意する",
  prefix: FormAffixStyle(
    icon: Icon(Icons.info),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.arrow_forward),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。チェックボックスの値が変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。チェックボックスの値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。デフォルトは`true`です。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。デフォルトは`false`です。
- `readOnly`: 読み取り専用。`true`の場合、有効化の表示になりますが値を変更できなくなります。デフォルトは`false`です。
- `focusNode`: フォーカスノード。チェックボックスのフォーカスを制御します。
- `autofocus`: 自動フォーカス。`true`の場合、画面表示時に自動的にフォーカスされます。デフォルトは`false`です。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。チェックボックスの横に表示するテキストを設定します。`labelText`と`labelWidget`を両方設定することはできません。
- `labelWidget`: ラベルウィジェット。チェックボックスの横に表示するウィジェットを設定します。`labelText`と`labelWidget`を両方設定することはできません。
- `prefix`: プレフィックス。チェックボックスの左側に表示する追加要素（`FormAffixStyle`）。`labelText`または`labelWidget`が設定されている場合のみ有効です。
- `suffix`: サフィックス。チェックボックスの右側に表示する追加要素（`FormAffixStyle`）。`labelText`または`labelWidget`が設定されている場合のみ有効です。
- `visualDensity`: チェックボックスの視覚的密度を設定します。
- `materialTapTargetSize`: チェックボックスのタップ対象サイズを設定します。

### `FormStyle`で設定可能なプロパティ
- `backgroundColor`: チェックボックスコンテナの背景色（ラベル付きの場合）
- `activeBackgroundColor`: チェックされた状態のチェックボックスの背景色
- `activeColor`: チェックマークの色
- `disabledBackgroundColor`: 無効化時のチェックボックスの背景色
- `disabledColor`: 無効化時のテキストとチェックマークの色
- `color`: テキストの色
- `subColor`: サブテキストの色
- `errorColor`: エラーテキストの色
- `borderColor`: 境界線の色
- `borderWidth`: 境界線の太さ
- `borderStyle`: 境界線のスタイル（`FormInputBorderStyle.outline`、`FormInputBorderStyle.underline`、`FormInputBorderStyle.none`）
- `borderRadius`: 境界線の角丸設定
- `border`: カスタム境界線
- `disabledBorder`: 無効化時のカスタム境界線
- `errorBorder`: エラー時のカスタム境界線
- `contentPadding`: コンテンツのパディング
- `textStyle`: テキストスタイル
- `errorTextStyle`: エラーテキストスタイル
- `textAlign`: テキストの配置
- `textAlignVertical`: テキストの垂直配置
- `shape`: チェックボックスの形状

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`もしくは`labelWidget`パラメータを使用して設定できます。
- `labelText`と`labelWidget`は同時に設定できません。どちらか一方を選択してください。
- `prefix`と`suffix`は、`labelText`または`labelWidget`が設定されている場合のみ有効です。
- `readOnly`が`true`の場合、チェックボックスは有効化の表示になりますが値を変更できません。
- `enabled`が`false`の場合、チェックボックスは無効化の表示になり値を変更できません。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 利用規約への同意必須チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. ラベルを設定する場合は、シンプルなテキストなら`labelText`、複雑なレイアウトなら`labelWidget`を使用
8. `labelText`と`labelWidget`は同時に設定しない
9. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）
10. 読み取り専用の表示が必要な場合は`readOnly`を使用し、完全に無効化する場合は`enabled`を`false`にする
11. `prefix`や`suffix`を使用して、チェックボックスに追加の情報やアイコンを表示できる

## 利用シーン

- 利用規約への同意チェック
- プライバシーポリシーへの同意チェック
- 設定画面でのオプション選択（通知ON/OFF、自動保存ON/OFFなど）
- フィルター条件の選択（複数条件のチェック）
- 複数選択可能なリストの項目選択
- タスクの完了チェック
- 商品の選択チェック
- メールマガジンの購読確認
- オプション機能の有効化/無効化
""";
  }
}
