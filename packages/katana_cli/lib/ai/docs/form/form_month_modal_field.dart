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

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormMonthModalField(
        initialValue: formController.value.selectedMonth.value,
        onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

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
    final now = Clock.now();
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
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
  ),
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## 読み取り専用の利用方法

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  readOnly: true,  // ピッカーが開かない
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## カスタムピッカーの利用方法

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  picker: const FormMonthModalFieldPicker(
    begin: DateTime(2020, 1),
    end: DateTime(2030, 12),
    yearSuffix: "年",
    monthSuffix: "月",
    confirmText: "決定",
    cancelText: "キャンセル",
  ),
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## 月末日を選択する

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  picker: const FormMonthModalFieldPicker(
    lastDayOfMonth: true,  // その月の最終日を選択
  ),
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## 特定の日を指定する

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  picker: const FormMonthModalFieldPicker(
    day: 15,  // 毎月15日を選択
  ),
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  prefix: FormAffixStyle(
    icon: Icon(Icons.calendar_month),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.clear),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormMonthModalField(
  form: formController,
  initialValue: formController.value.selectedMonth.value,
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(selectedMonth: ModelDate(value)),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された年月（`DateTime`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。年月が変更された時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。Enterキーなどが押された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択された年月の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、年月フィールドが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、ピッカーが開かなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期年月を設定します（`DateTime`型）。
- `controller`: テキストコントローラー。テキスト入力のコントロールを外部から制御します。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `format`: 年月のフォーマット。表示する年月のフォーマットを指定します。デフォルトは`"yyyy/MM"`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `picker`: 年月選択ピッカー（`FormMonthModalFieldPicker`）。年月の範囲制限や日の設定が可能です。デフォルトは`FormMonthModalFieldPicker()`です。
- `emptyErrorText`: 空のエラーメッセージ。年月が選択されていない場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。デフォルトは`TextInputType.text`です。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormMonthModalFieldPicker`で設定可能なプロパティ
- `begin`: 選択可能な最も古い年月。未指定の場合は現在から10年前が使用されます。
- `end`: 選択可能な最も新しい年月。未指定の場合は現在から10年後が使用されます。
- `defaultDateTime`: 選択されていない場合のデフォルト値。
- `yearSuffix`: 年の接尾辞（例: "年"）。デフォルトは空文字です。
- `monthSuffix`: 月の接尾辞（例: "月"）。デフォルトは空文字です。
- `yearFormat`: 年のフォーマット。デフォルトは`"yyyy"`です。
- `day`: `DateTime`として出力する場合の日を指定します（1-31）。未指定の場合は1日になります。`lastDayOfMonth`と同時に設定はできません。
- `lastDayOfMonth`: `true`の場合、`DateTime`として出力する際にその月の最終日になります。`day`と同時に設定はできません。
- `backgroundColor`: ピッカーの背景色。
- `color`: ピッカーのテキスト色（前景色）。
- `confirmText`: 確定ボタンのテキスト。デフォルトは`"Confirm"`です。
- `cancelText`: キャンセルボタンのテキスト。デフォルトは`"Cancel"`です。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- 年月は`DateTime`型で取り扱いますが、`Model`では`ModelDate`型で取り扱うため変換に注意が必要です。
- `format`は年月の表示フォーマットを指定します。デフォルトは`"yyyy/MM"`（年/月）です。
- `readOnly`が`true`の場合、フィールドをタップしてもピッカーは開きません。
- `emptyErrorText`を設定すると、年月が選択されていない場合にバリデーションエラーとして表示されます。
- `showDropdownIcon`を`false`にすると、ドロップダウンアイコンが非表示になります。
- ピッカーは年と月を選択します。日は`picker`の`day`または`lastDayOfMonth`で制御されます。
- `day`と`lastDayOfMonth`は同時に設定できません。どちらか一方を選択してください。
- `day`を指定しない場合、デフォルトで1日が設定されます。
- `begin`と`end`で選択可能な年月範囲を制限できます。未指定の場合は現在から±10年の範囲になります。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 過去の月チェック、未来の月チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. 年月は`DateTime`型で取り扱うが、`Model`では`ModelDate`型に変換して保存する
8. `format`パラメータを使用して、地域に合わせた年月表示フォーマットを設定する
9. `picker`の`yearSuffix`や`monthSuffix`を使用して、地域に合わせた接尾辞を設定する
10. `begin`と`end`を設定して、選択可能な年月範囲を適切に制限する
11. 月末日の選択が必要な場合は`lastDayOfMonth: true`を、特定の日が必要な場合は`day`を設定する
12. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 月次レポートの期間選択（売上レポート、統計レポートなど）
- 予約月の選択（月単位の予約、サブスクリプション開始月）
- 月別データの表示切り替え（月次グラフ、月次集計）
- 月次予算の設定（予算管理、経費計画）
- 定期イベントの月選択（年次イベント、定期メンテナンス）
- 請求月の選択（月次請求、支払い管理）
- 契約開始月の設定（契約管理、サブスクリプション）
- 有効期限の月設定（クレジットカード有効期限など）
- 月次スケジュールの設定（シフト管理、勤務スケジュール）
- 月次目標の設定（KPI設定、目標管理）
""";
  }
}
