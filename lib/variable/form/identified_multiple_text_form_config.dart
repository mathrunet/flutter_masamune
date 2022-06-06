part of masamune.variable;

/// FormConfig for using identified multiple TextField List.
@immutable
class IdentifiedMultipleTextFormConfig
    extends VariableFormConfig<Map<String, String>>
    with VariableFormConfigUtilMixin<Map<String, String>> {
  const IdentifiedMultipleTextFormConfig({
    this.backgroundColor,
    this.color,
    this.obscureText = false,
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
    required VariableConfig<Map<String, String>> config,
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
      FormItemIdentifiedMultipleTextField(
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
          config.id,
          jsonEncode(data.getAsMap(config.id, config.value)),
        ),
        onSaved: (value) {
          context[config.id] = Map.from(value ?? {})
            ..removeWhere((key, value) => key.isEmpty || value.isEmpty);
        },
      ),
    ];
  }

  @override
  Map<String, String>? value({
    required VariableConfig<Map<String, String>> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.getAsMap(config.id, config.value);
  }
}
