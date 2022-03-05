part of masamune.variable;

/// FormConfig for using Slider.
@immutable
class SliderFormConfig extends FormConfig<num> {
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
}

@immutable
class SliderFormConfigBuilder extends FormConfigBuilder<num, SliderFormConfig> {
  const SliderFormConfigBuilder();

  @override
  Iterable<Widget> form({
    required VariableConfig<num> config,
    required SliderFormConfig form,
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
        min: form.min,
        max: form.max,
        format:
            "0.##${form.suffixLabel != null ? " " + form.suffixLabel! : ""}",
        divisions: form.divisions,
        inaciveColor: form.backgroundColor,
        showLabel: true,
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
        activeColor: form.color,
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
    required VariableConfig<num> config,
    required SliderFormConfig form,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      ListItem(
        title: Text(data.get(config.id, form.min).toString()),
        trailing: form.suffixLabel.isEmpty
            ? null
            : Text(form.suffixLabel!.localize()),
      ),
    ];
  }

  @override
  dynamic value({
    required VariableConfig<num> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
