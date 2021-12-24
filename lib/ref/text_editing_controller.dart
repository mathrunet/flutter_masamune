part of masamune;

extension DynamicMapTextEditingControllerExtensions on DynamicMap? {
  TextEditingController useTextEditingController(
    WidgetRef ref,
    String key, [
    String defaultValue = "",
  ]) {
    return ref.useTextEditingController(
      key,
      this?[key]?.toString() ?? defaultValue,
    );
  }
}

extension WidgetRefTextEditingControllerExtensions on WidgetRef {
  TextEditingController useTextEditingController(
    String key, [
    String defaultValue = "",
  ]) {
    return valueBuilder<TextEditingController, _TextEditingControllerValue>(
      key: "textEditingController:$key",
      builder: () {
        return _TextEditingControllerValue(defaultValue);
      },
    );
  }

  Map<String, TextEditingController> useTextEditingControllerMap(
    String key,
    Map defaultValues,
  ) {
    return valueBuilder<Map<String, TextEditingController>,
        _TextEditingControllerMapValue>(
      key: "textEditingControllerMap:$key",
      builder: () {
        return _TextEditingControllerMapValue(defaultValues);
      },
    );
  }
}

@immutable
class _TextEditingControllerValue extends ScopedValue<TextEditingController> {
  const _TextEditingControllerValue(this.initialValue);
  final String initialValue;

  @override
  ScopedValueState<TextEditingController, ScopedValue<TextEditingController>>
      createState() => _TextEditingControllerValueState();
}

class _TextEditingControllerValueState extends ScopedValueState<
    TextEditingController, _TextEditingControllerValue> {
  late TextEditingController _controller;

  @override
  void initValue() {
    super.initValue();
    _controller = TextEditingController(text: value.initialValue);
  }

  @override
  void didUpdateValue(_TextEditingControllerValue oldValue) {
    super.didUpdateValue(oldValue);
    if (value.initialValue != oldValue.initialValue) {
      _controller.text = value.initialValue;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  TextEditingController build() => _controller;
}

@immutable
class _TextEditingControllerMapValue
    extends ScopedValue<Map<String, TextEditingController>> {
  const _TextEditingControllerMapValue(this.initialValues);
  final Map initialValues;

  @override
  ScopedValueState<Map<String, TextEditingController>,
          ScopedValue<Map<String, TextEditingController>>>
      createState() => _TextEditingControllerMapValueState();
}

class _TextEditingControllerMapValueState extends ScopedValueState<
    Map<String, TextEditingController>, _TextEditingControllerMapValue> {
  late final Map<String, TextEditingController> _controllers;

  @override
  void initValue() {
    super.initValue();
    _controllers = value.initialValues.map(
      (key, value) => MapEntry(
        key.toString(),
        TextEditingController(text: value.toString()),
      ),
    );
  }

  @override
  void didUpdateValue(_TextEditingControllerMapValue oldValue) {
    super.didUpdateValue(oldValue);
    if (value.initialValues != oldValue.initialValues) {
      for (final tmp in value.initialValues.entries) {
        if (_controllers.containsKey(tmp.key)) {
          final key = tmp.key.toString();
          final value = tmp.value.toString();
          final controller = _controllers[key];
          controller?.text = value;
          _controllers[tmp.key.toString()] =
              controller ?? TextEditingController(text: value);
        } else {
          _controllers[tmp.key.toString()] =
              TextEditingController(text: tmp.value.toString());
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.values.forEach((element) => element.dispose());
  }

  @override
  Map<String, TextEditingController> build() => _controllers;
}
