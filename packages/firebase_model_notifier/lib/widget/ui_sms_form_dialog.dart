// ignore_for_file: use_late_for_private_fields_and_variables

part of firebase_model_notifier;

/// Display the login form.
///
/// Normally, [UILoginForm.show()] is executed to output with [UILoginForm.show()].
class UISMSFormDialog extends StatefulWidget {
  /// Display the login form.
  ///
  /// Normally, [UILoginForm.show()] is executed to output with [UILoginForm.show()].
  const UISMSFormDialog({
    this.title = "SMS SignIn",
    this.defaultSubmitText = "Login",
    this.defaultSubmitAction,
  });

  /// Dialog title.
  final String title;

  /// Default submit button text.
  final String defaultSubmitText;

  /// Default submit button action.
  final void Function(String phoneNumber)? defaultSubmitAction;

  /// Display the login form.
  ///
  /// Normally, [UILoginForm.show()] is executed to output with [UILoginForm.show()].
  static Future<void> show(
    BuildContext context, {
    String title = "SMS SignIn",
    String defaultSubmitText = "Login",
    void Function(String phoneNumber)? defaultSubmitAction,
  }) async {
    await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return UISMSFormDialog(
          title: title,
          defaultSubmitText: defaultSubmitText,
          defaultSubmitAction: defaultSubmitAction,
        );
      },
    );
  }

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Subclasses should override this method to return a newly created
  /// instance of their associated [State] subclass:
  ///
  /// ```dart
  /// @override
  /// State<MyWidget> createState() => _MyWidgetState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of
  /// a [StatefulWidget]. For example, if the widget is inserted into the tree
  /// in multiple locations, the framework will create a separate [State] object
  /// for each location. Similarly, if the widget is removed from the tree and
  /// later inserted into the tree again, the framework will call [createState]
  /// again to create a fresh [State] object, simplifying the lifecycle of
  /// [State] objects.
  @override
  State<StatefulWidget> createState() => _UISMSFormDialogState();
}

class _UISMSFormDialogState extends State<UISMSFormDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title.localize()),
      actions: <Widget>[
        TextButton(
          child: Text(widget.defaultSubmitText.localize()),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (!formKey.currentState!.validate()) {
              return;
            }
            Navigator.of(context, rootNavigator: true).pop();
            if (widget.defaultSubmitAction == null) {
              return;
            }
            formKey.currentState?.save();
            widget.defaultSubmitAction?.call(phoneNumber!);
          },
        )
      ],
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                maxLength: 200,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Please enter a phone number".localize(),
                  labelText: "Phone Number".localize(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter some text".localize();
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
