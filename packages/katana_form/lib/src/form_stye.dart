part of katana_form;

/// Class for defining styles for Form.
///
/// Some parameters may not be supported depending on the type of form.
///
/// Form用のスタイルを定義するためのクラス。
///
/// フォームの種類によっては対応できないパラメーターもあります。
@immutable
class FormStyle {
  /// Class for defining styles for Form.
  ///
  /// Some parameters may not be supported depending on the type of form.
  ///
  /// Form用のスタイルを定義するためのクラス。
  ///
  /// フォームの種類によっては対応できないパラメーターもあります。
  const FormStyle({
    this.padding,
    this.contentPadding,
    this.border,
    this.disabledBorder,
    this.errorBorder,
    this.backgroundColor,
    this.height,
    this.width,
    this.color,
    this.borderWidth,
    this.textStyle,
    this.subColor,
    this.errorColor,
    this.cursorColor,
    this.borderColor,
    this.shape,
    this.disabledColor,
    this.borderRadius,
    this.disabledBackgroundColor,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.activeColor,
    this.activeBackgroundColor,
    this.prefix,
    this.suffix,
  });

  /// Form Height.
  ///
  /// フォームの高さ。
  final double? height;

  /// Form width.
  ///
  /// フォームの幅。
  final double? width;

  /// Text cursor color.
  ///
  /// テキストカーソルの色。
  final Color? cursorColor;

  /// Color when the item is active.
  ///
  /// 項目がアクティブなときの色。
  final Color? activeColor;

  /// Background color when the item is active.
  ///
  /// 項目がアクティブなときの背景色。
  final Color? activeBackgroundColor;

  /// Normal border of the form.
  ///
  /// フォームの通常のボーダー。
  final InputBorder? border;

  /// Border when deactivated. If not specified, [border] is used.
  ///
  /// 非有効化時のボーダー。指定されない場合は[border]が利用されます。
  final InputBorder? disabledBorder;

  /// Border on error. If not specified, [border] is used.
  ///
  /// エラー時のボーダー。指定されない場合は[border]が利用されます。
  final InputBorder? errorBorder;

  /// Text Style.
  ///
  /// テキストのスタイル。
  final TextStyle? textStyle;

  /// Form Background.
  ///
  /// フォームの背景。
  final Color? backgroundColor;

  /// Padding on the outside of the form.
  ///
  /// フォーム外側のパディング。
  final EdgeInsetsGeometry? padding;

  /// Padding of form content.
  ///
  /// フォームのコンテンツのパディング。
  final EdgeInsetsGeometry? contentPadding;

  /// Main color of the form. The color of the text and icons.
  ///
  /// フォームのメインカラー。文字やアイコンの色。
  final Color? color;

  /// Form sub-colors. Color of hint text, etc.
  ///
  /// フォームのサブカラー。ヒントテキスト等の色。
  final Color? subColor;

  /// Text color in case of error, etc.
  ///
  /// エラー時の文字色など。
  final Color? errorColor;

  /// Horizontal align of the text.
  ///
  /// テキストの横方向の位置。
  final TextAlign textAlign;

  /// Border color.
  ///
  /// ボーダーの色。
  final Color? borderColor;

  /// Border width.
  ///
  /// ボーダーの幅。
  final double? borderWidth;

  /// Text color when deactivated, etc.
  ///
  /// 非有効化時の文字色など。
  final Color? disabledColor;

  /// Background color when deactivated.
  ///
  /// 非有効化時の背景色。
  final Color? disabledBackgroundColor;

  /// Vertical align of the text.
  ///
  /// テキストの縦方向の位置。
  final TextAlignVertical? textAlignVertical;

  /// Roundness of the border.
  ///
  /// ボーダーの丸さ。
  final BorderRadius? borderRadius;

  /// A widget that is placed in front of the form.
  ///
  /// フォームの前に配置されるウィジェット。
  final FormAffixStyle? prefix;

  /// A widget that is placed after the form.
  ///
  /// フォームの後に配置されるウィジェット。
  final FormAffixStyle? suffix;

  /// Class for defining the shape of forms such as [FormCheckbox].
  ///
  /// [FormCheckbox]などのフォームの形状を定義するためのクラス。
  final OutlinedBorder? shape;

