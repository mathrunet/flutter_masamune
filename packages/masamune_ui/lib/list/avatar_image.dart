part of masamune_ui.list;

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    required this.image,
    this.label,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
  });
  final ImageProvider image;
  final String? label;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: CircleAvatar(
              backgroundColor: context.theme.disabledColor,
              backgroundImage: image,
            ),
          ),
          if (label.isNotEmpty)
            TextButton(
              style: TextButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: backgroundColor ?? context.theme.primaryColor,
              ),
              child: Text(
                label!,
                style: TextStyle(
                  color: textColor ?? context.theme.backgroundColor,
                ),
              ),
              onPressed: onPressed,
            )
        ],
      ),
    );
  }
}
