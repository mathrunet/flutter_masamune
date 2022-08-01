part of masamune.variable;

/// FormConfig for using avatar image.
@immutable
class AvatarFormConfig extends VariableFormConfig<String> {
  const AvatarFormConfig({
    this.color,
    this.backgroundColor,
    this.padding,
  });

  final Color? backgroundColor;

  final Color? color;

  final EdgeInsetsGeometry? padding;

  @override
  Iterable<Widget> build({
    required VariableConfig<String> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      FormItemAvatarImage(
        backgroundColor: backgroundColor,
        textColor: color,
        padding: const EdgeInsets.symmetric(vertical: 8),
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
              type: PlatformMediaType.image,
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
