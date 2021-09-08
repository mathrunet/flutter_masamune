part of masamune.form;

class UIPageChangeEmail extends PageHookWidget {
  const UIPageChangeEmail();

  @override
  Widget build(BuildContext context) {
    final form = useForm();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Email".localize(),
        ),
      ),
      body: ChangeEmailForm(key: form.key),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          if (!form.validate()) {
            return;
          }
          UIDialog.show(
            context,
            title: "Success".localize(),
            text: "Editing is completed.".localize(),
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
