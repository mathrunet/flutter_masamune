part of "/katana_form.dart";

/// Default maximum pin length.
///
/// デフォルトのピンの最大長。
const kPinLength = 6;

/// Widget for Pin text field for forms.
///
/// A form field for PIN code input.
/// Common design can be applied with `FormStyle`, and PIN code state management can be performed using `FormController`.
/// It provides features such as digit number settings.
///
/// PINコード入力用のフォームフィールド。
/// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでPINコードの状態管理を行えます。
/// 桁数設定などの機能を備えています。
///
/// ## Basic Usage Example 基本的な使用例
///
/// ```dart
/// FormPinField(
///   form: formController,
///   initialValue: "1234",
///   onSaved: (value) => formController.value.copyWith(pin: value),
/// );
/// ```
///
/// ## Usage Example with Maximum Digits Specified 最大桁数を指定した使用例
///
/// ```dart
/// FormPinField(
///   form: formController,
///   onSaved: (value) => formController.value.copyWith(pin: value),
///   maxLength: 6,
/// );
/// ```
///
/// ## Usage Example with Validation バリデーション付きの使用例
///
/// ```dart
/// FormPinField(
///   form: formController,
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return "PINコードを入力してください";
///     }
///     if (value.length != 4) {
///       return "PINコードは4桁で入力してください";
///     }
///     if (!RegExp(r'^[0-9]+\$').hasMatch(value)) {
///       return "PINコードは数字のみ入力可能です";
///     }
///     return null;
///   },
///   onSaved: (value) => formController.value.copyWith(pin: value),
/// );
/// ```
class FormPinField<TValue> extends FormField<String> {
  /// Widget for Pin text field for forms.
  ///
  /// A form field for PIN code input.
  /// Common design can be applied with `FormStyle`, and PIN code state management can be performed using `FormController`.
  /// It provides features such as digit number settings.
  ///
  /// PINコード入力用のフォームフィールド。
  /// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでPINコードの状態管理を行えます。
  /// 桁数設定などの機能を備えています。
  ///
  /// ## Basic Usage Example 基本的な使用例
  ///
  /// ```dart
  /// FormPinField(
  ///   form: formController,
  ///   initialValue: "1234",
  ///   onSaved: (value) => formController.value.copyWith(pin: value),
  /// );
  /// ```
  ///
  /// ## Usage Example with Maximum Digits Specified 最大桁数を指定した使用例
  ///
  /// ```dart
  /// FormPinField(
  ///   form: formController,
  ///   onSaved: (value) => formController.value.copyWith(pin: value),
  ///   maxLength: 6,
  /// );
  /// ```
  ///
  /// ## Usage Example with Validation バリデーション付きの使用例
  ///
  /// ```dart
  /// FormPinField(
  ///   form: formController,
  ///   validator: (value) {
  ///     if (value == null || value.isEmpty) {
  ///       return "PINコードを入力してください";
  ///     }
  ///     if (value.length != 4) {
  ///       return "PINコードは4桁で入力してください";
  ///     }
  ///     if (!RegExp(r'^[0-9]+\$').hasMatch(value)) {
  ///       return "PINコードは数字のみ入力可能です";
  ///     }
  ///     return null;
  ///   },
  ///   onSaved: (value) => formController.value.copyWith(pin: value),
  /// );
  /// ```
  FormPinField({
    super.key,
    this.keepAlive = true,
    int maxLength = kPinLength,
    int? minLength,
    this.form,
    this.controller,
    this.style,
    super.enabled = true,
    String? initialValue,
    this.focusNode,
    TextInputType keyboardType = TextInputType.phone,
    TextInputAction textInputAction = TextInputAction.done,
    List<TextInputFormatter>? inputFormatters,
    bool autocorrect = false,
    bool enableInteractiveSelection = false,
    this.readOnly = false,
    Iterable<String>? autofillHints,
    Cursor? mouseCursor,
    TextCapitalization textCapitalization = TextCapitalization.none,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String? emptyErrorText,
    String? lengthErrorText,
    String? Function(String? value)? validator,
    TValue Function(String value)? onSaved,
    String? hintText,
    bool obscureText = false,
    this.autofocus = false,
  })  : assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        super(
          initialValue:
              controller != null ? controller.text : (initialValue ?? ""),
          validator: (value) {
            if (emptyErrorText.isNotEmpty && value.isEmpty) {
              return emptyErrorText;
            }
            if (lengthErrorText.isNotEmpty && minLength.def(0) > value.length) {
              return lengthErrorText;
            }
            return validator?.call(value);
          },
          onSaved: (value) {
            if (value == null) {
              return;
            }
            final res = onSaved?.call(value);
            if (res == null) {
              return;
            }
            form!.value = res;
          },
          autovalidateMode: AutovalidateMode.disabled,
          builder: (FormFieldState<String> field) {
            final state = field as _FormPinFieldState<TValue>;
            final context = state.context;
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            final mainTextStyle = style?.textStyle?.copyWith(
                  color: style.color,
                ) ??
                Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: style?.color ??
                          Theme.of(context).textTheme.displaySmall?.color,
                    ) ??
                TextStyle(
                  color: style?.color ??
                      Theme.of(context).textTheme.displaySmall?.color ??
                      Theme.of(context).textTheme.displaySmall?.color,
                );
            final subTextStyle = style?.textStyle?.copyWith(
                  color: style.subColor,
                ) ??
                TextStyle(
                  color: style?.subColor ??
                      style?.color?.withValues(alpha: 0.5) ??
                      Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.color
                          ?.withValues(alpha: 0.5),
                );
            final errorTextStyle = style?.errorTextStyle?.copyWith(
                  color: style.errorColor,
                ) ??
                style?.textStyle?.copyWith(
                  color: style.errorColor,
                ) ??
                TextStyle(
                  color:
                      style?.errorColor ?? Theme.of(context).colorScheme.error,
                );
            final borderColor =
                style?.borderColor ?? Theme.of(context).dividerColor;

            return FormStyleScope(
              style: style,
              enabled: enabled,
              child: Container(
                alignment: style?.alignment,
                padding:
                    style?.padding ?? const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: style?.height,
                  width: style?.width,
                  child: UnmanagedRestorationScope(
                    bucket: field.bucket,
                    child: _PinInputTextField(
                      pinLength: maxLength,
                      controller: state._effectiveController,
                      focusNode: state._effectiveFocusNode,
                      decoration: BoxLooseDecoration(
                        errorText: state.errorText,
                        hintText: hintText,
                        errorTextStyle: errorTextStyle,
                        hintTextStyle: subTextStyle,
                        obscureStyle: ObscureStyle(isTextObscure: obscureText),
                        strokeColorBuilder: FixedColorBuilder(borderColor),
                        bgColorBuilder: FixedColorBuilder(
                          style?.backgroundColor ??
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        textStyle: mainTextStyle,
                      ),
                      keyboardType: keyboardType,
                      textInputAction: textInputAction,
                      textCapitalization: textCapitalization,
                      autocorrect: autocorrect,
                      autoFocus: autofocus,
                      onChanged: onChangedHandler,
                      onSubmit: onSubmitted,
                      inputFormatters: inputFormatters,
                      enabled: enabled,
                      enableInteractiveSelection: enableInteractiveSelection,
                      autofillHints: autofillHints,
                      cursor: mouseCursor,
                    ),
                  ),
                ),
              ),
            );
          },
        );

  /// Form Style.
  ///
  /// フォームのスタイル。
  final FormStyle? style;

  /// Context for forms.
  ///
  /// The widget is created outside of the widget in advance and handed over to the client.
  ///
  /// フォーム用のコンテキスト。
  ///
  /// 予めウィジェット外で作成し渡します。
  final FormController<TValue>? form;

  /// If this is `true`, the form cannot be filled out and changed from its initial value.
  ///
  /// これが`true`の場合、フォームの入力が行えずに初期値から変更することができなくなります。
  final bool readOnly;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  /// Controller for text forms.
  ///
  /// テキストフォーム用のコントローラー。
  final TextEditingController? controller;

  /// If `true`, focus is automatically applied.
  ///
  /// `true`の場合、自動でフォーカスが当たります。
  final bool autofocus;

  /// Specifies the focus node.
  ///
  /// The focus node makes it possible to control the focus of the form.
  ///
  /// フォーカスノードを指定します。
  ///
  /// フォーカスノードを利用してフォームのフォーカスをコントロールすることが可能になります。
  final FocusNode? focusNode;

  @override
  FormFieldState<String> createState() => _FormPinFieldState<TValue>();
}

