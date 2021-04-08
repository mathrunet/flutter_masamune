part of masamune.form;

/// Mix-in that provides the ability to handle forms.
///
/// Pass a [formKey] as the key to the [Form] widget.
///
/// Use [controller()] to get the controller of the form and store all changed values in [form].
///
/// Run [validate(context)] at the time of applying the changes to check if the values are correct.
///
/// Finally, save all changes to the specified document by running [save()].
mixin UIPageFormMixin on PageHookWidget {
  /// Key for form.
  final formKey = GlobalKey<FormState>();

  /// Validate the data in the form.
  ///
  /// Returns True if the validation is successful.
  ///
  /// If you enter a value in [initial], you can set it to the initial value.
  ///
  /// If [autoUnfocus] is `true`, the focus will be removed automatically.
  bool validate(
    BuildContext context, {
    bool autoUnfocus = true,
    Map<String, dynamic> initial = const {},
  }) {
    if (autoUnfocus) {
      context.unfocus();
    }
    if (formKey.currentState == null) {
      return false;
    }
    if (!formKey.currentState!.validate()) {
      return false;
    }
    initial.forEach((key, value) {
      if (key.isEmpty || value == null) {
        return;
      }
      context[key] = value;
    });
    formKey.currentState!.save();
    return true;
  }
}
