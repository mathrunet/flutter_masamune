part of masamune_ui.variable;

/// FormConfig for using Checkbox field.
@immutable
class CheckboxFormConfig extends VariableFormConfig<bool>
    with VariableFormConfigUtilMixin<bool> {
  const CheckboxFormConfig({
    this.backgroundColor,
    this.color,
    this.activeColor,
    this.borderColor,
  });

  final Color? backgroundColor;

  final Color? color;

  final Color? borderColor;

  final Color? activeColor;

  @override
  Iterable<Widget> build({
    required VariableConfig<bool> config,
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
      FormItemCheckbox(
        dense: true,
        color: color,
        activeColor: activeColor,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        type: FormItemCheckboxType.form,
        labelText: config.label.localize(),
        hintText: config.label.localize(),
        errorText: "No input %s".localize().format([config.label.localize()]),
        controller: ref.useTextEditingController(
          config.id,
          data.get(config.id, config.value).toString(),
        ),
        onSaved: (value) {
          if (value == null) {
            context[config.id] = config.value;
          } else {
            context[config.id] = value;
          }
        },
      ),
    ];
  }

  @override
  bool? value({
    required VariableConfig<bool> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
