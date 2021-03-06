part of masamune.form;

class UIPageChangeReauth extends UIPage with UIPageFormMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reauthentication".localize(),
        ),
      ),
      body: ChangeEmailForm(key: formKey),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          if (!validate(context)) {
            return;
          }
          context.navigator
              .pushReplacementNamed(context.get("redirect_to", "/"));
        },
      ),
    );
  }
}
