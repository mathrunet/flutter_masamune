part of "/katana_form.dart";

/// Combined with [FormTextField], it can be used to control whether or not editing is allowed.
///
/// Pass [FormTextField], etc. to [builder].
///
/// [FormTextField]と組み合わせることで、編集の可否の制御を行うことができます。
///
/// [builder]に[FormTextField]などを渡してください。
class FormEditableToggleBuilder extends StatefulWidget {
  /// Combined with [FormTextField], it can be used to control whether or not editing is allowed.
  ///
  /// Pass [FormTextField], etc. to [builder].
  ///
  /// [FormTextField]と組み合わせることで、編集の可否の制御を行うことができます。
  ///
  /// [builder]に[FormTextField]などを渡してください。
  const FormEditableToggleBuilder({
    required this.builder,
    super.key,
    this.style,
    this.onToggle,
    this.editableOnInit = false,
  });

  /// Initial editable. `true` means editable.
  ///
  /// 初期編集状態。`true`の場合は初期表示時に編集可能。
  final bool editableOnInit;

  /// Field style.
  ///
  /// フィールドのスタイル。
  final FormStyle? style;

  /// Builder for the field.
  ///
  /// Make editable when [editable] is `true`.
  ///
  /// フィールド用のビルダー。
  ///
  /// [editable]が`true`のときに編集可能にします。
  final Widget Function(BuildContext context, FormEditableToggleBuilderRef ref)
      builder;

  /// Callback if toggled.
  ///
  /// When [editable] is `true`, it is editable.
  ///
  /// トグルされた場合のコールバック。
  ///
  /// [editable]が`true`のときは編集可能な時。
  final void Function(bool editable)? onToggle;

  @override
  State<StatefulWidget> createState() => _FormEditableToggleBuilderState();
}

class _FormEditableToggleBuilderState extends State<FormEditableToggleBuilder>
    implements FormEditableToggleBuilderRef {
  @override
  void initState() {
    super.initState();
    _editable = widget.editableOnInit;
  }

  @override
  bool get editable => _editable;
  bool _editable = false;

  @override
  void toggle() {
    setState(() {
      _editable = !_editable;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onToggle?.call(_editable);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.style == null) {
      return widget.builder(context, this);
    }
    return FormContainer(
      style: widget.style,
      child: widget.builder(context, this),
    );
  }
}

/// Reference for [FormEditableToggleBuilder].
///
/// [FormEditableToggleBuilder]の参照。
abstract class FormEditableToggleBuilderRef {
  /// Whether or not editing is allowed. `true` means editable.
  ///
  /// 編集の可否。`true`の場合は編集可能。
  bool get editable;

  /// Toggle editing.
  ///
  /// 編集の可否を切り替えます。
  void toggle();
}
