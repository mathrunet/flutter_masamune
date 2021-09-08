part of masamune.form;

class ChangeEmailForm extends StatelessWidget {
  const ChangeEmailForm({
    required GlobalKey<FormState> key,
    this.defaultEmail = "",
  }) : super(key: key);
  final String defaultEmail;

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
        FormItemTextField(
          controller: useTextEditingController(text: defaultEmail),
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
