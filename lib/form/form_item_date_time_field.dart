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
    this.dense = false,
    this.enabled = true,
    this.prefix,
    this.suffix,
    this.errorText,
    this.allowEmpty = false,
    this.readOnly = false,
    this.obscureText = false,
    this.contentPadding,
    this.type = FormItemDateTimeFieldPickerType.dateTime,
    this.initialDateTime,
    DateFormat? format,
    Future<DateTime> onShowPicker(BuildContext context, DateTime dateTime)?,
    this.onSaved,
  })  : _format = format,
        _onShowPicker = onShowPicker;

  /// Calculate formatted datetime string from [millisecondsSinceEpoch].
  static String formatDateTime(int millisecondsSinceEpoch,
          {String format = "yyyy/MM/dd(E) HH:mm:ss",
          String defaultValue = ""}) =>
      _DateTimeTextFormField.formatDateTime(millisecondsSinceEpoch,
          format: format, defaultValue: defaultValue);

  /// Calculate formatted date string from [millisecondsSinceEpoch].
  static String formatDate(int millisecondsSinceEpoch,
          {String format = "yyyy/MM/dd(E)", String defaultValue = ""}) =>
      _DateTimeTextFormField.formatDate(millisecondsSinceEpoch,
          format: format, defaultValue: defaultValue);

  /// Calculate formatted time string from [millisecondsSinceEpoch].
  static String formatTime(int millisecondsSinceEpoch,
          {String format = "HH:mm:ss", String defaultValue = ""}) =>
      _DateTimeTextFormField.formatTime(millisecondsSinceEpoch,
          format: format, defaultValue: defaultValue);

  /// Converts a string with only date and time information to DateTime.
  static DateTime? tryParseFromDate(String formattedString,
          {DateTime? defaultValue,
          String format = r"([0-9]+)/([0-9]+)/([0-9]+)"}) =>
      _DateTimeTextFormField.tryParseFromDate(formattedString,
          defaultValue: defaultValue, format: format);

  /// Converts a string with only date and time information to DateTime.
  static DateTime? tryParseFromDateTime(String formattedString,
          {DateTime? defaultValue,
          String format =
              r"([0-9]+)/([0-9]+)/([0-9]+)(\([^\)]+\))? ([0-9]+):([0-9]+):([0-9]+)"}) =>
      _DateTimeTextFormField.tryParseFromDateTime(formattedString,
          defaultValue: defaultValue, format: format);

  /// Calculate DateTime from [millisecondsSinceEpoch].
  static DateTime value(int millisecondsSinceEpoch) =>
      _DateTimeTextFormField.value(millisecondsSinceEpoch);

  /// Picker definition that selects only dates.
  static Future<DateTime> Function(BuildContext, DateTime) datePicker(
          {DateTime? startDate, DateTime? currentDate, DateTime? endDate}) =>
      _DateTimeTextFormField.datePicker(
          startDate: startDate, currentDate: currentDate, endDate: endDate);

  /// Definition of a picker to select time.
  static Future<DateTime> Function(BuildContext, DateTime) timePicker(
          {DateTime? currentTime}) =>
      _DateTimeTextFormField.timePicker(currentTime: currentTime);

  /// Picker definition that selects the date and time.
  static Future<DateTime> Function(BuildContext, DateTime) dateTimePicker(
          {DateTime? startDate, DateTime? current, DateTime? endDate}) =>
      _DateTimeTextFormField.dateTimePicker(
          startDate: startDate, current: current, endDate: endDate);

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLength;
  final int maxLines;
  final bool dense;
  final int? minLines;
  final String? hintText;
  final String? errorText;
  final String? labelText;
  final String? counterText;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final bool allowEmpty;
  final bool obscureText;
  final Color? backgroundColor;
  final DateTime? initialDateTime;
  final DateFormat? _format;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final FormItemDateTimeFieldPickerType type;
  final Future<DateTime> Function(BuildContext, DateTime)? _onShowPicker;
  final void Function(DateTime? value)? onSaved;

  Future<DateTime> Function(BuildContext, DateTime) get onShowPicker {
    if (_onShowPicker != null) {
      return _onShowPicker!;
    }
    switch (type) {
      case FormItemDateTimeFieldPickerType.date:
        return _DateTimeTextFormField.datePicker();
      case FormItemDateTimeFieldPickerType.time:
        return _DateTimeTextFormField.timePicker();
      default:
        return _DateTimeTextFormField.dateTimePicker();
    }
  }

  DateFormat get format {
    if (_format != null) {
      return _format!;
    }
    switch (type) {
      case FormItemDateTimeFieldPickerType.date:
        return DateFormat("yyyy/MM/dd(E)");
      case FormItemDateTimeFieldPickerType.time:
        return DateFormat("HH:mm:ss");
      default:
        return DateFormat("yyyy/MM/dd(E) HH:mm:ss");
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
      widget.controller?.text = widget.format.format(widget.initialDateTime!);
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
      child: _DateTimeTextFormField(
        controller: _controller,
        keyboardType: TextInputType.text,
        initialValue: widget.initialDateTime,
        maxLength: widget.maxLength,
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
              borderSide: widget.dense ? BorderSide.none : const BorderSide()),
          enabledBorder: OutlineInputBorder(
              borderSide: widget.dense ? BorderSide.none : const BorderSide()),
          disabledBorder: OutlineInputBorder(
              borderSide: widget.dense ? BorderSide.none : const BorderSide()),
          errorBorder: OutlineInputBorder(
              borderSide: widget.dense ? BorderSide.none : const BorderSide()),
          focusedBorder: OutlineInputBorder(
              borderSide: widget.dense ? BorderSide.none : const BorderSide()),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: widget.dense ? BorderSide.none : const BorderSide()),
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
          return null;
        },
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

