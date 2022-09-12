part of masamune_module;

class ContentViewConfig extends VariableViewConfig<String> {
  const ContentViewConfig({
    this.color,
    this.backgroundColor,
    this.type = PostEditingType.planeText,
  });

  final PostEditingType type;
  final Color? backgroundColor;

  final Color? color;
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
      ..._buildView(
        config: config,
        context: context,
        ref: ref,
        data: data,
        onlyRequired: onlyRequired,
      ),
    ];
  }

  List<Widget> _buildView({
    required VariableConfig<String> config,
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    final text = data.get(config.id, config.value);

    switch (type) {
      case PostEditingType.wysiwyg:
        final controller = ref.cache(
          hookId: config.id,
          () => text.isEmpty
              ? QuillController.basic()
              : QuillController(
                  document: Document.fromJson(jsonDecode(text)),
                  selection: const TextSelection.collapsed(offset: 0),
                ),
          keys: [text],
        );

        return [
          Container(
            color: backgroundColor,
            child: QuillEditor(
              scrollController: ScrollController(),
              scrollable: false,
              focusNode: ref.useFocusNode(
                hookId: "${config.id}FocusNode",
                autoFocus: false,
              ),
              autoFocus: false,
              controller: controller,
              placeholder: "",
              readOnly: true,
              expands: false,
              padding: EdgeInsets.zero,
              customStyles: DefaultStyles(
                color: color,
                placeHolder: DefaultTextBlockStyle(
                  TextStyle(color: context.theme.disabledColor, fontSize: 16),
                  const Tuple2(16, 0),
                  const Tuple2(0, 0),
                  null,
                ),
              ),
            ),
          ),
        ];
      default:
        return [
          Container(
            color: backgroundColor,
            child: UIMarkdown(
              text,
              fontSize: 16,
              color: color,
              onTapLink: (url) {
                ref.open(url);
              },
            ),
          ),
        ];
    }
  }
}
