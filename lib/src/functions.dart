part of masamune;

TextEditingController textEditingController([String? value]) {
  final initial = useState<String?>(value);
  final controller = useTextEditingController(text: value);
  if (value != null && value != initial.value) {
    controller.text = value;
    initial.value = value;
  }
  return controller;
}
