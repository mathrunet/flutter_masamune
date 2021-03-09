part of masamune;

TextEditingController useMemoizedTextEditingController([String value = ""]) {
  final controller = useTextEditingController();
  useEffect(() {
    controller.text = value;
  }, [value]);
  return controller;
}

AsyncSnapshot<T> useMemoizedFuture<T>(Future<T> future, T initialData) {
  final initial = useMemoized(() => future);
  return useFuture<T>(initial, initialData: initialData);
}

AsyncSnapshot<T> useMemoizedStream<T>(Stream<T> stream, T initialData) {
  final initial = useMemoized(() => stream);
  return useStream<T>(initial, initialData: initialData);
}
