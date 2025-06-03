// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_date_field.md.
///
/// form_date_field.mdの中身。
class KatanaFormDateFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_date_field.md.
  ///
  /// form_date_field.mdの中身。
  const KatanaFormDateFieldMdCliAiCode();

  @override
  String get name => "`FormDateField`の利用方法";

  @override
  String get description => "フォームの日付フィールドを表示し選択するための`FormDateField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "モーダルピッカーにて日付を選択することができるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで日付の値を管理可能。カスタムフォーマットなどの機能を備えています。";

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
  initialValue: formController.value.date.value,
  onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormDateField(
  initialValue: DateTime.now(),
  onChanged: (value) {
    print(value);
  },
);
```

## カスタムフォーマット付きの利用方法

```dart
FormDateField(
  form: formController,
  initialValue: formController.value.date.value,
  format: "yyyy年MM月dd日",
  onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
);
```

## バリデーション付きの利用方法

```dart
FormDateField(
  form: formController,
  initialValue: formController.value.date.value,
  onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
  validator: (value) {
    if (value == null) {
      return "日付を選択してください";
    }
    if (value.isBefore(DateTime.now())) {
      return "過去の日付は選択できません";
    }
    return null;
  },
);
```

## カスタムデザインの適用

```dart
FormDateField(
    form: formController,
    initialValue: formController.value.date.value,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      backgroundColor: Colors.grey[200],
    ),
    onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
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
- `picker`: 日付ピッカー。日付選択のピッカーを設定します。
- `format`: 日付フォーマット。表示する日付のフォーマットを指定します。
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
6. 日付は`DateTime`型で取り扱うが、`Model`では`ModelDate`型で取り扱うため変換には注意。

## 利用シーン

- 予約日の選択
- 生年月日の入力
- イベント日程の設定
- 期限日の設定
- スケジュール管理
""";
  }
}
