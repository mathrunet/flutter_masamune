part of masamune;

extension WidgetRefGlobalKeyExtensions on WidgetRef {
  GlobalKey<T> useGlobalKey<T extends State<StatefulWidget>>() {
    return valueBuilder<GlobalKey<T>, _GlobalKeyValue<T>>(
      key: "globalKey:${T.toString()}",
      builder: () {
        return _GlobalKeyValue<T>();
      },
    );
  }
}

class _GlobalKeyValue<T extends State> extends ScopedValue<GlobalKey<T>> {
  const _GlobalKeyValue();
  @override
  ScopedValueState<GlobalKey<T>, ScopedValue<GlobalKey<T>>> createState() =>
      _GlobalKeyValueState<T>();
}

class _GlobalKeyValueState<T extends State>
    extends ScopedValueState<GlobalKey<T>, _GlobalKeyValue<T>> {
  final GlobalKey<T> key = GlobalKey<T>();
  @override
  GlobalKey<T> build() => key;
}
