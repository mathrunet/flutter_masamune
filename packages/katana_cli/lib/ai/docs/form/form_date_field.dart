import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_date_field.mdc.
///
/// form_date_field.mdcの中身。
class KatanaFormDateFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_date_field.mdc.
  ///
  /// form_date_field.mdcの中身。
  const KatanaFormDateFieldMdcCliAiCode();

  @override
  String get name => "`FormDateField`の利用方法";

  @override
  String get description => "フォームの日付フィールドを表示し選択するための`FormDateField`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`DatePicker`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで日付の値を管理可能。カレンダー表示、日付範囲制限、カスタムフォーマットなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormDateField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormDateField(
    form: formController,
    initialValue: formController.value.date,
    onSaved: (value) => formController.value.copyWith(date: value),
);
```

## 日付範囲制限付きの利用方法

```dart
FormDateField(
    form: formController,
    initialValue: formController.value.date,
    firstDate: DateTime(2024, 1, 1),
    lastDate: DateTime(2024, 12, 31),
    onSaved: (value) => formController.value.copyWith(date: value),
);
```

## カスタムフォーマット付きの利用方法

```dart
FormDateField(
    form: formController,
    initialValue: formController.value.date,
    format: "yyyy年MM月dd日",
    onSaved: (value) => formController.value.copyWith(date: value),
);
```

## バリデーション付きの利用方法

```dart
FormDateField(
    form: formController,
    initialValue: formController.value.date,
    validator: (value) {
      if (value == null) {
        return "日付を選択してください";
      }
      if (value.isBefore(DateTime.now())) {
        return "過去の日付は選択できません";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(date: value),
);
```

## カスタムデザインの適用

```dart
FormDateField(
    form: formController,
    initialValue: formController.value.date,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      backgroundColor: Colors.grey[200],
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blue,
        todayColor: Colors.orange,
      ),
    ),
    onSaved: (value) => formController.value.copyWith(date: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。選択された日付の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期日付を設定します。
- `firstDate`: 選択可能な最初の日付。これより前の日付は選択できません。
- `lastDate`: 選択可能な最後の日付。これより後の日付は選択できません。
- `format`: 日付フォーマット。表示する日付のフォーマットを指定します。
- `validator`: バリデーション関数。選択された日付の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、日付選択が無効化されます。
- `locale`: ロケール。カレンダーの言語や表示形式を指定します。

## 注意点

- `FormController`と組み合わせて使用することで、日付の値を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 日付の範囲制限は`firstDate`と`lastDate`で設定できます。
- 日付フォーマットは`format`パラメータで指定できます。
- `locale`パラメータを使用して、多言語対応が可能です。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. ユーザーの利便性を考慮して適切な日付範囲を設定する
3. 地域に応じた日付フォーマットを使用する
4. バリデーションで不正な日付選択を防ぐ
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 予約日の選択
- 生年月日の入力
- イベント日程の設定
- 期限日の設定
- スケジュール管理
""";
  }
}
