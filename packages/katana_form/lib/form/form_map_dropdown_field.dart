part of "/katana_form.dart";

/// Drop down form to select from there with [Map] as an option.
///
/// A form field that allows you to select Key-Value pair Map format data from a dropdown menu.
/// Common design can be applied with `FormStyle`, and selection state can be managed using `FormController`.
///
/// Key-ValueペアのMap形式のデータをドロップダウンメニューで選択できるフォームフィールド。
/// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。
///
/// ## Basic Usage Example 基本的な使用例
///
/// ```dart
/// final countries = <String, String>{
///   "ja": "日本語",
///   "en": "English",
///   "es": "Español",
///   "fr": "Français",
/// };
///
/// FormMapDropdownField(
///   form: formController,
///   initialValue: formController.value.selectedLanguage,
///   onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
///   picker: FormMapDropdownFieldPicker(
///     values: countries,
///   ),
/// );
/// ```
///
/// ## Usage Example with Validation バリデーション付きの使用例
///
/// ```dart
/// FormMapDropdownField(
///   form: formController,
///   initialValue: formController.value.selectedLanguage,
///   onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
///   validator: (value) {
///     if (value == null) {
///       return "地域を選択してください";
///     }
///     return null;
///   },
///   picker: FormMapDropdownFieldPicker(
///     values: countries,
///   ),
/// );
/// ```
class FormMapDropdownField<TValue> extends FormField<String> {
  /// Drop down form to select from there with [Map] as an option.
  ///
  /// A form field that allows you to select Key-Value pair Map format data from a dropdown menu.
  /// Common design can be applied with `FormStyle`, and selection state can be managed using `FormController`.
  ///
  /// Key-ValueペアのMap形式のデータをドロップダウンメニューで選択できるフォームフィールド。
  /// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。
  ///
  /// ## Basic Usage Example 基本的な使用例
  ///
  /// ```dart
  /// final countries = <String, String>{
  ///   "ja": "日本語",
  ///   "en": "English",
  ///   "es": "Español",
  ///   "fr": "Français",
  /// };
  ///
  /// FormMapDropdownField(
  ///   form: formController,
  ///   initialValue: formController.value.selectedLanguage,
  ///   onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  ///   picker: FormMapDropdownFieldPicker(
  ///     values: countries,
  ///   ),
  /// );
  /// ```
  ///
  /// ## Usage Example with Validation バリデーション付きの使用例
  ///
  /// ```dart
  /// FormMapDropdownField(
  ///   form: formController,
  ///   initialValue: formController.value.selectedLanguage,
  ///   onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  ///   validator: (value) {
  ///     if (value == null) {
  ///       return "地域を選択してください";
  ///     }
  ///     return null;
  ///   },
  ///   picker: FormMapDropdownFieldPicker(
  ///     values: countries,
  ///   ),
  /// );
  /// ```
  FormMapDropdownField({
    required this.picker,
    this.form,
    super.key,
    this.prefix,
    this.suffix,
    this.hintText,
    this.labelText,
    this.emptyErrorText,
    this.style,
    this.onChanged,
    this.focusNode,
    this.keepAlive = true,
    this.icon,
    this.expanded = false,
    TValue Function(String value)? onSaved,
    String Function(String? value)? validator,
    super.initialValue,
    super.enabled,
  })  : assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        super(
          builder: (state) {
            return const SizedBox.shrink();
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
          validator: (value) {
            if (emptyErrorText.isNotEmpty && value == null) {
              return emptyErrorText;
            }
            return validator?.call(value);
          },
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

  /// Specifies the focus node.
  ///
  /// The focus node makes it possible to control the focus of the form.
  ///
  /// フォーカスノードを指定します。
  ///
  /// フォーカスノードを利用してフォームのフォーカスをコントロールすることが可能になります。
  final FocusNode? focusNode;

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

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(String? value)? onChanged;

  /// Picker object for selecting from [Map].
  ///
  /// [Map]からを選択するためのピッカーオブジェクト。
  final FormMapDropdownFieldPicker picker;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  /// Specify the icon displayed on the right side of the drop-down form.
  ///
  /// ドロップダウンフォームの右側に表示されているアイコンを指定します。
  final Widget? icon;

  /// Extend the form.
  ///
  /// フォームを拡張します。
  final bool expanded;

  @override
  FormFieldState<String> createState() => _FormMapDropdownFieldState<TValue>();
}

class _FormMapDropdownFieldState<TValue> extends FormFieldState<String>
    with AutomaticKeepAliveClientMixin<FormField<String>> {
  @override
  FormMapDropdownField<TValue> get widget =>
      super.widget as FormMapDropdownField<TValue>;

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormMapDropdownField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    widget.onChanged?.call(value);
    super.didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final mainTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.activeColor ?? widget.style?.color,
        ) ??
        TextStyle(
          color: widget.style?.activeColor ??
              widget.style?.color ??
              theme.textTheme.titleMedium?.color,
        );
    final subTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.subColor,
        ) ??
        TextStyle(
          color: widget.style?.subColor ??
              widget.style?.color?.withValues(alpha: 0.5) ??
              theme.textTheme.titleMedium?.color?.withValues(alpha: 0.5),
        );
    final dropdownTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.color,
        ) ??
        TextStyle(
          color: widget.style?.color ?? theme.textTheme.titleMedium?.color,
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

    final activeBackgroundColor =
        widget.style?.activeBackgroundColor ?? widget.style?.backgroundColor;
    final surfaceBackgroundColor =
        widget.style?.backgroundColor ?? theme.colorScheme.surface;

    return FormStyleScope(
      style: widget.style,
      enabled: widget.enabled,
      child: Container(
        alignment: widget.style?.alignment,
        padding:
            widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 4),
        child: SizedBox(
          height: widget.style?.height,
          width: widget.style?.width,
          child: ButtonTheme(
            alignedDropdown: widget.style?.alignedDropdown ?? false,
            child: MouseRegion(
              cursor: !widget.enabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: DropdownButtonFormField<String>(
                padding: widget.style?.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                hint: widget.hintText != null
                    ? Text(
                        widget.hintText!,
                        style:
                            widget.enabled ? mainTextStyle : disabledTextStyle,
                      )
                    : null,
                disabledHint: widget.hintText != null
                    ? Text(
                        widget.hintText!,
                        style: widget.enabled
                            ? mainTextStyle.copyWith(
                                color: theme.disabledColor,
                              )
                            : disabledTextStyle,
                      )
                    : null,
                decoration: InputDecoration(
                  // contentPadding: widget.style?.contentPadding ??
                  //     const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  fillColor: activeBackgroundColor,
                  filled: activeBackgroundColor != null,
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
                ).copyWith(errorText: errorText),
                initialValue: widget.initialValue,
                validator: (value) {
                  if (widget.emptyErrorText.isNotEmpty && value == null) {
                    return widget.emptyErrorText;
                  }
                  return widget.validator?.call(value);
                },
                // focusColor: Colors.transparent,
                onChanged: widget.enabled ? didChange : null,
                elevation: widget.style?.elevation.toInt() ?? 8,
                style: widget.enabled ? mainTextStyle : disabledTextStyle,
                icon: widget.icon,
                iconEnabledColor: widget.enabled
                    ? mainTextStyle.color
                    : disabledTextStyle.color,
                iconDisabledColor: theme.disabledColor,
                iconSize: 24,
                isDense: true,
                isExpanded: widget.expanded,
                itemHeight: widget.style?.height,
                selectedItemBuilder: widget.picker.build,
                dropdownColor: surfaceBackgroundColor,
                items: widget.picker.values.toList((key, value) {
                  return DropdownMenuItem(
                    value: key,
                    child: Text(
                      value,
                      softWrap: true,
                      style: widget.enabled
                          ? dropdownTextStyle
                          : disabledTextStyle,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

/// Class that defines the picker style for selection from [Map].
///
/// Pass `Map<String, String>` to [values].
/// Key in [Map] is the ID for selection and Value is the display label for selection.
///
/// [Map]から選択するためのピッカースタイルを定義するクラス。
///
/// `Map<String, String>`を[values]に渡します。
/// [Map]のKeyが選択用のID、Valueが選択用の表示ラベルになります。
class FormMapDropdownFieldPicker {
  /// Class that defines the picker style for selection from [Map].
  ///
  /// Pass `Map<String, String>` to [values].
  /// Key in [Map] is the ID for selection and Value is the display label for selection.
  ///
  /// [Map]から選択するためのピッカースタイルを定義するクラス。
  ///
  /// `Map<String, String>`を[values]に渡します。
  /// [Map]のKeyが選択用のID、Valueが選択用の表示ラベルになります。
  FormMapDropdownFieldPicker({
    required this.values,
    this.labelBuilder,
  });

  /// Data for options.
  ///
  /// Key in [Map] is the ID for selection and Value is the display label for selection.
  ///
  /// 選択肢用のデータ。
  ///
  /// [Map]のKeyが選択用のID、Valueが選択用の表示ラベルになります。
  final Map<String, String> values;

  /// Label builder to create text to display choices.
  ///
  /// 選択肢を表示するためのテキストを作成するためのラベルビルダー。
  final String Function(String? key)? labelBuilder;

  /// Build the picker.
  ///
  /// [context] is passed [BuildContext].
  ///
  /// ピッカーのビルドを行ないます。
  ///
  /// [context]に[BuildContext]が渡されます。
  List<Widget> build(BuildContext context) {
    final keys = values.keys.toList();
    final theme = Theme.of(context);
    final visibility = Visibility.of(context);
    final formStyleScope = FormStyleScope.of(context);
    final style = formStyleScope?.style;
    final enabled = formStyleScope?.enabled ?? true;
    final color =
        (visibility ? style?.activeColor : style?.color) ?? style?.color;
    final textStyle =
        (visibility ? style?.activeTextStyle : style?.textStyle) ??
            style?.textStyle;
    final disabledColor =
        (visibility ? style?.disabledColor : style?.disabledColor) ??
            style?.disabledColor;
    final disabledTextStyle =
        (visibility ? style?.disabledTextStyle : style?.disabledTextStyle) ??
            style?.disabledTextStyle;
    return keys.map((key) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          labelBuilder?.call(values[key]) ?? values[key] ?? "",
          softWrap: true,
          style: (enabled
                  ? textStyle?.copyWith(
                      color: color ?? theme.colorScheme.onSurface,
                    )
                  : disabledTextStyle?.copyWith(
                      color: disabledColor ?? theme.disabledColor,
                    )) ??
              TextStyle(
                color: enabled
                    ? (color ?? theme.colorScheme.onSurface)
                    : (disabledColor ?? theme.disabledColor),
              ),
        ),
      );
    }).toList();
  }
}
