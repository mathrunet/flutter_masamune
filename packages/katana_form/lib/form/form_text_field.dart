part of katana_form;

/// Widgets for text fields for forms.
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// When [FormController] is passed to [form], [onSaved] must be passed together with [form]. The contents of [onSaved] will be used to save the data.
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// Each time the content is changed, [onChanged] is executed.
///
/// When [FormController.validateAndSave] is executed, validation and data saving are performed.
///
/// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
/// Only when [lengthErrorText] is specified, if the number of characters entered is less than [minLength], it is displayed as [lengthErrorText].
///
/// Other error checking is performed by specifying [validator].
/// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
///
/// The [onSubmitted] process is executed when the Enter key or other keys are pressed.
///
/// If [suggestion] is specified, suggestions will be displayed according to what you have entered.
///
/// If [onDeleteSuggestion] is specified, a delete button is displayed on the displayed suggestions, and if the button is pressed, the process is executed when the suggestion is deleted.
///
/// If [enabled] is `false`, the text is deactivated.
///
/// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
///
/// If [obscureText] is set to `true`, the input string will be hidden. Please use this function for inputting passwords, etc.
///
/// If [inputFormatters] is specified, it is possible to restrict the characters to be entered.
///
/// フォーム用のテキストフィールド用のウィジェット。
///
/// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
///
/// [form]に[FormController]を渡した場合、[form]を渡した場合一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
///
/// [initialValue]に[FormController.value]から与えられた初期値を入力します。
///
/// 内容が変更される度[onChanged]が実行されます。
///
/// [FormController.validateAndSave]が実行された場合、バリデーションとデータの保存を行ないます。
///
/// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
/// [lengthErrorText]が指定されている時に限り、[minLength]より入力された文字数が少ない場合[lengthErrorText]として表示されます。
///
/// それ以外のエラーチェックは[validator]を指定することで行ないます。
/// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
///
/// Enterキーなどが押された場合の処理を[onSubmitted]が実行されます。
///
/// [suggestion]が指定されている場合、入力した内容に応じてサジェストが表示されます。
///
/// [onDeleteSuggestion]が指定されている場合、表示されたサジェストに削除ボタンが表示され、ボタンが押された場合、サジェスト削除時の処理が実行されます。
///
/// [enabled]が`false`になるとテキストが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
///
/// [obscureText]が`true`になると入力された文字列が隠されます。パスワードの入力などにご利用ください。
///
/// [inputFormatters]が指定されると入力される文字を制限することが可能です。
class FormTextField<TValue> extends StatefulWidget {
  /// Widgets for text fields for forms.
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// When [FormController] is passed to [form], [onSaved] must be passed together with [form]. The contents of [onSaved] will be used to save the data.
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// When [FormController.validateAndSave] is executed, validation and data saving are performed.
  ///
  /// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
  /// Only when [lengthErrorText] is specified, if the number of characters entered is less than [minLength], it is displayed as [lengthErrorText].
  ///
  /// Other error checking is performed by specifying [validator].
  /// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
  ///
  /// The [onSubmitted] process is executed when the Enter key or other keys are pressed.
  ///
  /// If [suggestion] is specified, suggestions will be displayed according to what you have entered.
  ///
  /// If [onDeleteSuggestion] is specified, a delete button is displayed on the displayed suggestions, and if the button is pressed, the process is executed when the suggestion is deleted.
  ///
  /// If [enabled] is `false`, the text is deactivated.
  ///
  /// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
  ///
  /// If [obscureText] is set to `true`, the input string will be hidden. Please use this function for inputting passwords, etc.
  ///
  /// If [inputFormatters] is specified, it is possible to restrict the characters to be entered.
  ///
  /// フォーム用のテキストフィールド用のウィジェット。
  ///
  /// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
  ///
  /// [form]に[FormController]を渡した場合、[form]を渡した場合一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
  ///
  /// [initialValue]に[FormController.value]から与えられた初期値を入力します。
  ///
  /// 内容が変更される度[onChanged]が実行されます。
  ///
  /// [FormController.validateAndSave]が実行された場合、バリデーションとデータの保存を行ないます。
  ///
  /// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
  /// [lengthErrorText]が指定されている時に限り、[minLength]より入力された文字数が少ない場合[lengthErrorText]として表示されます。
  ///
  /// それ以外のエラーチェックは[validator]を指定することで行ないます。
  /// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
  ///
  /// Enterキーなどが押された場合の処理を[onSubmitted]が実行されます。
  ///
  /// [suggestion]が指定されている場合、入力した内容に応じてサジェストが表示されます。
  ///
  /// [onDeleteSuggestion]が指定されている場合、表示されたサジェストに削除ボタンが表示され、ボタンが押された場合、サジェスト削除時の処理が実行されます。
  ///
  /// [enabled]が`false`になるとテキストが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
  ///
  /// [obscureText]が`true`になると入力された文字列が隠されます。パスワードの入力などにご利用ください。
  ///
  /// [inputFormatters]が指定されると入力される文字を制限することが可能です。
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
    this.maxLines,
    this.minLines = 1,
    this.expands = false,
    this.hintText,
    this.labelText,
    this.lengthErrorText,
    this.suggestion = const [],
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.counterText = "",
    this.onDeleteSuggestion,
    this.validator,
    this.inputFormatters,
    this.onSaved,
    this.onSubmitted,
    this.onChanged,
    this.showCursor,
    this.focusNode,
    this.emptyErrorText,
    this.initialValue,
    this.onTapSuggestion,
    this.suggestionStyle,
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
  final int? maxLines;

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

