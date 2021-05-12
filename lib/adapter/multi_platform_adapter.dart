part of masamune;

@immutable
class MultiPlatformAdapter extends PlatformAdapter {
  const MultiPlatformAdapter();

  @override
  Future mediaDialog(
    BuildContext context, {
    required String title,
    PlatformMediaType type = PlatformMediaType.all,
  }) {
    throw UnimplementedError("The media function is not implemented.");
  }
}
