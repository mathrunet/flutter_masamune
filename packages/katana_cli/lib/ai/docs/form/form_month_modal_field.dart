// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_month_modal_field.md.
///
/// form_month_modal_field.mdの中身。
class KatanaFormMonthModalFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_month_modal_field.md.
  ///
  /// form_month_modal_field.mdの中身。
  const KatanaFormMonthModalFieldMdCliAiCode();

  @override
  String get name => "`FormMonthModalField`の利用方法";

  @override
  String get description => "年月を選択するためのフォームフィールドである`FormMonthModalField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "年月を選択するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。カスタムフォーマット、バリデーションなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormMonthModalField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## カスタムフォーマットの利用方法

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
  format: "yyyy年MM月",
);
```

## 選択可能範囲の設定

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
  picker: FormMonthModalFieldPicker(
    begin: DateTime(2020, 1),
    end: DateTime(2025, 12),
  ),
);
```

## バリデーション付きの利用方法

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
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
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## カスタムデザインの適用

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
  ),
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
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
- `picker`: 年月を選択するためのピッカー。年月の範囲制限を設定することができます。
  - `FormMonthModalFieldPicker`: 年月を選択するピッカー。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `picker`で年月選択するモーダルの設定をすることができます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. 日時は`DateTime`型で取り扱うが、`Model`では`ModelDate`型で取り扱うため変換には注意。
7. `picker`で年月選択するモーダルの設定をすることができます。

## 利用シーン

- 月次レポートの期間選択
- 予約月の選択
- 月別データの表示
- 月次予算の設定
- 定期イベントの月選択
""";
  }
}
