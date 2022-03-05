part of masamune.variable;

/// FormConfig for using Select/DropdownField.
@immutable
class SelectFormConfig extends FormConfig<String> {
  const SelectFormConfig({
    required this.items,
    this.backgroundColor,
    this.color,
  });

  final Map<String, String> items;

  final Color? backgroundColor;

  final Color? color;
}

@immutable
class SelectFormConfigBuilder
    extends FormConfigBuilder<String, SelectFormConfig> {
  const SelectFormConfigBuilder();

  @override
  Iterable<Widget> form({
    required VariableConfig<String> config,
    required SelectFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
          prefix: config.required
              ? IconTheme(
                  data: const IconThemeData(size: 16),
                  child: context.widgetTheme.requiredIcon,
                )
              : null,
        )
      else
        const Divid(),
      FormItemDropdownField(
        dense: true,
        backgroundColor: form.backgroundColor,
        items: form.items,
        allowEmpty: !config.required,
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        controller: ref.useTextEditingController(
            config.id, data.get(config.id, config.value)),
        onSaved: (value) {
          if (value.isEmpty) {
            context[config.id] = config.value;
          } else {
            context[config.id] = value;
          }
        },
      ),
    ];
  }

  @override
  Iterable<Widget> view({
    required VariableConfig<String> config,
    required SelectFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      ListItem(
        title: Text(form.items[data.get(config.id, config.value)] ?? ""),
      ),
    ];
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
