part of masamune.form;

class ReauthForm extends StatelessWidget {
  const ReauthForm({
    required GlobalKey<FormState> key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      // ignore: cast_nullable_to_non_nullable
      key: key as GlobalKey<FormState>,
      children: [
        Text(
          "Please enter your login information again".localize(),
          textAlign: TextAlign.center,
        ),
        const Space.height(20),
        FormItemTextField(
          controller: useTextEditingController(),
          hintText: "Input %s".localize().format(["Password".localize()]),
          errorText: "No input %s".localize().format(["Password".localize()]),
          labelText: "Password".localize(),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
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