/// Date and time selection form that can be handled like TextField.
class _DateTimeTextFormField extends StatelessWidget {
  /// Date and time selection form that can be handled like TextField.
  const _DateTimeTextFormField({
    required this.format,
    required this.onShowPicker,
    Key? key,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.enabled = true,
    this.resetIcon = const Icon(Icons.close),
    this.onChanged,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.readOnly = true,
    this.showCursor = true,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLengthEnforced = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.buildCounter,
  }) : super(key: key);

  /// Calculate formatted datetime string from [millisecondsSinceEpoch].
  static String formatDateTime(int millisecondsSinceEpoch,
      {String format = "yyyy/MM/dd(E) HH:mm:ss", String defaultValue = ""}) {
    if (format.isEmpty || millisecondsSinceEpoch <= 0) {
      return defaultValue;
    }
    return DateFormat(format).format(value(millisecondsSinceEpoch));
  }

  /// Calculate formatted date string from [millisecondsSinceEpoch].
  static String formatDate(int millisecondsSinceEpoch,
      {String format = "yyyy/MM/dd(E)", String defaultValue = ""}) {
    if (format.isEmpty || millisecondsSinceEpoch <= 0) {
      return defaultValue;
    }
    return DateFormat(format).format(value(millisecondsSinceEpoch));
  }

  /// Calculate formatted time string from [millisecondsSinceEpoch].
  static String formatTime(int millisecondsSinceEpoch,
      {String format = "HH:mm:ss", String defaultValue = ""}) {
    if (format.isEmpty || millisecondsSinceEpoch <= 0) {
      return defaultValue;
    }
    return DateFormat(format).format(value(millisecondsSinceEpoch));
  }

  /// Converts a string with only date and time information to DateTime.
  static DateTime? tryParseFromDate(String formattedString,
      {DateTime? defaultValue, String format = r"([0-9]+)/([0-9]+)/([0-9]+)"}) {
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
  static DateTime? tryParseFromDateTime(String formattedString,
      {DateTime? defaultValue,
      String format =
          r"([0-9]+)/([0-9]+)/([0-9]+)(\([^\)]+\))? ([0-9]+):([0-9]+):([0-9]+)"}) {
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
    final second = int.tryParse(match.group(7) ?? "");
    if (year == null ||
        month == null ||
        day == null ||
        hour == null ||
        minute == null ||
        second == null) {
      return defaultValue;
    }
    return DateTime(year, month, day, hour, minute, second);
  }

  /// Calculate DateTime from [millisecondsSinceEpoch].
  static DateTime value(int millisecondsSinceEpoch) {
    assert(millisecondsSinceEpoch > 0);
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  /// Picker definition that selects only dates.
  static Future<DateTime> Function(BuildContext, DateTime) datePicker(
      {DateTime? startDate, DateTime? currentDate, DateTime? endDate}) {
    return (context, dateTime) async {
      final date = await showDatePicker(
          context: context,
          firstDate:
              startDate ?? DateTime.now().subtract(const Duration(days: 365)),
          initialDate: currentDate ?? DateTime.now(),
          lastDate: endDate ?? DateTime.now().add(const Duration(days: 365)));
      return date ?? DateTime.now();
    };
  }

  /// Definition of a picker to select time.
  static Future<DateTime> Function(BuildContext, DateTime) timePicker(
      {DateTime? currentTime}) {
    return (context, dateTime) async {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentTime ?? DateTime.now()),
      );
      return _DateTimeField.combine(DateTime.now(), time ?? TimeOfDay.now());
    };
  }

