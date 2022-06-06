part of masamune;

class DefaultTextButtonStyle extends ButtonStyle {
  factory DefaultTextButtonStyle({
    Color? color,
    Color? backgroundColor,
    Color? focusedAndSelectedColor,
    Color? focusedAndSelectedBackgroundColor,
    Color? disabledColor,
    Color? disabledBackgroundColor,
    Color? borderColor,
    double radius = 6.0,
    double width = 0,
    EdgeInsetsGeometry? padding,
  }) {
    return DefaultTextButtonStyle._(
      TextButton.styleFrom(
        padding: padding,
        primary: color,
        onSurface: color,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          side: width <= 0 || borderColor == Colors.transparent
              ? BorderSide.none
              : BorderSide(color: borderColor ?? Colors.black, width: width),
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

  DefaultTextButtonStyle._(ButtonStyle style)
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
