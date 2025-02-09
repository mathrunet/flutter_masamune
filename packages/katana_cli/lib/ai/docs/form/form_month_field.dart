// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_month_field.mdc.
///
/// form_month_field.mdcの中身。
class KatanaFormMonthFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_month_field.mdc.
  ///
  /// form_month_field.mdcの中身。
  const KatanaFormMonthFieldMdcCliAiCode();

  @override
  String get name => "`FormMonthField`の利用方法";

  @override
  String get description => "年月を選択するためのフォームフィールドである`FormMonthField`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "年月を選択するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。カレンダー表示、カスタムフォーマット、バリデーションなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormMonthField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormMonthField(
    form: formController,
    initialValue: formController.value.selectedMonth,
    onSaved: (value) => formController.value.copyWith(selectedMonth: value),
);
```

## カスタムフォーマットの利用方法

```dart
FormMonthField(
    form: formController,
    initialValue: formController.value.selectedMonth,
    format: "yyyy年MM月",
    locale: const Locale("ja", "JP"),
    onSaved: (value) => formController.value.copyWith(selectedMonth: value),
);
```

## 選択可能範囲の設定

```dart
FormMonthField(
    form: formController,
    initialValue: formController.value.selectedMonth,
    firstDate: DateTime(2020),
    lastDate: DateTime(2025),
    onSaved: (value) => formController.value.copyWith(selectedMonth: value),
);
```

## バリデーション付きの利用方法

```dart
FormMonthField(
    form: formController,
    initialValue: formController.value.selectedMonth,
    validator: (value) {
      if (value == null) {
        return "月を選択してください";
      }
      final now = DateTime.now();
      if (value.isBefore(DateTime(now.year, now.month))) {
        return "過去の月は選択できません";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(selectedMonth: value),
);
```

## カスタムデザインの適用

```dart
FormMonthField(
    form: formController,
    initialValue: formController.value.selectedMonth,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      dateTimeStyle: DateTimeStyle(
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
        todayColor: Colors.blue[100],
        headerTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        weekdayTextStyle: TextStyle(
          fontSize: 14.0,
          color: Colors.grey[700],
        ),
      ),
    ),
    onSaved: (value) => formController.value.copyWith(selectedMonth: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します。
- `format`: 表示フォーマット。月の表示形式を設定します。
- `locale`: ロケール。表示言語を設定します。
- `firstDate`: 選択可能な最初の日付。
- `lastDate`: 選択可能な最後の日付。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、選択が無効化されます。
- `hint`: ヒントテキスト。未選択時に表示するテキストを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、選択状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 表示フォーマットは`format`パラメータでカスタマイズできます。
- 選択可能範囲は`firstDate`と`lastDate`で制限できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. ユーザーの地域に合わせた適切なフォーマットを設定する
3. 必要に応じて適切なバリデーションを設定する
4. 適切な選択可能範囲を設定する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 月次レポートの期間選択
- 予約月の選択
- 月別データの表示
- 月次予算の設定
- 定期イベントの月選択
""";
  }
}
