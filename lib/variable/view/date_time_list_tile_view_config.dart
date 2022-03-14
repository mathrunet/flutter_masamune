part of masamune.variable;

class DateTimeListTileViewConfig extends VariableViewConfig<int> {
  const DateTimeListTileViewConfig({
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
          initialValue != null ? _tryParseFromDateTime(initialValue) : "",
        ),
      ),
    ];
  }

  DateTime? __value(
    VariableConfig<int> config,
    DynamicMap? data,
  ) {
    if (data.containsKey(config.id)) {
      return data.getAsDateTime(config.id);
    }
    if (initialDate.isEmpty) {
      return null;
    }
    return FormItemDateTimeField.tryParseFromDate(initialDate!);
  }

  String _tryParseFromDateTime(DateTime dateTime) {
    switch (type) {
      case DateTimeFormConfigType.date:
        return FormItemDateTimeField.formatDate(
            dateTime.millisecondsSinceEpoch);
      case DateTimeFormConfigType.time:
        return FormItemDateTimeField.formatTime(
            dateTime.millisecondsSinceEpoch);
      default:
        return FormItemDateTimeField.formatDateTime(
            dateTime.millisecondsSinceEpoch);
    }
  }
}
