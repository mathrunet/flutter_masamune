part of masamune;

/// Show dialog.
///
/// ```
/// UIDialog.show( context );
/// ```
class UIDialog {
  /// Check the value and display a dialog when it is [false].
  ///
  /// [context]: Build context.
  /// [validator]: Validator. Shows a dialog when the value is false.
  /// [dialogTitlePath]: Dialog title path.
  /// [dialogTextPath]: Dialog text path.
  /// [dialogSubmitTextPath]: Dialog submit button text path.
  /// [dialogSubmitActionPath]: The path of action when the submit button of the dialog is pressed.
  /// [submitText]: Default submit button text.
  /// [onSubmit]: Default submit button action.
  /// [backgroundColor]: Background color.
  /// [color]: Text color.
  /// [title]: Default title.
  /// [text]: Default text.
  /// [disableBackKey]: True to disable the back key.
  /// [popOnPress]: True if the dialog should be closed together when the button is pressed.
  /// [willShowRepetition]: True if the dialog will continue to be displayed unless you press the regular close button.
  static Future<bool> validate(
    BuildContext context, {
    required Future<bool> validator(),
    String submitText = "OK",
    Color? backgroundColor,
    Color? color,
    String title = "ERROR",
    String text = "This data is invalid.",
    VoidCallback? onSubmit,
    bool disableBackKey = false,
    bool popOnPress = true,
    bool willShowRepetition = false,
  }) async {
    if (await validator()) {
      return true;
    }
    await Future.delayed(
      Duration.zero,
      () => show(
        context,
        submitText: submitText,
        backgroundColor: backgroundColor,
        color: color,
        title: title,
        text: text,
        onSubmit: onSubmit ?? () => context.navigator.pop(),
        disableBackKey: disableBackKey,
        popOnPress: popOnPress,
        willShowRepetition: willShowRepetition,
      ),
    );
    return false;
  }

  /// Show dialog.
  ///
  /// [context]: Build context.
  /// [dialogTitlePath]: Dialog title path.
  /// [dialogTextPath]: Dialog text path.
  /// [dialogSubmitTextPath]: Dialog submit button text path.
  /// [dialogSubmitActionPath]: The path of action when the submit button of the dialog is pressed.
  /// [submitText]: Default submit button text.
  /// [onSubmit]: Default submit button action.
  /// [backgroundColor]: Background color.
  /// [color]: Text color.
  /// [title]: Default title.
  /// [text]: Default text.
  /// [disableBackKey]: True to disable the back key.
  /// [popOnPress]: True if the dialog should be closed together when the button is pressed.
  /// [willShowRepetition]: True if the dialog will continue to be displayed unless you press the regular close button.
  static Future show(BuildContext context,
      {String submitText = "OK",
      Color? backgroundColor,
      Color? color,
      required String title,
      required String text,
      VoidCallback? onSubmit,
      bool disableBackKey = false,
      bool popOnPress = true,
      bool willShowRepetition = false}) async {
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
          return WillPopScope(
            onWillPop: disableBackKey ? () async => true : null,
            child: AlertDialog(
              title: Text(
                title.localize(),
                style: TextStyle(
                  color: color ?? context.theme.colorScheme.onSurface,
                ),
              ),
              content: SingleChildScrollView(
                child: Text(
                  text.localize(),
                  // color: color ?? context.theme.colorScheme.onSurface,
                ),
              ),
              backgroundColor:
                  backgroundColor ?? context.theme.colorScheme.surface,
              actions: <Widget>[
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
            ),
          );
        },
      );
    } while (willShowRepetition && !clicked);
  }
}
