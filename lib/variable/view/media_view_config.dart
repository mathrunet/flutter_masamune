part of masamune.variable;

class MediaViewConfig extends VariableViewConfig<String> {
  const MediaViewConfig();

  @override
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<String> config,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final path = data.get(config.id, config.value);
    final type = getPlatformMediaType(path);
    switch (type) {
      case PlatformMediaType.image:
        return [
          Image(image: NetworkOrAsset.image(path), fit: BoxFit.cover),
        ];
      case PlatformMediaType.video:
        return [
          Video(NetworkOrAsset.video(path), fit: BoxFit.cover),
        ];
      default:
        return [
          const Empty(),
        ];
    }
  }
}
