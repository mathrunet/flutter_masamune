part of "/katana_form.dart";

/// Widgets for text fields for forms.
///
/// フォーム用のテキストフィールド用のウィジェット。
///
/// Masamune framework version of `TextFormField`. A form field for text input.
/// Common design can be applied with `FormStyle`. Also, the value of `TextFormField` can be managed using `FormController`.
/// It has functions such as validation, suggestion function (advanced input completion by `SuggestionConfig`), custom design,
/// focus control, multi-line input, and character count restriction.
///
/// `TextFormField`のMasamuneフレームワーク版。テキスト入力を行うフォームフィールド。
/// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`TextFormField`の値を管理可能。
/// バリデーション、サジェスト機能（`SuggestionConfig`による高度な入力補完）、カスタムデザイン、
/// フォーカス制御、複数行入力、文字数制限などの機能を備えています。
///
/// ## 配置方法
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
///
/// ## フォーム管理
///
/// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
///
/// [form]に[FormController]を渡した場合、一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
///
/// ## 初期値とコールバック
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// [initialValue]に[FormController.value]から与えられた初期値を入力します。
///
/// Each time the content is changed, [onChanged] is executed.
///
/// 内容が変更される度[onChanged]が実行されます。
///
/// ## バリデーション
///
/// When [FormController.validate] is executed, validation and data saving are performed.
///
/// [FormController.validate]が実行された場合、バリデーションとデータの保存を行ないます。
///
/// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
/// Only when [lengthErrorText] is specified, if the number of characters entered is less than [minLength], it is displayed as [lengthErrorText].
///
/// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
/// [lengthErrorText]が指定されている時に限り、[minLength]より入力された文字数が少ない場合[lengthErrorText]として表示されます。
///
/// Other error checking is performed by specifying [validator].
/// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
///
/// それ以外のエラーチェックは[validator]を指定することで行ないます。
/// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
///
/// ## イベント処理
///
/// The [onSubmitted] process is executed when the Enter key or other keys are pressed.
///
/// Enterキーなどが押された場合の処理を[onSubmitted]が実行されます。
///
/// The [onFocusChanged] process is executed when the focus is changed.
///
/// フォーカスが変更された場合の処理を[onFocusChanged]が実行されます。
///
/// ## サジェスト機能
///
/// If [suggestion] is specified, suggestions will be displayed according to what you have entered.
/// Use [SuggestionConfig] to configure suggestion behavior, including items, display conditions, and tap actions.
///
/// [suggestion]が指定されている場合、入力した内容に応じてサジェストが表示されます。
/// [SuggestionConfig]を使用して、サジェストの候補リスト、表示条件、タップ時の動作などを設定します。
///
/// ## テキストフィールドの状態
///
/// If [enabled] is `false`, the text is deactivated.
///
/// [enabled]が`false`になるとテキストが非有効化されます。
///
/// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
///
/// If [obscureText] is set to `true`, the input string will be hidden. Please use this function for inputting passwords, etc.
///
/// [obscureText]が`true`になると入力された文字列が隠されます。パスワードの入力などにご利用ください。
///
/// ## 入力制限
///
/// If [inputFormatters] is specified, it is possible to restrict the characters to be entered.
///
/// [inputFormatters]が指定されると入力される文字を制限することが可能です。
///
/// If [maxLength] is specified, the maximum number of characters that can be entered is restricted.
///
/// [maxLength]が指定されると入力できる最大文字数が制限されます。
///
/// ## プレフィックス・サフィックス
///
/// Use [prefix] and [suffix] to add icons, labels, or other widgets before or after the text field.
///
/// [prefix]と[suffix]を使用して、テキストフィールドの前後にアイコン、ラベル、その他のウィジェットを追加できます。
///
/// ## 複数行入力
///
/// Set [maxLines] and [minLines] to allow multi-line input.
/// Use [expands] to make the text field expand to fill its parent.
/// Note: [obscureText] cannot be used with multi-line input.
///
/// [maxLines]と[minLines]を設定して複数行入力を許可します。
/// [expands]を使用して、テキストフィールドを親のサイズに合わせて拡張できます。
/// 注意: [obscureText]は複数行入力と併用できません。
///
/// ## フォーカス制御
///
/// Use [focusNode] to control focus programmatically.
/// Use [selectionOnFocus] to specify the selection behavior when focused.
///
/// [focusNode]を使用してプログラム的にフォーカスを制御します。
/// [selectionOnFocus]を使用してフォーカス時の選択動作を指定します。
///
/// ## 基本的な使用例
///
/// ```dart
/// FormTextField(
///   form: formController,
///   initialValue: formController.value.text,
///   labelText: "ユーザー名",
///   hintText: "例: yamada_taro",
///   onSaved: (value) => formController.value.copyWith(text: value),
/// );
/// ```
///
/// ## サジェスト付きの使用例
///
/// ```dart
/// FormTextField(
///   form: formController,
///   initialValue: formController.value.text,
///   suggestion: SuggestionConfig(
///     items: ["東京", "大阪", "名古屋", "福岡"],
///     showOnTap: true,
///     showOnEmpty: true,
///   ),
///   onSaved: (value) => formController.value.copyWith(text: value),
/// );
/// ```
///
/// ## バリデーション付きの使用例
///
/// ```dart
/// FormTextField(
///   form: formController,
///   initialValue: formController.value.text,
///   emptyErrorText: "必須項目です",
///   lengthErrorText: "3文字以上入力してください",
///   minLength: 3,
///   validator: (value) {
///     if (value?.contains("@") == false) {
///       return "@を含めてください";
///     }
///     return null;
///   },
///   onSaved: (value) => formController.value.copyWith(text: value),
/// );
/// ```
///
/// ## パスワード入力の使用例
///
/// ```dart
/// FormTextField(
///   form: formController,
///   initialValue: formController.value.password,
///   labelText: "パスワード",
///   obscureText: true,
///   keyboardType: TextInputType.visiblePassword,
///   onSaved: (value) => formController.value.copyWith(password: value),
/// );
/// ```
class FormTextField<TValue> extends StatefulWidget {
  /// Widgets for text fields for forms.
  ///
  /// フォーム用のテキストフィールド用のウィジェット。
  ///
  /// Masamune framework version of `TextFormField`. A form field for text input.
  /// Common design can be applied with `FormStyle`. Also, the value of `TextFormField` can be managed using `FormController`.
  /// It has functions such as validation, suggestion function (advanced input completion by `SuggestionConfig`), custom design,
  /// focus control, multi-line input, and character count restriction.
  ///
  /// `TextFormField`のMasamuneフレームワーク版。テキスト入力を行うフォームフィールド。
  /// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`TextFormField`の値を管理可能。
  /// バリデーション、サジェスト機能（`SuggestionConfig`による高度な入力補完）、カスタムデザイン、
  /// フォーカス制御、複数行入力、文字数制限などの機能を備えています。
  ///
  /// ## 配置方法
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
  ///
  /// ## フォーム管理
  ///
  /// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
  ///
  /// [form]に[FormController]を渡した場合、一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
  ///
  /// ## 初期値とコールバック
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// [initialValue]に[FormController.value]から与えられた初期値を入力します。
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// 内容が変更される度[onChanged]が実行されます。
  ///
  /// ## バリデーション
  ///
  /// When [FormController.validate] is executed, validation and data saving are performed.
  ///
  /// [FormController.validate]が実行された場合、バリデーションとデータの保存を行ないます。
  ///
  /// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
  /// Only when [lengthErrorText] is specified, if the number of characters entered is less than [minLength], it is displayed as [lengthErrorText].
  ///
  /// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
  /// [lengthErrorText]が指定されている時に限り、[minLength]より入力された文字数が少ない場合[lengthErrorText]として表示されます。
  ///
  /// Other error checking is performed by specifying [validator].
  /// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
  ///
  /// それ以外のエラーチェックは[validator]を指定することで行ないます。
  /// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
  ///
  /// ## イベント処理
  ///
  /// The [onSubmitted] process is executed when the Enter key or other keys are pressed.
  ///
  /// Enterキーなどが押された場合の処理を[onSubmitted]が実行されます。
  ///
  /// The [onFocusChanged] process is executed when the focus is changed.
  ///
  /// フォーカスが変更された場合の処理を[onFocusChanged]が実行されます。
  ///
  /// ## サジェスト機能
  ///
  /// If [suggestion] is specified, suggestions will be displayed according to what you have entered.
  /// Use [SuggestionConfig] to configure suggestion behavior, including items, display conditions, and tap actions.
  ///
  /// [suggestion]が指定されている場合、入力した内容に応じてサジェストが表示されます。
  /// [SuggestionConfig]を使用して、サジェストの候補リスト、表示条件、タップ時の動作などを設定します。
  ///
  /// ## テキストフィールドの状態
  ///
  /// If [enabled] is `false`, the text is deactivated.
  ///
  /// [enabled]が`false`になるとテキストが非有効化されます。
  ///
  /// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
  ///
  /// If [obscureText] is set to `true`, the input string will be hidden. Please use this function for inputting passwords, etc.
  ///
  /// [obscureText]が`true`になると入力された文字列が隠されます。パスワードの入力などにご利用ください。
  ///
  /// ## 入力制限
  ///
  /// If [inputFormatters] is specified, it is possible to restrict the characters to be entered.
  ///
  /// [inputFormatters]が指定されると入力される文字を制限することが可能です。
  ///
  /// If [maxLength] is specified, the maximum number of characters that can be entered is restricted.
  ///
  /// [maxLength]が指定されると入力できる最大文字数が制限されます。
  ///
  /// ## プレフィックス・サフィックス
  ///
  /// Use [prefix] and [suffix] to add icons, labels, or other widgets before or after the text field.
  ///
  /// [prefix]と[suffix]を使用して、テキストフィールドの前後にアイコン、ラベル、その他のウィジェットを追加できます。
  ///
  /// ## 複数行入力
  ///
  /// Set [maxLines] and [minLines] to allow multi-line input.
  /// Use [expands] to make the text field expand to fill its parent.
  /// Note: [obscureText] cannot be used with multi-line input.
  ///
  /// [maxLines]と[minLines]を設定して複数行入力を許可します。
  /// [expands]を使用して、テキストフィールドを親のサイズに合わせて拡張できます。
  /// 注意: [obscureText]は複数行入力と併用できません。
  ///
  /// ## フォーカス制御
  ///
  /// Use [focusNode] to control focus programmatically.
  /// Use [selectionOnFocus] to specify the selection behavior when focused.
  ///
  /// [focusNode]を使用してプログラム的にフォーカスを制御します。
  /// [selectionOnFocus]を使用してフォーカス時の選択動作を指定します。
  ///
  /// ## 基本的な使用例
  ///
  /// ```dart
  /// FormTextField(
  ///   form: formController,
  ///   initialValue: formController.value.text,
  ///   labelText: "ユーザー名",
  ///   hintText: "例: yamada_taro",
  ///   onSaved: (value) => formController.value.copyWith(text: value),
  /// );
  /// ```
  ///
  /// ## サジェスト付きの使用例
  ///
  /// ```dart
  /// FormTextField(
  ///   form: formController,
  ///   initialValue: formController.value.text,
  ///   suggestion: SuggestionConfig(
  ///     items: ["東京", "大阪", "名古屋", "福岡"],
  ///     showOnTap: true,
  ///     showOnEmpty: true,
  ///   ),
  ///   onSaved: (value) => formController.value.copyWith(text: value),
  /// );
  /// ```
  ///
  /// ## バリデーション付きの使用例
  ///
  /// ```dart
  /// FormTextField(
  ///   form: formController,
  ///   initialValue: formController.value.text,
  ///   emptyErrorText: "必須項目です",
  ///   lengthErrorText: "3文字以上入力してください",
  ///   minLength: 3,
  ///   validator: (value) {
  ///     if (value?.contains("@") == false) {
  ///       return "@を含めてください";
  ///     }
  ///     return null;
  ///   },
  ///   onSaved: (value) => formController.value.copyWith(text: value),
  /// );
  /// ```
  ///
  /// ## パスワード入力の使用例
  ///
  /// ```dart
  /// FormTextField(
  ///   form: formController,
  ///   initialValue: formController.value.password,
  ///   labelText: "パスワード",
  ///   obscureText: true,
  ///   keyboardType: TextInputType.visiblePassword,
  ///   onSaved: (value) => formController.value.copyWith(password: value),
  /// );
  /// ```
  const FormTextField({
    this.form,
    super.key,
    this.controller,
    this.prefix,
    this.suffix,
    this.style,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.onTap,
    this.minLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.expands = false,
    this.hintText,
    this.labelText,
    this.lengthErrorText,
    this.suggestion,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.counterText = "",
    this.counterbuilder,
    this.validator,
    this.inputFormatters,
    this.onSaved,
    this.onSubmitted,
    this.onChanged,
    this.showCursor,
    this.autofocus = false,
    this.autocorrect = false,
    this.selectionOnFocus = FormTextFieldSelectionOnFocus.selectAll,
    this.focusNode,
    this.emptyErrorText,
    this.initialValue,
    this.keepAlive = true,
    this.clearOnSubmitted = false,
    this.onFocusChanged,
  }) : assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        );

  /// Context for forms.
  ///
  /// The widget is created outside of the widget in advance and handed over to the client.
  ///
  /// フォーム用のコンテキスト。
  ///
  /// 予めウィジェット外で作成し渡します。
  final FormController<TValue>? form;

  /// Form Style.
  ///
  /// フォームのスタイル。
  final FormStyle? style;

  /// A widget that is placed in front of the form.
  ///
  /// Priority is given to this one, and if there is a [Null] element, [FormStyle.prefix] will be applied.
  ///
  /// フォームの前に配置されるウィジェット。
  ///
  /// 優先的にこちらが表示され、[Null]の要素がある場合は[FormStyle.prefix]が適用されます。
  final FormAffixStyle? prefix;

  /// A widget that is placed after the form.
  ///
  /// Priority is given to this one, and if there is a [Null] element, [FormStyle.suffix] will be applied.
  ///
  /// フォームの後に配置されるウィジェット。
  ///
  /// 優先的にこちらが表示され、[Null]の要素がある場合は[FormStyle.suffix]が適用されます。
  final FormAffixStyle? suffix;

  /// Controller for text forms.
  ///
  /// テキストフォーム用のコントローラー。
  final TextEditingController? controller;

  /// Specifies the focus node.
  ///
  /// The focus node makes it possible to control the focus of the form.
  ///
  /// フォーカスノードを指定します。
  ///
  /// フォーカスノードを利用してフォームのフォーカスをコントロールすることが可能になります。
  final FocusNode? focusNode;

  /// Mobile software keyboard type.
  ///
  /// モバイルのソフトウェアキーボードタイプ。
  final TextInputType keyboardType;

  /// Initial value.
  ///
  /// 初期値。
  final String? initialValue;

  /// Maximum number of strings. You will not be able to enter more than this.
  ///
  /// 文字列の最大数。これ以上は入力できなくなります。
  final int? maxLength;

  /// Minimum number of strings. If [lengthErrorText] is specified, an error is displayed.
  ///
  /// 文字列の最小数。[lengthErrorText]が指定されている場合、エラーが表示されます。
  final int? minLength;

  /// Maximum number of lines. No more line breaks will be allowed.
  ///
  /// 最大のライン数。これ以上は改行できなくなります。
  final int maxLines;

  /// Minimum number of lines; if a number greater than 1 is specified, the initial display of the form extends to the specified number of lines.
  ///
  /// 最小のライン数。1より大きい数が指定されている場合、フォームの初期表示が指定された行数分に広がります。
  final int minLines;

  /// Hint to be displayed on the form. Displayed when no text is entered.
  ///
  /// フォームに表示するヒント。文字が入力されていない場合表示されます。
  final String? hintText;

  /// Label text for forms.
  ///
  /// フォーム用のラベルテキスト。
  final String? labelText;

  /// Error text. Only displayed if no characters are entered.
  ///
  /// エラーテキスト。入力された文字がない場合のみ表示されます。
  final String? emptyErrorText;

  /// Text to be displayed if the number of characters is less than or equal to [minLength]. If this is not [Null], an error is checked and displayed.
  ///
  /// 文字数が[minLength]以下の場合に表示するテキスト。これが[Null]以外の場合、エラーチェックされ表示されます。
  final String? lengthErrorText;

  /// Text of the character counter. Default is disabled.
  ///
  /// 文字数のカウンターのテキスト。デフォルトは無効化されています。
  final String? counterText;

  /// Builder for building character count counters. It is used in preference to [counterText].
  ///
  /// The current input text is passed to [text].
  ///
  /// 文字数のカウンターを構築するためのビルダー。[counterText]より優先して利用されます。
  ///
  /// [text]には現在入力中の文字が渡されます。
  final String? Function(String text)? counterbuilder;

  /// If this is `false`, it is deactivated.
  ///
  /// In addition to disabling input, the form design, etc., will also be changed to a deactivated version.
  ///
  /// これが`false`の場合、非有効化されます。
  ///
  /// 入力ができなくなる他、フォームのデザイン等も非有効化されたものに変更されます。
  final bool enabled;

  /// If this is `true`, the form cannot be filled out and changed from its initial value.
  ///
  /// これが`true`の場合、フォームの入力が行えずに初期値から変更することができなくなります。
  final bool readOnly;

  /// If this is `true`, the input will be hidden. Use this to enter passwords, etc.
  ///
  /// これが`true`の場合、入力された内容が隠されます。パスワードの入力等にご利用ください。
  final bool obscureText;

  /// If this is `true`, the text field will be stretched vertically. If there is no height limit, an error will result.
  ///
  /// これが`true`の場合、テキストフィールドが縦に引き伸ばされます。高さの上限がない場合エラーとなります。
  final bool expands;

  /// If this is `true`, the cursor is displayed.
  ///
  /// これが`true`の場合、カーソルを表示します。
  final bool? showCursor;

  /// Suggestions setting. When enabled, the suggestions window will be displayed.
  ///
  /// サジェストの設定。これが有効になっているとサジェストウインドウが表示されます。
  final SuggestionConfig? suggestion;

  /// Callback executed when [FormController.validate] is executed.
  ///
  /// The current value is passed to `value`.
  ///
  /// [FormController.validate]が実行されたときに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final TValue Function(String value)? onSaved;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(String? value)? onChanged;

  /// A callback that returns the value at the time when the focus is changed.
  ///
  /// The `value` is passed the current value and `hasFocus` is passed whether the focus is on or not.
  ///
  /// フォーカスが変更されたときにそのときの値を返すコールバック。
  ///
  /// `value`に現在の値が渡され、`hasFocus`にフォーカスが当たっているかどうかが渡されます。
  final void Function(String? value, bool hasFocus)? onFocusChanged;

  /// It is executed when the Enter button on the keyboard or the Submit button on the software keyboard is pressed.
  ///
  /// The current value is passed to `value`.
  ///
  /// キーボードのEnterボタン、もしくはソフトウェアキーボードのサブミットボタンが押された場合に実行されます。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(String? value)? onSubmitted;

  /// Validator to be executed when [FormController.validate] is executed.
  ///
  /// It is executed before [onSaved] is called.
  ///
  /// The current value is passed to `value` and if it returns a value other than [Null], the character is displayed as error text.
  ///
  /// If a character other than [Null] is returned, [onSaved] will not be executed and [FormController.validate] will return `false`.
  ///
  /// [FormController.validate]が実行されたときに実行されるバリデーター。
  ///
  /// [onSaved]が呼ばれる前に実行されます。
  ///
  /// `value`に現在の値が渡され、[Null]以外の値を返すとその文字がエラーテキストとして表示されます。
  ///
  /// [Null]以外の文字を返した場合、[onSaved]は実行されず、[FormController.validate]が`false`が返されます。
  final String? Function(String? value)? validator;

  /// Executed when the form is tapped.
  ///
  /// フォームをタップした場合に実行されます。
  final VoidCallback? onTap;

  /// List of [TextInputFormatter].
  ///
  /// [TextInputFormatter] allows you to restrict the text to be input.
  ///
  /// [TextInputFormatter]のリスト。
  ///
  /// [TextInputFormatter]を指定することで入力するテキストを制限することが可能になります。
  final List<TextInputFormatter>? inputFormatters;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  /// If `true`, focus is automatically applied.
  ///
  /// `true`の場合、自動でフォーカスが当たります。
  final bool autofocus;

  /// If Submitted, the contents will be erased.
  ///
  /// Submitされた場合、中身を消去します。
  final bool clearOnSubmitted;

  /// `true` to modify auto-entered text.
  ///
  /// 自動で入力されたテキストを修正する場合`true`。
  final bool autocorrect;

  /// Specifies the behavior when focused.
  ///
  /// フォーカスされたときの挙動を指定します。
  final FormTextFieldSelectionOnFocus selectionOnFocus;

  @override
  State<StatefulWidget> createState() => _FormTextFieldState<TValue>();
}

