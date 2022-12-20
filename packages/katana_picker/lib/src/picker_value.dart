part of katana_picker;

@immutable
class PickerValue {
  const PickerValue({
    required this.path,
    required this.bytes,
  });

  final String path;
  final Uint8List bytes;

  @override
  int get hashCode => path.hashCode ^ bytes.hashCode;

  @override
  bool operator ==(Object other) => other.hashCode == hashCode;
}