  /// If you want to display suggestions as you type, pass the suggestions here.
  ///
  /// When you enter something, it will search from the string passed here and pop up only the matches.
  ///
  /// 入力の最中にサジェストを表示したい場合、その候補をここに渡します。
  ///
  /// 何かを入力するとここに渡された文字列から検索を行い、一致するものだけをポップアップで表示します。
  final List<String> suggestion;

  /// If suggestions are displayed in [suggestion], you can specify this to delete suggestions.
  ///
  /// A delete button will appear in the list of suggestion suggestions, and tapping it will execute this callback.
  ///
  /// [suggestion]でサジェスト候補が表示される場合、これを指定するとサジェスト候補の削除を行うことができるようになります。
  ///
  /// サジェスト候補のリストに削除ボタンが表示されるようになり、そこをタップするとこのコールバックが実行されます。
  final void Function(String value)? onDeleteSuggestion;

  /// Window style for suggestions.
  ///
  /// サジェスト用のウインドウのスタイル。
  final SuggestionStyle? suggestionStyle;

  /// Callback executed when the window for suggestions is tapped.
  ///
  /// サジェスト用のウインドウをタップした際に実行されるコールバック。
  final VoidCallback? onTapSuggestion;

  /// Callback executed when [FormController.validateAndSave] is executed.
  ///
  /// The current value is passed to `value`.
  ///
  /// [FormController.validateAndSave]が実行されたときに実行されるコールバック。
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

  /// It is executed when the Enter button on the keyboard or the Submit button on the software keyboard is pressed.
  ///
  /// The current value is passed to `value`.
  ///
  /// キーボードのEnterボタン、もしくはソフトウェアキーボードのサブミットボタンが押された場合に実行されます。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(String? value)? onSubmitted;

  /// Validator to be executed when [FormController.validateAndSave] is executed.
  ///
  /// It is executed before [onSaved] is called.
  ///
  /// The current value is passed to `value` and if it returns a value other than [Null], the character is displayed as error text.
  ///
  /// If a character other than [Null] is returned, [onSaved] will not be executed and [FormController.validateAndSave] will return `false`.
  ///
  /// [FormController.validateAndSave]が実行されたときに実行されるバリデーター。
  ///
  /// [onSaved]が呼ばれる前に実行されます。
  ///
  /// `value`に現在の値が渡され、[Null]以外の値を返すとその文字がエラーテキストとして表示されます。
  ///
  /// [Null]以外の文字を返した場合、[onSaved]は実行されず、[FormController.validateAndSave]が`false`が返されます。
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

  @override
  State<StatefulWidget> createState() => _FormTextFieldState<TValue>();
}

