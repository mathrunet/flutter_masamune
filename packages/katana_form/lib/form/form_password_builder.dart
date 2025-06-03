part of "/katana_form.dart";

/// Combined with [FormTextField], it can be used to control the visibility of passwords.
///
/// Pass [FormTextField] etc. to [builder] and pass [IconButton] etc. to [switcherBuilder].
///
/// [FormTextField]と組み合わせることで、パスワードの可視化の制御を行うことができます。
///
/// [builder]に[FormTextField]などを渡し、[switcherBuilder]には[IconButton]などを渡してください。
class FormPasswordBuilder extends StatefulWidget {
  /// Combined with [FormTextField], it can be used to control the visibility of passwords.
  ///
  /// Pass [FormTextField] etc. to [builder] and pass [IconButton] etc. to [switcherBuilder].
  ///
  /// [FormTextField]と組み合わせることで、パスワードの可視化の制御を行うことができます。
  ///
  /// [builder]に[FormTextField]などを渡し、[switcherBuilder]には[IconButton]などを渡してください。
  const FormPasswordBuilder({
    required this.builder,
    super.key,
    this.switcherBuilder,
    this.padding,
    this.switchPadding,
    this.switchAlignment,
    this.switchColor,
    this.style,
  });

  /// Style for the password builder.
  ///
  /// パスワードビルダーのスタイル。
  final FormStyle? style;

  /// Text field padding.
  ///
  /// テキストフィールドのパディング。
  final EdgeInsetsGeometry? padding;

  /// Switch padding.
  ///
  /// スイッチのパディング。
  final EdgeInsetsGeometry? switchPadding;

  /// Switch location.
  ///
  /// スイッチの位置。
  final Alignment? switchAlignment;

  /// Switch color.
  ///
  /// スイッチの色。
  final Color? switchColor;

  /// Builder for text fields.
  ///
  /// Display the password when [obscure] is `false`.
  ///
  /// テキストフィールド用のビルダー。
  ///
  /// [obscure]が`false`のときにパスワードを表示します。
  final Widget Function(BuildContext context, bool obscure) builder;

  /// Builder for password visualization toggle switch.
  ///
  /// Display the password when [obscure] is `false`.
  ///
  /// Calling [onSwitch] inverts the value of [obscure].
  ///
  /// パスワード可視化のトグルスイッチのためのビルダー。
  ///
  /// [obscure]が`false`のときにパスワードを表示します。
  ///
  /// [onSwitch]を呼び出すと、[obscure]の値が反転します。
  final Widget Function(
          BuildContext context, bool obscure, VoidCallback onSwitch)?
      switcherBuilder;

  @override
  State<StatefulWidget> createState() => _FormPasswordBuilderState();
}

class _FormPasswordBuilderState extends State<FormPasswordBuilder> {
  bool _obscure = true;

  void _onSwitch() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  Widget _buildSwitcher(BuildContext context) {
    return Positioned.fill(
      right: 16,
      child: Align(
        alignment: widget.switchAlignment ??
            widget.style?.alignment ??
            Alignment.centerRight,
        child: Padding(
          padding: widget.switchPadding ??
              widget.style?.contentPadding ??
              EdgeInsets.zero,
          child: IconButton(
            icon: Icon(
              !_obscure ? Icons.visibility : Icons.visibility_off,
            ),
            color: widget.switchColor ?? widget.style?.color,
            onPressed: _onSwitch,
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            padding: const EdgeInsets.only(top: 16),
            constraints: const BoxConstraints(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: widget.padding ?? widget.style?.padding ?? EdgeInsets.zero,
          child: widget.builder(context, _obscure),
        ),
        widget.switcherBuilder?.call(
              context,
              _obscure,
              _onSwitch,
            ) ??
            _buildSwitcher(context)
      ],
    );
  }
}
