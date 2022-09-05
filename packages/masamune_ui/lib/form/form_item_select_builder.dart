part of masamune_ui.form;

class FormItemSelectBuilder extends FormField<String> {
  FormItemSelectBuilder({
    required List<Widget> Function(
      BuildContext context,
      Map<String, String> items,
      String selected,
      void Function(String value) onSelect,
    )
        builder,
    this.labelText,
    String? initialValue,
    this.hintText,
    this.controller,
    this.header,
    this.footer,
    required this.items,
    this.onPressed,
    this.space = 8.0,
    Key? key,
    void Function(String? value)? onSaved,
    String? Function(String? value)? validator,
    bool enabled = true,
  })  : _builder = builder,
        super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: validator,
          initialValue: controller != null ? controller.text : initialValue,
          enabled: enabled,
        );

  final Map<String, String> items;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? header;
  final Widget? footer;
  final double space;
  final List<Widget> Function(
    BuildContext context,
    Map<String, String> items,
    String selected,
    void Function(String value) onSelect,
  ) _builder;
  final void Function(
    void Function(dynamic fileOrURL, AssetType type) onUpdate,
  )? onPressed;

  @override
  _FormItemSelectBuilderState createState() => _FormItemSelectBuilderState();
}

class _FormItemSelectBuilderState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemSelectBuilder get widget => super.widget as FormItemSelectBuilder;

  @override
  void didUpdateWidget(FormItemSelectBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_effectiveController?.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    setValue(_effectiveController?.text);
  }

  void _onSelect(String value) {
    if (this.value != value) {
      didChange(value);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText.isNotEmpty)
            Text(widget.labelText!, style: context.theme.textTheme.caption),
          if (widget.header != null) ...[
            Space(height: widget.space),
            widget.header!,
          ],
          Space(height: widget.space),
          ...widget
              ._builder(context, widget.items, value ?? "", _onSelect)
              .insertEvery(Space(height: widget.space), 1),
          if (widget.footer != null) ...[
            Space(height: widget.space),
            widget.footer!,
          ]
        ],
      ),
    );
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (_effectiveController?.text != value) {
      _effectiveController?.text = value ?? "";
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController?.text = widget.initialValue ?? "";
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != value)
      didChange(_effectiveController?.text);
  }
}

// class FormItemSelectItem extends StatelessWidget {
//   const FormItemSelectItem({
//     required this.id,
//     this.selected = false,
//     required this.onSelect,
//     required this.label,
//     this.selectedBackgroundColor,
//     this.selectedColor,
//     this.selectedIcon,
//     this.icon,
//     this.padding = const EdgeInsets.all(10),
//     this.child,
//   });

//   final void Function(String value) onSelect;
//   final bool selected;
//   final String id;
//   final String label;
//   final Color? selectedBackgroundColor;
//   final Color? selectedColor;
//   final EdgeInsetsGeometry padding;
//   final IconData? selectedIcon;
//   final IconData? icon;
//   final Widget? child;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         onSelect(id);
//       },
//       child: Container(
//         padding: padding,
//         decoration: BoxDecoration(
//           color: selected
//               ? (selectedBackgroundColor ?? context.theme.primaryColor)
//               : null,
//           border: Border.all(
//             color: selected ? Colors.transparent : context.theme.dividerColor,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(6.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(
//               selected
//                   ? (selectedIcon ?? FontAwesomeIcons.circleCheck)
//                   : (icon ?? FontAwesomeIcons.circle),
//               color: selected
//                   ? (selectedColor ?? context.theme.textColorOnPrimary)
//                   : context.theme.disabledColor,
//             ),
//             const Space.width(10),
//             Expanded(
//               child: child ??
//                   Text(
//                     label,
//                     style: TextStyle(
//                       color: selected
//                           ? (selectedColor ?? context.theme.textColorOnPrimary)
//                           : null,
//                       fontWeight: selected ? FontWeight.bold : null,
//                     ),
//                   ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
