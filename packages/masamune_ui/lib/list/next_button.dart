part of masamune_ui.list;

@immutable
class NextButton extends StatefulWidget {
  const NextButton({
    this.show = true,
    required this.label,
    this.size,
    this.icon,
    this.primaryColor,
    this.onSurfaceColor,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.textStyle,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.side,
    this.shape,
    this.visualDensity,
    this.tapTargetSize,
    required this.onNext,
  });

  final bool show;
  final Widget label;
  final double? size;
  final Widget? icon;
  final Color? primaryColor;
  final Color? onSurfaceColor;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Size? fixedSize;
  final Size? maximumSize;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? tapTargetSize;
  final FutureOr<void> Function() onNext;

  @override
  State<StatefulWidget> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  bool _loading = false;

  @override
  void didUpdateWidget(NextButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) {
      return const Empty();
    }
    if (_loading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const CircularProgressIndicator(),
      );
    } else {
      final style = TextButton.styleFrom(
        primary: widget.primaryColor,
        onSurface: widget.onSurfaceColor,
        backgroundColor: widget.backgroundColor,
        shadowColor: widget.shadowColor,
        surfaceTintColor: widget.surfaceTintColor,
        elevation: widget.elevation,
        textStyle: widget.textStyle,
        padding: widget.padding,
        minimumSize: widget.minimumSize,
        fixedSize: widget.fixedSize,
        maximumSize: widget.maximumSize,
        side: widget.side,
        shape: widget.shape,
        visualDensity: widget.visualDensity,
        tapTargetSize: widget.tapTargetSize,
      );
      if (widget.icon != null) {
        return TextButton.icon(
          onPressed: _update,
          icon: widget.icon!,
          label: widget.label,
          style: style,
        );
      } else {
        return TextButton(
          onPressed: _update,
          child: widget.label,
          style: style,
        );
      }
    }
  }

  Future<void> _update() async {
    setState(() {
      _loading = true;
    });
    await widget.onNext.call();
    setState(() {
      _loading = false;
    });
  }
}
