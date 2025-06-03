// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_date_time_field.md.
///
/// form_date_time_field.mdの中身。
class KatanaFormDateTimeFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_date_time_field.md.
  ///
  /// form_date_time_field.mdの中身。
  const KatanaFormDateTimeFieldMdCliAiCode();

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
      "`DateTimeField`のMasamuneフレームワーク版。`DatePicker`や`TimePicker`のモーダルで選択した日時を値として設定することができるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで日時の値を管理可能。日付範囲制限などの機能を備えています。";

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
  initialValue: formController.value.dateTime.value,
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormDateTimeField(
  initialValue: DateTime.now(),
  onChanged: (value) {
    print(value);
  },
);
```

## 日付のみ選択＆日付範囲制限付きの利用方法

```dart
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
  picker: const FormDateTimeFieldDatePicker(
    startDate: DateTime(2024, 1, 1, 9, 0),
    endDate: DateTime(2024, 12, 31, 17, 0),
  ),
);
```

## 日時選択＆日時範囲制限付きの利用方法

```dart
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
  picker: const FormDateTimeFieldDateTimePicker(
    startDate: DateTime(2024, 1, 1, 9, 0),
    endDate: DateTime(2024, 12, 31, 17, 0),
  ),
);
```

## バリデーション付きの利用方法

```dart
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
  validator: (value) {
    if (value == null) {
      return "日時を選択してください";
    }
    if (value.hour < 9 || value.hour >= 17) {
      return "営業時間（9:00-17:00）内の時間を選択してください";
    }
    return null;
  },
);
```

## カスタムデザインの適用

```dart
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
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
- `picker`: 日付を選択するためのピッカー。日付の範囲制限や時間間隔を設定することができます。ピッカーの種類を変えることで日付のみ選択や日時選択を切り替えることができます。
  - `FormDateTimeFieldDatePicker`: 日付のみを選択するピッカー。
  - `FormDateTimeFieldDateTimePicker`: 日付と時間を合わせて選択するピッカー。
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
6. 日時は`DateTime`型で取り扱うが、`Model`では`ModelTimestamp`型で取り扱うため変換には注意。

## 利用シーン

- 予約日時の選択
- イベントのスケジュール設定
- 配送希望日時の指定
- 会議時間の設定
- タスクの期限設定
""";
  }
}
