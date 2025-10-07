part of "/katana_form.dart";

/// Combined with [FormTextField], it can be used to control whether or not editing is allowed.
///
/// 編集モードと表示モードを切り替えられるフォームビルダー。
/// `FormController`の状態に応じて、編集可能なフォームと読み取り専用の表示を切り替えることができます。
/// 編集・保存・キャンセルなどの機能を備えています。
///
/// ## ビルダーの使用方法
///
/// Pass [FormTextField], etc. to [builder].
///
/// [builder]に[FormTextField]などを渡してください。
///
/// The [ref.editable] property can be used to get the current editing state.
///
/// [ref.editable]プロパティで現在の編集状態を取得できます。
///
/// The [ref.toggle] method can be used to toggle the editing state.
///
/// [ref.toggle]メソッドで編集状態を切り替えることができます。
///
/// ## 基本的な使用例
///
/// ```dart
/// FormEditableToggleBuilder(
///   builder: (context, ref) {
///     return Column(
///       children: [
///         if (ref.editable)
///           FormTextField(
///             form: form,
///             initialValue: form.value.text,
///             onSaved: (value) => form.value.copyWith(text: value),
///           )
///         else
///           Text(form.value.text),
///         FormButton(
///           label: ref.editable ? "保存" : "編集",
///           onPressed: () {
///             if (ref.editable) {
///               final value = form.validate();
///               if (value == null) {
///                 return;
///               }
///               final document = appRef.model(AnyModel.collection()).create();
///               await document.save(value);
///               // 表示モードへ切り替え
///               ref.toggle();
///             } else {
///               // 編集モードへ切り替え
///               ref.toggle();
///             }
///           },
///         ),
///       ],
///     );
///   },
/// );
/// ```
class FormEditableToggleBuilder extends StatefulWidget {
  /// Combined with [FormTextField], it can be used to control whether or not editing is allowed.
  ///
  /// 編集モードと表示モードを切り替えられるフォームビルダー。
  /// `FormController`の状態に応じて、編集可能なフォームと読み取り専用の表示を切り替えることができます。
  /// 編集・保存・キャンセルなどの機能を備えています。
  ///
  /// ## ビルダーの使用方法
  ///
  /// Pass [FormTextField], etc. to [builder].
  ///
  /// [builder]に[FormTextField]などを渡してください。
  ///
  /// The [ref.editable] property can be used to get the current editing state.
  ///
  /// [ref.editable]プロパティで現在の編集状態を取得できます。
  ///
  /// The [ref.toggle] method can be used to toggle the editing state.
  ///
  /// [ref.toggle]メソッドで編集状態を切り替えることができます。
  ///
  /// ## 基本的な使用例
  ///
  /// ```dart
  /// FormEditableToggleBuilder(
  ///   builder: (context, ref) {
  ///     return Column(
  ///       children: [
  ///         if (ref.editable)
  ///           FormTextField(
  ///             form: form,
  ///             initialValue: form.value.text,
  ///             onSaved: (value) => form.value.copyWith(text: value),
  ///           )
  ///         else
  ///           Text(form.value.text),
  ///         FormButton(
  ///           label: ref.editable ? "保存" : "編集",
  ///           onPressed: () {
  ///             if (ref.editable) {
  ///               final value = form.validate();
  ///               if (value == null) {
  ///                 return;
  ///               }
  ///               final document = appRef.model(AnyModel.collection()).create();
  ///               await document.save(value);
  ///               // 表示モードへ切り替え
  ///               ref.toggle();
  ///             } else {
  ///               // 編集モードへ切り替え
  ///               ref.toggle();
  ///             }
  ///           },
  ///         ),
  ///       ],
  ///     );
  ///   },
  /// );
  /// ```
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
