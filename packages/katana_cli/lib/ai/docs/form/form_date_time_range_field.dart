// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

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
  initialValue: formController.value.eventPeriod.value,
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormDateTimeRangeField(
  initialValue: DateTimeRange(
    start: DateTime(2024, 1, 1, 9, 0),
    end: DateTime(2024, 12, 31, 17, 0),
  ),
  onChanged: (value) {
    print(value);
  },
);
```

## カスタムフォーマットの利用方法

```dart
FormDateTimeRangeField(
  form: formController,
  initialValue: formController.value.eventPeriod.value,
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
  picker: const FormDateTimeRangeFieldDatePicker(
    dateFormat: "yyyy年MM月dd日 HH時mm分",
    startDate: DateTime(2024, 1, 1, 9, 0),
    endDate: DateTime(2024, 12, 31, 17, 0),
  ),
);
```

## 選択可能期間の制限

```dart
FormDateTimeRangeField(
  form: formController,
  initialValue: formController.value.eventPeriod.value,
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
  picker: const FormDateTimeRangeFieldDatePicker(
    startDate: DateTime(2024, 1, 1, 9, 0),
    endDate: DateTime(2024, 12, 31, 17, 0),
  ),
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
);
```

## カスタムデザインの適用

```dart
FormDateTimeRangeField(
  form: formController,
  initialValue: formController.value.eventPeriod.value,
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
  style: const FormStyle(
    style: FormInputBorderStyle.outline,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。
- `focusNode`: フォーカスノード。フォームのフォーカスを設定します。

- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `picker`: 日付の範囲を選択するためのピッカー。日付の範囲制限や時間間隔を設定することができます。ピッカーの種類を変えることで日付のみ選択や日時選択を切り替えることができます。
  - `FormDateTimeRangeFieldDatePicker`: 日付のみの範囲を選択するピッカー。
  - `FormDateTimeRangeFieldCustomPicker`: `pickerBuilder`を使用して選択可能なピッカーを指定するピッカー。
- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. 日時は`DateTimeRange`型で取り扱うが、`Model`では`ModelTimestampRange`型で取り扱うため変換には注意。

## 利用シーン

- イベント期間の設定
- 予約時間の選択
- 勤務時間の入力
- スケジュール管理
- 期限付きタスクの設定
""";
  }
}
