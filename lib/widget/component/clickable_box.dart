part of masamune;

class ClickableBox extends StatelessWidget {
  const ClickableBox({
    this.onTap,
    this.color,
    this.hoverColor,
    this.splashColor,
    this.width,
    this.height,
    this.child,
  })  : _type = _ClickableBoxType.none,
        image = null,
        video = null,
        fit = null;

  const ClickableBox.image({
    required this.image,
    this.onTap,
    this.hoverColor,
    this.splashColor,
    this.width,
    this.height,
    this.color,
    this.child,
    this.fit,
  })  : _type = _ClickableBoxType.image,
        video = null;

  const ClickableBox.video({
    required this.video,
    this.onTap,
    this.hoverColor,
    this.splashColor,
    this.width,
    this.height,
    this.child,
    this.color,
    this.fit,
  })  : _type = _ClickableBoxType.video,
        image = null;

  final ImageProvider? image;
  final VideoProvider? video;
  final VoidCallback? onTap;
  final BoxFit? fit;
  final Widget? child;
  final Color? color;
  final Color? hoverColor;
  final Color? splashColor;
  final double? width;
  final double? height;
  final _ClickableBoxType _type;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _ClickableBoxType.image:
        return InkWell(
          onTap: onTap,
          hoverColor: hoverColor ?? context.theme.splashColor.withOpacity(0.1),
          splashColor: splashColor,
          child: ColoredBox(
            color: color ?? context.theme.disabledColor.withOpacity(0.25),
            child: Ink.image(
              image: image!,
              width: width,
              fit: fit,
              height: height,
              child: child,
            ),
          ),
        );
      case _ClickableBoxType.video:
        return ColoredBox(
          color: color ?? context.theme.disabledColor.withOpacity(0.25),
          child: Video(
            video!,
            fit: fit,
            onTap: onTap,
            width: width,
            height: height,
            autoplay: true,
            mixWithOthers: true,
            mute: true,
          ),
        );
      default:
        return InkWell(
          onTap: onTap,
          hoverColor: hoverColor ?? context.theme.splashColor.withOpacity(0.1),
          splashColor: splashColor,
          child: Ink(
            color: color,
            width: width,
            height: height,
            child: child,
          ),
        );
    }
  }
}

enum _ClickableBoxType {
  none,
  image,
  video,
}
