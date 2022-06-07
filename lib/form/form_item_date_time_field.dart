part of masamune.form;

class FormItemDateTimeField extends StatefulWidget implements FormItem {
  const FormItemDateTimeField({
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.backgroundColor,
    this.hintText,
    this.labelText,
    this.counterText = "",
    this.pickerLabelText,
    this.dense = false,
    this.enabled = true,
    this.prefix,
    this.suffix,
    this.errorText,
    this.allowEmpty = false,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.showResetButton = true,
    this.contentPadding,
    this.type = FormItemDateTimeFieldPickerType.dateTime,
    this.initialDateTime,
    String? format,
    Future<DateTime> onShowPicker(BuildContext context, DateTime dateTime)?,
    this.onSaved,
  })  : _format = format,
        _onShowPicker = onShowPicker;

  /// Calculate formatted datetime string from [millisecondsSinceEpoch].
  static String formatDateTime(
    int millisecondsSinceEpoch, {
    String format = "yyyy/MM/dd(E) HH:mm",
    String defaultValue = "",
  }) {
    if (format.isEmpty || millisecondsSinceEpoch <= 0) {
      return defaultValue;
    }
    return DateFormat(format).format(value(millisecondsSinceEpoch));
  }

  /// Calculate formatted date string from [millisecondsSinceEpoch].
  static String formatDate(
    int millisecondsSinceEpoch, {
    String format = "yyyy/MM/dd(E)",
    String defaultValue = "",
  }) {
    if (format.isEmpty || millisecondsSinceEpoch <= 0) {
      return defaultValue;
    }
    return DateFormat(format).format(value(millisecondsSinceEpoch));
  }

  /// Calculate formatted time string from [millisecondsSinceEpoch].
  static String formatTime(
    int millisecondsSinceEpoch, {
    String format = "HH:mm",
    String defaultValue = "",
  }) {
    if (format.isEmpty || millisecondsSinceEpoch <= 0) {
      return defaultValue;
    }
    return DateFormat(format).format(value(millisecondsSinceEpoch));
  }

  /// Converts a string with only date and time information to DateTime.
  static DateTime? tryParseFromDate(
    String formattedString, {
    DateTime? defaultValue,
    String format = r"([0-9]+)/([0-9]+)/([0-9]+)",
  }) {
    if (formattedString.isEmpty || format.isEmpty) {
      return defaultValue;
    }
    final regex = RegExp(format);
    final match = regex.firstMatch(formattedString);
    if (match == null) {
      return defaultValue;
    }
    final year = int.tryParse(match.group(1) ?? "");
    final month = int.tryParse(match.group(2) ?? "");
    final day = int.tryParse(match.group(3) ?? "");
    if (year == null || month == null || day == null) {
      return defaultValue;
    }
    return DateTime(year, month, day);
  }

  /// Converts a string with only date and time information to DateTime.
  static DateTime? tryParseFromDateTime(
    String formattedString, {
    DateTime? defaultValue,
    String format =
        r"([0-9]+)/([0-9]+)/([0-9]+)(\([^\)]+\))? ([0-9]+):([0-9]+)",
  }) {
    if (formattedString.isEmpty || format.isEmpty) {
      return defaultValue;
    }
    final regex = RegExp(format);
    final match = regex.firstMatch(formattedString);
    if (match == null) {
      return defaultValue;
    }
    final year = int.tryParse(match.group(1) ?? "");
    final month = int.tryParse(match.group(2) ?? "");
    final day = int.tryParse(match.group(3) ?? "");
    final hour = int.tryParse(match.group(5) ?? "");
    final minute = int.tryParse(match.group(6) ?? "");
    if (year == null ||
        month == null ||
        day == null ||
        hour == null ||
        minute == null) {
      return defaultValue;
    }
    return DateTime(year, month, day, hour, minute);
  }

