part of masamune.form;

class UIPageChangeReauth extends PageHookWidget {
  const UIPageChangeReauth();

  @override
  Widget build(BuildContext context) {
    final form = useForm();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reauthentication".localize(),
        ),
      ),
      body: ChangeEmailForm(key: form.key),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          if (!form.validate()) {
            return;
          }
          context.navigator
              .pushReplacementNamed(context.get("redirect_to", "/"));
        },
      ),
    );
  }
}
