part of masamune.variable;

/// FormConfig for using TextField.
@immutable
class TextFormConfig<T> extends VariableFormConfig<T> {
  const TextFormConfig({
    this.color,
    this.backgroundColor,
    this.obscureText = false,
    this.minLines,
    this.maxLines,
    this.minLength,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.prefix,
    this.prefixText,
    this.suffix,
    this.suffixText,
    this.top,
    this.bottom,
  });

  final String? prefixText;
  final String? suffixText;

  final Widget? prefix;
  final Widget? suffix;

  final Color? backgroundColor;

  final Color? color;

  final int? minLines;

  final int? maxLines;

  final TextInputType keyboardType;

  final int? minLength;

  final int? maxLength;

  final bool obscureText;

  final TextInputFormatterConfig? inputFormatter;

  final ValueWidget<TextEditingController>? top;
  final ValueWidget<TextEditingController>? bottom;

  @override
  Iterable<Widget> build({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final controller = ref.useTextEditingController(
        config.id, data.get(config.id, config.value).toString());
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
      if (top != null) ValueProvider(value: controller, child: top!),
      FormItemTextField(
        dense: true,
        color: color,
        inputFormatters: [if (inputFormatter != null) inputFormatter!.value],
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
        controller: controller,
        onSaved: (value) {
          context[config.id] = value;
        },
        prefix: prefix ??
            (prefixText != null ? Text(prefixText?.localize() ?? "") : null),
        suffix: suffix ??
            (suffixText != null ? Text(suffixText?.localize() ?? "") : null),
      ),
      if (bottom != null) ValueProvider(value: controller, child: bottom!),
    ];
  }

  @override
  T? value({
    required VariableConfig<T> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
