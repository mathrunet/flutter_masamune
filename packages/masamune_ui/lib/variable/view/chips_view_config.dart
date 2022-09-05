part of masamune_ui.variable;

class ChipsViewConfig<T> extends VariableViewConfig<List<T>> {
  const ChipsViewConfig({
    this.chipColor,
    this.chipTextColor,
  });

  final Color? chipColor;

  final Color? chipTextColor;

  @override
  Iterable<Widget> build({
    required BuildContext context,
    required WidgetRef ref,
    required VariableConfig<List<T>> config,
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
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Wrap(
          children: data.getAsList(config.id, config.value).mapAndRemoveEmpty(
            (value) {
              return Chip(
                label: Text(
                  value.toString(),
                  style: TextStyle(
                    color: chipTextColor ?? context.theme.textColorOnPrimary,
                  ),
                ),
                backgroundColor: chipColor ?? context.theme.primaryColor,
              );
            },
          ),
        ),
      ),
    ];
  }
}
