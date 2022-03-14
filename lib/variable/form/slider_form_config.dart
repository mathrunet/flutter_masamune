part of masamune.variable;

/// FormConfig for using Slider.
@immutable
class SliderFormConfig extends VariableFormConfig<num> {
  const SliderFormConfig({
    required this.min,
    required this.max,
    this.divisions,
    this.backgroundColor,
    this.color,
    this.suffixLabel,
  });

  final double min;
  final double max;
  final int? divisions;

  final String? suffixLabel;

  final Color? backgroundColor;

  final Color? color;

  @override
  Iterable<Widget> build({
    required VariableConfig<num> config,
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
      FormItemSlider(
        controller: ref.useTextEditingController(
          config.id,
          data.get(config.id, config.value).toString(),
        ),
        min: min,
        max: max,
        format: "0.##${suffixLabel != null ? " " + suffixLabel! : ""}",
        divisions: divisions,
        inaciveColor: backgroundColor,
        showLabel: true,
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
        activeColor: color,
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
  num? value({
    required VariableConfig<num> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
