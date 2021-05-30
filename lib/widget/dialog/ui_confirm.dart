part of masamune;

/// Show confirmation dialog.
///
/// ```
/// UIConfirm.show( context );
/// ```
class UIConfirm {
  /// Show confirmation dialog.
  ///
  /// ```
  /// UIConfirm.show( context );
  /// ```
  ///
  /// [context]: Build context.
  /// [dialogTitlePath]: Dialog title path.
  /// [dialogTextPath]: Dialog text path.
  /// [dialogSubmitTextPath]: Dialog submit button text path.
  /// [dialogSubmitActionPath]: The path of action when the submit button of the dialog is pressed.
  /// [dialogCancelTextPath]: Dialog cancel button text path.
  /// [dialogCancelActionPath]: The path of action when the cancel button of the dialog is pressed.
  /// [submitText]: Default submit button text.
  /// [cancelText]: Default cancel button text.
  /// [onSubmit]: Default submit button action.
  /// [onCancel]: Default cancel button action.
  /// [backgroundColor]: Background color.
  /// [color]: Text color.
  /// [title]: Default title.
  /// [text]: Default text.
  /// [popOnPress]: True if the dialog should be closed together when the button is pressed.
  /// [willShowRepetition]: True if the dialog will continue to be displayed unless you press the regular close button.
  static Future show(
    BuildContext context, {
    Color? backgroundColor,
    Color? color,
    String submitText = "Yes",
    String cacnelText = "No",
    required String title,
    required String text,
    VoidCallback? onSubmit,
    VoidCallback? onCancel,
    bool popOnPress = true,
    bool willShowRepetition = false,
  }) async {
    bool clicked = false;
    final overlay = context.navigator.overlay;
    if (overlay == null) {
      return;
    }
    do {
      await showDialog(
          context: overlay.context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                title.localize(),
                style: TextStyle(
                  color: color ?? context.theme.textColorOnSurface,
                ),
              ),
              content: SingleChildScrollView(
                child: Text(
                  text.localize(),
                  // color: color ?? context.theme.textColorOnSurface,
                ),
              ),
              backgroundColor:
                  backgroundColor ?? context.theme.colorScheme.surface,
              actions: <Widget>[
                TextButton(
                  child: Text(cacnelText.localize()),
                  onPressed: () {
                    if (popOnPress) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    onCancel?.call();
                    clicked = true;
                  },
                ),
                TextButton(
                  child: Text(submitText.localize()),
                  onPressed: () {
                    if (popOnPress) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    onSubmit?.call();
                    clicked = true;
                  },
                )
              ],
            );
          });
    } while (willShowRepetition && !clicked);
  }
}
