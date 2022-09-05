part of masamune_ui.variable;

class MultipleSelectListTileViewConfig
    extends VariableViewConfig<List<String>> {
  const MultipleSelectListTileViewConfig({
    required this.items,
  });

  final Map<String, String> items;

  @override
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<List<String>> config,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final list = data.getAsList(config.id, config.value);
    return [
      if (config.label.isNotEmpty)
        DividHeadline(
          config.label.localize(),
        )
      else
        const Divid(),
      if (list.isEmpty)
        const ListItem(title: Text("--"))
      else
        for (final key in list)
          ListItem(title: Text(items[key.toString()] ?? "")),
    ];
  }
}
