part of masamune.form;

class UIPageChangeEmail extends UIPageForm {
  /// Page title.
  @protected
  String get title => "Change Email".localize();

  /// Default mail address.
  @protected
  String get email => "";

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
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(title: Text(title));
  }

  /// Form body definition.
  ///
  /// [context]: Build context.
  /// [form]: Form data.
  @override
  @protected
  List<Widget> formBody(BuildContext context, Map<String, dynamic> form) {
    return [
      Text(
        "Please enter the information you want to change".localize(),
        textAlign: TextAlign.center,
      ),
      const Space.height(20),
      FormItemTextField(
        controller: useTextEditingController(text: email),
        hintText: "Please enter a email address".localize(),
        labelText: "Email".localize(),
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          if (value.isEmpty) {
            return;
          }
          form["email"] = value;
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
