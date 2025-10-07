part of "/katana_form.dart";

/// Builder to hold and provide [TextEditingController].
///
/// TextEditingControllerを提供するビルダー。
/// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでテキスト入力の状態管理を行えます。
///
/// ## ビルダーの使用方法
///
/// Pass [FormTextField], etc. to [builder].
///
/// [builder]に[FormTextField]などを渡してください。
///
/// The [TextEditingController] is passed to the builder's [controller] parameter.
///
/// ビルダーの[controller]パラメータに[TextEditingController]が渡されます。
///
/// ## 基本的な使用例
///
/// ```dart
/// FormTextEditingControllerBuilder(
///   builder: (context, controller) {
///     return FormTextField(
///       form: formController,
///       controller: controller,
///       onSaved: (value) => formController.value.copyWith(text: value),
///     );
///   },
/// );
/// ```
///
/// ## カスタムデザインの使用例
///
/// ```dart
/// FormTextEditingControllerBuilder(
///   style: const FormStyle(
///     padding: EdgeInsets.all(16.0),
///   ),
///   builder: (context, controller) {
///     return FormTextField(
///       form: form,
///       controller: controller,
///       onSaved: (value) => form.value.copyWith(text: value),
///     );
///   },
/// );
/// ```
class FormTextEditingControllerBuilder extends StatefulWidget {
  /// Builder to hold and provide [TextEditingController].
  ///
  /// TextEditingControllerを提供するビルダー。
  /// `FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでテキスト入力の状態管理を行えます。
  ///
  /// ## ビルダーの使用方法
  ///
  /// Pass [FormTextField], etc. to [builder].
  ///
  /// [builder]に[FormTextField]などを渡してください。
  ///
  /// The [TextEditingController] is passed to the builder's [controller] parameter.
  ///
  /// ビルダーの[controller]パラメータに[TextEditingController]が渡されます。
  ///
  /// ## 基本的な使用例
  ///
  /// ```dart
  /// FormTextEditingControllerBuilder(
  ///   builder: (context, controller) {
  ///     return FormTextField(
  ///       form: formController,
  ///       controller: controller,
  ///       onSaved: (value) => formController.value.copyWith(text: value),
  ///     );
  ///   },
  /// );
  /// ```
  ///
  /// ## カスタムデザインの使用例
  ///
  /// ```dart
  /// FormTextEditingControllerBuilder(
  ///   style: const FormStyle(
  ///     padding: EdgeInsets.all(16.0),
  ///   ),
  ///   builder: (context, controller) {
  ///     return FormTextField(
  ///       form: form,
  ///       controller: controller,
  ///       onSaved: (value) => form.value.copyWith(text: value),
  ///     );
  ///   },
  /// );
  /// ```
  const FormTextEditingControllerBuilder({
    required this.builder,
    super.key,
    this.controller,
    this.style,
  });

  /// Builder for the field.
  ///
  /// [TextEditingController] is passed to [controller].
  ///
  /// フィールド用のビルダー。
  ///
  /// [controller]に[TextEditingController]が渡されます。
  final Widget Function(BuildContext context, TextEditingController controller)
      builder;

  /// Controller to be passed by default.
  ///
  /// If this is specified, this controller will be used.
  ///
  /// デフォルトで渡すコントローラー。
  ///
  /// こちらを指定するとこのコントローラーが使われます。
  final TextEditingController? controller;

  /// Field style.
  ///
  /// フィールドのスタイル。
  final FormStyle? style;

  @override
  State<StatefulWidget> createState() =>
      _FormTextEditingControllerBuilderState();
}

class _FormTextEditingControllerBuilderState
    extends State<FormTextEditingControllerBuilder> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController {
    if (widget.controller != null) {
      return widget.controller!;
    }
    return _controller ??= TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    _effectiveController.addListener(_onHandledUpdate);
  }

  @override
  void didUpdateWidget(FormTextEditingControllerBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller?.removeListener(_onHandledUpdate);
      oldWidget.controller?.removeListener(_onHandledUpdate);
      _effectiveController.addListener(_onHandledUpdate);
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onHandledUpdate);
    super.dispose();
  }

  void _onHandledUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.style == null) {
      return widget.builder(context, _effectiveController);
    }
    return FormContainer(
      style: widget.style,
      child: widget.builder(context, _effectiveController),
    );
  }
}
