part of masamune.form;

class UIPageChangeEmail extends PageHookWidget with UIPageFormMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Email".localize(),
        ),
      ),
      body: ChangeEmailForm(key: formKey),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          if (!validate(context)) {
            return;
          }
          UIDialog.show(
            context,
            title: "Success".localize(),
            text: "Editing is complete.".localize(),
            submitText: "OK".localize(),
            onSubmit: () {
              context.navigator.pop();
            },
          );
        },
      ),
    );
  }
}
