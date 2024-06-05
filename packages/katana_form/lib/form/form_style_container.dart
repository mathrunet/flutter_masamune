part of '/katana_form.dart';

/// Provides a container with [FormStyle] applied.
///
/// In [child], specify the widget to enclose in the container.
///
/// If [enabled] is `false`, the design is changed to a deactivated design.
///
/// [FormStyle]を適用したコンテナを提供します。
///
/// [child]には、コンテナで囲むウィジェットを指定します。
///
/// [enabled]が`false`の場合、非有効化のデザインに変更されます。
@immutable
class FormStyleContainer extends StatelessWidget {
  /// Provides a container with [FormStyle] applied.
  ///
  /// In [child], specify the widget to enclose in the container.
  ///
  /// If [enabled] is `false`, the design is changed to a deactivated design.
  ///
  /// [FormStyle]を適用したコンテナを提供します。
  ///
  /// [child]には、コンテナで囲むウィジェットを指定します。
  ///
  /// [enabled]が`false`の場合、非有効化のデザインに変更されます。
  const FormStyleContainer({
    super.key,
    this.style,
    this.child,
    this.prefix,
    this.suffix,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.counterText,
  });

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainTextStyle = style?.textStyle?.copyWith(
          color: style?.color,
        ) ??
        TextStyle(
          color: style?.color ?? theme.textTheme.titleMedium?.color,
        );
    final subTextStyle = style?.textStyle?.copyWith(
          color: style?.subColor,
        ) ??
        TextStyle(
          color: style?.subColor ??
              style?.color?.withOpacity(0.5) ??
              theme.textTheme.titleMedium?.color?.withOpacity(0.5),
        );
    final errorTextStyle = style?.errorTextStyle?.copyWith(
          color: style?.errorColor,
        ) ??
        style?.textStyle?.copyWith(
          color: style?.errorColor,
        ) ??
        TextStyle(
          color: style?.errorColor ?? theme.colorScheme.error,
        );
    final disabledTextStyle = style?.textStyle?.copyWith(
          color: style?.disabledColor,
        ) ??
        TextStyle(
          color: style?.disabledColor ?? theme.disabledColor,
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

    final borderSide = getBorderSide(style?.borderColor ?? theme.dividerColor);
    final errorBorderSide =
        getBorderSide(style?.errorColor ?? theme.colorScheme.error);
    final disabledBorderSide =
        getBorderSide(style?.disabledColor ?? theme.disabledColor);

    return Padding(
      padding: style?.padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: style?.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          fillColor: style?.backgroundColor,
          filled: style?.backgroundColor != null,
          isDense: true,
          border: style?.border ?? borderSide,
          enabledBorder: style?.border ?? borderSide,
          disabledBorder:
              style?.disabledBorder ?? style?.border ?? disabledBorderSide,
          errorBorder: style?.errorBorder ?? style?.border ?? errorBorderSide,
          focusedBorder: style?.border ?? borderSide,
          focusedErrorBorder:
              style?.errorBorder ?? style?.border ?? errorBorderSide,
          hintText: hintText,
          labelText: labelText,
          counterText: counterText,
          prefix: prefix?.child ?? style?.prefix?.child,
          suffix: suffix?.child ?? style?.suffix?.child,
          prefixIcon: prefix?.icon ?? style?.prefix?.icon,
          suffixIcon: suffix?.icon ?? style?.suffix?.icon,
          prefixText: prefix?.label ?? style?.prefix?.label,
          suffixText: suffix?.label ?? style?.suffix?.label,
          prefixIconColor: prefix?.iconColor ?? style?.prefix?.iconColor,
          suffixIconColor: suffix?.iconColor ?? style?.suffix?.iconColor,
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
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
