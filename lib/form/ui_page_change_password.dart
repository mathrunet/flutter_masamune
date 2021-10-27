part of masamune.form;

abstract class UIPageChangePassword extends PageHookWidget {
  const UIPageChangePassword();

  Future<bool> onSubmit(BuildContext context, FormContext form);

  @override
  Widget build(BuildContext context) {
    final form = useForm();
    final focusNode = useAutoFocusNode();

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
          if (await onSubmit(context, form)) {
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
