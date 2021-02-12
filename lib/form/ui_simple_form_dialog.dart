part of masamune.form;

/// Show dialog for simple form.
///
/// ```
/// UISimpleFormDialog.show( context );
/// ```
class UISimpleFormDialog {
  /// Show dialog.
  ///
  /// [context]: Build context.
  /// [submitText]: Default submit button text.
  /// [submitHeight]: Height of submit button.
  /// [onSubmit]: Default submit button action.
  /// [submitBorderRadius]: Border radius of the Submit button.
  /// [submitBackgroundColor]: Background color of the Submit button.
  /// [title]: Default title.
  /// [popOnPress]: True if the dialog should be closed together when the button is pressed.
  static Future show(
    BuildContext context, {
    IconData? submitIcon,
    required Widget Function(BuildContext context, Map<String, dynamic> form)
        builder,
    Color? submitBackgroundColor,
    bool popOnPress = true,
    void Function(Map<String, dynamic> form)? onSubmit,
  }) async {
    final key = GlobalKey<FormState>();
    final overlay = context.navigator.overlay;
    final form = <String, dynamic>{};
    if (overlay == null) {
      return;
    }
    await showDialog(
      context: overlay.context,
      builder: (context) {
        return WillPopScope(
          onWillPop: null,
          child: Form(
            key: key,
            child: SimpleDialog(
              titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: builder(context, form)),
                    const Space.width(20),
                    InkWell(
                      onTap: () {
                        context.unfocus();
                        if (!key.currentState!.validate()) {
                          return;
                        }
                        key.currentState!.save();
                        onSubmit?.call(form);
                        if (popOnPress) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: submitBackgroundColor ??
                              context.theme.accentColor,
                          shape: const CircleBorder(),
                        ),
                        child: Icon(
                          submitIcon ?? Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
