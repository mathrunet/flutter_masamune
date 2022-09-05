part of masamune_ui.list;

class SmallListCard extends StatelessWidget {
  const SmallListCard({
    this.onTap,
    this.feature,
    this.featureBackgroundColor,
    this.featureBackgroundImage,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.elevation = 8,
    this.icon,
    this.onIconTap,
    this.title,
    this.buttonTitle,
    this.subtitle,
    this.height = 60,
    this.trailing,
    this.onButtonTap,
    this.radius = 4.0,
    this.foregroundColor,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  final Color? foregroundColor;

  final double radius;

  final VoidCallback? onTap;

  final Widget? feature;

  final ImageProvider? featureBackgroundImage;

  final Color? featureBackgroundColor;

  final Widget? title;

  final double height;

  final Widget? subtitle;

  final String? buttonTitle;

  final VoidCallback? onButtonTap;

  final IconData? icon;

  final VoidCallback? onIconTap;

  final double elevation;

  final EdgeInsetsGeometry margin;

  final Widget? trailing;

  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: InkWell(
        // InkWellはCardの子ウィジェット
        onTap: onTap,
        child: Padding(
          padding: contentPadding,
          child: Row(
            children: [
              if (feature != null ||
                  featureBackgroundColor != null ||
                  featureBackgroundImage != null)
                Container(
                  height: height,
                  width: height,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    image: featureBackgroundImage != null
                        ? DecorationImage(
                            image: featureBackgroundImage!,
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: featureBackgroundColor,
                  ),
                  child: feature,
                ),
              if (title != null)
                Expanded(
                  child: subtitle == null
                      ? DefaultTextStyle(
                          style: TextStyle(
                            color: foregroundColor ?? context.theme.textColor,
                          ),
                          child: title!,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null)
                              DefaultTextStyle(
                                style: TextStyle(
                                  color: foregroundColor ??
                                      context.theme.textColor,
                                ),
                                child: title!,
                              ),
                            DefaultTextStyle(
                              style: context.theme.textTheme.overline?.copyWith(
                                    color: context.theme.disabledColor,
                                  ) ??
                                  TextStyle(
                                    color: context.theme.disabledColor,
                                  ),
                              child: subtitle!,
                            ),
                          ],
                        ),
                ),
              if (buttonTitle.isNotEmpty) ...[
                TextButton(
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                    backgroundColor: context.theme.secondaryColor,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    buttonTitle!.localize(),
                    style: TextStyle(color: context.theme.backgroundColor),
                  ),
                  onPressed: onButtonTap,
                ),
              ],
              if (icon != null) ...[
                const Space.width(16),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  icon: Icon(icon, color: context.theme.secondaryColor),
                  onPressed: onIconTap,
                )
              ],
              if (trailing != null) ...[
                const Space.width(16),
                trailing!,
              ]
            ],
          ),
        ),
      ),
    );
  }
}
