part of '/katana_form.dart';

/// Form to have the duration selected.
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// Each time the content is changed, [onChanged] is executed.
///
/// If [FormController.validate] is executed, validation and data saving are performed.
///
/// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
///
/// Other error checking is performed by specifying [validator].
/// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
///
/// The [onSubmitted] process is executed when the Enter key or other keys are pressed.
///
/// The interval selection method can be set by specifying [picker].
///
/// If [enabled] is `false`, the text is deactivated.
///
/// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
///
/// デュレーションを選択させるためのフォーム。
///
/// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
///
/// [form]に[FormController]を渡した場合、一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
///
/// [initialValue]に[FormController.value]から与えられた初期値を入力します。
///
/// 内容が変更される度[onChanged]が実行されます。
///
/// [FormController.validate]が実行された場合、バリデーションとデータの保存を行ないます。
///
/// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
///
/// それ以外のエラーチェックは[validator]を指定することで行ないます。
/// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
///
/// Enterキーなどが押された場合の処理を[onSubmitted]が実行されます。
///
/// [picker]を指定することで間隔の選択方法を設定することが可能です。
///
/// [enabled]が`false`になるとテキストが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
class FormDurationField<TValue> extends StatefulWidget {
  /// Form to have the duration selected.
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// If [FormController.validate] is executed, validation and data saving are performed.
  ///
  /// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
  ///
  /// Other error checking is performed by specifying [validator].
  /// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
  ///
  /// The [onSubmitted] process is executed when the Enter key or other keys are pressed.
  ///
  /// The interval selection method can be set by specifying [picker].
  ///
  /// If [enabled] is `false`, the text is deactivated.
  ///
  /// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
  ///
  /// デュレーションを選択させるためのフォーム。
  ///
  /// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
  ///
  /// [form]に[FormController]を渡した場合、一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
  ///
  /// [initialValue]に[FormController.value]から与えられた初期値を入力します。
  ///
  /// 内容が変更される度[onChanged]が実行されます。
  ///
  /// [FormController.validate]が実行された場合、バリデーションとデータの保存を行ないます。
  ///
  /// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
  ///
  /// それ以外のエラーチェックは[validator]を指定することで行ないます。
  /// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
  ///
  /// Enterキーなどが押された場合の処理を[onSubmitted]が実行されます。
  ///
  /// [picker]を指定することで間隔の選択方法を設定することが可能です。
  ///
  /// [enabled]が`false`になるとテキストが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
  const FormDurationField({
    this.form,
    super.key,
    this.controller,
    this.prefix,
    this.suffix,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.labelText,
    this.style,
    this.enabled = true,
    this.emptyErrorText,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
    String? format,
    this.picker = const FormDurationFieldPicker(),
    this.onSaved,
    this.keepAlive = true,
    this.showDropdownIcon = true,
    this.dropdownIcon,
  })  : _format = format,
        assert(
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
  final Duration? initialValue;

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

  /// Callback executed when [FormController.validate] is executed.
  ///
  /// The current value is passed to `value`.
  ///
  /// [FormController.validate]が実行されたときに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final TValue Function(Duration value)? onSaved;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(Duration? value)? onChanged;

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
  final FormFieldValidator<Duration?>? validator;

  /// It is executed when the Enter button on the keyboard or the Submit button on the software keyboard is pressed.
  ///
  /// The current value is passed to `value`.
  ///
  /// キーボードのEnterボタン、もしくはソフトウェアキーボードのサブミットボタンが押された場合に実行されます。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(Duration? value)? onSubmitted;

  /// Picker object for selecting intervals.
  ///
  /// 間隔を選択するためのピッカーオブジェクト。
  final FormDurationFieldPicker picker;

  /// Formatter for formatting [Duration] to [String].
  ///
  /// The following formats are available
  ///
  /// By default, `HH:mm:ss` is used.
  ///
  /// [Duration]を[String]にフォーマットするためのフォーマッタ。
  ///
  /// 下記のフォーマットが利用可能です。
  ///
  /// デフォルトだと`HH:mm:ss`が利用されます。
  ///
  /// - `d` Displays days. 日付を表示します。
  /// - `H` Displays hours. 時間を表示します。
  /// - `m` Display minutes. 分を表示します。
  /// - `s` Display seconds. 秒を表示します。
  /// - `HH` Displays hours in two digits. 時間を２桁で表示します。
  /// - `mm` Displays minutes in two digits. 分を２桁で表示します。
  /// - `ss` Displays seconds in two digits. 秒を２桁で表示します。
  /// - `S` Display milli-seconds. ミリ秒を表示します。
  /// - `M` Display micro-seconds. マイクロ秒を表示します。
  String get format {
    if (_format.isNotEmpty) {
      return _format!;
    }
    return "HH:mm:ss";
  }

  final String? _format;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  /// true` if you want to display icons for drop-downs.
  ///
  /// ドロップダウン用のアイコンを表示する場合`true`。
  final bool showDropdownIcon;

  /// Icon for dropdown. Valid only if [showDropdownIcon] is `true`.
  ///
  /// ドロップダウン用のアイコン。[showDropdownIcon]が`true`の場合のみ有効。
  final Widget? dropdownIcon;

  @override
  State<StatefulWidget> createState() => _FormDurationFieldState<TValue>();
}

class _FormDurationFieldState<TValue> extends State<FormDurationField<TValue>>
    with AutomaticKeepAliveClientMixin<FormDurationField<TValue>> {
  TextEditingController? _controller;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      return;
    }
    if (widget.initialValue != null) {
      widget.controller?.text = widget.initialValue!.format(widget.format);
    }
    _controller = TextEditingController(text: widget.controller?.text);
    _controller?.addListener(_listenerInside);
    widget.controller?.addListener(_listenerOutside);
  }

  @override
  void didUpdateWidget(FormDurationField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_listenerInside);
      widget.controller?.addListener(_listenerInside);
    }
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      widget.controller?.text = widget.initialValue!.toString();
      _controller?.text = widget.initialValue!.toString();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_listenerInside);
    widget.controller?.removeListener(_listenerOutside);
  }

  void _listenerOutside() {
    if (_controller?.text == widget.controller?.text) {
      return;
    }
    _controller?.text = widget.controller?.text ?? "";
  }

  void _listenerInside() {
    if (_controller?.text == widget.controller?.text) {
      return;
    }
    widget.controller?.text = _controller?.text ?? "";
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
              widget.style?.color?.withOpacity(0.5) ??
              theme.textTheme.titleMedium?.color?.withOpacity(0.5),
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

    return Container(
      alignment: widget.style?.alignment,
      padding:
          widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: widget.style?.height,
        width: widget.style?.width,
        child: Stack(
          children: [
            _DurationTextField<TValue>(
              form: widget.form,
              controller: _controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.text,
              initialValue: widget.initialValue,
              enabled: widget.enabled,
              decoration: InputDecoration(
                contentPadding: widget.style?.contentPadding ??
                    (widget.showDropdownIcon
                        ? const EdgeInsets.fromLTRB(16, 0, 32, 0)
                        : const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0)),
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
                labelStyle: widget.enabled ? mainTextStyle : disabledTextStyle,
                hintStyle: subTextStyle,
                suffixStyle: subTextStyle,
                prefixStyle: subTextStyle,
                counterStyle: subTextStyle,
                helperStyle: subTextStyle,
                errorStyle: errorTextStyle,
              ),
              style: widget.enabled ? mainTextStyle : disabledTextStyle,
              textAlign: widget.style?.textAlign ?? TextAlign.left,
              textAlignVertical: widget.style?.textAlignVertical,
              readOnly: widget.readOnly,
              format: widget.format,
              validator: (value) {
                if (widget.emptyErrorText.isNotEmpty && value == null) {
                  return widget.emptyErrorText;
                }
                return widget.validator?.call(value);
              },
              onSubmitted: widget.onSubmitted,
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
              picker: widget.picker,
            ),
            if (widget.showDropdownIcon)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IgnorePointer(
                    ignoring: true,
                    child: IconTheme(
                      data: IconThemeData(
                        size: 24,
                        color: widget.enabled
                            ? mainTextStyle.color
                            : disabledTextStyle.color,
                      ),
                      child: widget.dropdownIcon ??
                          const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

class _DurationTextField<TValue> extends FormField<Duration> {
  _DurationTextField({
    required this.format,
    this.form,
    required this.picker,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    this.onChanged,
    this.controller,
    this.focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    this.readOnly = true,
    bool? showCursor,
    bool obscureText = false,
    bool autocorrect = false,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    VoidCallback? onEditingComplete,
    this.onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
  }) : super(
          builder: (field) {
            final _DurationTextFieldState<TValue> state =
                field as _DurationTextFieldState<TValue>;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return TextField(
              mouseCursor: enabled == false
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              controller: state._effectiveController ??
                  TextEditingController(
                    text: state.value?.format(state.widget.format),
                  ),
              focusNode: state._effectiveFocusNode,
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
              ),
              keyboardType: keyboardType,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textCapitalization: textCapitalization,
              autofocus: autofocus,
              readOnly: true,
              showCursor: showCursor,
              obscureText: obscureText,
              autocorrect: autocorrect,
              maxLines: maxLines,
              minLines: minLines,
              expands: expands,
              maxLength: maxLength,
              onChanged: (text) => field.didChange(state.parse(text)),
              onEditingComplete: onEditingComplete,
              onSubmitted: (text) => onSubmitted?.call(state.parse(text)),
              inputFormatters: inputFormatters,
              enabled: enabled,
              cursorWidth: cursorWidth,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection,
              buildCounter: buildCounter,
            );
          },
        );

  final FormController<TValue>? form;
  final String format;

  final FormDurationFieldPicker picker;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final void Function(Duration? value)? onChanged;
  final void Function(Duration? value)? onSubmitted;

  @override
  _DurationTextFieldState createState() => _DurationTextFieldState<TValue>();
}

class _DurationTextFieldState<TValue> extends FormFieldState<Duration> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  _DurationTextField<TValue> get widget =>
      super.widget as _DurationTextField<TValue>;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  FocusNode? get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  bool get hasFocus => _effectiveFocusNode?.hasFocus ?? false;
  bool get hasText => _effectiveController?.text.isNotEmpty ?? false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: format(widget.initialValue));
      _controller?.addListener(_handleControllerChanged);
    }
    if (value == null) {
      setValue(parse(_effectiveController?.text ?? "") ?? widget.initialValue);
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _focusNode?.addListener(_handleFocusChanged);
    }
    widget.form?.register(this);
    widget.controller?.addListener(_handleControllerChanged);
    widget.focusNode?.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(_DurationTextField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
        _controller?.addListener(_handleControllerChanged);
      }
      if (widget.controller != null) {
        setValue(parse(widget.controller?.text ?? ""));
        if (oldWidget.controller == null) {
          _controller?.dispose();
          _controller = null;
        }
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      widget.focusNode?.addListener(_handleFocusChanged);

      if (oldWidget.focusNode != null && widget.focusNode == null) {
        _focusNode = FocusNode();
        _focusNode?.addListener(_handleFocusChanged);
      }
      if (widget.focusNode != null && oldWidget.focusNode == null) {
        // Release the focus node since it wont be used
        _focusNode?.dispose();
        _focusNode = null;
      }
    }
    if (widget.format != oldWidget.format) {
      if (_effectiveController?.text != format(value)) {
        setValue(parse(_effectiveController?.text ?? ""));
      }
    }
    if (widget.form != oldWidget.form) {
      oldWidget.form?.unregister(this);
      widget.form?.register(this);
    }
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      reset();
    }
  }

  @override
  void didChange(Duration? value) {
    widget.onChanged?.call(value);
    widget.onSubmitted?.call(value);
    super.didChange(value);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode?.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    widget.focusNode?.removeListener(_handleFocusChanged);
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    _effectiveController?.text = format(widget.initialValue) ?? "";
    didChange(widget.initialValue);
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != format(value)) {
      didChange(parse(_effectiveController?.text));
    }
  }

  String? format(Duration? value) => value?.format(widget.format);
  Duration? parse(String? text) {
    try {
      return text.isEmpty ? null : _parseLoose(text!);
    } catch (e) {
      return null;
    }
  }

  Duration? _parseLoose(String text) {
    final regex = RegExp(
      widget.format
          .replaceAll("HH", "(?<HH>[0-9]+)")
          .replaceAll("mm", "(?<mm>[0-9]+)")
          .replaceAll("ss", "(?<ss>[0-9]+)")
          .replaceAll("d", "(?<d>[0-9]+)"),
    );
    final match = regex.firstMatch(text);
    if (match == null) {
      return null;
    }
    final days = match.groupNames.contains("d")
        ? int.tryParse(match.namedGroup("d") ?? "") ?? 0
        : 0;
    final hours = match.groupNames.contains("HH")
        ? int.tryParse(match.namedGroup("HH") ?? "") ?? 0
        : 0;
    final minutes = match.groupNames.contains("mm")
        ? int.tryParse(match.namedGroup("mm") ?? "") ?? 0
        : 0;
    final seconds = match.groupNames.contains("ss")
        ? int.tryParse(match.namedGroup("ss") ?? "") ?? 0
        : 0;
    return Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  Future<void> requestUpdate() async {
    if (widget.readOnly) {
      return;
    }
    if (!isShowingDialog) {
      isShowingDialog = true;
      final newValue = await widget.picker.build(context, value);
      isShowingDialog = false;
      if (newValue != null) {
        _effectiveController?.text = format(newValue) ?? "";
      }
    }
  }

  void _handleFocusChanged() {
    if (hasFocus && !hadFocus) {
      hadFocus = hasFocus;
      _hideKeyboard();
      requestUpdate();
    } else {
      hadFocus = hasFocus;
    }
  }

  void _hideKeyboard() {
    Future.microtask(() => FocusScope.of(context).requestFocus(FocusNode()));
  }

  Future<void> clear() async {
    if (widget.readOnly) {
      return;
    }
    _hideKeyboard();
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      setState(() => _effectiveController?.clear());
    });
  }
}

