part of katana_form;

/// Context for using the form.
///
/// # How to use
///
/// First, initialize [FormContext] with the values to be used in the form.
/// In the example, [Map] is used, but it is safer to use an immutable class.
///
/// [FormContext] should be saved using some state management method.
///
/// We will give [key] to the `key` of [Form] and place the `FormXX` widget under it.
///
/// Pass the [value] of [FormContext] in the `initialValue` of each form widget, and describe the process of rewriting the [value] of [FormContext] in the `onSaved`.
///
/// If the Submit button is pressed, [validateAndSave] is executed.
///
/// Each form's `validate` is executed. Only when `true` is returned from [validateAndSave], `onSaved` of each form is executed and the process of rewriting [value] of [FormContext] is executed.
///
/// After that, execute the process of writing data to the server based on the [value] of [FormContext], etc.
///
/// フォームを利用していくためのコンテキスト。
///
/// # 基本的な使い方
///
/// まず、[FormContext]にフォーム中で利用するための値を与えながら初期化します。
/// 例では[Map]が利用されてますが、immutableなクラスを利用したほうが安全です。
///
/// [FormContext]はなにかしらの状態管理手法で保存してください。
///
/// [Form]の`key`に[key]を与え、その下に`FormXX`ウィジェットを配置していきます。
///
/// それぞれのフォームウィジェットの`initialValue`に[FormContext]の[value]を渡し、`onSaved`に[FormContext]の[value]を書き換える処理を記載します。
///
/// Submitボタンが押された場合、[validateAndSave]を実行します。
///
/// それぞれのフォームの`validate`が実行されます。[validateAndSave]から`true`が返された場合のみそれぞれのフォームの`onSaved`が実行され、[FormContext]の[value]を書き換える処理が走ります。
///
/// その後、[FormContext]の[value]を元にサーバーにデータを書き込む処理等を実行してください。
///
/// ```dart
/// class FormPage extends StatefulWidget {
///   const FormPage();
///
///   State<StatefulWidget> createState() => _FormPageState();
/// }
///
/// class _FormPageState extends State<FormPage> {
///   final _context = FormContext(<String, dynamic>{});
///
///   @override
///   Widget build(BuildContext context) {
///     return Form(
///       key: _context.key,
///       child: Column(
///         children: [
///           FormTextField(
///             hintText: "Input name",
///             initialValue: _context.value["name"],
///             onSaved: (form, value) => {...form.value, "name": value},
///           ),
///           FormTextField(
///             hintText: "Input description",
///             initialValue: _context.value["description"],
///             onSaved: (form, value) => {...form.value, "description": value},
///           ),
///           FormButton(
///             "Submit",
///             onPressed: () {
///               if(!_context.validateAndSave()){
///                 return;
///               }
///               // Form data storage process.
///             }
///           ),
///         ]
///       ),
///     );
///   }
/// }
/// ```
class FormContext<TValue> extends ValueNotifier<TValue> {
  /// Context for using the form.
  ///
  /// # How to use
  ///
  /// First, initialize [FormContext] with the values to be used in the form.
  /// In the example, [Map] is used, but it is safer to use an immutable class.
  ///
  /// [FormContext] should be saved using some state management method.
  ///
  /// We will give [key] to the `key` of [Form] and place the `FormXX` widget under it.
  ///
  /// Pass the [value] of [FormContext] in the `initialValue` of each form widget, and describe the process of rewriting the [value] of [FormContext] in the `onSaved`.
  ///
  /// If the Submit button is pressed, [validateAndSave] is executed.
  ///
  /// Each form's `validate` is executed. Only when `true` is returned from [validateAndSave], `onSaved` of each form is executed and the process of rewriting [value] of [FormContext] is executed.
  ///
  /// After that, execute the process of writing data to the server based on the [value] of [FormContext], etc.
  ///
  /// フォームを利用していくためのコンテキスト。
  ///
  /// # 基本的な使い方
  ///
  /// まず、[FormContext]にフォーム中で利用するための値を与えながら初期化します。
  /// 例では[Map]が利用されてますが、immutableなクラスを利用したほうが安全です。
  ///
  /// [FormContext]はなにかしらの状態管理手法で保存してください。
  ///
  /// [Form]の`key`に[key]を与え、その下に`FormXX`ウィジェットを配置していきます。
  ///
  /// それぞれのフォームウィジェットの`initialValue`に[FormContext]の[value]を渡し、`onSaved`に[FormContext]の[value]を書き換える処理を記載します。
  ///
  /// Submitボタンが押された場合、[validateAndSave]を実行します。
  ///
  /// それぞれのフォームの`validate`が実行されます。[validateAndSave]から`true`が返された場合のみそれぞれのフォームの`onSaved`が実行され、[FormContext]の[value]を書き換える処理が走ります。
  ///
  /// その後、[FormContext]の[value]を元にサーバーにデータを書き込む処理等を実行してください。
  ///
  /// ```dart
  /// class FormPage extends StatefulWidget {
  ///   const FormPage();
  ///
  ///   State<StatefulWidget> createState() => _FormPageState();
  /// }
  ///
  /// class _FormPageState extends State<FormPage> {
  ///   final _context = FormContext(<String, dynamic>{});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Form(
  ///       key: _context.key,
  ///       child: Column(
  ///         children: [
  ///           FormTextField(
  ///             hintText: "Input name",
  ///             initialValue: _context.value["name"],
  ///             onSaved: (form, value) => {...form.value, "name": value},
  ///           ),
  ///           FormTextField(
  ///             hintText: "Input description",
  ///             initialValue: _context.value["description"],
  ///             onSaved: (form, value) => {...form.value, "description": value},
  ///           ),
  ///           FormButton(
  ///             "Submit",
  ///             onPressed: () {
  ///               if(!_context.validateAndSave()){
  ///                 return;
  ///               }
  ///               // Form data storage process.
  ///             }
  ///           ),
  ///         ]
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  FormContext(super.value);

  /// [GlobalKey] passed to [Form].
  ///
  /// [Form]に渡す[GlobalKey]。
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  /// Validation is performed on all forms placed under [Form] to which [key] is passed, and if there are no problems, `onSaved` is executed.
  ///
  /// If the validation is problematic, `false` is returned.
  ///
  /// The `onSaved` is only executed if `true` is returned.
  ///
  /// If [autoUnfocus] is `true`, the focus on the form is released.
  ///
  /// [key]を渡した[Form]の配下に置かれているすべてのフォームでバリデーションを行ない、問題なければ`onSaved`が実行されます。
  ///
  /// バリデーションが問題ある場合は`false`が返されます。
  ///
  /// `onSaved`が実行されるのは`true`が返される場合のみです。
  ///
  /// [autoUnfocus]が`true`の場合、フォームにあるフォーカスが解除されます。
  bool validateAndSave({bool autoUnfocus = true}) {
    if (autoUnfocus) {
      FocusManager.instance.primaryFocus?.unfocus();
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
