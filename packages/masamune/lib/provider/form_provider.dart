part of masamune;

// ignore: subtype_of_sealed_class
/// Provider to use `FormContext` to help with form entry.
/// フォームでの入力を手助けするための`FormContext`を利用するためのプロバイダーです。
///
/// You can get the key of the form with `key` and validate and save the form with the `validate` method.
/// `key`でフォームのキーを取得でき、`validate`メソッドでフォームのバリデーションとSaveを行うことができます。
///
/// For each value given in the `onSaved` callback of each form, save the data in the `value`.
/// 各フォームの`onSaved`コールバックで与えられた値に対し、`value`にデータを保存していってください。
///
/// Then process the data for the `value` after the process that executed the `validate`.
/// その後`validate`を実行した処理の後に`value`に対するデータを処理してください。
///
/// ```dart
/// fianl formProvider = FormProvider(<String, dynamic>{});
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final form = ref.watch(formProvider);
///
///     return Form(
///       key: form.key,
///       child: ListView(
///         children: [
///           FormItemTextField(
///             hintText: "Input ID",
///             onSaved: (text) {
///               form.value["id"] = text;
///             }
///           ),
///           FormItemButton(
///             "SUBMIT"
///             onPressed: () {
///               if(!form.validate(context)){
///                 return;
///               }
///               final id = form.value.get("id", "");
///               // Save process
///             }
///           )
///         ]
///       )
///     );
///   }
/// }
/// ```
class FormProvider<T>
    extends AutoDisposeChangeNotifierProvider<_FormContext<T>> {
  FormProvider(T value)
      : super((ref) {
          return _FormContext(value);
        });
}

/// This is the context in which the form is managed.
/// フォームの管理を行うコンテキストです。
///
/// It inherits from [ValueNotifier] and can store the contents entered in the form by replacing the value of [value].
/// [ValueNotifier]を継承しており[value]の値を入れ替えることでフォームに入力された中身を保存できます。
class _FormContext<T> extends ValueNotifier<T> {
  _FormContext(super.value);

  /// Global key for forms.
  /// フォーム用のグローバルキー。
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  /// Validate the form.
  /// フォームのバリデーションを行います。
  ///
  /// A return of `true` indicates that the form value was successfully entered.
  /// `true`が返ってきた場合フォームの値が正常に入力されたことになります。
  ///
  /// Give [context] the current [BuildContext].
  /// [context]には現在の[BuildContext]を与えてください。
  ///
  /// [autoUnfocus] is used to unfocus all forms during validation.
  /// [autoUnfocus]を用いるとバリデーション時にフォームのフォーカスをすべて解除します。
  bool validate(
    BuildContext context, {
    bool autoUnfocus = true,
  }) {
    if (autoUnfocus) {
      context.unfocus();
    }
    if (key.currentState == null) {
      return false;
    }
    if (!key.currentState!.validate()) {
      return false;
    }
    key.currentState!.save();
    return true;
  }
}
