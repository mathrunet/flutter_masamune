part of masamune.list;

class ListCard extends StatelessWidget {
  const ListCard({
    this.onTap,
    this.image,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.elevation = 8,
    this.icon,
    this.onIconTap,
    this.height = 160,
    this.title,
    this.buttonTitle,
    this.onButtonTap,
  });

  final VoidCallback? onTap;

  final ImageProvider? image;

  final double height;

  final Widget? title;

  final String? buttonTitle;

  final VoidCallback? onButtonTap;

  final IconData? icon;

  final VoidCallback? onIconTap;

  final double elevation;

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: margin,
        elevation: elevation,
        child: Column(
          children: [
            if (image != null)
              ConstrainedBox(
                constraints: BoxConstraints.expand(height: height),
                child: Image(
                  image: image!,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  if (title != null) Expanded(child: title!),
                  if (buttonTitle.isNotEmpty) ...[
                    TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.all(0),
                        backgroundColor: context.theme.accentColor,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(buttonTitle!.localize(),
                          style:
                              TextStyle(color: context.theme.backgroundColor)),
                      onPressed: onButtonTap,
                    ),
                  ],
                  if (icon != null) ...[
                    const Space.width(15),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(),
                      icon: Icon(icon, color: context.theme.accentColor),
                      onPressed: onIconTap,
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
