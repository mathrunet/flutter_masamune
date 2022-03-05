part of masamune.variable;

/// FormConfig for using Image.
@immutable
class ImageFormConfig extends FormConfig<String> {
  const ImageFormConfig({
    this.color,
    this.backgroundColor,
    this.height = 160,
    this.type = PlatformMediaType.all,
  });

  final Color? backgroundColor;

  final Color? color;

  final PlatformMediaType type;

  final double height;
}

@immutable
class ImageFormConfigBuilder
    extends FormConfigBuilder<String, ImageFormConfig> {
  const ImageFormConfigBuilder();

  @override
  Iterable<Widget> form({
    required VariableConfig<String> config,
    required ImageFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      FormItemMedia(
        dense: true,
        height: form.height,
        color: form.color,
        padding: const EdgeInsets.only(bottom: 4),
        hintText: "Select %s".localize().format([config.label.localize()]),
        errorText: "No select %s".localize().format([config.label.localize()]),
        allowEmpty: !config.required,
        controller: ref.useTextEditingController(
            config.id, data.get(config.id, config.value)),
        onSaved: (value) {
          context[config.id] = value;
        },
        onTap: (onUpdate) async {
          try {
            final media = await context.platform?.mediaDialog(
              context,
              title: "Select %s".localize().format([config.label.localize()]),
              type: form.type,
            );
            if (media == null || media.path.isEmpty) {
              return;
            }
            final uploaded = await context.model
                ?.uploadMedia(media.path!)
                .showIndicator(context);
            if (uploaded.isEmpty) {
              return;
            }
            onUpdate(uploaded!);
          } catch (e) {
            UIDialog.show(
              context,
              title: "Error".localize(),
              text: "%s is not completed.".localize().format(
                ["Upload".localize()],
              ),
              submitText: "Close".localize(),
            );
          }
        },
      ),
    ];
  }

  @override
  Iterable<Widget> view({
    required VariableConfig<String> config,
    required ImageFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
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

  @override
  dynamic value({
    required VariableConfig<String> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
