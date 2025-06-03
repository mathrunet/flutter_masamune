// Project imports:
import 'package:katana_cli/ai/docs/form/form_builder.dart';
import 'package:katana_cli/ai/docs/form/form_button.dart';
import 'package:katana_cli/ai/docs/form/form_checkbox.dart';
import 'package:katana_cli/ai/docs/form/form_chips_field.dart';
import 'package:katana_cli/ai/docs/form/form_container.dart';
import 'package:katana_cli/ai/docs/form/form_date_field.dart';
import 'package:katana_cli/ai/docs/form/form_date_time_field.dart';
import 'package:katana_cli/ai/docs/form/form_date_time_range_field.dart';
import 'package:katana_cli/ai/docs/form/form_duration_field.dart';
import 'package:katana_cli/ai/docs/form/form_editable_toggle_builder.dart';
import 'package:katana_cli/ai/docs/form/form_enum_dropdown_field.dart';
import 'package:katana_cli/ai/docs/form/form_enum_modal_field.dart';
import 'package:katana_cli/ai/docs/form/form_focus_node_builder.dart';
import 'package:katana_cli/ai/docs/form/form_future_field.dart';
import 'package:katana_cli/ai/docs/form/form_label.dart';
import 'package:katana_cli/ai/docs/form/form_list_builder.dart';
import 'package:katana_cli/ai/docs/form/form_map_dropdown_field.dart';
import 'package:katana_cli/ai/docs/form/form_map_modal_field.dart';
import 'package:katana_cli/ai/docs/form/form_media.dart';
import 'package:katana_cli/ai/docs/form/form_month_modal_field.dart';
import 'package:katana_cli/ai/docs/form/form_multi_media.dart';
import 'package:katana_cli/ai/docs/form/form_num_modal_field.dart';
import 'package:katana_cli/ai/docs/form/form_password_builder.dart';
import 'package:katana_cli/ai/docs/form/form_pin_field.dart';
import 'package:katana_cli/ai/docs/form/form_rating_bar.dart';
import 'package:katana_cli/ai/docs/form/form_switch.dart';
import 'package:katana_cli/ai/docs/form/form_text_editing_controller_builder.dart';
import 'package:katana_cli/ai/docs/form/form_text_field.dart';
import 'package:katana_cli/katana_cli.dart';

/// List of Form types.
///
/// Formタイプのリスト。
const kFormList = {
  "FormTextField": KatanaFormTextFieldMdCliAiCode(),
  "FormPinField": KatanaFormPinFieldMdCliAiCode(),
  "FormChipsField": KatanaFormChipsFieldMdCliAiCode(),
  "FormDateField": KatanaFormDateFieldMdCliAiCode(),
  "FormDateTimeField": KatanaFormDateTimeFieldMdCliAiCode(),
  "FormSwitch": KatanaFormSwitchMdCliAiCode(),
  "FormCheckbox": KatanaFormCheckboxMdCliAiCode(),
  "FormBuilder": KatanaFormBuilderMdCliAiCode(),
  "FormButton": KatanaFormButtonMdCliAiCode(),
  "FormDateTimeRangeField": KatanaFormDateTimeRangeFieldMdCliAiCode(),
  "FormDurationField": KatanaFormDurationFieldMdCliAiCode(),
  "FormEditableToggleBuilder": KatanaFormEditableToggleBuilderMdCliAiCode(),
  "FormEnumModalField": KatanaFormEnumModalFieldMdCliAiCode(),
  "FormEnumDropdownField": KatanaFormEnumDropdownFieldMdCliAiCode(),
  "FormFocusNodeBuilder": KatanaFormFocusNodeBuilderMdCliAiCode(),
  "FormFutureField": KatanaFormFutureFieldMdCliAiCode(),
  "FormLabel": KatanaFormLabelMdCliAiCode(),
  "FormListBuilder": KatanaFormListBuilderMdCliAiCode(),
  "FormMapDropdownField": KatanaFormMapDropdownFieldMdCliAiCode(),
  "FormMapModalField": KatanaFormMapModalFieldMdCliAiCode(),
  "FormMedia": KatanaFormMediaMdCliAiCode(),
  "FormMonthField": KatanaFormMonthModalFieldMdCliAiCode(),
  "FormMultiMedia": KatanaFormMultiMediaMdCliAiCode(),
  "FormNumField": KatanaFormNumModalFieldMdCliAiCode(),
  "FormPasswordBuilder": KatanaFormPasswordBuilderMdCliAiCode(),
  "FormRatingBar": KatanaFormRatingBarMdCliAiCode(),
  "FormStyleContainer": KatanaFormContainerMdCliAiCode(),
  "FormTextEditingControllerBuilder":
      KatanaFormTextEditingControllerBuilderMdCliAiCode(),
};

/// Contents of form_usage.md.
///
/// form_usage.mdの中身。
abstract class FormUsageCliAiCode extends CliAiCode {
  /// Contents of form_usage.md.
  ///
  /// form_usage.mdの中身。
  const FormUsageCliAiCode();

  /// Excerpt of the form.
  ///
  /// Formの概要。
  String get excerpt;
}

/// Contents of form_usage.md.
///
/// form_usage.mdの中身。
class FormUsageMdCliAiCode extends CliAiCode {
  /// Contents of form_usage.md.
  ///
  /// form_usage.mdの中身。
  const FormUsageMdCliAiCode();

  @override
  String get name => "`Form`の利用方法";

  @override
  String get description =>
      "ユーザーによる入力や選択を受け取るために利用可能な`Widget`である`Form`の一覧とその利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    var header = r"""
ユーザーによる入力や選択を受け取るために利用可能な`Widget`である`Form`の一覧とその利用方法を下記に記載する。

## `Form`とは

`Form`はユーザーによる入力や選択を受け取るためのクラスである。

- `Form`は`FormController`を通して`State`によって管理される。
- `FormController`中の`valudate()`メソッドを実行することで各`Form`の`validate`プロパティや`onSave`プロパティの処理を実行し入力・選択された値の検証や保存を行うことができる。
- `FormStyle`を適用することでデザインを統一することができる。

## `Form`の一覧

| Class | Summary | Usage |
| --- | --- | --- |
""";
    for (final entry in kFormList.entries) {
      header +=
          "| `${entry.key}` | ${entry.value.excerpt} | Usage(`documents/rules/form/${entry.key.toSnakeCase()}.md`) |\n";
    }
    header += """

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
""";
    return header;
  }
}
