part of "/katana_form.dart";

/// A form to have the date (year and month) selected.
///
/// A form field for selecting year and month in a modal.
/// Common design can be applied with `FormStyle`, and selection state can be managed using `FormController`.
///
/// 年月をモーダルで選択するためのフォームフィールド。
/// `FormStyle`で共通したデザインを適用可能で、`FormController`を利用することで選択状態を管理できます。
///
/// ## Basic Usage Example 基本的な使用例
///
/// ```dart
/// FormMonthModalField(
///   form: formController,
///   initialValue: formController.value.month.value,
///   onSaved: (value) => formController.value.copyWith(month: ModelDate(value)),
/// );
/// ```
///
/// ## Custom Format Usage Example カスタムフォーマットの使用例
///
/// ```dart
/// FormMonthModalField(
///   form: formController,
///   initialValue: formController.value.month.value,
///   format: "yyyy年MM月",
///   onSaved: (value) => formController.value.copyWith(month: ModelDate(value)),
/// );
/// ```
class FormMonthModalField<TValue> extends StatefulWidget {
  /// A form to have the date (year and month) selected.
  ///
  /// A form field for selecting year and month in a modal.
  /// Common design can be applied with `FormStyle`, and selection state can be managed using `FormController`.
  ///
  /// 年月をモーダルで選択するためのフォームフィールド。
  /// `FormStyle`で共通したデザインを適用可能で、`FormController`を利用することで選択状態を管理できます。
  ///
  /// ## Basic Usage Example 基本的な使用例
  ///
  /// ```dart
  /// FormMonthModalField(
  ///   form: formController,
  ///   initialValue: formController.value.month.value,
  ///   onSaved: (value) => formController.value.copyWith(month: ModelDate(value)),
  /// );
  /// ```
  ///
  /// ## Custom Format Usage Example カスタムフォーマットの使用例
  ///
  /// ```dart
  /// FormMonthModalField(
  ///   form: formController,
  ///   initialValue: formController.value.month.value,
  ///   format: "yyyy年MM月",
  ///   onSaved: (value) => formController.value.copyWith(month: ModelDate(value)),
  /// );
  /// ```
  const FormMonthModalField({
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
    this.picker = const FormMonthModalFieldPicker(),
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
  final DateTime? initialValue;

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
  final TValue Function(DateTime value)? onSaved;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(DateTime? value)? onChanged;

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
  final FormFieldValidator<DateTime?>? validator;

  /// It is executed when the Enter button on the keyboard or the Submit button on the software keyboard is pressed.
  ///
  /// The current value is passed to `value`.
  ///
  /// キーボードのEnterボタン、もしくはソフトウェアキーボードのサブミットボタンが押された場合に実行されます。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(DateTime? value)? onSubmitted;

  /// Picker object for selecting dates.
  ///
  /// 日付を選択するためのピッカーオブジェクト。
  final FormMonthModalFieldPicker picker;

  /// Formatter for formatting [DateTime] to [String].
  ///
  /// Describe and define the following pattern.
  ///
  /// By default, "yyyy/MM" is used.
  ///
  /// [DateTime]を[String]にフォーマットするためのフォーマッタ。
  ///
  /// 下記のパターンを記述して定義してください。
  ///
  /// デフォルトで"yyyy/MM"が利用されます。
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
  String get format {
    if (_format.isNotEmpty) {
      return _format!;
    }
    return "yyyy/MM";
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
  State<StatefulWidget> createState() => _FormMonthModalFieldState<TValue>();
}

class _FormMonthModalFieldState<TValue>
    extends State<FormMonthModalField<TValue>>
    with AutomaticKeepAliveClientMixin<FormMonthModalField<TValue>> {
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
  void didUpdateWidget(FormMonthModalField<TValue> oldWidget) {
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
      enabled: widget.enabled,
      child: Container(
        alignment: widget.style?.alignment,
        padding:
            widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: widget.style?.height,
          width: widget.style?.width,
          child: Stack(
            children: [
              _MonthTextField<TValue>(
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

class _MonthTextField<TValue> extends FormField<DateTime> {
  _MonthTextField({
    required this.format,
    required this.picker,
    this.form,
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
            final state = field as _MonthTextFieldState<TValue>;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return TextField(
              mouseCursor: !enabled
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

  final FormMonthModalFieldPicker picker;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final void Function(DateTime? value)? onChanged;
  final void Function(DateTime? value)? onSubmitted;

  @override
  _MonthTextFieldState createState() => _MonthTextFieldState<TValue>();
}

class _MonthTextFieldState<TValue> extends FormFieldState<DateTime> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  _MonthTextField<TValue> get widget => super.widget as _MonthTextField<TValue>;

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
  void didUpdateWidget(_MonthTextField<TValue> oldWidget) {
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
  void didChange(DateTime? value) {
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

  String? format(DateTime? value) => value?.format(widget.format);
  DateTime? parse(String? text) {
    try {
      return text.isEmpty ? null : _parseLoose(text!);
    } catch (e) {
      return null;
    }
  }

  DateTime? _parseLoose(String text) {
    final regex = RegExp(
      widget.format
          .replaceAll("MM", "(?<MM>[0-9]+)")
          .replaceAll("yyyy", "(?<yyyy>[0-9]+)"),
    );
    final match = regex.firstMatch(text);
    if (match == null) {
      return null;
    }
    final years = match.groupNames.contains("yyyy")
        ? int.tryParse(match.namedGroup("yyyy") ?? "") ?? 0
        : 0;
    final months = match.groupNames.contains("MM")
        ? int.tryParse(match.namedGroup("MM") ?? "") ?? 0
        : 0;
    return Clock(
      years,
      months,
      1,
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
    Future.microtask(() {
      final context = this.context;
      if (context.mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
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

/// Class that defines a picker style for selecting dates.
///
/// 日付を選択するためのピッカースタイルを定義するクラス。
@immutable
class FormMonthModalFieldPicker {
  /// Class that defines a picker style for selecting dates.
  ///
  /// 日付を選択するためのピッカースタイルを定義するクラス。
  const FormMonthModalFieldPicker({
    this.defaultDateTime,
    this.monthSuffix = "",
    this.yearSuffix = "",
    this.yearFormat = "yyyy",
    this.backgroundColor,
    this.day,
    this.lastDayOfMonth,
    this.color,
    this.begin,
    this.end,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
  })  : assert(
          lastDayOfMonth == null || day == null,
          "You can't set both lastDayOfMonth and day.",
        ),
        assert(
          day == null || day > 0 && day <= 31,
          "day must be 1-31.",
        );

  /// Set the date to the end of the month when outputting as [DateTime].
  ///
  /// Cannot be set at the same time as [day].
  ///
  /// [DateTime]として出力する場合の日付をその月の最後にします。
  ///
  /// [day]と同時に設定することはできません。
  final bool? lastDayOfMonth;

  /// Set the date to [day] when outputting as [DateTime].
  ///
  /// Specify a number between 1-31.
  ///
  /// Cannot be set at the same time as [lastDayOfMonth].
  ///
  /// [DateTime]として出力する場合の日付を[day]にします。
  ///
  /// 1-31の間の数字を指定してください。
  ///
  /// [lastDayOfMonth]と同時に設定することはできません。
  final int? day;

  /// Specify the first year and month to be selected.
  ///
  /// If not specified, you can choose from 10 years prior to the current year.
  ///
  /// Specify a date earlier than [end].
  ///
  /// 選択させる最初の年月を指定します。
  ///
  /// 指定されない場合は現在の年から10年前から選択できます。
  ///
  /// [end]よりも前の日付を指定してください。
  final DateTime? begin;

  /// Specify the last year and month to be selected.
  ///
  /// If not specified, you can choose up to 10 years after the current year.
  ///
  /// Specify a date later than [begin].
  ///
  /// 選択させる最後の年月を指定します。
  ///
  /// 指定されない場合は現在の年から10年後まで選択できます。
  ///
  /// [begin]よりも後の日付を指定してください。
  final DateTime? end;

  /// Default value when not selected.
  ///
  /// 選択されていないときのデフォルトの値。
  final DateTime? defaultDateTime;

  /// Suffix of the Month.
  ///
  /// 月のSuffix。
  final String monthSuffix;

  /// Suffix in year.
  ///
  /// 年のSuffix。
  final String yearSuffix;

  /// Format of the year.
  ///
  /// Describe and define the following pattern.
  ///
  /// 年のフォーマット。
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
  final String yearFormat;

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
  /// [context] is passed [BuildContext]. [currentDateTime] is passed the currently selected [DateTime].
  ///
  /// ピッカーのビルドを行ないます。
  ///
  /// [context]に[BuildContext]が渡されます。[currentDateTime]に現在選択されている[DateTime]が渡されます。
  Future<DateTime?> build(
    BuildContext context,
    DateTime? currentDateTime,
  ) async {
    assert(
      begin == null ||
          end == null ||
          (begin != null && end != null && begin!.isBefore(end!)),
      "[begin] must be before [end].",
    );
    final theme = Theme.of(context);
    DateTime? res;
    final now = Clock.now();
    final startYear = begin?.year ?? (now.year - 10);
    final endYear = end?.year ?? (now.year + 10);
    final selectedYear = ((currentDateTime?.year ??
                defaultDateTime?.year ??
                begin?.year ??
                end?.year ??
                now.year) -
            startYear)
        .limit(0, endYear - startYear);
    var selectedMonth = ((currentDateTime?.month ??
                defaultDateTime?.month ??
                begin?.month ??
                end?.month ??
                now.month) -
            1)
        .limit(0, 12);
    if (selectedYear == 0) {
      selectedMonth = selectedMonth - ((begin?.month ?? 1) - 1);
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
        selectedYear,
        selectedMonth,
      ],
      adapter: _PickerDataAdapter<int>(
        data: [
          for (var y = startYear; y < endYear; y++) ...[
            () {
              final year = Clock(y, 1, 1);
              final startMonth = y == startYear ? begin?.month ?? 1 : 1;
              final endMonth = y == endYear - 1 ? end?.month ?? 12 : 12;
              return _PickerItem(
                text: Text(
                  "${year.format(yearFormat)}$yearSuffix",
                  style: TextStyle(
                    color: color ?? theme.colorScheme.onSurface,
                  ),
                ),
                value: y,
                children: [
                  for (var m = startMonth - 1; m < endMonth; m++)
                    _PickerItem(
                      text: Text(
                        "${(m + 1).format("00")}$monthSuffix",
                        style: TextStyle(
                          color: color ?? theme.colorScheme.onSurface,
                        ),
                      ),
                      value: m,
                    ),
                ],
              );
            }(),
          ],
        ],
      ),
      changeToFirst: true,
      hideHeader: false,
      onConfirm: (_Picker picker, List<int> value) {
        var month = value[1] + 1;
        if (value[0] == 0) {
          month = month + ((begin?.month ?? 1) - 1);
        }
        if (lastDayOfMonth ?? false) {
          res = Clock(value[0] + startYear, month + 1, 0);
        } else {
          res = Clock(value[0] + startYear, month, day ?? 1);
        }
      },
    ).showModal(context);
    return res;
  }
}
