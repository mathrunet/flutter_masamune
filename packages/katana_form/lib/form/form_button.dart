part of '/katana_form.dart';

/// Create buttons for forms.
///
/// Specify the label to be displayed on the button in [label].
///
/// The [onPressed] allows you to describe the process when the button is pressed.
///
/// If [icon] is specified, an icon is displayed to the left of the label.
///
/// If [enabled] is set to `false`, the button cannot be pressed.
///
/// The style of the button can be changed by specifying [style].
///
/// フォーム用のボタンを作成します。
///
/// [label]にボタンに表示するラベルを指定します。
///
/// [onPressed]でボタンが押された場合の処理を記述できます。
///
/// [icon]を指定した場合は、ラベルの左側にアイコンが表示されます。
///
/// [enabled]を`false`にした場合ボタンが押せなくなります。
///
/// [style]を指定するとボタンのスタイルを変更することが可能です。
class FormButton extends StatelessWidget {
  /// Create buttons for forms.
  ///
  /// Specify the label to be displayed on the button in [label].
  ///
  /// The [onPressed] allows you to describe the process when the button is pressed.
  ///
  /// If [icon] is specified, an icon is displayed to the left of the label.
  ///
  /// If [enabled] is set to `false`, the button cannot be pressed.
  ///
  /// The style of the button can be changed by specifying [style].
  ///
  /// フォーム用のボタンを作成します。
  ///
  /// [label]にボタンに表示するラベルを指定します。
  ///
  /// [onPressed]でボタンが押された場合の処理を記述できます。
  ///
  /// [icon]を指定した場合は、ラベルの左側にアイコンが表示されます。
  ///
  /// [enabled]を`false`にした場合ボタンが押せなくなります。
  ///
  /// [style]を指定するとボタンのスタイルを変更することが可能です。
  const FormButton(
    this.label, {
    super.key,
    this.onPressed,
    this.enabled = true,
    this.icon,
    this.style,
  });

  /// Defines the style of the button.
  ///
  /// ボタンのスタイルを定義します。
  final FormStyle? style;

  /// Button labels.
  ///
  /// ボタンのラベル。
  final String label;

  /// Processing when a button is pressed.
  ///
  /// ボタンが押された場合の処理。
  final VoidCallback? onPressed;

  /// Button icon. It appears to the left of the label.
  ///
  /// ボタンのアイコン。ラベルの左側に表示されます。
  final Widget? icon;

  /// If `false`, the button is deactivated and cannot be pressed.
  ///
  /// `false`になった場合、ボタンが非有効化され押せなくなります。
  final bool enabled;

  List<Widget> _buildAffix(BuildContext context, FormAffixStyle style) {
    return [
      if (style.icon != null) ...[
        IconTheme(
          data: IconThemeData(color: style.iconColor),
          child: ConstrainedBox(
            constraints: style.iconConstraints ?? const BoxConstraints(),
            child: style.icon,
          ),
        ),
        const SizedBox(width: 12),
      ],
      if (style.child != null)
        style.child!
      else
        Text(
          style.label ?? "",
          style: style.textStyle,
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        style?.backgroundColor ?? Theme.of(context).primaryColor;
    final disabledBackgroundColor =
        style?.disabledBackgroundColor ?? Theme.of(context).disabledColor;
    final foregroundColor =
        style?.color ?? Theme.of(context).colorScheme.onPrimary;
    final disabledForegroundColor =
        style?.color ?? Theme.of(context).colorScheme.onSurface;
    final textStyle = style?.textStyle?.copyWith(
          color: enabled ? foregroundColor : disabledForegroundColor,
        ) ??
        TextStyle(color: enabled ? foregroundColor : disabledForegroundColor);
    final borderColor = style?.borderColor ?? foregroundColor;
    final activeColor =
        style?.activeColor ?? foregroundColor.withValues(alpha: 0.5);

    return FormStyleScope(
      style: style,
      child: Container(
        alignment: style?.alignment,
        padding: style?.padding ??
            const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 4,
            ),
        child: SizedBox(
          height: style?.height,
          width: style?.width,
          child: Material(
            borderRadius: style?.borderRadius ?? BorderRadius.circular(32),
            child: InkWell(
              focusColor: activeColor,
              hoverColor: activeColor,
              highlightColor: activeColor,
              splashColor: activeColor,
              borderRadius: style?.borderRadius ?? BorderRadius.circular(32),
              onTap: enabled ? onPressed : null,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius:
                      style?.borderRadius ?? BorderRadius.circular(32),
                  border: style?.borderWidth != null && style!.borderWidth! > 0
                      ? Border.all(
                          color:
                              enabled ? borderColor : disabledForegroundColor,
                          width: style!.borderWidth!,
                        )
                      : null,
                  color: enabled ? backgroundColor : disabledBackgroundColor,
                ),
                child: Padding(
                  padding: style?.contentPadding ??
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                  child: IconTheme(
                    data: IconThemeData(
                      color:
                          enabled ? foregroundColor : disabledForegroundColor,
                    ),
                    child: DefaultTextStyle(
                      style: textStyle,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (style?.prefix != null) ...[
                            ..._buildAffix(context, style!.prefix!),
                            const SizedBox(width: 12),
                          ],
                          if (icon != null) ...[
                            icon!,
                            const SizedBox(width: 12),
                          ],
                          Center(
                            child: Text(label, textAlign: TextAlign.center),
                          ),
                          if (style?.suffix != null) ...[
                            const SizedBox(width: 12),
                            ..._buildAffix(context, style!.suffix!),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
