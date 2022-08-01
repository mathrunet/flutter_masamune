part of masamune.form;

/// Show dialog for form.
///
/// ```
/// UIFormDialog.show( context );
/// ```
class UIFormDialog {
  const UIFormDialog._();

  /// Show dialog.
  ///
  /// [context]: Build context.
  /// [submitText]: Default submit button text.
  /// [submitHeight]: Height of submit button.
  /// [onSubmit]: Default submit button action.
  /// [submitBorderRadius]: Border radius of the Submit button.
  /// [submitBackgroundColor]: Background color of the Submit button.
  /// [title]: Default title.
  /// [validate]: Verify the value.
  /// [popOnPress]: True if the dialog should be closed together when the button is pressed.
  static Future show(
    BuildContext context, {
    String submitText = "OK",
    required List<Widget> Function(BuildContext context, DynamicMap form)
        builder,
    double submitBorderRadius = 8.0,
    Color? submitBackgroundColor,
    required String title,
    bool validate = true,
    bool popOnPress = true,
    void Function(DynamicMap form)? onSubmit,
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
              title: Text(title),
              titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              children: [
                ...builder(context, form),
                const Space.height(10),
                FormItemButton(
                  submitText,
                  backgroundColor: submitBackgroundColor,
                  borderRadius: submitBorderRadius,
                  onPressed: () {
                    context.unfocus();
                    if (validate && !key.currentState!.validate()) {
                      return;
                    }
                    key.currentState!.save();
                    if (popOnPress) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    onSubmit?.call(form);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
