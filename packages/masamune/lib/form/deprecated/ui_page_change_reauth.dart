part of masamune.form;

@deprecated
abstract class UIPageChangeReauth extends PageScopedWidget {
  const UIPageChangeReauth();

  Future<bool> onSubmit(BuildContext context, WidgetRef ref, FormContext form);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.useForm();
    final focusNode = ref.useFocusNode("focusNode");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reauthentication".localize(),
        ),
      ),
      body: ReauthForm(
        formKey: form.key,
        focusNode: focusNode,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (!form.validate()) {
            return;
          }
          if (await onSubmit(context, ref, form)) {
            context.navigator
                .pushReplacementNamed(context.get(kRedirectTo, "/"));
          } else {
            UIDialog.show(
              context,
              title: "Error".localize(),
              text:
                  "Could not login. Please check your email address and password."
                      .localize(),
              submitText: "OK".localize(),
            );
          }
        },
      ),
    );
  }
}