class _FormTextFieldState<TValue> extends State<FormTextField<TValue>>
    with AutomaticKeepAliveClientMixin<FormTextField<TValue>> {
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  FocusNode? get _effectiveFocusNode => widget.focusNode ?? _focusNode;
  TextEditingController? _controller;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    if (widget.initialValue != null) {
      _effectiveController?.text = widget.initialValue!;
    }
    _effectiveController?.addListener(_handledOnUpdate);
    _effectiveFocusNode?.addListener(_handledOnFocused);
  }

  @override
  void didUpdateWidget(FormTextField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      if (widget.controller == null && _controller == null) {
        _controller = TextEditingController(text: widget.initialValue);
        _controller?.addListener(_handledOnUpdate);
      }
      oldWidget.controller?.removeListener(_handledOnUpdate);
      widget.controller?.addListener(_handledOnUpdate);
    }
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      _effectiveController?.text = widget.initialValue!;
    }
    if (oldWidget.focusNode != widget.focusNode) {
      if (widget.focusNode == null && _focusNode == null) {
        _focusNode = FocusNode();
        _focusNode?.addListener(_handledOnFocused);
      }
      oldWidget.focusNode?.removeListener(_handledOnFocused);
      widget.focusNode?.addListener(_handledOnFocused);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _effectiveFocusNode?.removeListener(_handledOnFocused);
    _focusNode?.dispose();
    _effectiveController?.removeListener(_handledOnUpdate);
    _controller?.dispose();
  }

  void _handledOnFocused() {
    if (_effectiveController != null) {
      switch (widget.selectionOnFocus) {
        case FormTextFieldSelectionOnFocus.selectAll:
          _effectiveController?.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _effectiveController!.value.text.length,
          );
          break;
        default:
          _effectiveController?.selection = TextSelection.fromPosition(
            TextPosition(offset: _effectiveController?.text.length ?? 0),
          );
          break;
      }
    }
    _handledOnUpdate();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final mainTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.color,
        ) ??
        TextStyle(
          color: widget.style?.color ?? theme.textTheme.titleMedium?.color,
        );
    final subTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.subColor,
        ) ??
        TextStyle(
          color: widget.style?.subColor ??
              widget.style?.color?.withValues(alpha: 0.5) ??
              theme.textTheme.titleMedium?.color?.withValues(alpha: 0.5),
        );
    final errorTextStyle = widget.style?.errorTextStyle?.copyWith(
          color: widget.style?.errorColor,
        ) ??
        widget.style?.textStyle?.copyWith(
          color: widget.style?.errorColor,
        ) ??
        TextStyle(
          color: widget.style?.errorColor ?? theme.colorScheme.error,
        );
    final disabledTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.disabledColor,
        ) ??
        TextStyle(
          color: widget.style?.disabledColor ?? theme.disabledColor,
        );
    InputBorder getBorderSide(Color borderColor) {
      switch (widget.style?.borderStyle) {
        case FormInputBorderStyle.outline:
          return OutlineInputBorder(
            borderRadius: widget.style?.borderRadius ??
                const BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(
              color: borderColor,
              width: widget.style?.borderWidth ?? 1.0,
            ),
          );
        case FormInputBorderStyle.underline:
          return UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.style?.borderColor ?? theme.dividerColor,
              width: widget.style?.borderWidth ?? 1.0,
            ),
            borderRadius: widget.style?.borderRadius ??
                const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
          );
        default:
          return const OutlineInputBorder(
            borderSide: BorderSide.none,
          );
      }
    }

    final borderSide =
        getBorderSide(widget.style?.borderColor ?? theme.dividerColor);
    final errorBorderSide =
        getBorderSide(widget.style?.errorColor ?? theme.colorScheme.error);
    final disabledBorderSide =
        getBorderSide(widget.style?.disabledColor ?? theme.disabledColor);

    return FormStyleScope(
      style: widget.style,
      enabled: widget.enabled,
      child: _SuggestionOverlayBuilder(
        suggestion: widget.suggestion,
        controller: _effectiveController,
        focusNode: _effectiveFocusNode,
        builder: (context, controller, onTap) => Container(
          alignment: widget.style?.alignment,
          padding:
              widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 0),
          child: SizedBox(
            height: widget.style?.height,
            width: widget.style?.width,
            child: _focusBuild(
              context,
              child: _TextFormField<TValue>(
                key: widget.key,
                form: widget.form,
                autocorrect: widget.autocorrect,
                cursorColor: widget.style?.cursorColor,
                inputFormatters: widget.inputFormatters,
                focusNode: _effectiveFocusNode,
                textAlign: widget.style?.textAlign ?? TextAlign.left,
                textAlignVertical: widget.style?.textAlignVertical,
                showCursor: widget.showCursor,
                enabled: widget.enabled,
                controller: controller,
                autofocus: widget.autofocus,
                keyboardType: widget.expands || widget.minLines > 1
                    ? TextInputType.multiline
                    : widget.keyboardType,
                maxLength: widget.maxLength,
                maxLines: (widget.obscureText
                    ? 1
                    : (widget.expands
                        ? null
                        : max(widget.maxLines, widget.minLines))),
                minLines: widget.obscureText
                    ? 1
                    : (widget.expands ? null : widget.minLines),
                expands: !widget.obscureText && widget.expands,
                decoration: InputDecoration(
                  contentPadding: widget.style?.contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  fillColor: widget.style?.backgroundColor,
                  filled: widget.style?.backgroundColor != null,
                  isDense: true,
                  border: widget.style?.border ?? borderSide,
                  enabledBorder: widget.style?.border ?? borderSide,
                  disabledBorder: widget.style?.disabledBorder ??
                      widget.style?.border ??
                      disabledBorderSide,
                  errorBorder: widget.style?.errorBorder ??
                      widget.style?.border ??
                      errorBorderSide,
                  focusedBorder: widget.style?.border ?? borderSide,
                  focusedErrorBorder: widget.style?.errorBorder ??
                      widget.style?.border ??
                      errorBorderSide,
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                  counterText: widget.counterbuilder
                          ?.call(_effectiveController?.text ?? "") ??
                      widget.counterText,
                  prefix: widget.prefix?.child ?? widget.style?.prefix?.child,
                  suffix: widget.suffix?.child ?? widget.style?.suffix?.child,
                  prefixIcon: widget.prefix?.icon ?? widget.style?.prefix?.icon,
                  suffixIcon: widget.suffix?.icon ?? widget.style?.suffix?.icon,
                  prefixText:
                      widget.prefix?.label ?? widget.style?.prefix?.label,
                  suffixText:
                      widget.suffix?.label ?? widget.style?.suffix?.label,
                  prefixIconColor: widget.prefix?.iconColor ??
                      widget.style?.prefix?.iconColor,
                  suffixIconColor: widget.suffix?.iconColor ??
                      widget.style?.suffix?.iconColor,
                  prefixIconConstraints: widget.prefix?.iconConstraints ??
                      widget.style?.prefix?.iconConstraints,
                  suffixIconConstraints: widget.suffix?.iconConstraints ??
                      widget.style?.suffix?.iconConstraints,
                  labelStyle:
                      widget.enabled ? mainTextStyle : disabledTextStyle,
                  hintStyle: subTextStyle,
                  suffixStyle: subTextStyle,
                  prefixStyle: subTextStyle,
                  counterStyle: subTextStyle,
                  helperStyle: subTextStyle,
                  errorStyle: errorTextStyle,
                ),
                style: widget.enabled ? mainTextStyle : disabledTextStyle,
                obscureText: widget.obscureText,
                readOnly: widget.readOnly,
                onFieldSubmitted: (value) {
                  widget.onSubmitted?.call(value);
                },
                onTap: widget.enabled
                    ? () {
                        if (widget.onTap != null) {
                          widget.onTap?.call();
                        } else {
                          onTap.call();
                        }
                      }
                    : null,
                validator: (value) {
                  if (widget.emptyErrorText.isNotEmpty && value.isEmpty) {
                    return widget.emptyErrorText;
                  }
                  if (widget.lengthErrorText.isNotEmpty &&
                      widget.minLength.def(0) > value.length) {
                    return widget.lengthErrorText;
                  }
                  return widget.validator?.call(value);
                },
                onChanged: widget.onChanged,
                onSaved: (value) {
                  if (value == null) {
                    return;
                  }
                  final res = widget.onSaved?.call(value);
                  if (res == null) {
                    return;
                  }
                  widget.form!.value = res;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _focusBuild(
    BuildContext context, {
    required Widget child,
  }) {
    if (widget.onFocusChanged != null) {
      return Focus(
        onFocusChange: (hasFocus) {
          widget.onFocusChanged?.call(_effectiveController?.text, hasFocus);
        },
        child: child,
      );
    }
    return child;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

class _SuggestionOverlayBuilder extends StatefulWidget {
  const _SuggestionOverlayBuilder({
    required this.builder,
    this.focusNode,
    this.controller,
    this.suggestion,
  });

  final SuggestionConfig? suggestion;

  final FocusNode? focusNode;

  final TextEditingController? controller;

  final Widget Function(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onTap,
  ) builder;

  @override
  State<StatefulWidget> createState() => _SuggestionOverlayBuilderState();
}

class _SuggestionOverlayBuilderState extends State<_SuggestionOverlayBuilder> {
  OverlayEntry? _overlay;
  TextEditingController? _controller;
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  String? _previousText;

  final LayerLink _layerLink = LayerLink();
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    widget.focusNode?.addListener(_listener);
    _effectiveController?.addListener(_listener);
  }

  @override
  void didUpdateWidget(_SuggestionOverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_listener);
      widget.controller?.addListener(_listener);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      }
      if (widget.controller != null) {
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_listener);
      widget.focusNode?.addListener(_listener);
    }
  }

  void _listener() {
    if (_overlay != null) {
      return;
    }
    final suggestion = widget.suggestion;
    if (_effectiveController == null || suggestion == null) {
      return;
    }
    if (suggestion.items.isEmpty) {
      return;
    }
    final checkShow = suggestion.checkShowOverlay;
    final search = _effectiveController?.text;
    final previousText = _previousText;
    _previousText = search;
    if (widget.focusNode != null &&
        widget.focusNode!.hasFocus &&
        search.isEmpty &&
        suggestion.showOnEmpty) {
      _updateOverlay();
      return;
    }
    if (!checkShow(search, previousText, suggestion)) {
      return;
    }
    _updateOverlay();
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode?.removeListener(_listener);
    _effectiveController?.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = widget.suggestion;
    if (suggestion == null || suggestion.items.isEmpty) {
      return widget.builder(
        context,
        _effectiveController!,
        suggestion?.onTapForm ?? () {},
      );
    }
    return PopScope(
      canPop: _overlay == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _overlay?.remove();
          _overlay = null;
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: widget.builder(
          context,
          _effectiveController!,
          () {
            if (suggestion.showOnTap) {
              _updateOverlay();
            }
            suggestion.onTapForm?.call();
          },
        ),
      ),
    );
  }

  void _updateOverlay() {
    final suggestion = widget.suggestion;
    if (suggestion == null || suggestion.items.isEmpty) {
      return;
    }
    final itemBox = context.findRenderObject() as RenderBox?;
    if (itemBox == null) {
      return;
    }
    final theme = Theme.of(context);
    final textFieldSize = itemBox.size;
    final width = textFieldSize.width;
    final height = textFieldSize.height;
    final rect = itemBox.localToGlobal(Offset.zero) & textFieldSize;
    final screen = MediaQuery.of(context).size;
    final up = rect.top > (screen.height / 2.0);
    _overlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlay?.remove();
              _overlay = null;
            },
            child: Container(
              constraints: const BoxConstraints.expand(),
              color: Colors.transparent,
            ),
          ),
          Positioned(
            width: width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, -(widget.suggestion?.style.maxHeight ?? 260)),
              child: SizedBox(
                width: width,
                child: _SuggestionOverlay(
                  suggestion: suggestion,
                  color: suggestion.style.color ?? theme.colorScheme.onSurface,
                  offset: Offset(
                    suggestion.style.offset.dx,
                    up
                        ? suggestion.style.offset.dy
                        : suggestion.style.maxHeight +
                            height +
                            suggestion.style.offset.dy,
                  ),
                  maxHeight: suggestion.style.maxHeight,
                  direction: up ? VerticalDirection.up : VerticalDirection.down,
                  backgroundColor: suggestion.style.backgroundColor ??
                      theme.colorScheme.surface,
                  controller: _effectiveController!,
                  elevation: suggestion.style.elevation,
                  onTap: () {
                    _overlay?.remove();
                    _overlay = null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (_overlay != null) {
      Navigator.of(context).overlay?.insert(_overlay!);
    }
  }
}

class _SuggestionOverlay extends StatefulWidget {
  const _SuggestionOverlay({
    required this.suggestion,
    this.controller,
    this.offset = Offset.zero,
    this.maxHeight = 260,
    this.direction = VerticalDirection.down,
    this.elevation = 8.0,
    this.color = Colors.black,
    this.onTap,
    this.backgroundColor = Colors.white,
  });
  final SuggestionConfig suggestion;
  final double elevation;
  final Color backgroundColor;
  final Color color;
  final VerticalDirection direction;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final double maxHeight;
  final Offset offset;
  @override
  State<StatefulWidget> createState() => _SuggestionOverlayState();
}

class _SuggestionOverlayState extends State<_SuggestionOverlay> {
  String? _search;
  TextEditingController? _controller;
  List<String> _items = [];
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    _items = widget.suggestion.items;
    _controller = widget.controller ?? TextEditingController();
    _search = _effectiveController?.text;
    _effectiveController?.addListener(_listener);
  }

  @override
  void didUpdateWidget(_SuggestionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.suggestion.items != oldWidget.suggestion.items) {
      _items = widget.suggestion.items;
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_listener);
      widget.controller?.addListener(_listener);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      }
      if (widget.controller != null) {
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  void _listener() {
    setState(() {
      _search = _effectiveController?.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _effectiveController?.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveController = _effectiveController;
    final widgets = _items.mapAndRemoveEmpty(
      (e) {
        if (effectiveController != null &&
            !widget.suggestion.checkShowSuggestion(
                _search, effectiveController, widget.suggestion)) {
          return null;
        }
        return GestureDetector(
          onTap: () {
            if (effectiveController != null) {
              widget.suggestion.onTapSuggestion
                  ?.call(e, effectiveController, widget.suggestion);
            }
            widget.onTap?.call();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints.expand(height: 50),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e,
                    style: TextStyle(fontSize: 18, color: widget.color),
                  ),
                ),
                if (widget.suggestion.onDelete != null)
                  Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      icon: Icon(Icons.close, size: 20, color: widget.color),
                      onPressed: () {
                        setState(() {
                          _items.remove(e);
                          widget.suggestion.onDelete?.call(e);
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (widgets.isEmpty) {
      widget.onTap?.call();
      return const SizedBox.shrink();
    }
    final height = min((widgets.length * 50).toDouble() + 20, widget.maxHeight);

    final offset = widget.offset.dy +
        (widget.direction == VerticalDirection.down
            ? 0
            : (widget.maxHeight - height));
    return Container(
      height: height + offset,
      padding: EdgeInsets.only(top: offset),
      child: Card(
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
          borderRadius:
              widget.suggestion.style.borderRadius ?? BorderRadius.zero,
          side: widget.suggestion.style.border ?? BorderSide.none,
        ),
        color: widget.backgroundColor,
        surfaceTintColor: widget.backgroundColor,
        child: SingleChildScrollView(
          reverse: widget.direction == VerticalDirection.up,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            verticalDirection: widget.direction,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
        ),
      ),
    );
  }
}

class _TextFormField<TValue> extends FormField<String> {
  _TextFormField({
    super.key,
    this.controller,
    this.form,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    bool? showCursor,
    String obscuringCharacter = "•",
    bool obscureText = false,
    bool autocorrect = false,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    super.onSaved,
    super.validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool? enableInteractiveSelection,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    ScrollController? scrollController,
    super.restorationId,
    bool enableIMEPersonalizedLearning = true,
    MouseCursor? mouseCursor,
  })  : assert(maxLines == null || maxLines > 0,
            "maxLines is not null and is not greater than 0"),
        assert(minLines == null || minLines > 0,
            "minLines is not null and is not greater than 0"),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          "minLines and maxLines must be null when expands is true.",
        ),
        assert(
          !obscureText || maxLines == 1,
          "Obscured fields cannot be multiline.",
        ),
        assert(
          maxLength == null ||
              maxLength == TextField.noMaxLength ||
              maxLength > 0,
          "maxLength is not null and is not equal to TextField.noMaxLength and is not greater than 0",
        ),
        super(
          initialValue:
              controller != null ? controller.text : (initialValue ?? ""),
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<String> field) {
            final state = field as _TextFormFieldState<TValue>;
            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TextField(
                restorationId: restorationId,
                controller: state._effectiveController,
                focusNode: focusNode,
                decoration:
                    effectiveDecoration.copyWith(errorText: field.errorText),
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                textDirection: textDirection,
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                readOnly: readOnly,
                showCursor: showCursor,
                obscuringCharacter: obscuringCharacter,
                obscureText: obscureText,
                autocorrect: autocorrect,
                smartDashesType: smartDashesType ??
                    (obscureText
                        ? SmartDashesType.disabled
                        : SmartDashesType.enabled),
                smartQuotesType: smartQuotesType ??
                    (obscureText
                        ? SmartQuotesType.disabled
                        : SmartQuotesType.enabled),
                enableSuggestions: enableSuggestions,
                maxLengthEnforcement: maxLengthEnforcement,
                maxLines: maxLines,
                minLines: minLines,
                expands: expands,
                maxLength: maxLength,
                onChanged: onChangedHandler,
                onTap: onTap,
                onEditingComplete: onEditingComplete,
                onSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters,
                enabled: enabled ?? decoration?.enabled ?? true,
                cursorWidth: cursorWidth,
                cursorHeight: cursorHeight,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                scrollPadding: scrollPadding,
                scrollPhysics: scrollPhysics,
                keyboardAppearance: keyboardAppearance,
                enableInteractiveSelection:
                    enableInteractiveSelection ?? (!obscureText || !readOnly),
                selectionControls: selectionControls,
                buildCounter: buildCounter,
                autofillHints: autofillHints,
                scrollController: scrollController,
                enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
                mouseCursor: enabled == false
                    ? SystemMouseCursors.forbidden
                    : mouseCursor,
              ),
            );
          },
        );

  final FormController<TValue>? form;
  final TextEditingController? controller;

  @override
  FormFieldState<String> createState() => _TextFormFieldState<TValue>();
}

class _TextFormFieldState<TValue> extends FormFieldState<String> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      _textFormField.controller ?? _controller!.value;

  _TextFormField<TValue> get _textFormField =>
      super.widget as _TextFormField<TValue>;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    setValue(_effectiveController.text);
  }

  void _registerController() {
    assert(_controller != null, "controller is null");
    registerForRestoration(_controller!, "controller");
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null, "controller is not null");
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_textFormField.controller == null) {
      _createLocalController(
        widget.initialValue != null
            ? TextEditingValue(text: widget.initialValue!)
            : null,
      );
    } else {
      _textFormField.controller!.addListener(_handleControllerChanged);
    }
    _textFormField.form?.register(this);
  }

  @override
  void didUpdateWidget(_TextFormField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_textFormField.controller != null) {
        setValue(_textFormField.controller!.text);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }
    if (_textFormField.form != oldWidget.form) {
      oldWidget.form?.unregister(this);
      _textFormField.form?.register(this);
    }
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        reset();
      });
    }
  }

  @override
  void dispose() {
    _textFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    _textFormField.form?.unregister(this);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? "";
    }
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}

