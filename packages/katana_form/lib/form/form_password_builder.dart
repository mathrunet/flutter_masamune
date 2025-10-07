part of "/katana_form.dart";

/// Combined with [FormTextField], it can be used to control the visibility of passwords.
///
/// A form builder that can toggle whether to hide password input content.
/// Common design can be applied with `FormStyle`, and password state management can be performed using `FormController`.
/// It provides features such as password show/hide toggle and a toggle switch for display switching.
///
/// パスワード入力時の内容を隠すかどうかを切り替えることができるフォームビルダー。
/// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでパスワードの状態管理を行えます。
/// パスワードの表示/非表示切り替え、および表示切替のトグルスイッチの機能を備えています。
///
/// ## Builder Usage ビルダーの使用方法
///
/// Pass [FormTextField] etc. to [builder] and pass [IconButton] etc. to [switcherBuilder].
///
/// [builder]に[FormTextField]などを渡し、[switcherBuilder]には[IconButton]などを渡してください。
///
/// ## Basic Usage Example 基本的な使用例
///
/// ```dart
/// FormPasswordBuilder(
///   builder: (context, obscure) {
///     return FormTextField(
///       form: formController,
///       initialValue: formController.value.password,
///       obscureText: obscure,
///       onSaved: (value) => formController.value.copyWith(password: value),
///     );
///   },
/// );
/// ```
///
/// ## Custom Toggle Switch Usage Example カスタムトグルスイッチの使用例
///
/// ```dart
/// FormPasswordBuilder(
///   builder: (context, obscure) {
///     return FormTextField(
///       form: formController,
///       initialValue: formController.value.password,
///       obscureText: obscure,
///       onSaved: (value) => formController.value.copyWith(password: value),
///     );
///   },
///   switchBuilder: (context, obscure, onSwitch) {
///     return Positioned.fill(
///       right: 16,
///       child: Align(
///         alignment: Alignment.centerRight,
///         child: IconButton(
///           icon: Icon(
///             obscure ? Icons.visibility : Icons.visibility_off,
///           ),
///           onPressed: onSwitch,
///           color: Colors.blue,
///         ),
///       ),
///     );
///   },
/// );
/// ```
class FormPasswordBuilder extends StatefulWidget {
  /// Combined with [FormTextField], it can be used to control the visibility of passwords.
  ///
  /// A form builder that can toggle whether to hide password input content.
  /// Common design can be applied with `FormStyle`, and password state management can be performed using `FormController`.
  /// It provides features such as password show/hide toggle and a toggle switch for display switching.
  ///
  /// パスワード入力時の内容を隠すかどうかを切り替えることができるフォームビルダー。
  /// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでパスワードの状態管理を行えます。
  /// パスワードの表示/非表示切り替え、および表示切替のトグルスイッチの機能を備えています。
  ///
  /// ## Builder Usage ビルダーの使用方法
  ///
  /// Pass [FormTextField] etc. to [builder] and pass [IconButton] etc. to [switcherBuilder].
  ///
  /// [builder]に[FormTextField]などを渡し、[switcherBuilder]には[IconButton]などを渡してください。
  ///
  /// ## Basic Usage Example 基本的な使用例
  ///
  /// ```dart
  /// FormPasswordBuilder(
  ///   builder: (context, obscure) {
  ///     return FormTextField(
  ///       form: formController,
  ///       initialValue: formController.value.password,
  ///       obscureText: obscure,
  ///       onSaved: (value) => formController.value.copyWith(password: value),
  ///     );
  ///   },
  /// );
  /// ```
  ///
  /// ## Custom Toggle Switch Usage Example カスタムトグルスイッチの使用例
  ///
  /// ```dart
  /// FormPasswordBuilder(
  ///   builder: (context, obscure) {
  ///     return FormTextField(
  ///       form: formController,
  ///       initialValue: formController.value.password,
  ///       obscureText: obscure,
  ///       onSaved: (value) => formController.value.copyWith(password: value),
  ///     );
  ///   },
  ///   switchBuilder: (context, obscure, onSwitch) {
  ///     return Positioned.fill(
  ///       right: 16,
  ///       child: Align(
  ///         alignment: Alignment.centerRight,
  ///         child: IconButton(
  ///           icon: Icon(
  ///             obscure ? Icons.visibility : Icons.visibility_off,
  ///           ),
  ///           onPressed: onSwitch,
  ///           color: Colors.blue,
  ///         ),
  ///       ),
  ///     );
  ///   },
  /// );
  /// ```
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
