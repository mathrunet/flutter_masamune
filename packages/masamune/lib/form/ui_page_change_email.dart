part of masamune.form;

abstract class UIPageChangeEmail extends PageScopedWidget {
  const UIPageChangeEmail();

  String? emailBuilder(BuildContext context);

  Future<bool> onSubmit(BuildContext context, WidgetRef ref, FormContext form);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.useForm();
    final focusNode = ref.useFocusNode("focusNode");
    final email = emailBuilder(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Email".localize(),
        ),
      ),
      body: ChangeEmailForm(
        formKey: form.key,
        defaultEmail: email ?? "",
        focusNode: focusNode,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (!form.validate()) {
            return;
          }
          if (await onSubmit(context, ref, form)) {
            UIDialog.show(
              context,
              title: "Success".localize(),
              text:
                  "Confirmation email has been sent to your registered email address. Your registration will be completed once we have received your email address."
                      .localize(),
              submitText: "OK".localize(),
              onSubmit: () {
                context.navigator.pop();
              },
            );
          } else {
            UIDialog.show(
              context,
              title: "Error".localize(),
              text: "%s is not completed."
                  .localize()
                  .format(["Editing".localize()]),
              submitText: "Close".localize(),
            );
          }
        },
      ),
    );
  }
}
