// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_duration_field.md.
///
/// form_duration_field.mdの中身。
class KatanaFormDurationFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_duration_field.md.
  ///
  /// form_duration_field.mdの中身。
  const KatanaFormDurationFieldMdCliAiCode();

  @override
  String get name => "`FormDurationField`の利用方法";

  @override
  String get description => "時間の長さ（Duration）を入力するための`FormDurationField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "時間の長さ（Duration）を入力するためのフォームフィールド。時間、分、秒などの単位で時間の長さを設定でき、範囲制限やバリデーションなどの機能を備えています。`FormStyle`で共通したデザインを適用可能で、`FormController`を利用することで入力値を管理できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormDurationField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormDurationField(
  initialValue: Duration(minutes: 30),
  onChanged: (value) {
    print(value);
  },
);
```

## 範囲制限の利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
  picker: const FormDurationFieldPicker(
    begin: Duration(minutes: 1),
    end: Duration(minutes: 30),
  ),
);
```

## バリデーション付きの利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
  validator: (value) {
    if (value == null) {
      return "時間を入力してください";
    }
    if (value.inMinutes < 30) {
      return "30分以上の時間を設定してください";
    }
    if (value.inHours > 8) {
      return "8時間以内の時間を設定してください";
    }
    return null;
  },
);
```

## カスタムデザインの適用

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
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
- `picker`: 間隔を選択するためのピッカー。
  - `FormDurationFieldPicker`: 範囲を選択するピッカー。
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
6. 日時は`Duration`型で取り扱うが、`Model`ではミリ秒や秒で取り扱うため変換には注意。

## 利用シーン

- タスクの所要時間設定
- タイマーの時間設定
- 作業時間の入力
- 予約時間の長さ設定
- 制限時間の設定
""";
  }
}
