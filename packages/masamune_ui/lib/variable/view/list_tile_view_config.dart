part of masamune_ui.variable;

class ListTileViewConfig<T> extends VariableViewConfig<T> {
  const ListTileViewConfig({
    this.prefixLabel,
    this.suffixLabel,
  });

  final String? prefixLabel;
  final String? suffixLabel;

  @override
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<T> config,
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
        leading: prefixLabel.isEmpty ? null : Text(prefixLabel!.localize()),
        title: UIText(data.get(config.id, config.value).toString()),
        trailing: suffixLabel.isEmpty ? null : Text(suffixLabel!.localize()),
      ),
    ];
  }
}
