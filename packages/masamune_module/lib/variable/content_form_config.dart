part of masamune_module;

const _kQuillToolbarHeight = 80;

/// FormConfig for using TextField.
@immutable
class ContentFormConfig extends VariableFormConfig<String> {
  const ContentFormConfig({
    this.color,
    this.subColor,
    this.backgroundColor,
    this.toolbarColor,
    this.type = PostEditingType.planeText,
  });

  final Color? subColor;

  final PostEditingType type;
  final Color? backgroundColor;

  final Color? color;

  final Color? toolbarColor;

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
          prefix: config.required
              ? IconTheme(
                  data: const IconThemeData(size: 16),
                  child: context.theme.widget.requiredIcon,
                )
              : null,
        )
      else
        const Divid(),
      ..._buildForm(
        config: config,
        context: context,
        ref: ref,
        data: data,
        onlyRequired: onlyRequired,
      ),
    ];
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

  List<Widget> _buildForm({
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
          Theme(
            data: context.theme.copyWith(
              canvasColor:
                  toolbarColor ?? context.theme.scaffoldBackgroundColor,
            ),
            child: QuillToolbar.basic(
              controller: controller,
              toolbarIconSize: 24,
              multiRowsDisplay: false,
              embedButtons: FlutterQuillEmbeds.buttons(
                showVideoButton: false,
                onImagePickCallback: (file) async {
                  if (file.path.isEmpty || !file.existsSync()) {
                    return "";
                  }
                  return await context.model!.uploadMedia(file.path);
                },
                onVideoPickCallback: (file) async {
                  if (file.path.isEmpty || !file.existsSync()) {
                    return "";
                  }
                  return await context.model!.uploadMedia(file.path);
                },
                filePickImpl: (context) async {
                  final media = await context.platform?.mediaDialog(
                    context,
                    title: "Select %s".localize().format(
                      ["Image".localize()],
                    ),
                  );
                  return media?.path;
                },
              ),
            ),
          ),
          Divid(color: context.theme.dividerColor.withOpacity(0.25)),
          Container(
            color: backgroundColor,
            height: (context.mediaQuery.size.height -
                    context.mediaQuery.viewInsets.bottom -
                    kToolbarHeight -
                    _kQuillToolbarHeight)
                .limitLow(0),
            child: QuillEditor(
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: ref.useFocusNode(
                hookId: "${config.id}FocusNode",
                autoFocus: false,
              ),
              autoFocus: false,
              controller: controller,
              placeholder:
                  "Input %s".localize().format([config.label.localize()]),
              readOnly: false,
              expands: true,
              padding: const EdgeInsets.all(12),
              customStyles: DefaultStyles(
                color: color,
                placeHolder: DefaultTextBlockStyle(
                  TextStyle(
                    color: subColor ?? context.theme.disabledColor,
                    fontSize: 16,
                  ),
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
          SizedBox(
            height: (context.mediaQuery.size.height -
                    context.mediaQuery.viewInsets.bottom -
                    kToolbarHeight -
                    _kQuillToolbarHeight)
                .limitLow(0),
            child: FormItemTextField(
              dense: true,
              expands: true,
              backgroundColor: backgroundColor,
              color: color,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              hintText: "Input %s".localize().format([config.label.localize()]),
              errorText:
                  "No input %s".localize().format([config.label.localize()]),
              subColor: subColor ?? context.theme.disabledColor,
              controller: ref.useTextEditingController(
                hookId: config.id,
                defaultValue: text,
              ),
              onSaved: (value) {
                context[config.id] = value;
              },
            ),
          ),
        ];
    }
  }
}
