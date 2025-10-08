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

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormDateField(
        initialValue: formController.value.date.value,
        onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormDateField(
  form: formController,
  initialValue: formController.value.date.value,
  onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
);
```

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
  initialValue: Clock.now(),
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
    if (value.isBefore(Clock.now())) {
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

## 読み取り専用の利用方法

```dart
FormDateField(
  form: formController,
  initialValue: formController.value.date.value,
  readOnly: true,  // ピッカーが開かない
  onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
);
```

## カスタムピッカーの利用方法

```dart
FormDateField(
  form: formController,
  initialValue: formController.value.date.value,
  picker: const FormDateFieldPicker(
    monthSuffix: "月",
    daySuffix: "日",
    monthFormat: "MM",
    confirmText: "決定",
    cancelText: "キャンセル",
  ),
  onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormDateField(
  form: formController,
  initialValue: formController.value.date.value,
  prefix: FormAffixStyle(
    icon: Icon(Icons.calendar_today),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.clear),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormDateField(
  form: formController,
  initialValue: formController.value.date.value,
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(date: ModelDate(value)),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された日付の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。日付が変更された時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。Enterキーなどが押された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択された日付の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、日付フィールドが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、ピッカーが開かなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期日付を設定します（`DateTime`型）。
- `controller`: テキストコントローラー。テキスト入力のコントロールを外部から制御します。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `picker`: 日付ピッカー。日付選択のピッカーを設定します（`FormDateFieldPicker`）。デフォルトは`FormDateFieldPicker()`です。
- `format`: 日付フォーマット。表示する日付のフォーマットを指定します。デフォルトは`"MM/dd"`です。
- `emptyErrorText`: 空のエラーメッセージ。日付が選択されていない場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。デフォルトは`TextInputType.text`です。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormDateFieldPicker`で設定可能なプロパティ
- `defaultDateTime`: 選択されていないときのデフォルトの値
- `monthSuffix`: 月の接尾辞（例: "月"）
- `daySuffix`: 日の接尾辞（例: "日"）
- `monthFormat`: 月のフォーマット。デフォルトは`"MM"`
- `backgroundColor`: ピッカーの背景色
- `color`: ピッカーの前景色（テキスト色）
- `confirmText`: 確定ボタンのテキスト。デフォルトは`"Confirm"`
- `cancelText`: キャンセルボタンのテキスト。デフォルトは`"Cancel"`

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- 日付は`DateTime`型で取り扱いますが、`Model`では`ModelDate`型で取り扱うため変換に注意が必要です。
- `format`は日付の表示フォーマットを指定します。デフォルトは`"MM/dd"`（月/日）です。
- `readOnly`が`true`の場合、フィールドをタップしてもピッカーは開きません。
- `emptyErrorText`を設定すると、日付が選択されていない場合にバリデーションエラーとして表示されます。
- `showDropdownIcon`を`false`にすると、ドロップダウンアイコンが非表示になります。
- ピッカーは月と日のみを選択できます（年は含まれません）。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 過去の日付チェック、未来の日付チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. 日付は`DateTime`型で取り扱うが、`Model`では`ModelDate`型に変換して保存する
8. `format`パラメータを使用して、地域に合わせた日付表示フォーマットを設定する
9. `picker`の`monthSuffix`や`daySuffix`を使用して、地域に合わせた接尾辞を設定する
10. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 予約日の選択（レストラン予約、ホテル予約など）
- 生年月日の入力（月日のみ）
- 記念日の登録（月日のみ）
- イベント日程の設定（月日のみ）
- 期限日の設定（月日のみ）
- スケジュール管理（月日のみ）
- 誕生日の入力（月日のみ）
- 定期イベントの日付設定（月日のみ）
""";
  }
}