  /// Create another [FormStyle], changing the parameters.
  ///
  /// パラメーターを変更しながら別の[FormStyle]を作成します。
  FormStyle copyWith({
    double? height,
    double? width,
    BorderRadius? borderRadius,
    Color? cursorColor,
    InputBorder? border,
    InputBorder? disabledBorder,
    InputBorder? errorBorder,
    double? borderWidth,
    TextStyle? textStyle,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? contentPadding,
    Color? color,
    Color? subColor,
    Color? errorColor,
    TextAlign? textAlign,
    Color? borderColor,
    Color? disabledColor,
    Color? disabledBackgroundColor,
    FormAffixStyle? prefix,
    FormAffixStyle? suffix,
    TextAlignVertical? textAlignVertical,
    OutlinedBorder? shape,
  }) {
    return FormStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      cursorColor: cursorColor ?? this.cursorColor,
      border: border ?? this.border,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      contentPadding: contentPadding ?? this.contentPadding,
      color: color ?? this.color,
      subColor: subColor ?? this.subColor,
      errorColor: errorColor ?? this.errorColor,
      textAlign: textAlign ?? this.textAlign,
      textAlignVertical: textAlignVertical ?? this.textAlignVertical,
      borderColor: borderColor ?? this.borderColor,
      disabledColor: disabledColor ?? this.disabledColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      shape: shape ?? this.shape,
    );
  }

  @override
  int get hashCode =>
      height.hashCode ^
      width.hashCode ^
      borderRadius.hashCode ^
      cursorColor.hashCode ^
      border.hashCode ^
      disabledBorder.hashCode ^
      errorBorder.hashCode ^
      textStyle.hashCode ^
      backgroundColor.hashCode ^
      padding.hashCode ^
      contentPadding.hashCode ^
      color.hashCode ^
      subColor.hashCode ^
      errorColor.hashCode ^
      textAlign.hashCode ^
      textAlignVertical.hashCode ^
      borderColor.hashCode ^
      disabledColor.hashCode ^
      disabledBackgroundColor.hashCode ^
      borderWidth.hashCode ^
      prefix.hashCode ^
      suffix.hashCode ^
      shape.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// Class for defining prefix and suffix of text form.
///
/// If you want to place a widget, use [FormAffixStyle], and if you want to display text as is, create an object with [FormAffixStyle.text].
///
/// [icon] can be placed in front of each widget.
///
/// テキストフォームのprefix、suffixを定義するためのクラス。
///
/// Widgetを設置したい場合は、[FormAffixStyle]を利用し、テキストをそのまま表示したい場合は[FormAffixStyle.text]でオブジェクトを作成します。
///
/// [icon]をそれぞれのWidgetの前に設置することが可能です。
@immutable
class FormAffixStyle {
  /// Class for defining prefix and suffix of text form.
  ///
  /// If you want to place a widget, use [FormAffixStyle], and if you want to display text as is, create an object with [FormAffixStyle.text].
  ///
  /// [icon] can be placed in front of each widget.
  ///
  /// テキストフォームのprefix、suffixを定義するためのクラス。
  ///
  /// Widgetを設置したい場合は、[FormAffixStyle]を利用し、テキストをそのまま表示したい場合は[FormAffixStyle.text]でオブジェクトを作成します。
  ///
  /// [icon]をそれぞれのWidgetの前に設置することが可能です。
  const FormAffixStyle(
    this.child, {
    this.icon,
    this.iconColor,
    this.iconConstraints,
  })  : label = null,
        textStyle = null;

  /// Class for defining prefix and suffix of text form.
  ///
  /// If you want to place a widget, use [FormAffixStyle], and if you want to display text as is, create an object with [FormAffixStyle.text].
  ///
  /// [icon] can be placed in front of each widget.
  ///
  /// テキストフォームのprefix、suffixを定義するためのクラス。
  ///
  /// Widgetを設置したい場合は、[FormAffixStyle]を利用し、テキストをそのまま表示したい場合は[FormAffixStyle.text]でオブジェクトを作成します。
  ///
  /// [icon]をそれぞれのWidgetの前に設置することが可能です。
  const FormAffixStyle.text(
    this.label, {
    this.icon,
    this.iconColor,
    this.iconConstraints,
    this.textStyle,
  }) : child = null;

  /// Widget to be placed in prefix or suffix.
  ///
  /// prefixまたはsuffixに設置するウィジェット。
  final Widget? child;

  /// An icon that appears before [child] or [label].
  ///
  /// [child]または[label]の前に表示されるアイコン。
  final Widget? icon;

  /// Text to be placed in prefix or suffix.
  ///
  /// prefixまたはsuffixに設置するテキスト。
  final String? label;

  /// Text style when [label] is specified.
  ///
  /// [label]を指定したときのテキストスタイル。
  final TextStyle? textStyle;

  /// [Color]. when [icon] is specified.
  ///
  /// [icon]を指定したときの[Color]。
  final Color? iconColor;

  /// [BoxConstraints] when [icon] is specified.
  ///
  /// [icon]を指定したときの[BoxConstraints]。
  final BoxConstraints? iconConstraints;

  @override
  int get hashCode =>
      child.hashCode ^
      label.hashCode ^
      icon.hashCode ^
      textStyle.hashCode ^
      iconColor.hashCode ^
      iconConstraints.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
