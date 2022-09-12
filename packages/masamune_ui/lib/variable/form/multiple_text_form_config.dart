part of masamune_ui.variable;

/// FormConfig for using multiple TextField List.
@immutable
class MultipleTextFormConfig extends VariableFormConfig<List<String>>
    with VariableFormConfigUtilMixin<List<String>> {
  const MultipleTextFormConfig({
    this.backgroundColor,
    this.obscureText = false,
    this.color,
    this.minLength,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.maxItems,
    this.minItems,
    this.keyboardType = TextInputType.text,
  });

  final int? maxItems;

  final int? minItems;

  final Color? backgroundColor;

  final Color? color;

  final int? minLines;

  final int? maxLines;

  final TextInputType keyboardType;

  final int? minLength;

  final int? maxLength;

  final bool obscureText;

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
      FormItemMultipleTextField(
        dense: true,
        color: color,
        cursorColor: color,
        minItems: minItems,
        subColor: color?.withOpacity(0.5),
        minLines: minLines ?? 1,
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        maxLines: maxLines,
        minLength: minLength,
        maxLength: maxLength,
        keyboardType: keyboardType,
        backgroundColor: backgroundColor,
        obscureText: obscureText,
        allowEmpty: !config.required,
        controller: ref.useTextEditingController(
          hookId: config.id,
          defaultValue: data.getAsList(config.id, config.value).join(","),
        ),
        onSaved: (value) {
          context[config.id] = value?.where((e) => e.isNotEmpty).toList() ?? [];
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
