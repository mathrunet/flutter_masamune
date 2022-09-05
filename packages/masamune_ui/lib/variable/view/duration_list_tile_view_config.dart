part of masamune_ui.variable;

class DurationListTileViewConfig extends VariableViewConfig<int> {
  const DurationListTileViewConfig({
    this.initialDate,
    this.type = DateTimeFormConfigType.dateTime,
  });

  final String? initialDate;

  final DateTimeFormConfigType type;

  @override
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<int> config,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final initialValue = __value(config, data);
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      ListItem(
        title: Text(
          FormItemDurationField.tryFormat(initialValue?.inMilliseconds ?? 0),
        ),
      ),
    ];
  }

  Duration? __value(
    VariableConfig<int> config,
    DynamicMap? data,
  ) {
    if (data.containsKey(config.id)) {
      return Duration(milliseconds: data.get(config.id, 0));
    }
    return Duration(milliseconds: config.value);
  }
}
