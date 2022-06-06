part of masamune.variable;

/// FormConfig for using Select/DropdownField.
@immutable
class SelectFormConfig extends VariableFormConfig<String>
    with VariableFormConfigUtilMixin<String> {
  const SelectFormConfig({
    required this.items,
    this.backgroundColor,
    this.color,
  });

  final Map<String, String> items;

  final Color? backgroundColor;

  final Color? color;

  @override
  Iterable<Widget> build({
    required VariableConfig<String> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
          color: color?.withOpacity(0.75),
          prefix: headlinePrefix(
            context: context,
            config: config,
            color: color,
          ),
        )
      else
        const Divid(),
      FormItemDropdownField(
        dense: true,
        backgroundColor: backgroundColor,
        items: items,
        allowEmpty: !config.required,
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        controller: ref.useTextEditingController(
          config.id,
          data.get(config.id, config.value),
        ),
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
  String? value({
    required VariableConfig<String> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
