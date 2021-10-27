part of masamune;

class AccountDrawerHeader extends StatelessWidget {
  const AccountDrawerHeader({
    this.avatar,
    this.onTap,
    this.backgroundImage,
    required this.name,
    this.text,
    this.color,
  });

  final String name;

  final String? text;

  final ImageProvider? avatar;

  final ImageProvider? backgroundImage;

  final VoidCallback? onTap;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DrawerHeader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (avatar != null)
              SizedBox(
                width: 80,
                height: 80,
                child: CircleAvatar(
                  backgroundImage: avatar,
                ),
              ),
            const Space.height(10),
            Text(
              name,
              style: TextStyle(
                color: context.theme.backgroundColor,
              ),
            ),
            if (text.isNotEmpty)
              Text(
                text!,
                style: TextStyle(
                  color: context.theme.backgroundColor,
                ),
              )
          ],
        ),
        decoration: BoxDecoration(
          image: backgroundImage != null
              ? DecorationImage(
                  image: backgroundImage!,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    (color ?? context.theme.secondaryColor).withOpacity(0.5),
                    BlendMode.srcOver,
                  ),
                )
              : null,
          color: color ?? context.theme.secondaryColor,
        ),
      ),
    );
  }
}