  /// Create a DateTime by combining [date] and [time].
  static DateTime combine(DateTime date, DateTime time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
      time.millisecond,
    );
  }

  /// Calculate DateTime from [millisecondsSinceEpoch].
  static DateTime value(int millisecondsSinceEpoch) {
    assert(millisecondsSinceEpoch > 0);
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  /// Picker definition that selects only dates.
  static Future<DateTime> Function(BuildContext, DateTime) datePicker({
    DateTime? startDate,
    DateTime? currentDate,
    DateTime? endDate,
    String? helpText,
  }) {
    return (context, dateTime) async {
      final now = dateTime;
      final date = await showDatePicker(
        context: context,
        helpText: helpText,
        firstDate: startDate ?? now.subtract(const Duration(days: 365)),
        initialDate: currentDate ?? now,
        lastDate: endDate ??
            now.add(
              const Duration(days: 365),
            ),
      );
      return _DateTimeTextField.combine(
        date ?? now,
        TimeOfDay.fromDateTime(now),
      );
    };
  }

  /// Definition of a picker to select time.
  static Future<DateTime> Function(BuildContext, DateTime) timePicker({
    DateTime? currentTime,
    String? helpText,
  }) {
    return (context, dateTime) async {
      final now = dateTime;
      final time = await showTimePicker(
        context: context,
        helpText: helpText,
        initialTime: TimeOfDay.fromDateTime(currentTime ?? now),
      );
      return _DateTimeTextField.combine(
        now,
        time ?? TimeOfDay.fromDateTime(now),
      );
    };
  }

  /// Picker definition that selects the date and time.
  static Future<DateTime> Function(BuildContext, DateTime) dateTimePicker({
    DateTime? startDate,
    DateTime? current,
    DateTime? endDate,
    String? helpText,
  }) {
    return (context, dateTime) async {
      final now = dateTime;
      final date = await showDatePicker(
        context: context,
        helpText: helpText,
        firstDate: startDate ?? now.subtract(const Duration(days: 365)),
        initialDate: current ?? now,
        lastDate: endDate ??
            now.add(
              const Duration(days: 365),
            ),
      );
      if (date != null) {
        final time = await showTimePicker(
          context: context,
          helpText: helpText,
          initialTime: TimeOfDay.fromDateTime(current ?? now),
        );
        return _DateTimeTextField.combine(
          date,
          time ?? TimeOfDay.fromDateTime(now),
        );
      } else {
        return current ?? now;
      }
    };
  }

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLength;
  final int maxLines;
  final bool dense;
  final int? minLines;
  final String? hintText;
  final bool showResetButton;
  final String? errorText;
  final String? labelText;
  final String? counterText;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final String? pickerLabelText;
  final bool allowEmpty;
  final bool obscureText;
  final Color? backgroundColor;
  final DateTime? initialDateTime;
  final String? _format;
  final bool enabled;
  final FormFieldValidator<DateTime?>? validator;
  final EdgeInsetsGeometry? contentPadding;
  final FormItemDateTimeFieldPickerType type;
  final Future<DateTime> Function(BuildContext, DateTime)? _onShowPicker;
  final void Function(DateTime? value)? onSaved;
  final void Function(DateTime? value)? onChanged;
  final void Function()? onEditingComplete;

  Future<DateTime> Function(BuildContext, DateTime) get onShowPicker {
    if (_onShowPicker != null) {
      return _onShowPicker!;
    }
    switch (type) {
      case FormItemDateTimeFieldPickerType.date:
        return FormItemDateTimeField.datePicker(helpText: pickerLabelText);
      case FormItemDateTimeFieldPickerType.time:
        return FormItemDateTimeField.timePicker(helpText: pickerLabelText);
      default:
        return FormItemDateTimeField.dateTimePicker(helpText: pickerLabelText);
    }
  }

  DateFormat get format {
    if (_format != null) {
      return DateFormat(_format!);
    }
    switch (type) {
      case FormItemDateTimeFieldPickerType.date:
        return DateFormat("yyyy/MM/dd(E)");
      case FormItemDateTimeFieldPickerType.time:
        return DateFormat("HH:mm");
      default:
        return DateFormat("yyyy/MM/dd(E) HH:mm");
    }
  }

  @override
  State<StatefulWidget> createState() => _FormItemDateTimeFieldState();
}

class _FormItemDateTimeFieldState extends State<FormItemDateTimeField> {
  TextEditingController? _controller;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      return;
    }
    if (widget.initialDateTime != null) {
      widget.controller?.text = widget.initialDateTime!.toIso8601String();
    }
    _controller = TextEditingController(text: widget.controller?.text);
    _controller?.addListener(_listenerInside);
    widget.controller?.addListener(_listenerOutside);
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
    return Padding(
      padding: widget.dense
          ? const EdgeInsets.symmetric(vertical: 10, horizontal: 6)
          : const EdgeInsets.symmetric(vertical: 10),
      child: _DateTimeTextField(
        controller: _controller,
        keyboardType: TextInputType.text,
        initialValue: widget.initialDateTime,
        maxLength: widget.maxLength,
        showResetButton: widget.showResetButton,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        minLines: widget.minLines,
        decoration: InputDecoration(
          fillColor: widget.backgroundColor,
          contentPadding: widget.contentPadding ??
              (widget.dense
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 0)
                  : null),
          filled: widget.backgroundColor != null,
          border: OutlineInputBorder(
            borderSide: widget.dense ? BorderSide.none : const BorderSide(),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: widget.dense ? BorderSide.none : const BorderSide(),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: widget.dense ? BorderSide.none : const BorderSide(),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: widget.dense ? BorderSide.none : const BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: widget.dense ? BorderSide.none : const BorderSide(),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: widget.dense ? BorderSide.none : const BorderSide(),
          ),
          hintText: widget.hintText,
          counterText: widget.counterText,
          labelText: widget.labelText,
          prefix: widget.prefix,
          suffix: widget.suffix,
        ),
        style: Config.isIOS ? const TextStyle(fontSize: 13) : null,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        format: widget.format,
        validator: (value) {
          if (!widget.allowEmpty &&
              widget.errorText.isNotEmpty &&
              value == null) {
            return widget.errorText;
          }
          return widget.validator?.call(value);
        },
        onEditingComplete: widget.onEditingComplete,
        onChanged: widget.onChanged,
        onSaved: (value) {
          if (!widget.allowEmpty && value == null) {
            return;
          }
          widget.onSaved?.call(value);
        },
        onShowPicker: widget.onShowPicker,
      ),
    );
  }
}