/// Specifies the behavior when focused.
///
/// フォーカスされたときの挙動を指定します。
enum FormTextFieldSelectionOnFocus {
  /// Select all text when focused.
  ///
  /// フォーカスされたときにテキストを全選択します。
  selectAll,

  /// Moves the cursor to the last character when in focus.
  ///
  /// フォーカスされたときに最後の文字にカーソルを移動します。
  positionAtEnd;
}

/// Configuration for suggestions.
///
/// サジェストの設定。
class SuggestionConfig {
  /// Configuration for suggestions.
  ///
  /// サジェストの設定。
  const SuggestionConfig({
    required this.items,
    this.onDelete,
    this.style = const SuggestionStyle(),
    this.onTapForm,
    this.checkShowOverlay = defaultCheckShowOverlay,
    this.checkShowSuggestion = defaultCheckShowSuggestion,
    this.showOnTap = true,
    this.showOnEmpty = true,
    this.onTapSuggestion = defaultOnTapSuggestion,
  });

  /// Default [checkShowOverlay] function.
  ///
  /// デフォルトの[checkShowOverlay]関数。
  static bool defaultCheckShowOverlay(
      String? value, String? oldValue, SuggestionConfig suggestion) {
    final wordList = value?.split(" ") ?? const <String>[];
    if (!suggestion.items.any(
      (element) =>
          element.isNotEmpty &&
          wordList.isNotEmpty &&
          wordList.last.isNotEmpty &&
          element != wordList.last &&
          element.toLowerCase().startsWith(wordList.last.toLowerCase()),
    )) {
      return false;
    }
    return true;
  }

