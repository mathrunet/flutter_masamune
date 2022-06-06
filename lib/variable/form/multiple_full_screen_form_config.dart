part of masamune.variable;

/// FormConfig for using multiple Fullscreen List.
@immutable
class MultipleFullScreenFormConfig extends VariableFormConfig<List<DynamicMap>>
    with VariableFormConfigUtilMixin<List<DynamicMap>> {
  const MultipleFullScreenFormConfig({
    required this.path,
    this.child = const MultipleFullscreenFormItem(),
    this.backgroundColor,
    this.color,
    this.minItems,
  });

  final String path;

  final ValueWidget<MultipleFullscreenFormValue> child;

  final Color? backgroundColor;

  final Color? color;

  final int? minItems;

  @override
  Iterable<Widget> build({
    required VariableConfig<List<DynamicMap>> config,
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
      FormItemMultipleFullScreen(
        path: path,
        minItems: minItems,
        color: color,
        hintText: "Input %s".localize().format([config.label.localize()]),
        errorText: "No input %s".localize().format([config.label.localize()]),
        builder: (context, item, index, onEdit, onDelete) {
          return ValueProvider(
            value: MultipleFullscreenFormValue._(
              onEdit: onEdit,
              onDelete: onDelete,
              value: item,
            ),
            child: child,
          );
        },
        controller: ref.useTextEditingController(
          config.id,
          jsonEncode(data.getAsList(config.id, config.value)),
        ),
        onSaved: (value) {
          context[config.id] = List<DynamicMap>.from(value ?? [])
            ..removeWhere((e) => e.isEmpty);
        },
      ),
    ];
  }

  @override
  List<DynamicMap>? value({
    required VariableConfig<List<DynamicMap>> config,
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    return context.getAsList(config.id, config.value);
  }
}

@immutable
class MultipleFullscreenFormValue {
  const MultipleFullscreenFormValue._({
    required this.onEdit,
    required this.onDelete,
    required this.value,
  });

  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final DynamicMap value;
}

class MultipleFullscreenFormItem
    extends ValueWidget<MultipleFullscreenFormValue> {
  const MultipleFullscreenFormItem({
    this.color,
  });

  final Color? color;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    MultipleFullscreenFormValue value,
  ) {
    final image =
        value.value.get(Const.image, value.value.get(Const.media, ""));
    final name = value.value.get(Const.name, "");
    return ListItem(
      leading: image.isEmpty
          ? null
          : CircleAvatar(
              backgroundImage: NetworkOrAsset.image(image),
            ),
      title: Text(name, style: TextStyle(color: color)),
      onTap: () {
        value.onEdit.call();
      },
      trailing: value.onDelete == null
          ? null
          : IconButton(
              onPressed: () {
                value.onDelete?.call();
              },
              icon: Icon(Icons.delete, color: color),
            ),
    );
  }
}
