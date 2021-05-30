part of masamune;

class BlogContainer extends StatelessWidget {
  const BlogContainer({
    required this.child,
    this.leftBar,
    this.rightBar,
    this.leftBarWidth = 200,
    this.rightBarWidth = 200,
    this.borderColor,
  });
  final Color? borderColor;
  final double leftBarWidth;
  final double rightBarWidth;
  final Widget? leftBar;
  final Widget? rightBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leftBar != null)
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: borderColor ??
                      context.theme.dividerColor.withOpacity(0.25),
                ),
              ),
            ),
            width: leftBarWidth,
            child: leftBar,
          ),
        Expanded(
          child: child,
        ),
        if (rightBar != null)
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: borderColor ??
                      context.theme.dividerColor.withOpacity(0.25),
                ),
              ),
            ),
            width: rightBarWidth,
            child: rightBar,
          ),
      ],
    );
  }
}
