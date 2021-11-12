part of masamune;

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

class _TextEditingControllerMapHookCreator {
  const _TextEditingControllerMapHookCreator();

  /// Creates a map of [String] and [TextEditingController] that will be disposed automatically.
  ///
  /// The [text] parameter can be used to set the initial value of the
  /// controller.
  Map<String, TextEditingController> call(
      [Map<String, String>? map, List<Object?>? keys]) {
    return use(_TextEditingControllerMapHook(map, keys));
  }

  /// Creates a map of [String] and [TextEditingController] from the initial [value] that will
  /// be disposed automatically.
  Map<String, TextEditingController> fromValue(
    Map<String, TextEditingValue>? map, [
    List<Object?>? keys,
  ]) {
    return use(_TextEditingControllerMapHook.fromValue(map, keys));
  }
}

/// Creates a map of [String] and [TextEditingController], either via an initial text or an initial
/// [TextEditingValue].
///
/// To use a [TextEditingController] with an optional initial text, use
/// ```dart
/// final controller = useTextEditingController(text: 'initial text');
/// ```
///
/// To use a [TextEditingController] with an optional initial value, use
/// ```dart
/// final controller = useTextEditingController
///   .fromValue(TextEditingValue.empty);
/// ```
///
/// Changing the text or initial value after the widget has been built has no
/// effect whatsoever. To update the value in a callback, for instance after a
/// button was pressed, use the [TextEditingController.text] or
/// [TextEditingController.text] setters. To have the [TextEditingController]
/// reflect changing values, you can use [useEffect]. This example will update
/// the [TextEditingController.text] whenever a provided [ValueListenable]
/// changes:
/// ```dart
/// final controller = useTextEditingController();
/// final update = useValueListenable(myTextControllerUpdates);
///
/// useEffect(() {
///   controller.text = update;
/// }, [update]);
/// ```
///
/// See also:
/// - [TextEditingController], which this hook creates.
const useTextEditingControllerMap = _TextEditingControllerMapHookCreator();

class _TextEditingControllerMapHook
    extends Hook<Map<String, TextEditingController>> {
  const _TextEditingControllerMapHook(
    this.initialTextMap, [
    List<Object?>? keys,
  ])  : initialValueMap = null,
        super(keys: keys);

  const _TextEditingControllerMapHook.fromValue(
    this.initialValueMap, [
    List<Object?>? keys,
  ])  : initialTextMap = null,
        super(keys: keys);

  final Map<String, String>? initialTextMap;
  final Map<String, TextEditingValue>? initialValueMap;

  @override
  _TextEditingControllerMapHookState createState() {
    return _TextEditingControllerMapHookState();
  }
}

class _TextEditingControllerMapHookState extends HookState<
    Map<String, TextEditingController>, _TextEditingControllerMapHook> {
  late final Map<String, TextEditingController> _map;
  @override
  void initHook() {
    _map = hook.initialTextMap?.map(
          (k, v) => MapEntry(k, TextEditingController(text: v)),
        ) ??
        hook.initialValueMap?.map(
          (k, v) => MapEntry(k, TextEditingController.fromValue(v)),
        ) ??
        <String, TextEditingController>{};
  }

  @override
  Map<String, TextEditingController> build(BuildContext context) => _map;

  @override
  void dispose() {
    _map.forEach((key, value) => value.dispose());
    _map.clear();
  }

  @override
  String get debugLabel => 'useTextEditingControllerMap';
}
