part of '/katana_form.dart';

/// Drop-down form to select from all elements in [TEnum].
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
/// By specifying [picker], it is possible to set the selection method for [TEnum].
///
/// Deactivated when [enabled] is set to `false`.
///
/// [TEnum]のすべての要素から選択するためのドロップダウンフォーム。
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
/// [picker]を指定することで[TEnum]の選択方法を設定することが可能です。
///
/// [enabled]が`false`になると非有効化されます。
class FormEnumDropdownField<TEnum extends Enum, TValue>
    extends FormField<TEnum> {
  /// Drop-down form to select from all elements in [TEnum].
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
  /// By specifying [picker], it is possible to set the selection method for [TEnum].
  ///
  /// Deactivated when [enabled] is set to `false`.
  ///
  /// [TEnum]のすべての要素から選択するためのドロップダウンフォーム。
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
  /// [picker]を指定することで[TEnum]の選択方法を設定することが可能です。
  ///
  /// [enabled]が`false`になると非有効化されます。
  FormEnumDropdownField({
    super.key,
    this.form,
    this.prefix,
    this.suffix,
    this.hintText,
    this.labelText,
    this.emptyErrorText,
    this.style,
    this.onChanged,
    required this.picker,
    this.focusNode,
    this.keepAlive = true,
    this.icon,
    this.expanded = false,
    TValue Function(TEnum value)? onSaved,
    String Function(TEnum? value)? validator,
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
  final void Function(TEnum? value)? onChanged;

  /// Picker object for selecting [TEnum].
  ///
  /// [TEnum]を選択するためのピッカーオブジェクト。
  final FormEnumDropdownFieldPicker<TEnum> picker;

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
  FormFieldState<TEnum> createState() =>
      _FormEnumDropdownFieldState<TEnum, TValue>();
}

class _FormEnumDropdownFieldState<TEnum extends Enum, TValue>
    extends FormFieldState<TEnum>
    with AutomaticKeepAliveClientMixin<FormField<TEnum>> {
  @override
  FormEnumDropdownField<TEnum, TValue> get widget =>
      super.widget as FormEnumDropdownField<TEnum, TValue>;

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormEnumDropdownField<TEnum, TValue> oldWidget) {
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
  void didChange(TEnum? value) {
    widget.onChanged?.call(value);
    super.didChange(value);
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
      padding: widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: widget.style?.height,
        width: widget.style?.width,
        child: ButtonTheme(
          alignedDropdown: widget.style?.alignedDropdown ?? false,
          child: MouseRegion(
            cursor: widget.enabled == false
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: DropdownButtonFormField<TEnum>(
              padding: EdgeInsets.zero,
              hint: widget.hintText != null
                  ? Text(
                      widget.hintText!,
                      style: widget.enabled ? mainTextStyle : disabledTextStyle,
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
                contentPadding: widget.style?.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
              ).copyWith(errorText: errorText),
              focusNode: widget.focusNode,
              focusColor: Colors.transparent,
              value: widget.initialValue,
              onChanged: widget.enabled ? (value) => didChange(value) : null,
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
              dropdownColor:
                  widget.picker.backgroundColor ?? theme.colorScheme.surface,
              items: widget.picker.values.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    widget.picker.labelBuilder?.call(item) ?? item.name,
                    style: TextStyle(
                      color: widget.picker.color ?? theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

/// Class that defines the picker style for selecting [TEnum].
///
/// [TEnum]を選択するためのピッカースタイルを定義するクラス。
class FormEnumDropdownFieldPicker<TEnum extends Enum> {
  /// Class that defines the picker style for selecting [TEnum].
  ///
  /// [TEnum]を選択するためのピッカースタイルを定義するクラス。
  FormEnumDropdownFieldPicker({
    required this.values,
    this.labelBuilder,
    this.backgroundColor,
    this.color,
  });

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

  /// Build the picker.
  ///
  /// [context] is passed [BuildContext].
  ///
  /// ピッカーのビルドを行ないます。
  ///
  /// [context]に[BuildContext]が渡されます。
  List<Widget> build(BuildContext context) {
    final theme = Theme.of(context);
    return values.map((item) {
      return Container(
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        child: Text(
          labelBuilder?.call(item) ?? item.name,
          style: TextStyle(
            color: color ?? theme.colorScheme.onSurface,
          ),
        ),
      );
    }).toList();
  }
}
