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

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormDateTimeRangeField(
        initialValue: formController.value.eventPeriod.value,
        onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormDateTimeRangeField(
  form: formController,
  initialValue: formController.value.eventPeriod.value,
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
);
```

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
    borderStyle: FormInputBorderStyle.outline,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
  ),
);
```

## 読み取り専用の利用方法

```dart
FormDateTimeRangeField(
  form: formController,
  initialValue: formController.value.eventPeriod.value,
  readOnly: true,  // ピッカーが開かない
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
);
```

## カスタムピッカー（pickerBuilder）の利用方法

```dart
FormDateTimeRangeField(
  form: formController,
  initialValue: formController.value.eventPeriod.value,
  picker: FormDateTimeRangeFieldCustomPicker(
    dateFormat: "yyyy年MM月dd日",
    separator: " 〜 ",
    pickerBuilder: (context, currentDateTimeRange) async {
      // カスタムピッカーの実装
      return await showDateRangePicker(
        context: context,
        firstDate: DateTime(2024, 1, 1),
        lastDate: DateTime(2024, 12, 31),
        initialDateRange: currentDateTimeRange,
      );
    },
  ),
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormDateTimeRangeField(
  form: formController,
  initialValue: formController.value.eventPeriod.value,
  prefix: FormAffixStyle(
    icon: Icon(Icons.date_range),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.clear),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormDateTimeRangeField(
  form: formController,
  initialValue: formController.value.eventPeriod.value,
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(eventPeriod: ModelTimestampRange(value)),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された日時範囲の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。日時範囲が変更された時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。Enterキーなどが押された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択された日時範囲の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、日時範囲フィールドが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、ピッカーが開かなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期日時範囲を設定します（`DateTimeRange`型）。
- `controller`: テキストコントローラー。テキスト入力のコントロールを外部から制御します。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `picker`: 日時範囲選択ピッカー。日付範囲の制限や表示フォーマットを設定できます。デフォルトは`FormDateTimeRangeFieldDatePicker()`です。
  - `FormDateTimeRangeFieldDatePicker`: 日付範囲を選択するピッカー。デフォルトフォーマット: `"yyyy/MM/dd(E)"`
  - `FormDateTimeRangeFieldCustomPicker`: `pickerBuilder`を使用してカスタムピッカーを指定するピッカー。
- `emptyErrorText`: 空のエラーメッセージ。日時範囲が選択されていない場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。デフォルトは`TextInputType.text`です。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormDateTimeRangeFieldPicker`共通プロパティ
- `dateFormat`: 日時のフォーマット。表示する日時のフォーマットを指定します。
- `separator`: 開始日時と終了日時の間の区切り文字。デフォルトは`" - "`です。
- `startDate`: 選択可能な最も古い日付。未指定の場合は現在から1年前が使用されます。
- `endDate`: 選択可能な最も新しい日付。未指定の場合は現在から1年後が使用されます。
- `defaultDateTimeRange`: 選択されていない場合の初期値。
- `helpText`: ピッカーに表示されるヘルプテキスト。
- `cancelText`: キャンセルボタンのテキスト。
- `confirmText`: 確定ボタンのテキスト。
- `locale`: ピッカーのロケール。
- `initialEntryMode`: ピッカーの初期入力モード（`DatePickerEntryMode.calendar`または`DatePickerEntryMode.input`）。デフォルトは`DatePickerEntryMode.calendar`です。
- `errorFormatText`: フォーマットエラー時のテキスト。
- `errorInvalidText`: 無効な値のエラーテキスト。
- `fieldStartHintText`: 開始日時フィールドのヒントテキスト。
- `fieldStartLabelText`: 開始日時フィールドのラベルテキスト。
- `fieldEndHintText`: 終了日時フィールドのヒントテキスト。
- `fieldEndLabelText`: 終了日時フィールドのラベルテキスト。

### `FormDateTimeRangeFieldCustomPicker`固有プロパティ
- `pickerBuilder`: カスタムピッカーを実装するためのビルダー関数。`BuildContext`と現在の`DateTimeRange`を受け取り、選択された`DateTimeRange`を返します。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- 日時範囲は`DateTimeRange`型で取り扱いますが、`Model`では`ModelTimestampRange`型で取り扱うため変換に注意が必要です。
- `picker`で選択するピッカーの種類を変更できます：
  - `FormDateTimeRangeFieldDatePicker`: 日付範囲を選択（デフォルト）
  - `FormDateTimeRangeFieldCustomPicker`: カスタムピッカーを指定
- デフォルトでは`FormDateTimeRangeFieldDatePicker`が使用されます。
- `readOnly`が`true`の場合、フィールドをタップしてもピッカーは開きません。
- `emptyErrorText`を設定すると、日時範囲が選択されていない場合にバリデーションエラーとして表示されます。
- `showDropdownIcon`を`false`にすると、ドロップダウンアイコンが非表示になります。
- `startDate`と`endDate`で選択可能な日付範囲を制限できます。未指定の場合は現在から±1年の範囲になります。
- `separator`は開始日時と終了日時の間に表示される区切り文字で、デフォルトは`" - "`です。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。
- `validator`で日時範囲の期間長さ（例: 最大7日間）などをチェックできます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 期間の長さチェック、営業日チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. 日時範囲は`DateTimeRange`型で取り扱うが、`Model`では`ModelTimestampRange`型に変換して保存する
8. `startDate`と`endDate`を設定して、選択可能な日付範囲を適切に制限する
9. `separator`を使用して、開始と終了の区切り文字を地域に合わせて設定する（例: `" 〜 "`、`" to "`など）
10. `locale`を設定して、地域に合わせた日付表示を行う
11. カスタムピッカーが必要な場合は`FormDateTimeRangeFieldCustomPicker`を使用する
12. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- イベント期間の設定（開催期間の指定）
- 予約時間の選択（チェックイン・チェックアウト日時）
- 勤務時間の入力（勤務開始・終了時刻）
- スケジュール管理（プロジェクトの開始・終了日）
- 期限付きタスクの設定（タスクの開始・終了期限）
- キャンペーン期間の設定（開始日・終了日）
- 休暇期間の申請（休暇開始日・終了日）
- セール期間の設定（セール開始・終了日時）
- 会議室予約（予約開始・終了時刻）
- レンタル期間の指定（レンタル開始・返却日時）
""";
  }
}
