part of masamune_ui;

class UIBottomCallAction extends StatelessWidget {
  const UIBottomCallAction({
    required this.label,
    required this.buttonLabel,
    this.buttonBackgroundColor,
    this.buttonColor,
    this.onPress,
    this.borderRadius,
    this.backgroundColor,
    this.buttonPadding,
  });

  final Color? backgroundColor;
  final Color? buttonBackgroundColor;
  final Color? buttonColor;
  final EdgeInsetsGeometry? buttonPadding;
  final BorderRadius? borderRadius;
  final Widget buttonLabel;
  final VoidCallback? onPress;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? context.theme.bottomAppBarColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: label,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      buttonBackgroundColor ?? context.theme.primaryColor,
                  foregroundColor:
                      buttonColor ?? context.theme.textColorOnPrimary,
                  elevation: 0.0,
                  padding: buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: buttonLabel,
                onPressed: () {
                  onPress?.call();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
