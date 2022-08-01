part of masamune.form;

abstract class UIPageChangePassword extends PageScopedWidget {
  const UIPageChangePassword();

  Future<bool> onSubmit(BuildContext context, WidgetRef ref, FormContext form);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.useForm();
    final focusNode = ref.useFocusNode("focusNode");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password".localize(),
        ),
      ),
      body: ChangePasswordForm(
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
            UIDialog.show(
              context,
              title: "Success".localize(),
              text:
                  "%s is completed.".localize().format(["Editing".localize()]),
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
              submitText: "OK".localize(),
            );
          }
        },
      ),
    );
  }
}
