part of katana_picker;

@immutable
class PickerValue {
  const PickerValue({
    this.path,
    this.bytes,
  }) : assert(path != null || bytes != null,
            "[Either [path] or [bytes] must be non-null.");

  final String? path;
  final Uint8List? bytes;

  @override
  int get hashCode => path.hashCode ^ bytes.hashCode;

  @override
  bool operator ==(Object other) => other.hashCode == hashCode;
}
