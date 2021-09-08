part of masamune.form;

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    required GlobalKey<FormState> key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      // ignore: cast_nullable_to_non_nullable
      key: key as GlobalKey<FormState>,
      children: [
        Text(
          "Please enter the information you want to change".localize(),
          textAlign: TextAlign.center,
        ),
        const Space.height(20),
        FormItemPassword(
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
