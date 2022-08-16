part of masamune.variable;

/// FormConfig for using Selevtive icon.
@immutable
class SelectiveIconFormConfig extends VariableFormConfig<String>
    with VariableFormConfigUtilMixin<String> {
  const SelectiveIconFormConfig({
    required this.items,
    this.backgroundColor,
    this.color,
  });

  final Map<String, dynamic> items;

  final Color? backgroundColor;

  final Color? color;

  @override
  Iterable<Widget> build({
    required VariableConfig<String> config,
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
      FormItemSelectiveIconBuilder(
        controller: ref.useTextEditingController(
          config.id,
          data.get(config.id, config.value),
        ),
        items: items.map((key, value) => MapEntry(key, Icon(value))),
        builder: (context, items, selected, onSelect) {
          return items.toList((key, value) {
            return IconButton(
              padding: const EdgeInsets.all(0),
              visualDensity: VisualDensity.compact,
              onPressed: selected == key
                  ? null
                  : () {
                      onSelect(key);
                    },
              icon: _toIconWidget(value),
              color: selected == key
                  ? (color ?? context.theme.primaryColor)
                  : (backgroundColor ?? context.theme.disabledColor),
            );
          }).toList();
        },
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
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

  Widget _toIconWidget(dynamic value) {
    if (value is Widget) {
      return value;
    } else if (value is String) {
      return Image(image: Asset.image(value));
    } else if (value is IconData) {
      return Icon(value);
    }
    return const Empty();
  }

  @override
  String? value({
    required VariableConfig<String> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.get(config.id, config.value);
  }
}
