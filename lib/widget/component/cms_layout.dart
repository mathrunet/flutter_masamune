part of masamune;

class CMSLayout extends StatelessWidget {
  const CMSLayout({
    required this.child,
    this.leftBar,
    this.rightBar,
    this.header,
    this.footer,
    this.top,
    this.bottom,
    this.options,
    this.mainAxisSpace = 0,
    this.crossAxisSpace = 0,
    this.leftBarWidth = 200,
    this.rightBarWidth = 200,
    this.borderColor,
    this.sideBorder,
    this.headerBorder,
    this.footerBorder,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
  });
  final BorderSide? sideBorder;
  final BorderSide? headerBorder;
  final BorderSide? footerBorder;
  final Color? borderColor;
  final Color? headerBackgroundColor;
  final Color? footerBackgroundColor;
  final double leftBarWidth;
  final double rightBarWidth;
  final Widget? leftBar;
  final Widget? rightBar;
  final Widget? header;
  final Widget? footer;
  final Widget? top;
  final Widget? bottom;
  final double mainAxisSpace;
  final double crossAxisSpace;
  final List<Widget>? options;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (header == null && footer == null && options.isEmpty) {
      return _middle(context);
    } else {
      return Column(
        children: [
          if (header != null) ...[
            if (headerBackgroundColor != null || headerBorder != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: headerBackgroundColor,
                  border: headerBorder != null
                      ? Border(
                          bottom: headerBorder!.copyWith(
                            color: borderColor ??
                                context.theme.dividerColor.withOpacity(0.25),
                          ),
                        )
                      : null,
                ),
                child: header,
              )
            else
              header!,
            if (mainAxisSpace > 0) Space.height(mainAxisSpace),
          ],
          _middle(context),
          if (options.isNotEmpty) ...[
            if (mainAxisSpace > 0) Space.height(mainAxisSpace),
            Row(
              children: options!.map((e) => Flexible(child: e)).toList(),
            ),
          ],
          if (footer != null) ...[
            if (mainAxisSpace > 0) Space.height(mainAxisSpace),
            if (footerBackgroundColor != null || footerBorder != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: footerBackgroundColor,
                  border: footerBorder != null
                      ? Border(
                          top: footerBorder!.copyWith(
                            color: borderColor ??
                                context.theme.dividerColor.withOpacity(0.25),
                          ),
                        )
                      : null,
                ),
                child: header,
              )
            else
              footer!,
          ],
        ],
      );
    }
  }

  Widget _center(BuildContext context) {
    if (top == null && bottom == null) {
      return child;
    } else {
      return Column(
        children: [
          if (top != null) ...[
            top!,
            if (mainAxisSpace > 0) Space.height(mainAxisSpace),
          ],
          child,
          if (bottom != null) ...[
            if (mainAxisSpace > 0) Space.height(mainAxisSpace),
            bottom!,
          ],
        ],
      );
    }
  }

  Widget _middle(BuildContext context) {
    if (leftBar == null && rightBar == null) {
      return _center(context);
    } else {
      return Row(
        children: [
          if (leftBar != null)
            if (sideBorder != null)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: sideBorder!.copyWith(
                      color: borderColor ??
                          context.theme.dividerColor.withOpacity(0.25),
                    ),
                  ),
                ),
                width: leftBarWidth,
                child: leftBar,
              )
            else
              SizedBox(
                width: leftBarWidth,
                child: leftBar,
              ),
          Expanded(
            child: _center(context),
          ),
          if (rightBar != null)
            if (sideBorder != null)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: sideBorder!.copyWith(
                      color: borderColor ??
                          context.theme.dividerColor.withOpacity(0.25),
                    ),
                  ),
                ),
                width: rightBarWidth,
                child: rightBar,
              )
            else
              SizedBox(
                width: rightBarWidth,
                child: rightBar,
              ),
        ],
      );
    }
  }
}
