part of masamune.form;

class UIPageChangePassword extends UIPageForm {
  /// Page title.
  @protected
  String get title => "Change Password".localize();

  /// Set the form type.
  ///
  /// Available for login and password reset page.
  @override
  @protected
  FormBuilderType get formType => FormBuilderType.center;

  /// Creating a app bar.
  ///
  /// [context]: Build context.
  @override
  @protected
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(title: Text(title));
  }

  /// Form body definition.
  ///
  /// [context]: Build context.
  /// [form]: Form data.
  @override
  List<Widget> formBody(BuildContext context, Map<String, dynamic> form) {
    return [
      Text(
        "Please enter the information you want to change".localize(),
        textAlign: TextAlign.center,
      ),
      const Space.height(20),
      FormItemPassword(
        hintText: "Please enter a password".localize(),
        labelText: "Password".localize(),
        confirm: true,
        notMatchText: "Passwords do not match.".localize(),
        confirmLabelText: "ConfirmationPassword".localize(),
        onSaved: (value) {
          if (value.isEmpty) {
            return;
          }
          form["password"] = value;
        },
      ),
    ];
  }

  /// What happens when a form is submitted.
  ///
  /// [context]: Build context.
  /// [form]: Form data.
  @override
  @protected
  Future<void> onSubmit(BuildContext context, Map<String, dynamic> form) async {
    if (!validate(context)) {
      return;
    }
    UIDialog.show(context,
        title: "Success".localize(),
        text: "Editing is complete.".localize(),
        submitText: "OK".localize(), onSubmit: () {
      context.navigator.pop();
    });
  }
}