/// Class that defines the picker style for selecting spacing.
///
/// 間隔を選択するためのピッカースタイルを定義するクラス。
@immutable
class FormDurationFieldPicker {
  /// Class that defines the picker style for selecting spacing.
  ///
  /// 間隔を選択するためのピッカースタイルを定義するクラス。
  const FormDurationFieldPicker({
    this.defaultDuration,
    this.minuteSuffix = "",
    this.secondSuffix = "",
    this.hourSuffix = "",
    this.daySuffix = "",
    this.backgroundColor,
    this.color,
    this.begin,
    this.end,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
  });

  /// Specifies the initial interval at which to make the selection.
  ///
  /// If not specified, 0 seconds can be selected.
  ///
  /// Specify an interval less than [end].
  ///
  /// 選択させる最初の間隔を指定します。
  ///
  /// 指定されない場合は0秒を選択できます。
  ///
  /// [end]よりも少ない間隔を指定してください。
  final Duration? begin;

  /// Specifies the last interval to be selected.
  ///
  /// If not specified, 23 hours, 59 minutes and 59 seconds can be selected.
  ///
  /// Specify the interval after [begin].
  ///
  /// 選択させる最後の間隔を指定します。
  ///
  /// 指定されない場合は23時間59分59秒を選択できます。
  ///
  /// [begin]よりも後の間隔を指定してください。
  final Duration? end;

