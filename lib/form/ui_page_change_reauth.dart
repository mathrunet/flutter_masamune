part of masamune.form;

abstract class UIPageChangeReauth extends PageHookWidget {
  const UIPageChangeReauth();

  Future<bool> onSubmit(BuildContext context, FormContext form);

  @override
  Widget build(BuildContext context) {
    final form = useForm();
    final focusNode = useAutoFocusNode();

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
          if (await onSubmit(context, form)) {
            context.navigator
                .pushReplacementNamed(context.get("redirect_to", "/"));
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
