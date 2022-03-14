part of masamune.variable;

/// FormConfig for using multiple TextField List.
@immutable
class MultipleTextFormConfig extends VariableFormConfig<List<String>> {
  const MultipleTextFormConfig({
    this.backgroundColor,
    this.obscureText = false,
    this.color,
    this.minLength,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.maxItems,
    this.keyboardType = TextInputType.url,
  });

  final int? maxItems;

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
          prefix: config.required
              ? IconTheme(
                  data: const IconThemeData(size: 16),
                  child: context.widgetTheme.requiredIcon,
                )
              : null,
        )
      else
        const Divid(),
      FormItemMultipleTextField(
        dense: true,
        color: color,
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
            config.id, data.getAsList(config.id, config.value).join(",")),
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
