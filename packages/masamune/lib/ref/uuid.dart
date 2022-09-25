part of masamune;

/// Provides extended methods for [WidgetRef].
/// [WidgetRef]用の拡張メソッドを提供します。
extension WidgetRefUuidExtensions on WidgetRef {
  /// Create a unique UUID within the page.
  /// ページ内で一意なUUIDを作成します。
  ///
  /// The content of the UUID does not change when the page is updated.
  /// ページが更新された場合でもUUIDの内容は変わりません。
  ///
  /// The UUID created is returned in Version 4 as a 32-character string with hyphens removed.
  /// 作成されるUUIDはVersion4で32文字のハイフンが取り除かれた文字列として返されます。
  String uuid() {
    return valueBuilder<String, _UuidValue>(
      key: r"_$$uuid",
      builder: () {
        return const _UuidValue();
      },
    );
  }

  @Deprecated(
    "It will not be available from the next version. Use [WidgetRef.uuid] instead.",
  )
  String useUuid() {
    return valueBuilder<String, _UuidValue>(
      key: r"_$$uuid",
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
