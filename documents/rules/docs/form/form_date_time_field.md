# `FormDateTimeField`の利用方法

`FormDateTimeField`は下記のように利用する。

## 概要

`DateTimeField`のMasamuneフレームワーク版。`DatePicker`や`TimePicker`のモーダルで選択した日時を値として設定することができるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで日時の値を管理可能。日付範囲制限などの機能を備えています。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormDateTimeField(
        initialValue: formController.value.dateTime.value,
        onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
);
```

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
  initialValue: Clock.now(),
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

## 読み取り専用の利用方法

```dart
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  readOnly: true,  // ピッカーが開かない
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  prefix: FormAffixStyle(
    icon: Icon(Icons.calendar_today),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.clear),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
);
```

## カスタムピッカーカラーの適用

```dart
FormDateTimeField(
  form: formController,
  initialValue: formController.value.dateTime.value,
  picker: const FormDateTimeFieldDateTimePicker(
    startDate: DateTime(2024, 1, 1),
    endDate: DateTime(2024, 12, 31),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    primaryColor: Colors.blue,
    onPrimaryColor: Colors.white,
    headerBackgroundColor: Colors.blue,
    headerForegroundColor: Colors.white,
  ),
  onSaved: (value) => formController.value.copyWith(dateTime: ModelTimestamp(value)),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された日時の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。日時が変更された時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。Enterキーなどが押された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択された日時の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、日時フィールドが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、ピッカーが開かなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期日時を設定します（`DateTime`型）。
- `controller`: テキストコントローラー。テキスト入力のコントロールを外部から制御します。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `picker`: 日時選択ピッカー。日付の範囲制限や表示フォーマットを設定できます。ピッカーの種類を変えることで日付のみ選択や日時選択を切り替えることができます。デフォルトは`FormDateTimeFieldDateTimePicker()`です。
  - `FormDateTimeFieldDatePicker`: 日付のみを選択するピッカー。デフォルトフォーマット: `"yyyy/MM/dd(E)"`
  - `FormDateTimeFieldDateTimePicker`: 日付と時間を合わせて選択するピッカー。デフォルトフォーマット: `"yyyy/MM/dd(E) HH:mm"`
- `emptyErrorText`: 空のエラーメッセージ。日時が選択されていない場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。デフォルトは`TextInputType.text`です。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormDateTimeFieldPicker`共通プロパティ
- `dateFormat`: 日時のフォーマット。表示する日時のフォーマットを指定します。
- `startDate`: 選択可能な最も古い日付。未指定の場合は現在から1年前が使用されます。
- `endDate`: 選択可能な最も新しい日付。未指定の場合は現在から1年後が使用されます。
- `defaultDateTime`: 選択されていない場合の初期値。
- `helpText`: ピッカーに表示されるヘルプテキスト。
- `cancelText`: キャンセルボタンのテキスト。
- `confirmText`: 確定ボタンのテキスト。
- `locale`: ピッカーのロケール。
- `initialDatePickerMode`: ピッカーの最初に表示される要素（`DatePickerMode.year`または`DatePickerMode.day`）。デフォルトは`DatePickerMode.day`です。
- `errorFormatText`: フォーマットエラー時のテキスト。
- `errorInvalidText`: 無効な値のエラーテキスト。
- `fieldHintText`: ピッカー内のテキストフィールドのヒントテキスト。
- `fieldLabelText`: ピッカー内のテキストフィールドのラベルテキスト。
- `backgroundColor`: ピッカーの背景色。
- `foregroundColor`: ピッカーのテキスト色。
- `primaryColor`: ピッカーのプライマリーカラー。
- `onPrimaryColor`: ピッカーのオンプライマリーカラー。
- `headerBackgroundColor`: ピッカーヘッダーの背景色。
- `headerForegroundColor`: ピッカーヘッダーのテキスト色。

### `FormDateTimeFieldDateTimePicker`固有プロパティ
- `dateSelectorHelpText`: 日付選択時のヘルプテキスト。
- `timeSelectorHelpText`: 時間選択時のヘルプテキスト。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- 日時は`DateTime`型で取り扱いますが、`Model`では`ModelTimestamp`型で取り扱うため変換に注意が必要です。
- `picker`で選択するピッカーの種類を変更できます：
  - `FormDateTimeFieldDatePicker`: 日付のみ選択（年月日）
  - `FormDateTimeFieldDateTimePicker`: 日付と時間を選択（年月日時分）
- デフォルトでは`FormDateTimeFieldDateTimePicker`が使用され、日付と時間の両方を選択できます。
- `readOnly`が`true`の場合、フィールドをタップしてもピッカーは開きません。
- `emptyErrorText`を設定すると、日時が選択されていない場合にバリデーションエラーとして表示されます。
- `showDropdownIcon`を`false`にすると、ドロップダウンアイコンが非表示になります。
- `startDate`と`endDate`で選択可能な日付範囲を制限できます。未指定の場合は現在から±1年の範囲になります。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 営業時間内チェック、未来日時チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. 日時は`DateTime`型で取り扱うが、`Model`では`ModelTimestamp`型に変換して保存する
8. 日付のみの選択が必要な場合は`FormDateTimeFieldDatePicker`を使用し、日時の選択が必要な場合は`FormDateTimeFieldDateTimePicker`を使用する
9. `startDate`と`endDate`を設定して、選択可能な日付範囲を適切に制限する
10. `locale`を設定して、地域に合わせた日付表示を行う
11. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 予約日時の選択（レストラン、美容院、ホテルなど）
- イベントのスケジュール設定（会議、セミナー、イベント開催日時）
- 配送希望日時の指定（ECサイトの配送日時選択）
- 会議時間の設定（カレンダーアプリ、スケジュール管理）
- タスクの期限設定（ToDoアプリの締切日時）
- リマインダーの設定（通知日時の設定）
- 予約変更・キャンセル期限の設定
- 営業時間内での予約受付
