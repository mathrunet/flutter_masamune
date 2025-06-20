# `Form`の利用方法

ユーザーによる入力や選択を受け取るために利用可能な`Widget`である`Form`の一覧とその利用方法を下記に記載する。

## `Form`とは

`Form`はユーザーによる入力や選択を受け取るためのクラスである。

- `Form`は`FormController`を通して`State`によって管理される。
- `FormController`中の`valudate()`メソッドを実行することで各`Form`の`validate`プロパティや`onSave`プロパティの処理を実行し入力・選択された値の検証や保存を行うことができる。
- `FormStyle`を適用することでデザインを統一することができる。
- `FormController`を渡さない使い方も可能。その場合は`onSaved`パラメーターではなく`onChanged`パラメーター等を利用する。
- 各種`Form`は型パラメーターが用意されていることが多いが、基本的に型パラメーターは明示的に指定しない。必須パラメーターを型有りで渡すことで自動的に型パラメーターが推論される。
    - 例：この場合`FormEnumDropdownFieldPicker`の`values`に`UserType.values`を渡すことで`picker`が`FormEnumDropdownFieldPicker<UserType>`であるという推論が行われる。また`formController`が`FormController<UserValue>`の型であれば、`picker`の型と`form`の型により`FormEnumDropdownField<UserType, UserValue>`であるという推論が行われる。
        ```dart
        FormEnumDropdownField(
          form: formController,
          initialValue: formController.value.type,
          onSaved: (value) => formController.value.copyWith(type: value),
          picker: FormEnumDropdownFieldPicker(
            values: UserType.values,
            labelBuilder: (value) {
              return value.label;
            },
          ),
        )
        ```

## `Form`の一覧