  /// Default value when not selected.
  ///
  /// 選択されていないときのデフォルトの値。
  final Duration? defaultDuration;

  /// Suffix of the Second.
  ///
  /// 秒のSuffix。
  final String secondSuffix;

  /// Suffix of the Minute.
  ///
  /// 分のSuffix。
  final String minuteSuffix;

  /// Suffix of the Hour.
  ///
  /// 時のSuffix。
  final String hourSuffix;

  /// Suffix of the Day.
  ///
  /// 日のSuffix。
  final String daySuffix;

  /// Background color of the picker.
  ///
  /// ピッカーの背景色。
  final Color? backgroundColor;

  /// Foreground view of the picker.
  ///
  /// ピッカーの前景色。
  final Color? color;

  /// Text of the button that confirms the picker's content.
  ///
  /// ピッカーの内容を確定するボタンのテキスト。
  final String confirmText;

  /// Text of the button to cancel the picker.
  ///
  /// ピッカーをキャンセルするボタンのテキスト。
  final String cancelText;

  /// Build the picker.
  ///
  /// [context] is passed [BuildContext]. [currentDuration] is passed the currently selected [DateTime].
  ///
  /// ピッカーのビルドを行ないます。
  ///
  /// [context]に[BuildContext]が渡されます。[currentDuration]に現在選択されている[DateTime]が渡されます。
  Future<Duration?> build(
    BuildContext context,
    Duration? currentDuration,
  ) async {
    assert(
      begin == null ||
          end == null ||
          (begin != null &&
              end != null &&
              begin!.inMicroseconds < end!.inMicroseconds),
      "[begin] must be before [end].",
    );
    Duration? res;
    final theme = Theme.of(context);
    final enableDays = (begin?.inDays ?? 0) > 0 || (end?.inDays ?? 0) > 0;
    final selectedDay = (currentDuration?.inDays ??
        defaultDuration?.inDays ??
        begin?.inDays ??
        end?.inDays ??
        0);
    final enableHours = (begin?.inHours ?? 0) > 0 || (end?.inHours ?? 0) > 0;
    final selectedHours = (currentDuration?.inHours.remainder(24) ??
        defaultDuration?.inHours.remainder(24) ??
        begin?.inHours.remainder(24) ??
        end?.inHours.remainder(24) ??
        0);
    final enableMinutes =
        (begin?.inMinutes ?? 0) > 0 || (end?.inMinutes ?? 0) > 0;
    final selectedMinutes = (currentDuration?.inMinutes.remainder(60) ??
        defaultDuration?.inMinutes.remainder(60) ??
        begin?.inMinutes.remainder(60) ??
        end?.inMinutes.remainder(60) ??
        0);
    final selectedSeconds = (currentDuration?.inSeconds.remainder(60) ??
        defaultDuration?.inSeconds.remainder(60) ??
        begin?.inSeconds.remainder(60) ??
        end?.inSeconds.remainder(60) ??
        0);

    List<_PickerItem<int>> pickerItems = <_PickerItem<int>>[];
    for (var s = begin?.inSeconds.remainder(60) ?? 0;
        s <= (end?.inSeconds.remainder(60) ?? 0);
        s++) {
      pickerItems.add(
        _PickerItem(
          text: Text(
            "$s$secondSuffix",
            style: TextStyle(
              color: color ?? theme.colorScheme.onSurface,
            ),
          ),
          value: s,
        ),
      );
    }
    if (enableMinutes) {
      final secondsPickerItems = List<_PickerItem<int>>.from(pickerItems);
      pickerItems = <_PickerItem<int>>[];
      for (var m = begin?.inMinutes.remainder(60) ?? 0;
          m <= (end?.inMinutes.remainder(60) ?? 0);
          m++) {
        pickerItems.add(
          _PickerItem(
            text: Text(
              "$m$minuteSuffix",
              style: TextStyle(
                color: color ?? theme.colorScheme.onSurface,
              ),
            ),
            value: m,
            children: secondsPickerItems,
          ),
        );
      }
      if (enableHours) {
        final minutesPickerItems = List<_PickerItem<int>>.from(pickerItems);
        pickerItems = <_PickerItem<int>>[];
        for (var h = begin?.inHours.remainder(24) ?? 0;
            h <= (end?.inHours.remainder(24) ?? 0);
            h++) {
          pickerItems.add(
            _PickerItem(
              text: Text(
                "$h$hourSuffix",
                style: TextStyle(
                  color: color ?? theme.colorScheme.onSurface,
                ),
              ),
              value: h,
              children: minutesPickerItems,
            ),
          );
        }
        if (enableDays) {
          final hoursPickerItems = List<_PickerItem<int>>.from(pickerItems);
          pickerItems = <_PickerItem<int>>[];
          for (var d = begin?.inDays ?? 0; d <= (end?.inDays ?? 0); d++) {
            pickerItems.add(
              _PickerItem(
                text: Text(
                  "$d$daySuffix",
                  style: TextStyle(
                    color: color ?? theme.colorScheme.onSurface,
                  ),
                ),
                value: d,
                children: hoursPickerItems,
              ),
            );
          }
        }
      }
    }
    await _Picker(
      height: 240,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      containerColor: backgroundColor ?? theme.colorScheme.surface,
      headerColor: backgroundColor ?? theme.colorScheme.surface,
      textStyle: TextStyle(color: color ?? theme.colorScheme.onSurface),
      confirmText: confirmText,
      cancelText: cancelText,
      selecteds: [
        if (enableDays) selectedDay,
        if (enableHours) selectedHours,
        if (enableMinutes) selectedMinutes,
        selectedSeconds,
      ],
      adapter: _PickerDataAdapter<int>(
        data: [
          ...pickerItems,
        ],
      ),
      changeToFirst: true,
      hideHeader: false,
      onConfirm: (_Picker picker, List<int> value) {
        if (value.length >= 4) {
          res = Duration(
            days: value[0],
            hours: value[1],
            minutes: value[2],
            seconds: value[3],
          );
        } else if (value.length == 3) {
          res = Duration(
            hours: value[0],
            minutes: value[1],
            seconds: value[2],
          );
        } else if (value.length == 2) {
          res = Duration(
            minutes: value[0],
            seconds: value[1],
          );
        } else if (value.length == 1) {
          res = Duration(
            seconds: value[0],
          );
        }
      },
    ).showModal(context);
    return res;
  }
}