  /// Picker definition that selects the date and time.
  static Future<DateTime> Function(BuildContext, DateTime) dateTimePicker(
      {DateTime? startDate, DateTime? current, DateTime? endDate}) {
    return (context, dateTime) async {
      final date = await showDatePicker(
          context: context,
          firstDate:
              startDate ?? DateTime.now().subtract(const Duration(days: 365)),
          initialDate: current ?? DateTime.now(),
          lastDate: endDate ?? DateTime.now().add(const Duration(days: 365)));
      if (date != null) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(current ?? DateTime.now()),
        );
        return _DateTimeField.combine(date, time ?? TimeOfDay.now());
      } else {
        return current ?? DateTime.now();
      }
    };
  }

  final DateFormat format;
  final Future<DateTime> Function(BuildContext context, DateTime currentValue)
      onShowPicker;
  final Icon resetIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final void Function(DateTime? value)? onChanged;
  final FormFieldSetter<DateTime?>? onSaved;
  final FormFieldValidator<DateTime?>? validator;
  final DateTime? initialValue;
  final bool enabled;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final bool autofocus;
  final bool showCursor;
  final bool obscureText;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final ValueChanged<DateTime?>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder? buildCounter;
  @override
  Widget build(BuildContext context) {
    return _DateTimeField(
      format: format,
      onShowPicker: onShowPicker,
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      enabled: enabled,
      resetIcon: resetIcon,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      obscureText: obscureText,
      autocorrect: autocorrect,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      cursorWidth: cursorWidth,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      buildCounter: buildCounter,
    );
  }
}

class _DateTimeField extends FormField<DateTime> {
  _DateTimeField({
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
    this.focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
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
    ValueChanged<DateTime?>? onFieldSubmitted,
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
              final _DateTimeFieldState state = field as _DateTimeFieldState;
              final InputDecoration effectiveDecoration = decoration
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              return TextField(
                mouseCursor: SystemMouseCursors.click,
                controller: state._effectiveController,
                focusNode: state._effectiveFocusNode,
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                  suffixIcon: state.shouldShowClearIcon(effectiveDecoration)
                      ? IconButton(
                          icon: resetIcon,
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
                onChanged: (string) =>
                    field.didChange(tryParse(string, format)),
                onEditingComplete: onEditingComplete,
                onSubmitted: (string) => onFieldSubmitted == null
                    ? null
                    : onFieldSubmitted(tryParse(string, format)),
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
            });

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
  _DateTimeFieldState createState() => _DateTimeFieldState();

  /// Returns an empty string if [DateFormat.format()] throws or [date] is null.
  static String? tryFormat(DateTime? date, DateFormat format) {
    if (date == null) {
      return "";
    }
    try {
      return format.format(date);
    } catch (e) {
      // print('Error formatting date: $e');
    }
    return "";
  }

  /// Returns null if [format.parse()] throws.
  static DateTime? tryParse(String? string, DateFormat format) {
    if (string.isNotEmpty) {
      return format.parse(string!);
    }
    return null;
  }

  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  static DateTime combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  // static DateTime convert(TimeOfDay time) =>
  //     DateTime(1, 1, 1, time.hour, time.minute);
}

class _DateTimeFieldState extends FormFieldState<DateTime> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  _DateTimeField get widget => super.widget as _DateTimeField;

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
      setValue(
          _DateTimeField.tryParse(_effectiveController?.text, widget.format) ??
              widget.initialValue);
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _focusNode?.addListener(_handleFocusChanged);
    }
    widget.controller?.addListener(_handleControllerChanged);
    widget.focusNode?.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(_DateTimeField oldWidget) {
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
      _DateTimeField.tryFormat(date, widget.format);
  DateTime? parse(String? text) => _DateTimeField.tryParse(text, widget.format);

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
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() => _effectiveController?.clear());
    });
  }

  bool shouldShowClearIcon([InputDecoration? decoration]) =>
      (hasText || hasFocus) &&
      decoration?.suffixIcon == null &&
      !widget.readOnly;
}
