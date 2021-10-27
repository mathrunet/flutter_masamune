part of masamune.form;

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    required this.formKey,
    this.focusNode,
  }) : super();
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
        FormItemPassword(
          focusNode: focusNode,
          hintText: "Input %s".localize().format(["Password".localize()]),
          labelText: "Password".localize(),
          confirm: true,
          notMatchText: "Passwords do not match.".localize(),
          confirmLabelText: "ConfirmationPassword".localize(),
          onSaved: (value) {
            if (value.isEmpty) {
              return;
            }
            context["password"] = value;
          },
        ),
      ],
      type: FormBuilderType.center,
    );
  }
}
