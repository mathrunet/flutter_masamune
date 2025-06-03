part of "/katana_form.dart";

/// Provides a container with [FormStyle] applied.
///
/// You can also perform arbitrary value validation using [validator].
///
/// In [child], specify the widget to enclose in the container.
///
/// If [enabled] is `false`, the design is changed to a deactivated design.
///
/// [FormStyle]を適用したコンテナを提供します。
///
/// また、[validator]を利用して任意の値のバリデーションを行うことができます。
///
/// [child]には、コンテナで囲むウィジェットを指定します。
///
/// [enabled]が`false`の場合、非有効化のデザインに変更されます。
@immutable
class FormContainer extends StatefulWidget {
  /// Provides a container with [FormStyle] applied.
  ///
  /// You can also perform arbitrary value validation using [validator].
  ///
  /// In [child], specify the widget to enclose in the container.
  ///
  /// If [enabled] is `false`, the design is changed to a deactivated design.
  ///
  /// [FormStyle]を適用したコンテナを提供します。
  ///
  /// また、[validator]を利用して任意の値のバリデーションを行うことができます。
  ///
  /// [child]には、コンテナで囲むウィジェットを指定します。
  ///
  /// [enabled]が`false`の場合、非有効化のデザインに変更されます。
  const FormContainer({
    this.form,
    super.key,
    this.style,
    this.child,
    this.prefix,
    this.suffix,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.counterText,
    this.width,
    this.height,
    this.padding,
    this.contentPadding,
    this.alignment,
    this.errorText,
    this.validator,
  }) : assert(
          (form == null && validator == null) ||
              (form != null && validator != null),
          "Both are required when using [form] or [validator].",
        );

  /// Context for forms.
  ///
  /// The widget is created outside of the widget in advance and handed over to the client.
  ///
  /// フォーム用のコンテキスト。
  ///
  /// 予めウィジェット外で作成し渡します。
  final FormController? form;

  /// Widgets enclosed in containers.
  ///
  /// コンテナで囲むウィジェット。
  final Widget? child;

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

  /// Hint to be displayed on the form. Displayed when no text is entered.
  ///
  /// フォームに表示するヒント。文字が入力されていない場合表示されます。
  final String? hintText;

  /// Label text for forms.
  ///
  /// フォーム用のラベルテキスト。
  final String? labelText;

  /// Error text.
  ///
  /// エラーテキスト。
  final String? errorText;

  /// If this is `false`, it is deactivated.
  ///
  /// The design of the form will be changed to a deactivated one.
  ///
  /// これが`false`の場合、非有効化されます。
  ///
  /// フォームのデザインが非有効化されたものに変更されます。
  final bool enabled;

  /// Text of the character counter. Default is disabled.
  ///
  /// 文字数のカウンターのテキスト。デフォルトは無効化されています。
  final String? counterText;

  /// Container width.
  ///
  /// コンテナの幅。
  final double? width;

  /// Container height.
  ///
  /// コンテナの高さ。
  final double? height;

  /// Outer margins.
  ///
  /// 外側の余白。
  final EdgeInsetsGeometry? padding;

  /// Inner margins.
  ///
  /// 内側の余白。
  final EdgeInsetsGeometry? contentPadding;

  /// Alignment of child.
  ///
  /// 子要素の配置。
  final AlignmentGeometry? alignment;

  /// Set validators for forms.
  ///
  /// If an error text is returned as the return value, the error text is displayed.
  ///
  /// It is executed after the other fields so that it can refer to the values of the other fields.
  ///
  /// To specify this, give [form].
  ///
  /// フォーム用のバリデータを設定します。
  ///
  /// 戻り値としてエラーテキストを返すと、エラーテキストが表示されます。
  ///
  /// 他のフィールドよりも後に実行されるため、他のフィールドの値を参照することができます。
  ///
  /// これを指定する場合は[form]を与えて下さい。
  final String? Function()? validator;

  @override
  State<StatefulWidget> createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    widget.form?._registerContainer(this);
  }

  @override
  void didUpdateWidget(FormContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.form != oldWidget.form) {
      oldWidget.form?._unregisterContainer(this);
      widget.form?._registerContainer(this);
    }
  }

  @override
  void dispose() {
    widget.form?._unregisterContainer(this);
    super.dispose();
  }

  bool _validate() {
    final result = widget.validator?.call();
    if (result != null) {
      setState(() {
        _errorText = result;
      });
    } else if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
    return result == null;
  }

  @override
  Widget build(BuildContext context) {
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
        width: widget.width ?? widget.style?.width,
        height: widget.height ?? widget.style?.height,
        padding: widget.padding ??
            widget.style?.padding ??
            const EdgeInsets.symmetric(vertical: 8),
        alignment: widget.alignment ?? Alignment.center,
        child: InputDecorator(
          decoration: InputDecoration(
            errorText: _errorText,
            contentPadding: widget.contentPadding ??
                widget.style?.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            counterText: widget.counterText,
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
          ),
          child: widget.child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
