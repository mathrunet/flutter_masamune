part of masamune;

extension WidgetRefUuidExtensions on WidgetRef {
  String useUuid({String hookId = ""}) {
    return valueBuilder<String, _UuidValue>(
      key: "uuid:$hookId",
      builder: () {
        return const _UuidValue();
      },
    );
  }
}

class _UuidValue extends ScopedValue<String> {
  const _UuidValue();
  @override
  ScopedValueState<String, ScopedValue<String>> createState() =>
      _UuidValueState();
}

class _UuidValueState extends ScopedValueState<String, _UuidValue> {
  final String id = uuid;
  @override
  String build() => id;
}