class _FormTextFieldState<TValue> extends State<FormTextField<TValue>> {
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }
    if (widget.initialValue != null) {
      _effectiveController?.text = widget.initialValue!;
    }
    _effectiveController?.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(FormTextField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handledOnUpdate);
      widget.controller?.addListener(_handledOnUpdate);
    }
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      _effectiveController?.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _effectiveController?.removeListener(_handledOnUpdate);
    _controller?.dispose();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mainTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.color,
        ) ??
        TextStyle(
          color: widget.style?.color ??
              Theme.of(context).textTheme.subtitle1?.color ??
              Theme.of(context).colorScheme.onBackground,
        );
    final subTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.subColor,
        ) ??
        TextStyle(
          color: widget.style?.subColor ??
              widget.style?.color?.withOpacity(0.5) ??
              Theme.of(context).textTheme.subtitle1?.color?.withOpacity(0.5) ??
              Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        );
    final errorTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.errorColor,
        ) ??
        TextStyle(
          color:
              widget.style?.errorColor ?? Theme.of(context).colorScheme.error,
        );
    const borderSide = OutlineInputBorder(
      borderSide: BorderSide.none,
    );

    return _SuggestionOverlayBuilder(
      items: widget.suggestion,
      onTap: widget.onTapSuggestion,
      style: widget.suggestionStyle ?? const SuggestionStyle(),
      onDeleteSuggestion: widget.onDeleteSuggestion,
      controller: _effectiveController,
      focusNode: widget.focusNode,
      builder: (context, controller, onTap) => Container(
        height: widget.style?.height,
        width: widget.style?.width,
        padding:
            widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: _TextFormField<TValue>(
          key: widget.key,
          form: widget.form,
          cursorColor: widget.style?.cursorColor,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          textAlign: widget.style?.textAlign ?? TextAlign.left,
          textAlignVertical: widget.style?.textAlignVertical,
          showCursor: widget.showCursor,
          enabled: widget.enabled,
          controller: controller,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          maxLines: widget.obscureText
              ? 1
              : (widget.expands ? null : widget.maxLines),
          minLines: widget.obscureText
              ? 1
              : (widget.expands ? null : widget.minLines),
          expands: !widget.obscureText && widget.expands,
          decoration: InputDecoration(
            contentPadding: widget.style?.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            fillColor: widget.style?.backgroundColor,
            filled: widget.style?.backgroundColor != null,
            isDense: true,
            border: widget.style?.border ?? borderSide,
            enabledBorder: widget.style?.border ?? borderSide,
            disabledBorder: widget.style?.disabledBorder ??
                widget.style?.border ??
                borderSide,
            errorBorder:
                widget.style?.errorBorder ?? widget.style?.border ?? borderSide,
            focusedBorder: widget.style?.border ?? borderSide,
            focusedErrorBorder:
                widget.style?.errorBorder ?? widget.style?.border ?? borderSide,
            hintText: widget.hintText,
            labelText: widget.labelText,
            counterText: widget.counterText,
            prefix: widget.prefix?.child ?? widget.style?.prefix?.child,
            suffix: widget.suffix?.child ?? widget.style?.suffix?.child,
            prefixIcon: widget.prefix?.icon ?? widget.style?.prefix?.icon,
            suffixIcon: widget.suffix?.icon ?? widget.style?.suffix?.icon,
            prefixText: widget.prefix?.label ?? widget.style?.prefix?.label,
            suffixText: widget.suffix?.label ?? widget.style?.suffix?.label,
            prefixIconColor:
                widget.prefix?.iconColor ?? widget.style?.prefix?.iconColor,
            suffixIconColor:
                widget.suffix?.iconColor ?? widget.style?.suffix?.iconColor,
            prefixIconConstraints: widget.prefix?.iconConstraints ??
                widget.style?.prefix?.iconConstraints,
            suffixIconConstraints: widget.suffix?.iconConstraints ??
                widget.style?.suffix?.iconConstraints,
            labelStyle: mainTextStyle,
            hintStyle: subTextStyle,
            suffixStyle: subTextStyle,
            prefixStyle: subTextStyle,
            counterStyle: subTextStyle,
            helperStyle: subTextStyle,
            errorStyle: errorTextStyle,
          ),
          style: mainTextStyle,
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
    );
  }
}

/// Class that defines the design for suggestions.
///
/// サジェスト用のデザインを定義するクラス。
@immutable
class SuggestionStyle {
  /// Class that defines the design for suggestions.
  ///
  /// サジェスト用のデザインを定義するクラス。
  const SuggestionStyle({
    this.offset = const Offset(0, 20),
    this.showOnTap = true,
    this.elevation = 8.0,
    this.backgroundColor,
    this.color,
    this.maxHeight = 260,
  });

  /// Offset at which to place the suggestion overlay.
  ///
  /// Specifies the offset from the form position.
  ///
  /// サジェストのオーバーレイを配置するオフセット。
  ///
  /// フォームの位置からのオフセットを指定します。
  final Offset offset;

  /// Suggestions window height.
  ///
  /// サジェストのウインドウの高さ。
  final double elevation;

  /// Background color of the Suggestions window.
  ///
  /// サジェストのウインドウの背景色。
  final Color? backgroundColor;

  /// Text color of the Suggestions window.
  ///
  /// サジェストのウインドウの文字色。
  final Color? color;

  /// `true` if you want to display on the frontmost side.
  ///
  /// 最前面に表示する場合`true`.
  final bool showOnTap;

  /// Maximum height of the suggestion window.
  ///
  /// サジェストのウインドウの最大高さ。
  final double maxHeight;
}

class _SuggestionOverlayBuilder extends StatefulWidget {
  const _SuggestionOverlayBuilder({
    required this.builder,
    required this.items,
    this.onDeleteSuggestion,
    this.style = const SuggestionStyle(),
    this.onTap,
    this.focusNode,
    this.controller,
  });

  final List<String> items;

  final SuggestionStyle style;

  final FocusNode? focusNode;

  final VoidCallback? onTap;

  final TextEditingController? controller;

