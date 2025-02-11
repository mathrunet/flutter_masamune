// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_date_time_field.mdc.
///
/// form_date_time_field.mdcの中身。
class KatanaFormDateTimeFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_date_time_field.mdc.
  ///
  /// form_date_time_field.mdcの中身。
  const KatanaFormDateTimeFieldMdcCliAiCode();

  @override
  String get name => "`FormDateTimeField`の利用方法";

  @override
  String get description => "フォームの日時フィールドを表示し選択するための`FormDateTimeField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`DateTimeField`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで日時の値を管理可能。日付と時刻の同時選択、カスタムフォーマット、時間範囲制限などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormDateTimeField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormDateTimeField(
    form: formController,
    initialValue: formController.value.dateTime,
    onSaved: (value) => formController.value.copyWith(dateTime: value),
);
```

## 日時範囲制限付きの利用方法

```dart
FormDateTimeField(
    form: formController,
    initialValue: formController.value.dateTime,
    firstDate: DateTime(2024, 1, 1, 9, 0),
    lastDate: DateTime(2024, 12, 31, 17, 0),
    onSaved: (value) => formController.value.copyWith(dateTime: value),
);
```

## カスタムフォーマット付きの利用方法

```dart
FormDateTimeField(
    form: formController,
    initialValue: formController.value.dateTime,
    format: "yyyy年MM月dd日 HH時mm分",
    onSaved: (value) => formController.value.copyWith(dateTime: value),
);
```

## 時間選択のカスタマイズ

```dart
FormDateTimeField(
    form: formController,
    initialValue: formController.value.dateTime,
    timeInterval: const Duration(minutes: 30),
    timeFormat: "HH:mm",
    onSaved: (value) => formController.value.copyWith(dateTime: value),
);
```

## バリデーション付きの利用方法

```dart
FormDateTimeField(
    form: formController,
    initialValue: formController.value.dateTime,
    validator: (value) {
      if (value == null) {
        return "日時を選択してください";
      }
      if (value.hour < 9 || value.hour >= 17) {
        return "営業時間（9:00-17:00）内の時間を選択してください";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(dateTime: value),
);
```

## カスタムデザインの適用

```dart
FormDateTimeField(
    form: formController,
    initialValue: formController.value.dateTime,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      backgroundColor: Colors.grey[200],
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blue,
        todayColor: Colors.orange,
      ),
      timePickerStyle: TimePickerStyle(
        backgroundColor: Colors.white,
        selectedTextColor: Colors.blue,
      ),
    ),
    onSaved: (value) => formController.value.copyWith(dateTime: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。選択された日時の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期日時を設定します。
- `firstDate`: 選択可能な最初の日時。これより前の日時は選択できません。
- `lastDate`: 選択可能な最後の日時。これより後の日時は選択できません。
- `format`: 日時フォーマット。表示する日時のフォーマットを指定します。
- `timeFormat`: 時刻フォーマット。時刻選択部分のフォーマットを指定します。
- `timeInterval`: 時間間隔。時刻選択の間隔を指定します。
- `validator`: バリデーション関数。選択された日時の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、日時選択が無効化されます。
- `locale`: ロケール。カレンダーと時刻選択の言語や表示形式を指定します。

## 注意点

- `FormController`と組み合わせて使用することで、日時の値を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 日時の範囲制限は`firstDate`と`lastDate`で設定できます。
- 時間間隔は`timeInterval`で調整できます。
- 日時フォーマットは`format`パラメータで指定できます。
- `locale`パラメータを使用して、多言語対応が可能です。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. ユーザーの利便性を考慮して適切な日時範囲を設定する
3. 用途に応じた時間間隔を設定する
4. 地域に応じた日時フォーマットを使用する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 予約日時の選択
- イベントのスケジュール設定
- 配送希望日時の指定
- 会議時間の設定
- タスクの期限設定
""";
  }
}
