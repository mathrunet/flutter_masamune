// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_date_time_range_field.md.
///
/// form_date_time_range_field.mdの中身。
class KatanaFormDateTimeRangeFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_date_time_range_field.md.
  ///
  /// form_date_time_range_field.mdの中身。
  const KatanaFormDateTimeRangeFieldMdCliAiCode();

  @override
  String get name => "`FormDateTimeRangeField`の利用方法";

  @override
  String get description =>
      "フォームの日時範囲フィールドを表示し選択するための`FormDateTimeRangeField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "期間（開始日時と終了日時）を選択するためのフォームフィールド。日付と時刻を同時に選択でき、カスタムフォーマットや時間範囲の制限などの機能を備えています。`FormStyle`で共通したデザインを適用可能で、`FormController`を利用することで選択状態を管理できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormDateTimeRangeField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormDateTimeRangeField(
    form: formController,
    initialValue: formController.value.eventPeriod,
    onSaved: (value) => formController.value.copyWith(eventPeriod: value),
);
```

## カスタムフォーマットの利用方法

```dart
FormDateTimeRangeField(
    form: formController,
    initialValue: formController.value.workPeriod,
    format: "yyyy年MM月dd日",
    timeFormat: "HH時mm分",
    onSaved: (value) => formController.value.copyWith(workPeriod: value),
);
```

## 選択可能期間の制限

```dart
FormDateTimeRangeField(
    form: formController,
    initialValue: formController.value.reservationPeriod,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 90)),
    validator: (value) {
      if (value == null) {
        return "予約期間を選択してください";
      }
      final duration = value.end.difference(value.start);
      if (duration.inDays > 7) {
        return "予約期間は7日以内にしてください";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(reservationPeriod: value),
);
```

## 時間選択のカスタマイズ

```dart
FormDateTimeRangeField(
    form: formController,
    initialValue: formController.value.meetingPeriod,
    timeInterval: const Duration(minutes: 30),
    timeFormat: "HH:mm",
    style: const FormStyle(
      dateTimeRangeStyle: DateTimeRangeStyle(
        startLabel: "開始時間",
        endLabel: "終了時間",
        timePickerEntryMode: TimePickerEntryMode.input,
      ),
    ),
    onSaved: (value) => formController.value.copyWith(meetingPeriod: value),
);
```

## カスタムデザインの適用

```dart
FormDateTimeRangeField(
    form: formController,
    initialValue: formController.value.eventPeriod,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      dateTimeRangeStyle: DateTimeRangeStyle(
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
        todayColor: Colors.blue[100],
        startLabel: "イベント開始",
        endLabel: "イベント終了",
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    onSaved: (value) => formController.value.copyWith(eventPeriod: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します。
- `firstDate`: 選択可能な最初の日付。これより前の日付は選択できません。
- `lastDate`: 選択可能な最後の日付。これより後の日付は選択できません。
- `format`: 日付のフォーマット。表示される日付の形式を指定します。
- `timeFormat`: 時刻のフォーマット。表示される時刻の形式を指定します。
- `timeInterval`: 時間選択の間隔。時刻選択時の分単位の間隔を指定します。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、選択が無効化されます。
- `locale`: ローカライズ設定。日付や時刻の表示言語を指定します。

## 注意点

- `FormController`と組み合わせて使用することで、選択状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 時間選択の間隔は`timeInterval`で調整できます。
- 日付と時刻のフォーマットは別々に指定できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 適切な選択可能期間を設定する
3. ユーザーの地域に合わせた日付・時刻フォーマットを使用する
4. 分かりやすいラベルを設定する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- イベント期間の設定
- 予約時間の選択
- 勤務時間の入力
- スケジュール管理
- 期限付きタスクの設定
""";
  }
}