  final void Function(String value)? onDeleteSuggestion;

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

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
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
    if (_effectiveController == null) {
      return;
    }
    if (widget.items.isEmpty) {
      return;
    }
    final search = _effectiveController?.text;
    final wordList = search?.split(" ") ?? const <String>[];
    if (widget.focusNode != null &&
        widget.focusNode!.hasFocus &&
        search.isEmpty) {
      _updateOverlay();
      return;
    }
    if (!widget.items.any(
      (element) =>
          element.isNotEmpty &&
          wordList.isNotEmpty &&
          wordList.last.isNotEmpty &&
          element != wordList.last &&
          element.toLowerCase().startsWith(wordList.last.toLowerCase()),
    )) {
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
    if (widget.items.isEmpty) {
      return widget.builder(
        context,
        _effectiveController!,
        widget.onTap ?? () {},
      );
    }
    return WillPopScope(
      onWillPop: () {
        if (_overlay == null) {
          return Future.value(true);
        } else {
          _overlay!.remove();
          _overlay = null;
          return Future.value(false);
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: widget.builder(
          context,
          _effectiveController!,
          () {
            if (widget.style.showOnTap) {
              _updateOverlay();
            }
            widget.onTap?.call();
          },
        ),
      ),
    );
  }

  void _updateOverlay() {
    final itemBox = context.findRenderObject() as RenderBox?;
    if (itemBox == null) {
      return;
    }
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
              offset: Offset(0.0, -widget.style.maxHeight),
              child: SizedBox(
                width: width,
                child: _SuggestionOverlay(
                  items: widget.items,
                  color: widget.style.color ??
                      Theme.of(context).colorScheme.onSurface,
                  offset: Offset(
                    widget.style.offset.dx,
                    up
                        ? widget.style.offset.dy
                        : widget.style.maxHeight +
                            height +
                            widget.style.offset.dy,
                  ),
                  maxHeight: widget.style.maxHeight,
                  direction: up ? VerticalDirection.up : VerticalDirection.down,
                  onDeleteSuggestion: widget.onDeleteSuggestion,
                  backgroundColor: widget.style.backgroundColor ??
                      Theme.of(context).colorScheme.surface,
                  controller: _effectiveController!,
                  elevation: widget.style.elevation,
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
    required this.items,
    this.controller,
    this.offset = Offset.zero,
    this.maxHeight = 260,
    this.direction = VerticalDirection.down,
    this.onDeleteSuggestion,
    this.elevation = 8.0,
    this.color = Colors.black,
    this.onTap,
    this.backgroundColor = Colors.white,
  });
  final double elevation;
  final Color backgroundColor;
  final Color color;
  final List<String> items;
  final VerticalDirection direction;
  final void Function(String value)? onDeleteSuggestion;
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
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  List<String> _wordList = [];
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _search = _effectiveController?.text;
    _wordList = _search?.split(" ") ?? const <String>[];
    _effectiveController?.addListener(_listener);
  }

  @override
  void didUpdateWidget(_SuggestionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_listener);
      widget.controller?.addListener(_listener);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
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
      _wordList = _search?.split(" ") ?? const <String>[];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _effectiveController?.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    final widgets = widget.items.mapAndRemoveEmpty(
      (e) {
        if (e.isNotEmpty &&
            _wordList.isNotEmpty &&
            _wordList.last.isNotEmpty &&
            e != _wordList.last &&
            !e.toLowerCase().startsWith(_wordList.last.toLowerCase())) {
          return null;
        }
        return GestureDetector(
          onTap: () {
            if (_wordList.isNotEmpty) {
              _wordList[_wordList.length - 1] = e;
            }
            final text = _wordList.join(" ");
            _effectiveController?.clearComposing();
            _effectiveController?.clear();
            _effectiveController?.text = text;
            _effectiveController?.selection = TextSelection.fromPosition(
              TextPosition(offset: _effectiveController?.text.length ?? 0),
            );
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
                if (widget.onDeleteSuggestion != null)
                  Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      icon: Icon(Icons.close, size: 20, color: widget.color),
                      onPressed: () {
                        setState(() {
                          widget.items.remove(e);
                          widget.onDeleteSuggestion?.call(e);
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        color: widget.backgroundColor,
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
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = "•",
    bool obscureText = false,
    bool autocorrect = true,
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
  })  : assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
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
        ),
        super(
          initialValue:
              controller != null ? controller.text : (initialValue ?? ""),
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<String> field) {
            final _TextFormFieldState<TValue> state =
                field as _TextFormFieldState<TValue>;
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
                toolbarOptions: toolbarOptions,
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
                mouseCursor: mouseCursor,
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
    assert(_controller != null);
    registerForRestoration(_controller!, "controller");
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
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

  @override
  void reset() {
    _effectiveController.text = widget.initialValue ?? "";
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}
