part of masamune.form;

class FormItemDateTimeField extends StatefulWidget implements FormItem {
  const FormItemDateTimeField(
      {this.controller,
      this.keyboardType = TextInputType.text,
      this.maxLength,
      this.maxLines = 1,
      this.minLines,
      this.backgroundColor,
      this.hintText = "",
      this.labelText = "",
      this.counterText = "",
      this.dense = false,
      this.enabled = true,
      this.prefix,
      this.suffix,
      this.allowEmpty = false,
      this.readOnly = false,
      this.obscureText = false,
      this.type = FormItemDateTimeFieldPickerType.dateTime,
      this.initialDateTime,
      DateFormat? format,
      Future<DateTime> onShowPicker(BuildContext context, DateTime dateTime)?,
      this.onSaved})
      : _format = format,
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
  final String hintText;
  final String labelText;
  final String counterText;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final bool allowEmpty;
  final bool obscureText;
  final Color? backgroundColor;
  final DateTime? initialDateTime;
  final DateFormat? _format;
  final bool enabled;
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
    } else {
      widget.controller?.text = "";
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
            ? const EdgeInsets.all(0)
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
              filled: widget.backgroundColor != null,
              border: OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide()),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide()),
              disabledBorder: OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide()),
              errorBorder: OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide()),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide()),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide()),
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
              if (!widget.allowEmpty && value == null) {
                return widget.hintText;
              }
              return null;
            },
            onSaved: (value) {
              if (!widget.allowEmpty && value == null) {
                return;
              }
              widget.onSaved?.call(value!);
            },
            onShowPicker: widget.onShowPicker));
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
      return DateTimeField.combine(DateTime.now(), time);
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
        return DateTimeField.combine(date, time);
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
  final void Function(DateTime value)? onChanged;
  final FormFieldSetter<DateTime>? onSaved;
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
  final ValueChanged<DateTime>? onFieldSubmitted;
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
    return DateTimeField(
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
      maxLengthEnforced: maxLengthEnforced,
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
