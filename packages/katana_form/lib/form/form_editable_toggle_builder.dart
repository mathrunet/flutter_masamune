part of '/katana_form.dart';

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
    super.key,
    required this.builder,
    this.padding,
    this.onToggle,
  });

  /// Field padding.
  ///
  /// フィールドのパディング。
  final EdgeInsetsGeometry? padding;

  /// Builder for the field.
  ///
  /// Make editable when [editable] is `true`.
  ///
  /// フィールド用のビルダー。
  ///
  /// [editable]が`true`のときに編集可能にします。
  final Widget Function(
      BuildContext context, bool editable, VoidCallback onToggle) builder;

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

class _FormEditableToggleBuilderState extends State<FormEditableToggleBuilder> {
  bool _editable = false;

  void _onSwitch() {
    setState(() {
      _editable = !_editable;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onToggle?.call(_editable);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: widget.builder(context, _editable, _onSwitch),
    );
  }
}
