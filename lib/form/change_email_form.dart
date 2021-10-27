part of masamune.form;

class ChangeEmailForm extends HookWidget {
  const ChangeEmailForm({
    required this.formKey,
    this.defaultEmail = "",
    this.focusNode,
  }) : super();
  final String defaultEmail;
  final FocusNode? focusNode;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      // ignore: cast_nullable_to_non_nullable
      key: formKey,
      children: [
        Text(
          "Please enter the information you want to change".localize(),
          textAlign: TextAlign.center,
        ),
        const Space.height(20),
        FormItemTextField(
          focusNode: focusNode,
          controller: useMemoizedTextEditingController(defaultEmail),
          hintText: "Input %s".localize().format(["Email".localize()]),
          errorText: "No input %s".localize().format(["Email".localize()]),
          labelText: "Email".localize(),
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) {
            if (value.isEmpty) {
              return;
            }
            context["email"] = value;
          },
        ),
      ],
      type: FormBuilderType.center,
    );
  }
}
