// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_num_field.mdc.
///
/// form_num_field.mdcの中身。
class KatanaFormNumFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_num_field.mdc.
  ///
  /// form_num_field.mdcの中身。
  const KatanaFormNumFieldMdcCliAiCode();

  @override
  String get name => "`FormNumField`の利用方法";

  @override
  String get description => "数値入力を行うためのフォームフィールドである`FormNumField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`TextFormField`の数値入力特化版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで数値の値を管理可能。最小値・最大値の制限、小数点以下の桁数制限、通貨表示などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormNumField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormNumField(
    form: formController,
    initialValue: formController.value.number,
    onSaved: (value) => formController.value.copyWith(number: value),
);
```

## 最小値・最大値制限付きの利用方法

```dart
FormNumField(
    form: formController,
    initialValue: formController.value.number,
    min: 0,
    max: 100,
    onSaved: (value) => formController.value.copyWith(number: value),
);
```

## 小数点以下の桁数制限付きの利用方法

```dart
FormNumField(
    form: formController,
    initialValue: formController.value.number,
    decimalDigits: 2,
    onSaved: (value) => formController.value.copyWith(number: value),
);
```

## 通貨表示の利用方法

```dart
FormNumField(
    form: formController,
    initialValue: formController.value.number,
    prefix: "¥",
    thousandsSeparator: true,
    onSaved: (value) => formController.value.copyWith(number: value),
);
```

## バリデーション付きの利用方法

```dart
FormNumField(
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
FormNumField(
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
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。入力された数値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期数値を設定します。
- `min`: 最小値。入力可能な最小値を設定します。
- `max`: 最大値。入力可能な最大値を設定します。
- `decimalDigits`: 小数点以下の桁数。小数点以下の表示桁数を制限します。
- `prefix`: 接頭辞。数値の前に表示する文字列（通貨記号など）を設定します。
- `suffix`: 接尾辞。数値の後に表示する文字列（単位など）を設定します。
- `thousandsSeparator`: 3桁区切り。`true`の場合、3桁ごとにカンマを挿入します。
- `validator`: バリデーション関数。入力値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、フォームが無効化されます。

## 注意点

- `FormController`と組み合わせて使用することで、数値の値を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 最小値・最大値の制限は`min`と`max`で設定できます。
- 小数点以下の桁数は`decimalDigits`で制限できます。
- 通貨表示には`prefix`と`thousandsSeparator`を組み合わせて使用します。
- 数値以外の文字は自動的にフィルタリングされます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 入力可能な値の範囲を適切に制限する
3. 用途に応じて適切な小数点以下の桁数を設定する
4. 通貨表示の場合は3桁区切りを有効にする
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 金額の入力
- 数量の入力
- 年齢の入力
- 評価点数の入力
- 寸法・サイズの入力
""";
  }
}