  /// Default [checkShowSuggestion] function.
  ///
  /// デフォルトの[checkShowSuggestion]関数。
  static bool defaultCheckShowSuggestion(String? value,
      TextEditingController controller, SuggestionConfig suggestion) {
    final wordList = value?.split(" ") ?? const <String>[];
    if (!suggestion.items.any(
      (element) =>
          element.isNotEmpty &&
          wordList.isNotEmpty &&
          wordList.last.isNotEmpty &&
          element != wordList.last &&
          element.toLowerCase().startsWith(wordList.last.toLowerCase()),
    )) {
      return false;
    }
    return true;
  }

  /// Default [onTapSuggestion] function.
  ///
  /// デフォルトの[onTapSuggestion]関数。
  static void defaultOnTapSuggestion(String value,
      TextEditingController controller, SuggestionConfig suggestion) {
    final wordList = controller.text.split(" ");
    if (wordList.isNotEmpty) {
      wordList[wordList.length - 1] = value;
    }
    final text = wordList.join(" ");
    controller.clearComposing();
    controller.clear();
    controller.text = text;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  /// If you want to display suggestions as you type, pass the suggestions here.
  ///
  /// When you enter something, it will search from the string passed here and pop up only the matches.
  ///
  /// 入力の最中にサジェストを表示したい場合、その候補をここに渡します。
  ///
  /// 何かを入力するとここに渡された文字列から検索を行い、一致するものだけをポップアップで表示します。
  final List<String> items;

  /// If suggestions are displayed in [items], you can specify this to delete suggestions.
  ///
  /// A delete button will appear in the list of suggestion suggestions, and tapping it will execute this callback.
  ///
  /// [items]でサジェスト候補が表示される場合、これを指定するとサジェスト候補の削除を行うことができるようになります。
  ///
  /// サジェスト候補のリストに削除ボタンが表示されるようになり、そこをタップするとこのコールバックが実行されます。
  final void Function(String value)? onDelete;

  /// Window style for suggestions.
  ///
  /// サジェスト用のウインドウのスタイル。
  final SuggestionStyle style;

  /// Callback executed when the window for suggestions is tapped.
  ///
  /// サジェスト用のウインドウをタップした際に実行されるコールバック。
  final VoidCallback? onTapForm;

  /// Compares [value] and [oldValue] to return whether to display overlay.
  ///
  /// Returns `true` to display overlay.
  ///
  /// Returning `false` will prevent overlay from being displayed.
  ///
  /// [value]と[oldValue]を比較してオーバーレイを表示するかどうかを返します。
  ///
  /// `true`を返すとオーバーレイを表示します。
  ///
  /// `false`を返すとオーバーレイを表示しません。
  final bool Function(
          String? value, String? oldValue, SuggestionConfig suggestion)
      checkShowOverlay;

  /// Compares [value] and [oldValue] to return whether to display suggestions.
  ///
  /// Returns `true` to display suggestions.
  ///
  /// Returning `false` will prevent suggestions from being displayed.
  ///
  /// [value]と[oldValue]を比較してサジェストを表示するかどうかを返します。
  ///
  /// `true`を返すとサジェストを表示します。
  ///
  /// `false`を返すとサジェストを表示しません。
  final bool Function(String? value, TextEditingController controller,
      SuggestionConfig suggestion) checkShowSuggestion;

  /// Callback executed when the window for suggestions is tapped.
  ///
  /// サジェスト用のウインドウをタップした際に実行されるコールバック。
  final void Function(String value, TextEditingController controller,
      SuggestionConfig suggestion)? onTapSuggestion;

  /// `true` if suggestions should be displayed on top when tapped.
  ///
  /// タップ時にサジェストを最前面に表示する場合`true`.
  final bool showOnTap;

  /// `true` if suggestions should be displayed when the text is empty.
  ///
  /// テキストが空の場合にサジェストを表示する場合`true`.
  final bool showOnEmpty;
}
