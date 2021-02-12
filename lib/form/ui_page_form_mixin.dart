part of masamune.form;

final formProvider = Provider((_) => <String, dynamic>{});

/// Mix-in that provides the ability to handle forms.
///
/// Pass a [formKey] as the key to the [Form] widget.
///
/// Use [controller()] to get the controller of the form and store all changed values in [form].
///
/// Run [validate(context)] at the time of applying the changes to check if the values are correct.
///
/// Finally, save all changes to the specified document by running [save()].
mixin UIPageFormMixin on UIPage {
  /// Key for form.
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> get form {
    return ProviderContainer().read(formProvider);
  }

  /// Validate the data in the form.
  ///
  /// Returns True if the validation is successful.
  ///
  /// If you enter a value in [initial], you can set it to the initial value.
  bool validate(
    BuildContext context, {
    Map<String, dynamic> initial = const {},
  }) {
    context.unfocus();
    if (formKey.currentState == null) {
      return false;
    }
    if (!formKey.currentState!.validate()) {
      return false;
    }
    final form = ProviderContainer().read(formProvider);
    form.clear();
    initial.forEach((key, value) {
      if (key.isEmpty || value == null) {
        return;
      }
      form[key] = value;
    });
    formKey.currentState!.save();
    return true;
  }
}
