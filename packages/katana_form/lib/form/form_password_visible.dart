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
    this.padding = const EdgeInsets.only(right: 16),
  });

  /// Text field padding.
  ///
  /// テキストフィールドのパディング。
  final EdgeInsetsGeometry padding;

  /// Builder for text fields.
  ///
  /// Display the password when [visible] is `true`.
  ///
  /// テキストフィールド用のビルダー。
  ///
  /// [visible]が`true`のときにパスワードを表示します。
  final Widget Function(BuildContext context, bool visible) builder;

  /// Builder for password visualization toggle switch.
  ///
  /// Display the password when [visible] is `true`.
  ///
  /// Calling [onSwitch] inverts the value of [visible].
  ///
  /// パスワード可視化のトグルスイッチのためのビルダー。
  ///
  /// [visible]が`true`のときにパスワードを表示します。
  ///
  /// [onSwitch]を呼び出すと、[visible]の値が反転します。
  final Widget Function(
          BuildContext context, bool visible, VoidCallback onSwitch)?
      switcherBuilder;

  @override
  State<StatefulWidget> createState() => _FormPasswordVisibleState();
}

class _FormPasswordVisibleState extends State<FormPasswordVisible> {
  bool _visible = false;

  void _onSwitch() {
    setState(() {
      _visible = !_visible;
    });
  }

  Widget _buildSwitcher(BuildContext context) {
    return Positioned.fill(
      right: 16,
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(
            _visible ? Icons.visibility : Icons.visibility_off,
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
          padding: widget.padding,
          child: widget.builder(context, !_visible),
        ),
        widget.switcherBuilder?.call(
              context,
              !_visible,
              _onSwitch,
            ) ??
            _buildSwitcher(context)
      ],
    );
  }
}
