part of masamune_ui.variable;

/// FormConfig for using Image.
@immutable
class ImageFormConfig extends VariableFormConfig<String> {
  const ImageFormConfig({
    this.color,
    this.backgroundColor,
    this.height = 160,
    this.fit = BoxFit.cover,
    this.type = PlatformMediaType.all,
    this.contentPadding,
  });

  final Color? backgroundColor;

  final Color? color;

  final PlatformMediaType type;

  final double height;

  final BoxFit fit;

  final EdgeInsetsGeometry? contentPadding;

  @override
  Iterable<Widget> build({
    required VariableConfig<String> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      FormItemMedia(
        dense: true,
        height: height,
        color: color,
        fit: fit,
        contentPadding: contentPadding,
        padding: const EdgeInsets.only(bottom: 4),
        hintText: "Select %s".localize().format([config.label.localize()]),
        errorText: "No select %s".localize().format([config.label.localize()]),
        allowEmpty: !config.required,
        controller: ref.useTextEditingController(
          config.id,
          data.get(config.id, config.value),
        ),
        onSaved: (value) {
          context[config.id] = value;
        },
        onTap: (onUpdate) async {
          try {
            final media = await context.platform?.mediaDialog(
              context,
              title: "Select %s".localize().format([config.label.localize()]),
              type: type,
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
  String? value({
    required VariableConfig<String> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
