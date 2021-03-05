part of masamune;

TextEditingController textEditingController([String? value]) {
  final controller = useTextEditingController();
  if (value != null) {
    controller.text = value;
  }
  return controller;
}
