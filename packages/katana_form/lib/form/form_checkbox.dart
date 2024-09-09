part of '/katana_form.dart';

/// Width of the border outside the default checkbox.
///
/// デフォルトのチェックボックスの外側のボーダーの幅。
const kDefaultCheckboxBorderWidth = 2.0;

/// This widget is used to display a check box and save the check or not.
///
/// If [labelText] or [labelWidget] is specified, the checkbox is displayed with a label.
/// Only one of [labelText] and [labelWidget] should be specified.
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// Each time the content is changed, [onChanged] is executed.
///
/// When [FormController.validate] is executed, validation and data saving are performed.
///
/// If [enabled] is `false`, the checkbox is deactivated.
///
/// If [readOnly] is set to `true`, it will show enabled, but the value cannot be changed.
///
/// チェックボックスを表示して、チェックの有無を保存するためのウィジェットです。
///
/// [labelText]もしくは[labelWidget]を指定するとラベル付きでチェックボックスが表示されます。
/// [labelText]と[labelWidget]はどちらか一方のみを指定してください。
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
/// [enabled]が`false`になるとチェックボックスが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、値が変更できなくなります。
class FormCheckbox<TValue> extends FormField<bool> {
  /// This widget is used to display a check box and save the check or not.
  ///
  /// If [labelText] or [labelWidget] is specified, the checkbox is displayed with a label.
  /// Only one of [labelText] and [labelWidget] should be specified.
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// When [FormController.validate] is executed, validation and data saving are performed.
  ///
  /// If [enabled] is `false`, the checkbox is deactivated.
  ///
  /// If [readOnly] is set to `true`, it will show enabled, but the value cannot be changed.
  ///
  /// チェックボックスを表示して、チェックの有無を保存するためのウィジェットです。
  ///
  /// [labelText]もしくは[labelWidget]を指定するとラベル付きでチェックボックスが表示されます。
  /// [labelText]と[labelWidget]はどちらか一方のみを指定してください。
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
  /// [enabled]が`false`になるとチェックボックスが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、値が変更できなくなります。
  FormCheckbox({
    this.form,
    super.key,
    FormStyle? style,
    TValue Function(bool value)? onSaved,
    bool super.initialValue = false,
    super.enabled,
    this.onChanged,
    this.keepAlive = true,
    FocusNode? focusNode,
    bool autofocus = false,
    bool readOnly = false,
    String? labelText,
    Widget? labelWidget,
    FormAffixStyle? prefix,
    FormAffixStyle? suffix,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? materialTapTargetSize,
    super.validator,
  })  : assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        assert(!(labelText != null && labelWidget != null),
            "Please select either [labelText] or [labelWidget]."),
        super(
          onSaved: (val) {
            if (val == null) {
              return;
            }
            final res = onSaved?.call(val);
            if (res == null) {
              return;
            }
            form!.value = res;
          },
          builder: (field) {
            final state = field as _FormCheckBoxState<TValue>;
            final theme = Theme.of(field.context);
            final mainTextStyle = style?.textStyle?.copyWith(
                  color: style.color,
                ) ??
                TextStyle(
                  color: style?.color ?? theme.textTheme.titleMedium?.color,
                );
            final subTextStyle = style?.textStyle?.copyWith(
                  color: style.subColor,
                ) ??
                TextStyle(
                  color: style?.subColor ??
                      style?.color?.withOpacity(0.5) ??
                      theme.textTheme.titleMedium?.color?.withOpacity(0.5),
                );
            final errorTextStyle = style?.errorTextStyle?.copyWith(
                  color: style.errorColor,
                ) ??
                style?.textStyle?.copyWith(
                  color: style.errorColor,
                ) ??
                TextStyle(
                  color: style?.errorColor ?? theme.colorScheme.error,
                );
            final disabledTextStyle = style?.textStyle?.copyWith(
                  color: style.disabledColor,
                ) ??
                TextStyle(
                  color: style?.disabledColor ?? theme.disabledColor,
                );
            final border = BorderSide(
              width: style?.borderWidth ?? kDefaultCheckboxBorderWidth,
              color: style?.borderColor ??
                  style?.disabledBackgroundColor ??
                  theme.disabledColor,
            );

            InputBorder getBorderSide(Color borderColor) {
              switch (style?.borderStyle) {
                case FormInputBorderStyle.outline:
                  return OutlineInputBorder(
                    borderRadius: style?.borderRadius ??
                        const BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: style?.borderWidth ?? 1.0,
                    ),
                  );
                case FormInputBorderStyle.underline:
                  return UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: style?.borderColor ?? theme.dividerColor,
                      width: style?.borderWidth ?? 1.0,
                    ),
                    borderRadius: style?.borderRadius ??
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
                getBorderSide(style?.borderColor ?? theme.dividerColor);
            final errorBorderSide =
                getBorderSide(style?.errorColor ?? theme.colorScheme.error);
            final disabledBorderSide =
                getBorderSide(style?.disabledColor ?? theme.disabledColor);

            final checkbox = Checkbox(
              value: field.value ?? false,
              tristate: false,
              visualDensity: visualDensity,
              materialTapTargetSize: materialTapTargetSize,
              onChanged:
                  enabled && !readOnly ? (val) => field.didChange(val) : null,
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (!readOnly && states.contains(WidgetState.disabled)) {
                  return style?.disabledBackgroundColor ?? theme.disabledColor;
                }
                if (states.contains(WidgetState.selected)) {
                  return style?.activeBackgroundColor ??
                      theme.colorScheme.primary;
                }
                return style?.backgroundColor ??
                    theme.checkboxTheme.fillColor?.resolve(states);
              }),
              checkColor: enabled
                  ? (style?.activeColor ?? theme.colorScheme.onPrimary)
                  : style?.disabledColor,
              side: enabled
                  ? style?.border?.borderSide ?? border
                  : style?.disabledBorder?.borderSide ?? border,
              focusNode: focusNode,
              autofocus: autofocus,
              shape: style?.shape,
            );
            if (labelText == null && labelWidget == null) {
              return checkbox;
            }
            return MouseRegion(
              cursor: enabled == false
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: InputDecorator(
                baseStyle: style?.textStyle,
                textAlign: style?.textAlign,
                textAlignVertical: style?.textAlignVertical,
                decoration: InputDecoration(
                  contentPadding: style?.contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  fillColor: style?.backgroundColor,
                  filled: style?.backgroundColor != null,
                  isDense: true,
                  border: style?.border ?? borderSide,
                  enabledBorder: style?.border ?? borderSide,
                  disabledBorder: style?.disabledBorder ??
                      style?.border ??
                      disabledBorderSide,
                  errorBorder:
                      style?.errorBorder ?? style?.border ?? errorBorderSide,
                  focusedBorder: style?.border ?? borderSide,
                  focusedErrorBorder:
                      style?.errorBorder ?? style?.border ?? errorBorderSide,
                  prefix: prefix?.child ?? style?.prefix?.child,
                  suffix: suffix?.child ?? style?.suffix?.child,
                  prefixIcon: prefix?.icon ?? style?.prefix?.icon,
                  suffixIcon: suffix?.icon ?? style?.suffix?.icon,
                  prefixText: prefix?.label ?? style?.prefix?.label,
                  suffixText: suffix?.label ?? style?.suffix?.label,
                  prefixIconColor:
                      prefix?.iconColor ?? style?.prefix?.iconColor,
                  suffixIconColor:
                      suffix?.iconColor ?? style?.suffix?.iconColor,
                  prefixIconConstraints:
                      prefix?.iconConstraints ?? style?.prefix?.iconConstraints,
                  suffixIconConstraints:
                      suffix?.iconConstraints ?? style?.suffix?.iconConstraints,
                  labelStyle: enabled ? mainTextStyle : disabledTextStyle,
                  hintStyle: subTextStyle,
                  suffixStyle: subTextStyle,
                  prefixStyle: subTextStyle,
                  counterStyle: subTextStyle,
                  helperStyle: subTextStyle,
                  errorStyle: errorTextStyle,
                ),
                child: Row(
                  children: [
                    checkbox,
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          labelWidget ??
                              Text(
                                labelText!,
                                style: style?.textStyle,
                              ),
                          if (state.errorText.isNotEmpty)
                            Text(
                              state.errorText!,
                              style: errorTextStyle,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
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

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(bool value)? onChanged;

  @override
  FormFieldState<bool> createState() => _FormCheckBoxState<TValue>();
}

class _FormCheckBoxState<TValue> extends FormFieldState<bool>
    with AutomaticKeepAliveClientMixin<FormField<bool>> {
  @override
  FormCheckbox<TValue> get widget => super.widget as FormCheckbox<TValue>;

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormCheckbox<TValue> oldWidget) {
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
  void didChange(bool? value) {
    widget.onChanged?.call(value ?? false);
    super.didChange(value);
  }

  @override
  void dispose() {
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    didChange(widget.initialValue);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(this);
  }
}
