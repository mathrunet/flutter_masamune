part of masamune.form;

class FormItemMonthDayField extends StatefulWidget implements FormItem {
  const FormItemMonthDayField({
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
    this.showResetButton = true,
    this.validator,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.onEditingComplete,
    this.contentPadding,
    this.initialDateTime,
    String? format,
    Future<DateTime?> onShowPicker(BuildContext context, DateTime duration)?,
    this.onSaved,
  })  : _format = format,
        _onShowPicker = onShowPicker;

  /// Calculate formatted DateTime string from [millisecondsSinceEpoch].
  static String tryFormat(
    int millisecondsSinceEpoch, {
    String format = "MM/dd",
    String defaultValue = "",
  }) {
    if (format.isEmpty || millisecondsSinceEpoch < 0) {
      return defaultValue;
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch)
        .format(format);
  }

  /// Converts a string with only date and time information to DateTime.
  static DateTime? tryParse(
    String formattedString, {
    DateTime? defaultValue,
    String format = r"([0-9]+)/([0-9]+)",
  }) {
    if (formattedString.isEmpty || format.isEmpty) {
      return defaultValue;
    }
    final regex = RegExp(format);
    final match = regex.firstMatch(formattedString);
    if (match == null) {
      return defaultValue;
    }
    final month = int.tryParse(match.group(1) ?? "");
    final day = int.tryParse(match.group(2) ?? "");
    if (month == null || day == null) {
      return defaultValue;
    }
    final now = DateTime.now();
    return DateTime(now.year, month, day);
  }

  /// Calculate DateTime from [millisecondsSinceEpoch].
  static DateTime value(int millisecondsSinceEpoch) {
    assert(millisecondsSinceEpoch > 0);
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  /// Defines the picker for DateTime.
  static Future<DateTime?> Function(BuildContext, DateTime?) picker({
    DateTime? defaultDateTime,
    String monthSuffix = "",
    String daySuffix = "",
    String monthFormat = "MM",
    Color? backgroundColor,
    Color? color,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
  }) {
    return (context, currentDateTime) async {
      DateTime? res;
      await Picker(
        height: 240,
        backgroundColor: backgroundColor ?? context.theme.surfaceColor,
        containerColor: backgroundColor ?? context.theme.surfaceColor,
        headerColor: backgroundColor ?? context.theme.surfaceColor,
        textStyle: TextStyle(color: color ?? context.theme.textColorOnSurface),
        confirmText: confirmText.localize(),
        cancelText: cancelText.localize(),
        selecteds: [
          (currentDateTime?.month ?? defaultDateTime?.month ?? 1) - 1,
          (currentDateTime?.day ?? defaultDateTime?.day ?? 1) - 1,
        ],
        adapter: PickerDataAdapter<int>(
          data: [
            ...List.generate(12, (m) {
              final month = DateTime(1970, m + 2, 0);
              return PickerItem(
                text: Text(
                  "${month.format(monthFormat)}$monthSuffix",
                  style: TextStyle(
                    color: color ?? context.theme.textColorOnSurface,
                  ),
                ),
                value: m + 1,
                children: List.generate(
                  month.day,
                  (d) => PickerItem(
                    text: Text(
                      "${(d + 1).format("00")}$daySuffix",
                      style: TextStyle(
                        color: color ?? context.theme.textColorOnSurface,
                      ),
                    ),
                    value: d + 1,
                  ),
                ),
              );
            }),
          ],
        ),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List<int> value) {
          final now = DateTime.now();
          res = DateTime(now.year, value[0] + 1, value[1] + 1);
        },
      ).showModal(context);
      return res;
    };
  }

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLength;
  final int maxLines;
  final bool dense;
  final int? minLines;
  final bool showResetButton;
  final String? hintText;
  final String? errorText;
  final String? labelText;
  final TextAlign textAlign;
  final String? counterText;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final bool allowEmpty;
  final bool obscureText;
  final Color? backgroundColor;
  final DateTime? initialDateTime;
  final String? _format;
  final bool enabled;
  final FormFieldValidator<DateTime?>? validator;
  final EdgeInsetsGeometry? contentPadding;
  final Future<DateTime?> Function(BuildContext, DateTime)? _onShowPicker;
  final void Function(DateTime? value)? onSaved;
  final void Function(DateTime? value)? onChanged;
  final void Function()? onEditingComplete;

  Future<DateTime?> Function(BuildContext, DateTime) get onShowPicker {
    if (_onShowPicker != null) {
      return _onShowPicker!;
    }
    return picker();
  }

  String get format {
    if (_format.isNotEmpty) {
      return _format!;
    }
    return "MM/dd";
  }

  @override
  State<StatefulWidget> createState() => _FormItemMonthDayFieldState();
}

class _FormItemMonthDayFieldState extends State<FormItemMonthDayField> {
  TextEditingController? _controller;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      return;
    }
    if (widget.initialDateTime != null) {
      widget.controller?.text = widget.initialDateTime!.format(widget.format);
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
      child: _MonthDayTextField(
        controller: _controller,
        keyboardType: TextInputType.text,
        initialValue: widget.initialDateTime,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        minLines: widget.minLines,
        showResetButton: widget.showResetButton,
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
        textAlign: widget.textAlign,
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

class _MonthDayTextField extends FormField<DateTime> {
  _MonthDayTextField({
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
            final _MonthDayTextFieldState state =
                field as _MonthDayTextFieldState;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return TextField(
              mouseCursor: SystemMouseCursors.click,
              controller: state._effectiveController ??
                  TextEditingController(
                    text: state.value != null
                        ? state.value!.format(state.widget.format)
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
              textAlign: textAlign,
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

  /// For representing the date as a string e.g.
  /// `DateFormat("EEEE, MMMM d, yyyy 'at' h:mma")`
  /// (Sunday, June 3, 2018 at 9:24pm)
  final String format;

  /// Called when the date chooser dialog should be shown.
  final Future<DateTime?> Function(BuildContext context, DateTime currentValue)?
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
  _MonthDayTextFieldState createState() => _MonthDayTextFieldState();
}

class _MonthDayTextFieldState extends FormFieldState<DateTime> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  _MonthDayTextField get widget => super.widget as _MonthDayTextField;

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
  void didUpdateWidget(_MonthDayTextField oldWidget) {
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

  String? format(DateTime? duration) =>
      duration == null ? null : duration.format(widget.format);
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
          .replaceAll("dd", "(?<dd>[0-9]+)"),
    );
    final match = regex.firstMatch(text);
    if (match == null) {
      return null;
    }
    final now = DateTime.now();
    final days = match.groupNames.contains("dd")
        ? int.tryParse(match.namedGroup("dd") ?? "") ?? 0
        : 0;
    final months = match.groupNames.contains("MM")
        ? int.tryParse(match.namedGroup("MM") ?? "") ?? 0
        : 0;
    return DateTime(
      now.year,
      months,
      days,
    );
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
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      setState(() => _effectiveController?.clear());
    });
  }

  bool shouldShowClearIcon([InputDecoration? decoration]) =>
      (hasText || hasFocus) &&
      decoration?.suffixIcon == null &&
      !widget.readOnly;
}
