part of masamune_ui.variable;

/// FormConfig for using Select/DropdownField.
@immutable
class MultipleCheckboxFormConfig extends VariableFormConfig<List<String>>
    with VariableFormConfigUtilMixin<List<String>> {
  const MultipleCheckboxFormConfig({
    required this.items,
    this.backgroundColor,
    this.color,
  });
  final Map<String, String> items;

  final Color? backgroundColor;

  final Color? color;

  @override
  Iterable<Widget> build({
    required VariableConfig<List<String>> config,
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
      FormItemMultipleCheckbox(
        dense: true,
        backgroundColor: backgroundColor,
        items: items,
        allowEmpty: !config.required,
        labelText: "Input %s".localize().format([config.label.localize()]),
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        controller: ref.useTextEditingController(
          config.id,
          data.getAsList(config.id, config.value).join(","),
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
  List<String>? value({
    required VariableConfig<List<String>> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.getAsList(config.id, config.value);
  }
}
