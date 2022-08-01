part of masamune;

/// Show selecting dialog.
///
/// ```
/// UISelectDialog.show( context );
/// ```
class UISelectDialog {
  const UISelectDialog._();

  /// Show selecting dialog.
  ///
  /// [context]: Build context.
  /// [dialogTitlePath]: Dialog title path.
  /// [backgroundColor]: Background color.
  /// [color]: Text color.
  /// [title]: Default title.
  /// [selected]: The element that is selected.
  /// [disableBackKey]: True to disable the back key.
  /// [popOnPress]: True if the dialog should be closed together when the button is pressed.
  /// [willShowRepetition]: True if the dialog will continue to be displayed unless you press the regular close button.
  static Future<void> show(
    BuildContext context, {
    Color? backgroundColor,
    Color? color,
    required String title,
    String? selected,
    required Map<String, VoidCallback> selectors,
    bool disableBackKey = false,
    bool popOnPress = true,
    bool willShowRepetition = false,
  }) async {
    bool clicked = false;
    try {
      do {
        final options = <SimpleDialogOption>[];
        for (final selector in selectors.entries) {
          options.add(
            SimpleDialogOption(
              onPressed: () {
                selector.value.call();
                if (popOnPress) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                clicked = true;
              },
              child: Text(
                selector.key.localize(),
                style: TextStyle(
                  color: color ?? context.theme.textColorOnSurface,
                  fontWeight: selected == selector.key ? FontWeight.bold : null,
                ),
              ),
            ),
          );
        }
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return WillPopScope(
              onWillPop: disableBackKey ? () async => true : null,
              child: SimpleDialog(
                title: Text(
                  title.localize(),
                  style: TextStyle(
                    color: color ?? context.theme.textColorOnSurface,
                  ),
                ),
                children: options,
                backgroundColor:
                    backgroundColor ?? context.theme.colorScheme.surface,
              ),
            );
          },
        );
      } while (willShowRepetition && !clicked);
    } catch (e) {
      print(e.toString());
    }
  }
}
