part of '/katana_form.dart';

/// Combined with [FormTextField], it can be used to control the visibility of passwords.
///
/// Pass [FormTextField] etc. to [builder] and pass [IconButton] etc. to [switcherBuilder].
///
/// [FormTextField]と組み合わせることで、パスワードの可視化の制御を行うことができます。
///
/// [builder]に[FormTextField]などを渡し、[switcherBuilder]には[IconButton]などを渡してください。
class FormPasswordVisible extends StatefulWidget {
  /// Combined with [FormTextField], it can be used to control the visibility of passwords.
  ///
  /// Pass [FormTextField] etc. to [builder] and pass [IconButton] etc. to [switcherBuilder].
  ///
  /// [FormTextField]と組み合わせることで、パスワードの可視化の制御を行うことができます。
  ///
  /// [builder]に[FormTextField]などを渡し、[switcherBuilder]には[IconButton]などを渡してください。
  const FormPasswordVisible({
    super.key,
    required this.builder,
    this.switcherBuilder,
    this.padding,
  });

  /// Text field padding.
  ///
  /// テキストフィールドのパディング。
  final EdgeInsetsGeometry? padding;

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
  State<StatefulWidget> createState() => _FormPasswordVisibleState();
}

class _FormPasswordVisibleState extends State<FormPasswordVisible> {
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
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(
            !_obscure ? Icons.visibility : Icons.visibility_off,
          ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: widget.padding ?? EdgeInsets.zero,
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
