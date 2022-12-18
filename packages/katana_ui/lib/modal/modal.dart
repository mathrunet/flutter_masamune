part of katana_ui;

class Modal {
  const Modal._();

  static Future<void> alert(
    BuildContext context, {
    required String submitText,
    Color? backgroundColor,
    Color? color,
    required String title,
    required String text,
    VoidCallback? onSubmit,
    bool disableBackKey = false,
    bool popOnPress = true,
    bool willShowRepetition = false,
  }) async {
    bool clicked = false;
    ScaffoldMessenger.of(context);
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return;
    }
    do {
      await showDialog(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: disableBackKey ? () async => true : null,
            child: AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  color: color ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
              content: SingleChildScrollView(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color ?? Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              backgroundColor:
                  backgroundColor ?? Theme.of(context).colorScheme.surface,
              actions: <Widget>[
                TextButton(
                  child: Text(submitText),
                  onPressed: () {
                    if (popOnPress) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    onSubmit?.call();
                    clicked = true;
                  },
                )
              ],
            ),
          );
        },
      );
    } while (willShowRepetition && !clicked);
  }

  static Future<bool> confirm(
    BuildContext context, {
    Color? backgroundColor,
    Color? color,
    required String submitText,
    required String cancelText,
    required String title,
    required String text,
    VoidCallback? onSubmit,
    VoidCallback? onCancel,
    bool popOnPress = true,
    bool willShowRepetition = false,
  }) async {
    bool state = false;
    bool clicked = false;
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) {
      return state;
    }
    do {
      await showDialog(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                color: color ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                text,
                style: TextStyle(
                  color: color ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.surface,
            actions: <Widget>[
              TextButton(
                child: Text(cancelText),
                onPressed: () {
                  if (popOnPress) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  onCancel?.call();
                  state = false;
                  clicked = true;
                },
              ),
              TextButton(
                child: Text(submitText),
                onPressed: () {
                  if (popOnPress) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  onSubmit?.call();
                  state = true;
                  clicked = true;
                },
              )
            ],
          );
        },
      );
    } while (willShowRepetition && !clicked);
    return state;
  }
}