enum FormItemDateTimeFieldPickerType { date, time, dateTime }

class _DateTimeTextField extends FormField<DateTime> {
  _DateTimeTextField({
    required this.format,
    required this.onShowPicker,
    Key? key,
    FormFieldSetter<DateTime?>? onSaved,
    FormFieldValidator<DateTime?>? validator,
    DateTime? initialValue,
    bool enabled = true,
    this.resetIcon = const Icon(Icons.close),
    this.onChanged,
    this.controller,
    // ignore: unused_element
    this.focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    bool showResetButton = true,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    this.readOnly = true,
    bool? showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    VoidCallback? onEditingComplete,
    ValueChanged<DateTime?>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
  }) : super(
          key: key,
          initialValue: initialValue,
          enabled: enabled,
          validator: validator,
          onSaved: onSaved,
          builder: (field) {
            final _DateTimeTextFieldState state =
                field as _DateTimeTextFieldState;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return TextField(
              mouseCursor: SystemMouseCursors.click,
              controller: state._effectiveController ??
                  TextEditingController(
                    text: state.value != null
                        ? state.widget.format.format(state.value!)
                        : null,
                  ),
              focusNode: state._effectiveFocusNode,
              decoration: effectiveDecoration.copyWith(
                errorText: field.errorText,
                suffixIcon: showResetButton &&
                        state.shouldShowClearIcon(effectiveDecoration)
                    ? IconButton(
                        icon: resetIcon,
                        color: field.context.theme.textColor,
                        onPressed: state.clear,
                      )
                    : null,
              ),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
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

  /// For representing the date as a string e.g.
  /// `DateFormat("EEEE, MMMM d, yyyy 'at' h:mma")`
  /// (Sunday, June 3, 2018 at 9:24pm)
  final DateFormat format;

  /// Called when the date chooser dialog should be shown.
  final Future<DateTime> Function(BuildContext context, DateTime currentValue)?
      onShowPicker;

  /// The [InputDecoration.suffixIcon] to show when the field has text. Tapping
  /// the icon will clear the text field. Set this to `null` to disable that
  /// behavior. Also, setting the suffix icon yourself will override this option.
  final Icon resetIcon;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final void Function(DateTime? value)? onChanged;

  @override
  _DateTimeTextFieldState createState() => _DateTimeTextFieldState();

  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  static DateTime combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  // static DateTime convert(TimeOfDay time) =>
  //     DateTime(1, 1, 1, time.hour, time.minute);
}

class _DateTimeTextFieldState extends FormFieldState<DateTime> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  _DateTimeTextField get widget => super.widget as _DateTimeTextField;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  FocusNode? get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  bool get hasFocus => _effectiveFocusNode?.hasFocus ?? false;
  bool get hasText => _effectiveController.isNotEmpty;

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
    widget.controller?.addListener(_handleControllerChanged);
    widget.focusNode?.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(_DateTimeTextField oldWidget) {
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
  }

  @override
  void didChange(DateTime? value) {
    widget.onChanged?.call(value);
    super.didChange(value);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode?.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    widget.focusNode?.removeListener(_handleFocusChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    _effectiveController?.text = format(widget.initialValue) ?? "";
    didChange(widget.initialValue);
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != format(value))
      didChange(parse(_effectiveController?.text));
  }

  String? format(DateTime? date) =>
      date == null ? null : widget.format.format(date);
  DateTime? parse(String? text) {
    try {
      return text.isEmpty ? null : widget.format.parseLoose(text!);
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
      final newValue =
          await widget.onShowPicker?.call(context, value ?? DateTime.now());
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _effectiveController?.clear());
    });
  }

  bool shouldShowClearIcon([InputDecoration? decoration]) =>
      (hasText || hasFocus) &&
      decoration?.suffixIcon == null &&
      !widget.readOnly;
}
