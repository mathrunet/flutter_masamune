part of masamune_ui.variable;

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
    final type = getAdapterMediaType(path);
    switch (type) {
      case AdapterMediaType.image:
        return [
          Image(image: Asset.image(path), fit: BoxFit.cover),
        ];
      case AdapterMediaType.video:
        return [
          Video(Asset.video(path), fit: BoxFit.cover),
        ];
      default:
        return [
          const Empty(),
        ];
    }
  }
}
