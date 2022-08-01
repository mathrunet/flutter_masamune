part of masamune.variable;

/// FormConfig for using Slider.
@immutable
class RatingFormConfig extends VariableFormConfig<num>
    with VariableFormConfigUtilMixin<num> {
  const RatingFormConfig({
    required this.min,
    required this.max,
    this.count,
    this.backgroundColor,
    this.color,
    this.suffixLabel,
    this.icon,
  });

  final double min;
  final double max;
  final int? count;

  final String? suffixLabel;

  final Color? backgroundColor;

  final Color? color;

  final IconData? icon;

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
          color: color?.withOpacity(0.75),
          prefix: headlinePrefix(
            context: context,
            config: config,
            color: color,
          ),
        )
      else
        const Divid(),
      FormItemRating(
        controller: ref.useTextEditingController(
          config.id,
          data.get(config.id, config.value).toString(),
        ),
        min: min,
        max: max,
        count: count ?? 5,
        inaciveColor: backgroundColor,
        showLabel: true,
        format: "0.##${suffixLabel != null ? " " + suffixLabel! : ""}",
        icon: icon == null
            ? null
            : Icon(
                icon!,
                color: color,
              ),
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
