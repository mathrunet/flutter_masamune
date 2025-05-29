// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_num_field.md.
///
/// form_num_field.mdの中身。
class KatanaFormNumModalFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_num_field.md.
  ///
  /// form_num_field.mdの中身。
  const KatanaFormNumModalFieldMdCliAiCode();

  @override
  String get name => "`FormNumModalField`の利用方法";

  @override
  String get description =>
      "モーダルで数値を選択するためのフォームフィールドである`FormNumModalField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "モーダルで数値を選択するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで数値の値を管理可能。最小値・最大値の制限、小数点以下の桁数制限、通貨表示などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormNumModalField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## 最小値・最大値制限、間隔付きの利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  onSaved: (value) => formController.value.copyWith(number: value),
  picker: FormNumModalFieldPicker(
    begin: 5,
    end: 50,
    interval: 10,
  ),
);
```

## 小数点以下の桁数制限付きの利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  onSaved: (value) => formController.value.copyWith(number: value),
  picker: FormNumModalFieldPicker(
    begin: 0.0,
    end: 0.1,
    interval: 0.01,
    fractionDigits: 2,
  ),
);
```

## 通貨表示の利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  onSaved: (value) => formController.value.copyWith(number: value),
  picker: FormNumModalFieldPicker(
    begin: 0,
    end: 10000,
    interval: 100,
    suffix: "円",
  ),
);
```

## バリデーション付きの利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  validator: (value) {
    if (value == null) {
      return "数値を入力してください";
    }
    if (value < 0) {
      return "正の数を入力してください";
    }
    if (value % 2 != 0) {
      return "偶数を入力してください";
    }
    return null;
  },
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## カスタムデザインの適用

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
  ),
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `format`: 表示フォーマット。月の表示形式を設定します。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。
- `focusNode`: フォーカスノード。フォームのフォーカスを設定します。

- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `picker`: 数値を選択するためのピッカー。数値の範囲制限を設定することができます。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `picker`で数値選択するモーダルの設定をすることができます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. `picker`で数値選択するモーダルの設定をすることができます。

## 利用シーン

- 金額の入力
- 数量の入力
- 年齢の入力
- 評価点数の入力
- 寸法・サイズの入力
""";
  }
}
