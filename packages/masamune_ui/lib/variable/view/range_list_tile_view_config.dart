part of masamune_ui.variable;

class RangeListTileViewConfig<T> extends VariableViewConfig<T> {
  const RangeListTileViewConfig({
    this.minKey = "min",
    this.maxKey = "max",
  });

  final String minKey;
  final String maxKey;

  @override
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<T> config,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final map = data.getAsMap(config.id, <String, dynamic>{});
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      ListItem(
        title: UIText(
          "${map.get(minKey, config.value)} ～ ${map.get(maxKey, config.value)}",
        ),
      ),
    ];
  }
}
