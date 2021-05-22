part of masamune;

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
