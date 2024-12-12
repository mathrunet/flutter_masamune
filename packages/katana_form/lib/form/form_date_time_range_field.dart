part of '/katana_form.dart';

/// Form to have a range of dates selected.
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
/// You can set how to select a date range by specifying [delegate].
///
/// If [enabled] is `false`, the text is deactivated.
///
/// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
///
/// 日付の範囲を選択させるためのフォーム。
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
/// [delegate]を指定することで日付範囲の選択方法を設定することが可能です。
///
/// [enabled]が`false`になるとテキストが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
class FormDateTimeRangeField<TValue> extends StatefulWidget {
  /// Form to have a range of dates selected.
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
  /// You can set how to select a date range by specifying [delegate].
  ///
  /// If [enabled] is `false`, the text is deactivated.
  ///
  /// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
  ///
  /// 日付の範囲を選択させるためのフォーム。
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
  /// [delegate]を指定することで日付範囲の選択方法を設定することが可能です。
  ///
  /// [enabled]が`false`になるとテキストが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
  const FormDateTimeRangeField({
    this.form,
    super.key,
    this.controller,
    this.prefix,
    this.suffix,
    this.style,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.emptyErrorText,
    this.readOnly = false,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
    this.keepAlive = true,
    this.delegate = const FormDateTimeRangeFieldDateDelegate(),
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownIcon,
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
  final DateTimeRange? initialValue;

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
  final TValue Function(DateTimeRange value)? onSaved;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(DateTimeRange? value)? onChanged;

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
  final FormFieldValidator<DateTimeRange?>? validator;

  /// It is executed when the Enter button on the keyboard or the Submit button on the software keyboard is pressed.
  ///
  /// The current value is passed to `value`.
  ///
  /// キーボードのEnterボタン、もしくはソフトウェアキーボードのサブミットボタンが押された場合に実行されます。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(DateTimeRange? value)? onSubmitted;

  /// A delegate where the form picker and formatter are defined.
  ///
  /// フォームのピッカーやフォーマッタが定義されているデリゲート。
  final FormDateTimeRangeFieldDelegate delegate;

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
  State<StatefulWidget> createState() => _FormDateTimeRangeFieldState<TValue>();
}

class _FormDateTimeRangeFieldState<TValue>
    extends State<FormDateTimeRangeField<TValue>>
    with AutomaticKeepAliveClientMixin<FormDateTimeRangeField<TValue>> {
  TextEditingController? _controller;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      return;
    }
    if (widget.initialValue != null) {
      widget.controller?.text = widget.delegate.format(widget.initialValue!);
    }
    _controller = TextEditingController(text: widget.controller?.text);
    _controller?.addListener(_listenerInside);
    widget.controller?.addListener(_listenerOutside);
  }

