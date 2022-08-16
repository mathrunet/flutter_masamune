part of masamune.form;

@deprecated
class ReauthForm extends ScopedWidget {
  const ReauthForm({
    required this.formKey,
    this.focusNode,
  }) : super();
  final FocusNode? focusNode;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      // ignore: cast_nullable_to_non_nullable
      key: formKey,
      children: [
        Text(
          "Please enter your login information again".localize(),
          textAlign: TextAlign.center,
        ),
        const Space.height(20),
        FormItemTextField(
          focusNode: focusNode,
          controller: ref.useTextEditingController("password"),
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
