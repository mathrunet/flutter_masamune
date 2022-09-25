part of masamune;

@immutable
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.color,
    this.backgroundColor,
    this.strokeWidth,
  });

  final Color? color;
  final Color? backgroundColor;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return loading_indicator.LoadingIndicator(
      indicatorType: loading_indicator.Indicator.ballPulse,
      colors: [color ?? context.theme.primaryColor],
      backgroundColor: backgroundColor,
      strokeWidth: strokeWidth,
    );
  }
}
