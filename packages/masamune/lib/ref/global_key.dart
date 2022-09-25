part of masamune;

@deprecated
extension WidgetRefGlobalKeyExtensions on WidgetRef {
  @Deprecated(
    "It will not be available from the next version. Use [GlobalKeyProvider] instead.",
  )
  GlobalKey<T> useGlobalKey<T extends State<StatefulWidget>>() {
    return valueBuilder<GlobalKey<T>, _GlobalKeyValue<T>>(
      key: "globalKey:${T.toString()}",
      builder: () {
        return _GlobalKeyValue<T>();
      },
    );
  }

  @Deprecated(
    "It will not be available from the next version. Use [GlobalKeyProvider] instead.",
  )
  GlobalKey<T> useGlobalValueKey<T extends State<StatefulWidget>>(String key) {
    return valueBuilder<GlobalKey<T>, _GlobalKeyValue<T>>(
      key: "globalKey:${T.toString()}:$key",
      builder: () {
        return _GlobalKeyValue<T>();
      },
    );
  }
}

@deprecated
class _GlobalKeyValue<T extends State> extends ScopedValue<GlobalKey<T>> {
  const _GlobalKeyValue();
  @override
  ScopedValueState<GlobalKey<T>, ScopedValue<GlobalKey<T>>> createState() =>
      _GlobalKeyValueState<T>();
}

@deprecated
class _GlobalKeyValueState<T extends State>
    extends ScopedValueState<GlobalKey<T>, _GlobalKeyValue<T>> {
  final GlobalKey<T> key = GlobalKey<T>();
  @override
  GlobalKey<T> build() => key;
}