| Class | Summary | Usage |
| --- | --- | --- |
| `FormTextField` | `TextFormField`のMasamuneフレームワーク版。テキスト入力を行うフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`TextFormField`の値を管理可能。バリデーション、サジェスト機能、カスタムデザインなどの機能を備えています。 | Usage(`documents/rules/form/form_text_field.md`) |
| `FormPinField` | PINコード入力用のフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでPINコードの状態管理を行えます。桁数設定などの機能を備えています。 | Usage(`documents/rules/form/form_pin_field.md`) |
| `FormChipsField` | `Chip`ウィジェットを使用して複数の選択肢を表示・選択できるフォームフィールド。テキスト入力を同時に行えるため、選択肢を新しく作ったり、検索したりすることが可能。タグ選択やフィルター選択などに最適で、`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。 | Usage(`documents/rules/form/form_chips_field.md`) |
| `FormDateField` | モーダルピッカーにて日付を選択することができるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで日付の値を管理可能。カスタムフォーマットなどの機能を備えています。 | Usage(`documents/rules/form/form_date_field.md`) |
| `FormDateTimeField` | `DateTimeField`のMasamuneフレームワーク版。`DatePicker`や`TimePicker`のモーダルで選択した日時を値として設定することができるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで日時の値を管理可能。日付範囲制限などの機能を備えています。 | Usage(`documents/rules/form/form_date_time_field.md`) |
| `FormSwitch` | `Switch`のMasamuneフレームワーク版。トグルスイッチを表示し切り替えるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでスイッチの値を管理可能。ラベル付きスイッチ、カスタムデザインなどの機能を備えています。 | Usage(`documents/rules/form/form_switch.md`) |
| `FormCheckbox` | `Checkbox`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`Checkbox`の値を管理可能。ラベル付きチェックボックスやカスタムデザインなどの機能を備えています。 | Usage(`documents/rules/form/form_checkbox.md`) |
| `FormBuilder` | `FormController`を使用して独自のフォームを構築するためのビルダー。`ref.update`メソッドでフォームの情報を更新することができるためボタンを並べたフォームやモーダルで表示するフォームなどを構築することができます。 | Usage(`documents/rules/form/form_builder.md`) |
| `FormButton` | `ElevatedButton`、`FilledButton`、`OutlinedButton`、`TextButton`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`と連携してフォームの送信等を行うことができます。勿論通常のボタンとしても利用可能です。アイコン表示、カスタムデザインなどの機能を備えています。 | Usage(`documents/rules/form/form_button.md`) |
| `FormDateTimeRangeField` | 期間（開始日時と終了日時）を選択するためのフォームフィールド。日付と時刻を同時に選択でき、カスタムフォーマットや時間範囲の制限などの機能を備えています。`FormStyle`で共通したデザインを適用可能で、`FormController`を利用することで選択状態を管理できます。 | Usage(`documents/rules/form/form_date_time_range_field.md`) |
| `FormDurationField` | 時間の長さ（Duration）を入力するためのフォームフィールド。時間、分、秒などの単位で時間の長さを設定でき、範囲制限やバリデーションなどの機能を備えています。`FormStyle`で共通したデザインを適用可能で、`FormController`を利用することで入力値を管理できます。 | Usage(`documents/rules/form/form_duration_field.md`) |
| `FormEditableToggleBuilder` | 編集モードと表示モードを切り替えられるフォームビルダー。`FormController`の状態に応じて、編集可能なフォームと読み取り専用の表示を切り替えることができます。編集・保存・キャンセルなどの機能を備えています。 | Usage(`documents/rules/form/form_editable_toggle_builder.md`) |
| `FormEnumModalField` | モーダルで列挙型の選択肢から選択することができるフォーム。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで列挙型の値を管理可能。列挙型の値をラベル付きで表示、カスタムデザインなどの機能を備えています。 | Usage(`documents/rules/form/form_enum_modal_field.md`) |
| `FormEnumDropdownField` | 列挙型の値をドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。カスタムラベルやバリデーションなどを備えています。 | Usage(`documents/rules/form/form_enum_dropdown_field.md`) |
| `FormFocusNodeBuilder` | フォーカスノードを保持して提供するためのビルダー。フォーカス状態を管理し、フォーカスの取得・解放時の処理を実装できます。 | Usage(`documents/rules/form/form_focus_node_builder.md`) |
| `FormFutureField` | 非同期処理の結果を表示・入力するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで非同期データの管理と表示を行えます。主に`Modal`や別`Page`にフォームフィールドを作成し、その結果を受け取るために利用することが多いです。 | Usage(`documents/rules/form/form_future_field.md`) |
| `FormLabel` | フォームフィールドのラベルを表示するためのウィジェット。`FormStyle`で共通したデザインを適用可能。必須マーク、ヘルプテキスト、エラーメッセージなどの表示機能を備えています。 | Usage(`documents/rules/form/form_label.md`) |
| `FormListBuilder` | リスト形式のデータを動的に追加・削除・編集できるフォームビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでリストの状態管理を行えます。バリデーション、カスタムデザインなどの機能を備えています。 | Usage(`documents/rules/form/form_list_builder.md`) |
| `FormMapDropdownField` | Key-ValueペアのMap形式のデータをドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。 | Usage(`documents/rules/form/form_map_dropdown_field.md`) |
| `FormMapModalField` | Key-ValueペアのMap型のデータ入力に特化したフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用してマップデータの入力と管理を行うことができます。カスタムデザインなどの機能を備えています。 | Usage(`documents/rules/form/form_map_modal_field.md`) |
| `FormMedia` | 画像や動画を1つだけ選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用してメディアの選択と管理を行うことができます。 | Usage(`documents/rules/form/form_media.md`) |
| `FormMonthField` | 年月を選択するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。カスタムフォーマット、バリデーションなどの機能を備えています。 | Usage(`documents/rules/form/form_month_field.md`) |
| `FormMultiMedia` | `FormMedia`の複数選択版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用して複数のメディアの選択と管理を行うことができます。画像・動画の複数選択、プレビュー表示、並び替え、削除などの機能を備えています。 | Usage(`documents/rules/form/form_multi_media.md`) |
| `FormNumField` | モーダルで数値を選択するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで数値の値を管理可能。最小値・最大値の制限、小数点以下の桁数制限、通貨表示などの機能を備えています。 | Usage(`documents/rules/form/form_num_field.md`) |
| `FormPasswordBuilder` | パスワード入力時の内容を隠すかどうかを切り替えることができるフォームビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでパスワードの状態管理を行えます。パスワードの表示/非表示切り替え、および表示切替のトグルスイッチの機能を備えています。 | Usage(`documents/rules/form/form_password_builder.md`) |
| `FormRatingBar` | 評価を星やアイコンで入力するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで評価値を管理できます。カスタムアイコン、半星表示、タップ・ドラッグでの入力、ラベルの表示などの機能を備えています。 | Usage(`documents/rules/form/form_rating_bar.md`) |
| `FormStyleContainer` | `FormStyle`を適用するためのコンテナウィジェット。パディング、背景色、ボーダー、影などのスタイルを統一的に管理できます。また、任意の値のバリデーションを行うことができます。 | Usage(`documents/rules/form/form_style_container.md`) |
| `FormTextEditingControllerBuilder` | TextEditingControllerを提供するビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでテキスト入力の状態管理を行えます。 | Usage(`documents/rules/form/form_text_editing_controller_builder.md`) |

