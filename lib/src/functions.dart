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
