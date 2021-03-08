part of masamune;

TextEditingController useMemoizedTextEditingController([String? value]) {
  return useTextEditingController(text: value, keys: [value]);
}

AsyncSnapshot<T> useMemoizedFuture<T>(Future<T> future, T initialData) {
  final initial = useMemoized(() => future);
  return useFuture<T>(initial, initialData: initialData);
}

AsyncSnapshot<T> useMemoizedStream<T>(Stream<T> stream, T initialData) {
  final initial = useMemoized(() => stream);
  return useStream<T>(initial, initialData: initialData);
}