class _FormPinFieldState<TValue> extends FormFieldState<String>
    with AutomaticKeepAliveClientMixin<FormField<String>> {
  RestorableTextEditingController? _controller;
  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode!;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  @override
  FormPinField<TValue> get widget => super.widget as FormPinField<TValue>;

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
    if (widget.controller == null) {
      _createLocalController(
        widget.initialValue != null
            ? TextEditingValue(text: widget.initialValue!)
            : null,
      );
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormPinField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
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
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    widget.form?.unregister(this);
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

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(this);
  }
}

class _PinInputTextField extends StatefulWidget {
  _PinInputTextField({
    required this.decoration,
    this.pinLength = kPinLength,
    this.onSubmit,
    this.inputFormatters,
    this.keyboardType = TextInputType.phone,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.onChanged,
    textCapitalization,
    this.autocorrect = false,
    this.enableInteractiveSelection = false,
    this.autofillHints,
    Cursor? cursor,
  })  : assert(pinLength > 0, "pinLength is not greater than 0"),
        assert(
            decoration.hintText == null ||
                decoration.hintText!.length == pinLength,
            "decoration.hintText is not null and its length is not equal to pinLength"),
        assert(
            decoration is! SupportGap ||
                (decoration is SupportGap &&
                        (decoration as SupportGap).getGapWidthList == null ||
                    (decoration as SupportGap).getGapWidthList!.length ==
                        pinLength - 1),
            "decoration is not SupportGap or its getGapWidthList is not null and its length is not equal to pinLength - 1"),
        textCapitalization = textCapitalization ?? TextCapitalization.none,
        cursor = cursor ?? Cursor.disabled();

