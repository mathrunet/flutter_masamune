part of masamune_ui.variable;

/// FormConfig for using ChipsField.
@immutable
class ChipsFormConfig extends VariableFormConfig<List<String>>
    with VariableFormConfigUtilMixin<List<String>> {
  const ChipsFormConfig({
    this.color,
    this.backgroundColor,
    this.chipColor,
    this.chipTextColor,
    this.keyboardType = TextInputType.text,
  });

  final Color? backgroundColor;

  final Color? color;

  final Color? chipColor;

  final Color? chipTextColor;

  final TextInputType keyboardType;

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
      FormItemChipsField(
        dense: true,
        color: color,
        inputType: keyboardType,
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        backgroundColor: backgroundColor,
        allowEmpty: !config.required,
        controller: ref.useTextEditingController(
          config.id,
          data
              .getAsList(config.id, config.value)
              .map((e) => e.toString())
              .join(","),
        ),
        onSaved: (value) {
          context[config.id] = value;
        },
        chipBuilder: (context, state, value) {
          return Chip(
            label: Text(
              value,
              style: TextStyle(
                color: chipTextColor ?? context.theme.textColorOnPrimary,
              ),
            ),
            backgroundColor: chipColor ?? context.theme.primaryColor,
            deleteIcon: const Icon(Icons.close),
            deleteIconColor: chipTextColor ?? context.theme.textColorOnPrimary,
            onDeleted: () {
              state.deleteChip(value);
            },
          );
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
