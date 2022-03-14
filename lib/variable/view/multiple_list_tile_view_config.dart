part of masamune.variable;

class MultipleListTileViewConfig<T> extends VariableViewConfig<List<T>> {
  const MultipleListTileViewConfig();

  @override
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<List<T>> config,
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
        for (final key in list) ListItem(title: Text(key.toString()))
    ];
  }
}
