part of masamune.form;

class FormItemAvatarImage extends StatelessWidget implements FormItem {
  const FormItemAvatarImage({
    required this.image,
    this.label = "",
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.enabled = true,
  });

  final ImageProvider image;
  final String label;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: enabled ? onPressed : null,
              child: SizedBox(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  backgroundColor: context.theme.disabledColor,
                  backgroundImage: image,
                ),
              ),
            ),
            if (label.isNotEmpty)
              TextButton(
                style: TextButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: enabled
                      ? (backgroundColor ?? context.theme.primaryColor)
                      : context.theme.disabledColor,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor ?? context.theme.backgroundColor,
                  ),
                ),
                onPressed: enabled ? onPressed : null,
              ),
          ],
        ),
      ),
    );
  }
}
