part of masamune;

class Modal extends StatelessWidget {
  const Modal({
    required this.child,
    this.width,
    this.widthRatio,
    this.height,
    this.heightRatio,
  });

  final Widget child;
  final double? widthRatio;
  final double? heightRatio;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuery.size;
    final w = width ??
        (widthRatio != null ? (size.width * (widthRatio ?? 1.0)) : null);
    final h = height ??
        (heightRatio != null ? (size.height * (heightRatio ?? 1.0)) : null);
    return SizedBox(
      width: w,
      height: h,
      child: child,
    );
  }
}

/// Show modal.
///
/// ```
/// UIModal.show( context );
/// ```
class UIModal {
  const UIModal._();

  /// Show modal.
  static Future<void> show(
    BuildContext context, {
    required Widget child,
    bool disableBackKey = false,
    bool barrierDismissible = true,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: WillPopScope(
              onWillPop: disableBackKey ? () async => false : null,
              child: Center(
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
