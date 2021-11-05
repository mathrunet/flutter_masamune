part of masamune;

TextEditingController useMemoizedTextEditingController([String value = ""]) {
  final controller = useTextEditingController();
  useEffect(() {
    controller.text = value;
  }, [value]);
  return controller;
}

Map<String, TextEditingController> useMemoizedTextEditingControllerMap(
    [Map map = const {}]) {
  final controllers = useTextEditingControllerMap(
    map is Map<String, String>
        ? map
        : map.map((key, value) => MapEntry(key.toString(), value.toString())),
  );
  useEffect(
    () {
      for (final tmp in map.entries) {
        if (!controllers.containsKey(tmp.key)) {
          continue;
        }
        controllers[tmp.key]?.text = tmp.value;
      }
    },
    [...map.keys, ...map.values.map((e) => e.toString())],
  );
  return controllers;
}

AsyncSnapshot<T> useMemoizedFuture<T>(Future<T> future, T initialData) {
  final initial = useMemoized(() => future);
  return useFuture<T>(initial, initialData: initialData);
}

AsyncSnapshot<T> useMemoizedStream<T>(Stream<T> stream, T initialData) {
  final initial = useMemoized(() => stream);
  return useStream<T>(initial, initialData: initialData);
}

void useWidgetState({
  required void Function() onInit,
  void Function()? onDispose,
}) {
  useEffect(() {
    onInit.call();
    return onDispose;
  }, const []);
}

/// Creates a variable and subscribes to it.
///
/// Whenever [ValueNotifier.value] updates, it will mark the caller [HookWidget]
/// as needing build.
/// On first call, inits [ValueNotifier] to [initialData]. [initialData] is ignored
/// on subsequent calls.
///
/// The following example showcase a basic counter application.
///
/// ```dart
/// class Counter extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     final counter = useValue(0);
///
///     return GestureDetector(
///       onTap: () => counter.value++,
///       child: Text(counter.value.toString()),
///     );
///   }
/// }
/// ```
///
/// See also:
///
///  * [ValueNotifier]
///  * [useStreamController], an alternative to [ValueNotifier] for state.
ValueNotifier<T> useValue<T>(T initialData) {
  return use(_ValueHook(initialData: initialData));
}

class _ValueHook<T> extends Hook<ValueNotifier<T>> {
  const _ValueHook({required this.initialData});

  final T initialData;

  @override
  _ValueHookState<T> createState() => _ValueHookState();
}

class _ValueHookState<T> extends HookState<ValueNotifier<T>, _ValueHook<T>> {
  late final _state = ValueNotifier<T>(hook.initialData);

  @override
  void dispose() {
    _state.dispose();
  }

  @override
  ValueNotifier<T> build(BuildContext context) => _state;

  @override
  Object? get debugValue => _state.value;

  @override
  String get debugLabel => 'useValue<$T>';
}
