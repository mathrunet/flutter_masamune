part of masamune.form;

/// Template for creating form pages.
abstract class UIPageForm extends UIPageScaffold with UIPageFormMixin {
  /// Creating a floating action button.
  ///
  /// [context]: Build context.
  @override
  @protected
  Widget floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (autoValidate && !validate(context)) {
          return;
        }
        onSubmit(context, form);
      },
      child: Icon(floatingActionButtonIcon),
    );
  }

  /// Automatic verification.
  @protected
  bool get autoValidate => true;

  /// What happens when a form is submitted.
  ///
  /// [context]: Build context.
  /// [form]: Form data.
  @protected
  void onSubmit(BuildContext context, Map<String, dynamic> form) {}

  /// FAB icon definition.
  @protected
  IconData get floatingActionButtonIcon => Icons.check;

  /// Form body definition.
  ///
  /// [context]: Build context.
  /// [form]: Form data.
  @protected
  List<Widget> formBody(BuildContext context, Map<String, dynamic> form);

  /// Set the form type.
  ///
  /// Available for login and password reset page.
  @protected
  FormBuilderType get formType => FormBuilderType.listView;

  /// Specify the padding of the form.
  @protected
  EdgeInsetsGeometry get formPadding => const EdgeInsets.all(0);

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  @protected
  Widget body(BuildContext context) {
    return FormBuilder(
      type: formType,
      key: formKey,
      padding: formPadding,
      children: formBody(context, form),
    );
  }
}