## `FormStyle`について

`FormStyle`は`Form`のスタイルを定義するためのクラスである。これを各`Form`に適用することで、デザインを統一することができる。

```dart
final formStyle = FormStyle(
  padding: EdgeInsets.all(16.0),
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
  backgroundColor: Colors.grey[200],
);
```

### `FormInputBorderStyle`について

`FormInputBorderStyle`は`Form`の入力ボーダーのスタイルを定義するためのクラスである。これを各`FormStyle`で設定することで、入力ボーダーのスタイルを統一することができる。

```dart
final formStyle = FormStyle(
  style: FormInputBorderStyle.outline,
);
```

種類は下記の通りである。

- `FormInputBorderStyle.none`: ボーダーなし。
- `FormInputBorderStyle.outline`: 外枠をすべて囲う。
- `FormInputBorderStyle.underline`: 下線のみ。

## `FormController`について

`FormController`は`Form`の状態を管理するためのクラスである。これを各`Form`に適用することで、`Form`の状態を管理することができる。`FormController`の取得は`Model`で定義された`form`メソッドを利用し`State`を通して取得する。

- `Model`の実装方法(`documents/rules/docs/model_usage.md`)
- `State`の利用方法(`documents/rules/docs/state_usage.md`)

```dart
final formController = ref.page.form(AnyModel.form(AnyModel()));
```

既存の値を編集する際に`Document`の`Model`を既存の値として利用する場合は下記のように定義する。

```dart
final anyDocument = ref.app.model(AnyModel.document(documentId))..load();
final formController = ref.page.form(
  AnyModel.form(
    anyDocument.value ?? AnyModel(),
  ),
);
```

`FormController`を各`Form`に適用する際には各`Form`の`form`パラメーターに`FormController`を渡す。
また`form`パラメーターに`FormController`を渡す際には`onSaved`パラメーターを定義する必要がある。
`onSaved`パラメーターには`FormController`の`value`の`copyWith`メソッドを利用して`FormController`の`value`を更新し、`onSaved`の戻り値にその値をそのまま返す。

```dart
FormTextField(
  form: formController,
  onSaved: (value) => formController.value.copyWith(
    title: value,
  ),
);
```

`FormController`の`validate()`メソッドを実行することで各`Form`の`validate`プロパティや`onSave`プロパティの処理を実行し入力・選択された値の検証や保存を行うことができる。

```dart
final value = formController.validate();
if(value == null){
  // 入力された値が検証に通らなかった場合の処理
} else {
  // 入力された値が検証に通った場合の処理
}
```
