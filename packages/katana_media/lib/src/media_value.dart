part of katana_media;

@immutable
class MediaValue {
  const MediaValue({
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
