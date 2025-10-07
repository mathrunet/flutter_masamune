part of "/katana_form.dart";

/// Form to select from all elements in [TEnum].
///
/// モーダルで列挙型の選択肢から選択することができるフォーム。
/// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで列挙型の値を管理可能。
/// 列挙型の値をラベル付きで表示、カスタムデザインなどの機能を備えています。
///
/// ## ピッカーの指定
///
/// Specify [picker] to define the selection options.
///
/// [picker]を指定して選択肢を定義します。
///
/// ## 基本的な使用例
///
/// ```dart
/// enum UserType {
///   admin,
///   user,
///   guest;
///
///   String get label => switch (this) {
///       admin => "管理者",
///       user => "一般ユーザー",
///       guest => "ゲスト",
///     };
/// }
///
/// FormEnumModalField(
///   form: formController,
///   initialValue: formController.value.type,
///   onSaved: (value) => formController.value.copyWith(type: value),
///   picker: FormEnumModalFieldPicker(
///     values: UserType.values,
///   ),
/// );
/// ```
///
/// ## ラベル付きの使用例
///
/// ```dart
/// FormEnumModalField(
///   form: formController,
///   initialValue: formController.value.type,
///   onSaved: (value) => formController.value.copyWith(type: value),
///   picker: FormEnumModalFieldPicker(
///     values: UserType.values,
///     labelBuilder: (value) {
///       return value.label;
///     },
///   ),
/// );
/// ```
///
/// ## バリデーション付きの使用例
///
/// ```dart
/// FormEnumModalField(
///   form: formController,
///   initialValue: formController.value.type,
///   validator: (value) {
///     if (value == null) {
///       return "ユーザータイプを選択してください";
///     }
///     if (value == UserType.guest) {
///       return "ゲストユーザーは選択できません";
///     }
///     return null;
///   },
///   onSaved: (value) => formController.value.copyWith(type: value),
///   picker: FormEnumModalFieldPicker(
///     values: UserType.values,
///   ),
/// );
/// ```
class FormEnumModalField<TEnum extends Enum, TValue> extends StatefulWidget {
  /// Form to select from all elements in [TEnum].
  ///
  /// モーダルで列挙型の選択肢から選択することができるフォーム。
  /// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで列挙型の値を管理可能。
  /// 列挙型の値をラベル付きで表示、カスタムデザインなどの機能を備えています。
  ///
  /// ## ピッカーの指定
  ///
  /// Specify [picker] to define the selection options.
  ///
  /// [picker]を指定して選択肢を定義します。
  ///
  /// ## 基本的な使用例
  ///
  /// ```dart
  /// enum UserType {
  ///   admin,
  ///   user,
  ///   guest;
  ///
  ///   String get label => switch (this) {
  ///       admin => "管理者",
  ///       user => "一般ユーザー",
  ///       guest => "ゲスト",
  ///     };
  /// }
  ///
  /// FormEnumModalField(
  ///   form: formController,
  ///   initialValue: formController.value.type,
  ///   onSaved: (value) => formController.value.copyWith(type: value),
  ///   picker: FormEnumModalFieldPicker(
  ///     values: UserType.values,
  ///   ),
  /// );
  /// ```
  ///
  /// ## ラベル付きの使用例
  ///
  /// ```dart
  /// FormEnumModalField(
  ///   form: formController,
  ///   initialValue: formController.value.type,
  ///   onSaved: (value) => formController.value.copyWith(type: value),
  ///   picker: FormEnumModalFieldPicker(
  ///     values: UserType.values,
  ///     labelBuilder: (value) {
  ///       return value.label;
  ///     },
  ///   ),
  /// );
  /// ```
  ///
  /// ## バリデーション付きの使用例
  ///
  /// ```dart
  /// FormEnumModalField(
  ///   form: formController,
  ///   initialValue: formController.value.type,
  ///   validator: (value) {
  ///     if (value == null) {
  ///       return "ユーザータイプを選択してください";
  ///     }
  ///     if (value == UserType.guest) {
  ///       return "ゲストユーザーは選択できません";
  ///     }
  ///     return null;
  ///   },
  ///   onSaved: (value) => formController.value.copyWith(type: value),
  ///   picker: FormEnumModalFieldPicker(
  ///     values: UserType.values,
  ///   ),
  /// );
  /// ```
  const FormEnumModalField({
    required this.picker,
    this.form,
    super.key,
    this.controller,
    this.prefix,
    this.suffix,
    this.hintText,
    this.labelText,
    this.emptyErrorText,
    this.style,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
    this.onSaved,
    this.focusNode,
    this.keepAlive = true,
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

  /// Initial value.
  ///
  /// 初期値。
  final TEnum? initialValue;

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
  final TValue Function(TEnum value)? onSaved;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(TEnum? value)? onChanged;

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
  final FormFieldValidator<TEnum?>? validator;

  /// It is executed when the Enter button on the keyboard or the Submit button on the software keyboard is pressed.
  ///
  /// The current value is passed to `value`.
  ///
  /// キーボードのEnterボタン、もしくはソフトウェアキーボードのサブミットボタンが押された場合に実行されます。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(TEnum? value)? onSubmitted;

  /// Picker object for selecting [TEnum].
  ///
  /// [TEnum]を選択するためのピッカーオブジェクト。
  final FormEnumModalFieldPicker<TEnum> picker;

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
  State<StatefulWidget> createState() =>
      _FormEnumModalFieldState<TEnum, TValue>();
}

class _FormEnumModalFieldState<TEnum extends Enum, TValue>
    extends State<FormEnumModalField<TEnum, TValue>>
    with AutomaticKeepAliveClientMixin<FormEnumModalField<TEnum, TValue>> {
  TextEditingController? _controller;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      return;
    }
    if (widget.initialValue != null) {
      widget.controller?.text = widget.initialValue!.toString();
    }
    _controller = TextEditingController(text: widget.controller?.text);
    _controller?.addListener(_listenerInside);
    widget.controller?.addListener(_listenerOutside);
  }

