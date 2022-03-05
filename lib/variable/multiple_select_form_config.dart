part of masamune.variable;

/// FormConfig for using Select/DropdownField.
@immutable
class MultipleSelectFormConfig extends FormConfig<List<String>> {
  const MultipleSelectFormConfig({
    required this.items,
    this.backgroundColor,
    this.color,
  });
  final Map<String, String> items;

  final Color? backgroundColor;

  final Color? color;
}

@immutable
class MultipleSelectFormConfigBuilder
    extends FormConfigBuilder<List<String>, MultipleSelectFormConfig> {
  const MultipleSelectFormConfigBuilder();

  @override
  Iterable<Widget> form({
    required VariableConfig<List<String>> config,
    required MultipleSelectFormConfig form,
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
      FormItemMultipleCheckbox(
        dense: true,
        backgroundColor: form.backgroundColor,
        items: form.items,
        allowEmpty: !config.required,
        labelText: "Input %s".localize().format([config.label.localize()]),
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        controller: ref.useTextEditingController(
            config.id, data.getAsList(config.id, config.value).join(",")),
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
    required VariableConfig<List<String>> config,
    required MultipleSelectFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final list = data.getAsList(config.id, config.value);
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      if (list.isEmpty)
        const ListItem(title: Text("--"))
      else
        for (final key in list) ListItem(title: Text(form.items[key] ?? "")),
    ];
  }

  @override
  dynamic value({
    required VariableConfig<List<String>> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.getAsList(config.id, config.value);
  }
}