  @override
  State createState() => _PinInputTextFieldState();

  final int pinLength;

  final ValueChanged<String>? onSubmit;

  final PinDecoration decoration;

  final List<TextInputFormatter>? inputFormatters;

  final TextInputType keyboardType;

  final TextEditingController? controller;

  final bool autoFocus;

  final FocusNode? focusNode;

  final TextInputAction textInputAction;

  final bool enabled;

  final ValueChanged<String>? onChanged;

  final TextCapitalization textCapitalization;

  final bool autocorrect;

  final bool enableInteractiveSelection;

  final Iterable<String>? autofillHints;

  final Cursor cursor;
}

class _PinInputTextFieldState extends State<_PinInputTextField>
    with SingleTickerProviderStateMixin {
  String _text = "";

  TextEditingController? _controller;

  late AnimationController _cursorBlinkOpacityController;
  final ValueNotifier<bool> _cursorVisibilityNotifier =
      ValueNotifier<bool>(true);
  Timer? _cursorTimer;
  bool _targetCursorVisibility = false;

  Color _cursorColor = Colors.transparent;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  void _pinChanged() {
    setState(_updateText);
  }

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  void _updateText() {
    if (_effectiveController!.text.runes.length > widget.pinLength) {
      _text = String.fromCharCodes(
          _effectiveController!.text.runes.take(widget.pinLength));
    } else {
      _text = _effectiveController!.text;
    }

    widget.decoration.notifyChange(_text);
  }

  @override
  void initState() {
    super.initState();
    _cursorBlinkOpacityController =
        AnimationController(vsync: this, duration: widget.cursor.fadeDuration);
    _cursorBlinkOpacityController.addListener(_onCursorColorTick);
    _cursorVisibilityNotifier.value = widget.cursor.enabled;
    _effectiveFocusNode.addListener(_handleFocusChanged);
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    _effectiveController!.addListener(_pinChanged);

    _updateText();
    _startOrStopCursorTimerIfNeeded();
  }

  void _onCursorColorTick() {
    if (widget.cursor.enabled) {
      _cursorColor = widget.cursor.color
          .withValues(alpha: _cursorBlinkOpacityController.value);
      _cursorVisibilityNotifier.value = _cursorBlinkOpacityController.value > 0;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _effectiveController!.removeListener(_pinChanged);
    _cursorBlinkOpacityController.removeListener(_onCursorColorTick);
    _stopCursorTimer();
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(_PinInputTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller!.removeListener(_pinChanged);
      _controller =
          TextEditingController.fromValue(oldWidget.controller!.value);
      _controller!.addListener(_pinChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller!.removeListener(_pinChanged);
      _controller = null;
      widget.controller!.addListener(_pinChanged);
      if (_text != widget.controller!.text) {
        _pinChanged();
      }
    } else if (widget.controller != oldWidget.controller) {
      oldWidget.controller!.removeListener(_pinChanged);
      widget.controller!.addListener(_pinChanged);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }

    if (oldWidget.pinLength > widget.pinLength &&
        _text.runes.length > widget.pinLength) {
      setState(() {
        _text = _text.substring(0, widget.pinLength);
        _effectiveController!.text = _text;
        _effectiveController!.selection =
            TextSelection.collapsed(offset: _text.runes.length);
      });
    }

    widget.decoration.notifyChange(_text);
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: _buildTextField(),
    );
  }

  Widget _buildTextField() {
    final pinPaint = _PinPaint(
      text: _text,
      pinLength: widget.pinLength,
      decoration: widget.decoration,
      themeData: Theme.of(context),
      cursor: widget.cursor.copyWith(color: _cursorColor),
      textDirection: Directionality.of(context),
    );
    return CustomPaint(
      foregroundPainter: pinPaint,
      child: TextField(
        controller: _effectiveController,
        style: const TextStyle(
          color: Colors.transparent,
        ),
        showCursor: false,
        autofillHints: widget.autofillHints,
        autocorrect: widget.autocorrect,
        textAlign: TextAlign.center,
        // enableInteractiveSelection: widget.enableInteractiveSelection,
        maxLength: widget.pinLength,
        onSubmitted: widget.onSubmit,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        focusNode: _effectiveFocusNode,
        autofocus: widget.autoFocus,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        textCapitalization: widget.textCapitalization,
        decoration: InputDecoration(
          counterText: "",
          errorText: widget.decoration.errorText,
          errorStyle: widget.decoration.errorTextStyle,
          enabled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  void _cursorTick(Timer timer) {
    _targetCursorVisibility = !_targetCursorVisibility;
    final targetOpacity = _targetCursorVisibility ? 1.0 : 0.0;
    _cursorBlinkOpacityController.animateTo(targetOpacity,
        curve: Curves.easeOut);
  }

  void _cursorWaitForStart(Timer timer) {
    assert(widget.cursor.blinkHalfPeriod > widget.cursor.fadeDuration,
        "widget.cursor.blinkHalfPeriod is not greater than widget.cursor.fadeDuration");
    _cursorTimer?.cancel();
    _cursorTimer = Timer.periodic(widget.cursor.blinkHalfPeriod, _cursorTick);
  }

  void _startCursorTimer() {
    _targetCursorVisibility = true;
    _cursorBlinkOpacityController.value = 1.0;
    _cursorTimer =
        Timer.periodic(widget.cursor.blinkWaitForStart, _cursorWaitForStart);
  }

  void _stopCursorTimer() {
    _cursorTimer?.cancel();
    _cursorTimer = null;
    _targetCursorVisibility = false;
    _cursorBlinkOpacityController.value = 0.0;
    _cursorBlinkOpacityController.stop();
    _cursorBlinkOpacityController.value = 0.0;
  }

  void _startOrStopCursorTimerIfNeeded() {
    if (_cursorTimer == null && _hasFocus && _value.selection.isCollapsed) {
      _startCursorTimer();
    } else if (_cursorTimer != null &&
        (!_hasFocus || !_value.selection.isCollapsed)) {
      _stopCursorTimer();
    }
  }

  bool get _hasFocus => _effectiveFocusNode.hasFocus;

  TextEditingValue get _value => _effectiveController!.value;

  void _handleFocusChanged() {
    _startOrStopCursorTimerIfNeeded();
  }
}

class _PinPaint extends CustomPainter {
  _PinPaint({
    required this.text,
    required this.pinLength,
    required PinDecoration decoration,
    required this.themeData,
    this.type = PinEntryType.boxTight,
    this.cursor,
    this.textDirection = TextDirection.ltr,
  }) : decoration = decoration.copyWith(
          textStyle: decoration.textStyle ?? themeData.textTheme.headlineSmall,
          errorTextStyle: decoration.errorTextStyle ??
              themeData.textTheme.bodySmall
                  ?.copyWith(color: themeData.colorScheme.error),
          hintTextStyle: decoration.hintTextStyle ??
              themeData.textTheme.headlineSmall
                  ?.copyWith(color: themeData.hintColor),
        );
  final String text;
  final int pinLength;
  final PinEntryType type;
  final PinDecoration decoration;
  final ThemeData themeData;
  Cursor? cursor;
  TextDirection textDirection;

  @override
  bool shouldRepaint(_PinPaint oldDelegate) => oldDelegate != this;

  @override
  void paint(Canvas canvas, Size size) {
    decoration.drawPin(canvas, size, text, pinLength, cursor, textDirection);
  }

  _PinPaint copyWith({
    String? text,
    int? pinLength,
    PinDecoration? decoration,
    PinEntryType? type,
    ThemeData? themeData,
    Cursor? cursor,
  }) =>
      _PinPaint(
        text: text ?? this.text,
        pinLength: pinLength ?? this.pinLength,
        decoration: decoration ?? this.decoration,
        type: type ?? this.type,
        themeData: themeData ?? this.themeData,
        cursor: cursor ?? this.cursor,
      );

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PinPaint &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          pinLength == other.pinLength &&
          type == other.type &&
          decoration == other.decoration &&
          themeData == other.themeData &&
          cursor == other.cursor;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      text.hashCode ^
      pinLength.hashCode ^
      type.hashCode ^
      decoration.hashCode ^
      themeData.hashCode ^
      cursor.hashCode;
}