  @override
  void didUpdateWidget(FormDateTimeRangeField<TValue> oldWidget) {
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
      child: Container(
        alignment: widget.style?.alignment,
        padding:
            widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: widget.style?.height,
          width: widget.style?.width,
          child: Stack(
            children: [
              _DateTimeRangeTextField<TValue>(
                form: widget.form,
                controller: _controller,
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
                focusNode: widget.focusNode,
                style: widget.enabled ? mainTextStyle : disabledTextStyle,
                readOnly: widget.readOnly,
                textAlign: widget.style?.textAlign ?? TextAlign.left,
                textAlignVertical: widget.style?.textAlignVertical,
                delegate: widget.delegate,
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
                onShowPicker: widget.delegate.picker,
              ),
              if (widget.showDropdownIcon)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
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
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

class _DateTimeRangeTextField<TValue> extends FormField<DateTimeRange> {
  _DateTimeRangeTextField({
    this.form,
    required this.delegate,
    required this.onShowPicker,
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
    bool expands = false,
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
            final _DateTimeRangeTextFieldState<TValue> state =
                field as _DateTimeRangeTextFieldState<TValue>;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return TextField(
              mouseCursor: enabled == false
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              controller: state._effectiveController ??
                  TextEditingController(
                    text: state.value != null
                        ? state.widget.delegate.format(state.value!)
                        : null,
                  ),
              focusNode: state._effectiveFocusNode,
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
              ),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textCapitalization: textCapitalization,
              autofocus: autofocus,
              readOnly: true,
              showCursor: showCursor,
              obscureText: obscureText,
              autocorrect: autocorrect,
              expands: expands,
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
  final FormDateTimeRangeFieldDelegate delegate;

  final Future<DateTimeRange?> Function(
      BuildContext context, DateTimeRange currentValue)? onShowPicker;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final void Function(DateTimeRange? value)? onChanged;
  final void Function(DateTimeRange? value)? onSubmitted;

  @override
  _DateTimeRangeTextFieldState<TValue> createState() =>
      _DateTimeRangeTextFieldState<TValue>();
}

class _DateTimeRangeTextFieldState<TValue>
    extends FormFieldState<DateTimeRange> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  _DateTimeRangeTextField<TValue> get widget =>
      super.widget as _DateTimeRangeTextField<TValue>;

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
  void didUpdateWidget(_DateTimeRangeTextField<TValue> oldWidget) {
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
    if (widget.delegate.dateFormat != oldWidget.delegate.dateFormat) {
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
  void didChange(DateTimeRange? value) {
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

  String? format(DateTimeRange? date) =>
      date == null ? null : widget.delegate.format(date);
  DateTimeRange? parse(String? text) {
    try {
      return text.isEmpty ? null : widget.delegate.parse(text!);
    } catch (e) {
      return null;
    }
  }

  Future<void> requestUpdate() async {
    if (widget.readOnly) {
      return;
    }
    if (!isShowingDialog) {
      isShowingDialog = true;
      final now = DateTime.now();
      final newValue = await widget.onShowPicker?.call(
        context,
        value ?? DateTimeRange(start: now, end: now),
      );
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

  bool shouldShowClearIcon([InputDecoration? decoration]) =>
      (hasText || hasFocus) &&
      decoration?.suffixIcon == null &&
      !widget.readOnly;
}

/// [FormDateTimeRangeFieldDelegate] that allows specifying pickers that can be selected by [pickerBuilder].
///
/// [dateFormat] is defined as `yyyyy/MM/dd(E) HH:mm`.
///
/// [pickerBuilder]で選択可能なピッカーを指定可能な[FormDateTimeRangeFieldDelegate]。
///
/// [dateFormat]は`yyyy/MM/dd(E)`が定義されます。
class FormDateTimeRangeFieldCustomDelegate
    extends FormDateTimeRangeFieldDelegate {
  /// [FormDateTimeRangeFieldDelegate] that allows specifying pickers that can be selected by [pickerBuilder].
  ///
  /// [dateFormat] is defined as `yyyyy/MM/dd(E) HH:mm`.
  ///
  /// [pickerBuilder]で選択可能なピッカーを指定可能な[FormDateTimeRangeFieldDelegate]。
  ///
  /// [dateFormat]は`yyyy/MM/dd(E)`が定義されます。
  const FormDateTimeRangeFieldCustomDelegate({
    required this.pickerBuilder,
    super.dateFormat = "yyyy/MM/dd(E)",
    super.separator = " - ",
  });

  /// Builder to call picker.
  ///
  /// [context] is passed the context in which the builder was invoked.
  ///
  /// The current date range is passed to [currentDateTimeRange].
  ///
  /// Return the date range selected by the picker.
  ///
  /// ピッカーを呼び出すためのビルダー。
  ///
  /// [context]にはビルダーが呼び出された際のコンテキストが渡されます。
  ///
  /// [currentDateTimeRange]には現在の日付範囲が渡されます。
  ///
  /// ピッカーで選択された日付範囲を返してください。
  final Future<DateTimeRange?> Function(
    BuildContext context,
    DateTimeRange currentDateTimeRange,
  ) pickerBuilder;

  @override
  Future<DateTimeRange?> picker(
    BuildContext context,
    DateTimeRange currentDateTimeRange,
  ) =>
      pickerBuilder(context, currentDateTimeRange);
}

/// Let the user select only dates [FormDateTimeRangeFieldDelegate].
///
/// You can have it selected within the range of [startDate] and [endDate].
///
/// The default value when not selected is [defaultDateTimeRange].
///
/// [dateFormat] is defined as `yyyyy/MM/dd(E) HH:mm`.
///
/// 日付のみを選択させる[FormDateTimeRangeFieldDelegate]。
///
/// [startDate]と[endDate]の範囲内で選択させることができます。
///
/// 選択されていない場合の初期値が[defaultDateTimeRange]になります。
///
/// [dateFormat]は`yyyy/MM/dd(E)`が定義されます。
class FormDateTimeRangeFieldDateDelegate
    extends FormDateTimeRangeFieldDelegate {
  /// Let the user select only dates [FormDateTimeRangeFieldDelegate].
  ///
  /// You can have it selected within the range of [startDate] and [endDate].
  ///
  /// The default value when not selected is [defaultDateTimeRange].
  ///
  /// [dateFormat] is defined as `yyyyy/MM/dd(E) HH:mm`.
  ///
  /// 日付のみを選択させる[FormDateTimeRangeFieldDelegate]。
  ///
  /// [startDate]と[endDate]の範囲内で選択させることができます。
  ///
  /// 選択されていない場合の初期値が[defaultDateTimeRange]になります。
  ///
  /// [dateFormat]は`yyyy/MM/dd(E)`が定義されます。
  const FormDateTimeRangeFieldDateDelegate({
    super.startDate,
    super.endDate,
    super.defaultDateTimeRange,
    super.helpText,
    super.cancelText,
    super.confirmText,
    super.locale,
    super.errorFormatText,
    super.errorInvalidText,
    super.fieldEndHintText,
    super.fieldEndLabelText,
    super.initialEntryMode = DatePickerEntryMode.calendar,
    super.dateFormat = "yyyy/MM/dd(E)",
    super.separator = " - ",
  });

  @override
  Future<DateTimeRange?> picker(
    BuildContext context,
    DateTimeRange currentDateTimeRange,
  ) async {
    final now = DateTime.now();
    final nowRange = defaultDateTimeRange;
    final date = await showDateRangePicker(
      context: context,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      locale: locale,
      initialEntryMode: initialEntryMode,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      fieldStartHintText: fieldStartHintText,
      fieldStartLabelText: fieldStartLabelText,
      fieldEndHintText: fieldEndHintText,
      fieldEndLabelText: fieldEndLabelText,
      firstDate: startDate ??
          (nowRange?.start ?? now).subtract(const Duration(days: 365)),
      initialDateRange: currentDateTimeRange,
      lastDate: endDate ??
          (nowRange?.end ?? now).add(
            const Duration(days: 365),
          ),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            datePickerTheme: theme.datePickerTheme.copyWith(
              rangeSelectionBackgroundColor: theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    return date;
  }
}

/// A delegate where the form picker and formatter are defined.
///
/// フォームのピッカーやフォーマッタが定義されているデリゲート。
@immutable
abstract class FormDateTimeRangeFieldDelegate {
  /// A delegate where the form picker and formatter are defined.
  ///
  /// フォームのピッカーやフォーマッタが定義されているデリゲート。
  const FormDateTimeRangeFieldDelegate({
    this.startDate,
    this.endDate,
    this.defaultDateTimeRange,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.locale,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldStartHintText,
    this.fieldStartLabelText,
    this.fieldEndHintText,
    this.fieldEndLabelText,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    required this.dateFormat,
    this.separator = " - ",
  });

  /// Define date and time formats.
  ///
  /// Describe and define the following pattern.
  ///
  /// 日付と時間のフォーマットを定義します。
  ///
  /// 下記のパターンを記述して定義してください。
  ///
  ///     Symbol   Meaning                Presentation       Example
  ///     ------   -------                ------------       -------
  ///     G        era designator         (Text)             AD
  ///     y        year                   (Number)           1996
  ///     M        month in year          (Text & Number)    July & 07
  ///     L        standalone month       (Text & Number)    July & 07
  ///     d        day in month           (Number)           10
  ///     c        standalone day         (Number)           10
  ///     h        hour in am/pm (1~12)   (Number)           12
  ///     H        hour in day (0~23)     (Number)           0
  ///     m        minute in hour         (Number)           30
  ///     s        second in minute       (Number)           55
  ///     S        fractional second      (Number)           978
  ///     E        day of week            (Text)             Tuesday
  ///     D        day in year            (Number)           189
  ///     a        am/pm marker           (Text)             PM
  ///     k        hour in day (1~24)     (Number)           24
  ///     K        hour in am/pm (0~11)   (Number)           0
  ///     Q        quarter                (Text)             Q3
  ///     '        escape for text        (Delimiter)        'Date='
  ///     ''       single quote           (Literal)          'o''clock'
  final String dateFormat;

  /// The earliest date to be selected.
  ///
  /// 選択させる一番古い日付。
  final DateTime? startDate;

  /// The most recent date to be selected.
  ///
  /// 選択させる一番新しい日付。
  final DateTime? endDate;

  /// Default value if not selected.
  ///
  /// 選択されていない場合の初期値。
  final DateTimeRange? defaultDateTimeRange;

  /// Hint text to be displayed in the picker.
  ///
  /// ピッカーに表示されるヒントテキスト。
  final String? helpText;

  /// Picker cancel text.
  ///
  /// ピッカーのキャンセルテキスト。
  final String? cancelText;

  /// The definitive text of the picker.
  ///
  /// ピッカーの確定テキスト。
  final String? confirmText;

  /// Dialog locale.
  ///
  /// ピッカーのロケール。
  final Locale? locale;

  /// Characters between the start and end dates and times.
  ///
  /// 開始日時と終了日時の間の文字。
  final String separator;

  /// Specifies the initial input mode.
  ///
  /// 初期の入力モードを指定します。
  final DatePickerEntryMode initialEntryMode;

  /// Text to be displayed if a formatting error occurs.
  ///
  /// フォーマットのエラーが発生した場合に表示するテキスト。
  final String? errorFormatText;

  /// Text in case of some error.
  ///
  /// なにかしらのエラーが出た場合のテキスト。
  final String? errorInvalidText;

  /// Hint text of start date for text fields in the dialog.
  ///
  /// 開始日時のピッカー中のテキストフィールドのヒントテキスト。
  final String? fieldStartHintText;

  /// Label text of start date for text fields in the dialog.
  ///
  /// 開始日時のピッカー中のテキストフィールドのラベルテキスト。
  final String? fieldStartLabelText;

  /// Hint text of end date for text fields in the dialog.
  ///
  /// 終了日時のピッカー中のテキストフィールドのヒントテキスト。
  final String? fieldEndHintText;

  /// Label text of end date for text fields in the dialog.
  ///
  /// 終了日時のピッカー中のテキストフィールドのラベルテキスト。
  final String? fieldEndLabelText;

  /// Callback to display picker.
  ///
  /// The currently selected [DateTimeRange] is passed to [currentDateTimeRange].
  ///
  /// ピッカーを表示するためのコールバック。
  ///
  /// [currentDateTimeRange]に現在選択中の[DateTimeRange]が渡されます。
  Future<DateTimeRange?> picker(
    BuildContext context,
    DateTimeRange currentDateTimeRange,
  );

  /// Pass [DateTimeRange] to get a string.
  ///
  /// [dateFormat] and [separator] are used.
  ///
  /// [DateTimeRange]を渡して文字列を取得します。
  ///
  /// [dateFormat]と[separator]が利用されます。
  String format(DateTimeRange? dateTimeRange) {
    if (dateTimeRange == null) {
      return "";
    }
    return "${DateFormat(dateFormat).format(dateTimeRange.start)}$separator${DateFormat(dateFormat).format(dateTimeRange.end)}";
  }

  /// Pass a string to get [DateTimeRange].
  ///
  /// [dateFormat] and [separator] are used.
  ///
  /// 文字列を渡して[DateTimeRange]を取得します。
  ///
  /// [dateFormat]と[separator]が利用されます。
  DateTimeRange? parse(String dateTimeRangeString) {
    final format = DateFormat(dateFormat);
    if (dateTimeRangeString.isEmpty) {
      return null;
    }
    final List<String> dateTimeRangeStringList =
        dateTimeRangeString.split(separator);
    if (dateTimeRangeStringList.length != 2) {
      return null;
    }
    final startString = dateTimeRangeStringList[0].trim();
    final endString = dateTimeRangeStringList[1].trim();
    final start = startString.isEmpty ? null : format.parse(startString);
    final end = endString.isEmpty ? null : format.parse(endString);
    if (start == null || end == null) {
      return null;
    }
    return DateTimeRange(start: start, end: end);
  }
}
