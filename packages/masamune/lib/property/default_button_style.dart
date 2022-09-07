part of masamune;

class DefaultButtonStyle extends ButtonStyle {
  factory DefaultButtonStyle({
    Color? color,
    Color? backgroundColor,
    Color? focusedAndSelectedColor,
    Color? focusedAndSelectedBackgroundColor,
    Color? disabledColor,
    Color? disabledBackgroundColor,
    Color? borderColor,
    double radius = 6.0,
    double borderWidth = 0.0,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return DefaultButtonStyle._(
      TextButton.styleFrom(
        padding: padding,
        textStyle: textStyle,
        foregroundColor: color,
        disabledForegroundColor: color,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          side: borderWidth <= 0 || borderColor == Colors.transparent
              ? BorderSide.none
              : BorderSide(
                  color: borderColor ?? Colors.black,
                  width: borderWidth,
                ),
          borderRadius: radius <= 0
              ? BorderRadius.zero
              : BorderRadius.all(
                  Radius.circular(radius),
                ),
        ),
      )
          .addState(
        foregroundColor: focusedAndSelectedColor,
        backgroundColor: focusedAndSelectedBackgroundColor,
      )
          .addState(
        foregroundColor: disabledColor,
        backgroundColor: disabledBackgroundColor,
        state: {
          MaterialState.disabled,
        },
      ),
    );
  }

  DefaultButtonStyle._(ButtonStyle style)
      : super(
          textStyle: style.textStyle,
          backgroundColor: style.backgroundColor,
          foregroundColor: style.foregroundColor,
          overlayColor: style.overlayColor,
          shadowColor: style.shadowColor,
          elevation: style.elevation,
          padding: style.padding,
          minimumSize: style.minimumSize,
          side: style.side,
          shape: style.shape,
          mouseCursor: style.mouseCursor,
          visualDensity: style.visualDensity,
          tapTargetSize: style.tapTargetSize,
          animationDuration: style.animationDuration,
          enableFeedback: style.enableFeedback,
          alignment: style.alignment,
        );
}
