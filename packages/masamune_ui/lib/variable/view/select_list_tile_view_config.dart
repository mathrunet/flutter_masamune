part of masamune_ui.variable;

class SelectListTileViewConfig extends VariableViewConfig<String> {
  const SelectListTileViewConfig({
    required this.items,
  });

  final Map<String, String> items;

  @override
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<String> config,
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
        title: Text(items[data.get(config.id, config.value)] ?? ""),
      ),
    ];
  }
}