  @override
  void didUpdateWidget(FormEnumModalField<TEnum, TValue> oldWidget) {
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
              _EnumTextField<TEnum, TValue>(
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

class _EnumTextField<TEnum extends Enum, TValue> extends FormField<TEnum> {
  _EnumTextField({
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
            final state = field as _EnumTextFieldState<TEnum, TValue>;
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            return TextField(
              mouseCursor: !enabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              controller: state._effectiveController ??
                  TextEditingController(
                    text: state.value?.toString(),
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
  final FormEnumModalFieldPicker<TEnum> picker;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final void Function(TEnum? value)? onChanged;
  final void Function(TEnum? value)? onSubmitted;

  @override
  _EnumTextFieldState<TEnum, TValue> createState() =>
      _EnumTextFieldState<TEnum, TValue>();
}

class _EnumTextFieldState<TEnum extends Enum, TValue>
    extends FormFieldState<TEnum> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  bool isShowingDialog = false;
  bool hadFocus = false;

  @override
  _EnumTextField<TEnum, TValue> get widget =>
      super.widget as _EnumTextField<TEnum, TValue>;

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
  void didUpdateWidget(_EnumTextField<TEnum, TValue> oldWidget) {
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
  void didChange(TEnum? value) {
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

  String? format(TEnum? value) {
    return widget.picker.labelBuilder?.call(value) ?? value?.name;
  }

  TEnum? parse(String? text) {
    return widget.picker.values.firstWhereOrNull(
      (item) => (widget.picker.labelBuilder?.call(item) ?? item.name) == text,
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

/// Class that defines the picker style for selecting [TEnum].
///
/// [TEnum]を選択するためのピッカースタイルを定義するクラス。
class FormEnumModalFieldPicker<TEnum extends Enum> {
  /// Class that defines the picker style for selecting [TEnum].
  ///
  /// [TEnum]を選択するためのピッカースタイルを定義するクラス。
  FormEnumModalFieldPicker({
    required this.values,
    this.defaultValue,
    this.labelBuilder,
    this.backgroundColor,
    this.color,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
  }) : assert(
          (defaultValue?.index ?? 0) < values.length,
          "[defaultValue] is not included in [values].",
        );

  /// Default value when not selected.
  ///
  /// 選択されていないときのデフォルトの値。
  final TEnum? defaultValue;

  /// List of [TEnum]. Pass `TEnum.values` as is.
  ///
  /// [TEnum]のリスト。`TEnum.values`をそのまま渡してください。
  final List<TEnum> values;

  /// Label builder to create text to display choices.
  ///
  /// 選択肢を表示するためのテキストを作成するためのラベルビルダー。
  final String Function(TEnum? value)? labelBuilder;

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
  /// [context] is passed [BuildContext]. [currentValue] is passed the currently selected [TEnum].
  ///
  /// ピッカーのビルドを行ないます。
  ///
  /// [context]に[BuildContext]が渡されます。[currentValue]に現在選択されている[TEnum]が渡されます。
  Future<TEnum?> build(BuildContext context, TEnum? currentValue) async {
    TEnum? res;
    final theme = Theme.of(context);
    await _Picker(
      height: 240,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      containerColor: backgroundColor ?? theme.colorScheme.surface,
      headerColor: backgroundColor ?? theme.colorScheme.surface,
      textStyle: TextStyle(color: color ?? theme.colorScheme.onSurface),
      confirmText: confirmText,
      cancelText: cancelText,
      selecteds: [
        currentValue?.index ?? defaultValue?.index ?? 0,
      ],
      adapter: _PickerDataAdapter<TEnum>(
        data: [
          ...values.map((key) {
            return _PickerItem<TEnum>(
              text: Text(
                labelBuilder?.call(key) ?? key.name,
                style: TextStyle(
                  color: color ?? theme.colorScheme.onSurface,
                ),
              ),
              value: key,
            );
          })
        ],
      ),
      changeToFirst: true,
      hideHeader: false,
      onConfirm: (_Picker picker, List<int> value) {
        res = values[value[0]];
      },
    ).showModal(context);
    return res;
  }
}
