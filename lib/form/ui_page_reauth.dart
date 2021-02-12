part of masamune.form;

class UIPageReauth extends UIPageForm {
  /// Page title.
  @protected
  String get title => "Reauthentication".localize();

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
  @override
  @protected
  List<Widget> formBody(BuildContext context, Map<String, dynamic> form) {
    return [
      Text(
        "Please enter your login information again".localize(),
        textAlign: TextAlign.center,
      ),
      const Space.height(20),
      FormItemTextField(
        controller: useTextEditingController(),
        hintText: "Please enter a password".localize(),
        labelText: "Password".localize(),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        onSaved: (value) {
          if (value.isEmpty) {
            return;
          }
          form["password"] = value;
        },
      )
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
    context.navigator.pushReplacementNamed(context.arg.get("redirect_to"));
  }
}
