part of "/katana_form.dart";

/// Context for using the form.
///
/// # How to use
///
/// First, initialize [FormController] with the values to be used in the form.
/// In the example, [Map] is used, but it is safer to use an immutable class.
///
/// [FormController] should be saved using some state management method.
///
/// We will give [key] to the `key` of [Form] and place the `FormXX` widget under it.
///
/// Pass the [value] of [FormController] in the `initialValue` of each form widget, and describe the process of rewriting the [value] of [FormController] in the `onSaved`.
///
/// If the Submit button is pressed, [validate] is executed.
///
/// Each form's `validate` is executed. Only when `true` is returned from [validate], `onSaved` of each form is executed and the process of rewriting [value] of [FormController] is executed.
///
/// After that, execute the process of writing data to the server based on the [value] of [FormController], etc.
///
/// フォームを利用していくためのコンテキスト。
///
/// # 基本的な使い方
///
/// まず、[FormController]にフォーム中で利用するための値を与えながら初期化します。
/// 例では[Map]が利用されてますが、immutableなクラスを利用したほうが安全です。
///
/// [FormController]はなにかしらの状態管理手法で保存してください。
///
/// [Form]の`key`に[key]を与え、その下に`FormXX`ウィジェットを配置していきます。
///
/// それぞれのフォームウィジェットの`initialValue`に[FormController]の[value]を渡し、`onSaved`に[FormController]の[value]を書き換える処理を記載します。
///
/// Submitボタンが押された場合、[validate]を実行します。
///
/// それぞれのフォームの`validate`が実行されます。[validate]から`true`が返された場合のみそれぞれのフォームの`onSaved`が実行され、[FormController]の[value]を書き換える処理が走ります。
///
/// その後、[FormController]の[value]を元にサーバーにデータを書き込む処理等を実行してください。
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
///             onSaved: (value) => {...form.value, "name": value},
///           ),
///           FormTextField(
///             hintText: "Input description",
///             initialValue: _context.value["description"],
///             onSaved: (value) => {...form.value, "description": value},
///           ),
///           FormButton(
///             "Submit",
///             onPressed: () {
///               if(!_context.validate()){
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
class FormController<TValue> extends ValueNotifier<TValue> {
  /// Context for using the form.
  ///
  /// # How to use
  ///
  /// First, initialize [FormController] with the values to be used in the form.
  /// In the example, [Map] is used, but it is safer to use an immutable class.
  ///
  /// [FormController] should be saved using some state management method.
  ///
  /// We will give [key] to the `key` of [Form] and place the `FormXX` widget under it.
  ///
  /// Pass the [value] of [FormController] in the `initialValue` of each form widget, and describe the process of rewriting the [value] of [FormController] in the `onSaved`.
  ///
  /// If the Submit button is pressed, [validate] is executed.
  ///
  /// Each form's `validate` is executed. Only when `true` is returned from [validate], `onSaved` of each form is executed and the process of rewriting [value] of [FormController] is executed.
  ///
  /// After that, execute the process of writing data to the server based on the [value] of [FormController], etc.
  ///
  /// フォームを利用していくためのコンテキスト。
  ///
  /// # 基本的な使い方
  ///
  /// まず、[FormController]にフォーム中で利用するための値を与えながら初期化します。
  /// 例では[Map]が利用されてますが、immutableなクラスを利用したほうが安全です。
  ///
  /// [FormController]はなにかしらの状態管理手法で保存してください。
  ///
  /// [Form]の`key`に[key]を与え、その下に`FormXX`ウィジェットを配置していきます。
  ///
  /// それぞれのフォームウィジェットの`initialValue`に[FormController]の[value]を渡し、`onSaved`に[FormController]の[value]を書き換える処理を記載します。
  ///
  /// Submitボタンが押された場合、[validate]を実行します。
  ///
  /// それぞれのフォームの`validate`が実行されます。[validate]から`true`が返された場合のみそれぞれのフォームの`onSaved`が実行され、[FormController]の[value]を書き換える処理が走ります。
  ///
  /// その後、[FormController]の[value]を元にサーバーにデータを書き込む処理等を実行してください。
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
  ///             onSaved: (value) => {...form.value, "name": value},
  ///           ),
  ///           FormTextField(
  ///             hintText: "Input description",
  ///             initialValue: _context.value["description"],
  ///             onSaved: (value) => {...form.value, "description": value},
  ///           ),
  ///           FormButton(
  ///             "Submit",
  ///             onPressed: () {
  ///               if(!_context.validate()){
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
  // ignore: use_super_parameters
  FormController(TValue value) : super(value);

  /// Register [FormFieldState] to execute `validator` and `onSaved` when [validate] is executed.
  ///
  /// [FormFieldState]を登録して、[validate]実行時に`validator`、`onSaved`を実行するようにします。
  void register(FormFieldState state) {
    _fields.add(state);
  }

  /// Unregister [FormFieldState].
  ///
  /// [FormFieldState]の登録を解除します。
  void unregister(FormFieldState state) {
    _fields.remove(state);
  }

  void _registerContainer(_FormContainerState state) {
    _containers.add(state);
  }

  void _unregisterContainer(_FormContainerState state) {
    _containers.remove(state);
  }

  final Set<FormFieldState> _fields = <FormFieldState>{};
  final Set<_FormContainerState> _containers = <_FormContainerState>{};

  /// [GlobalKey] passed to [Form].
  ///
  /// [Form]に渡す[GlobalKey]。
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  /// Validate all forms placed under [Form] to which [key] is passed, and if there are no problems, `onSaved` is executed and the value is returned.
  ///
  /// If the validation is problematic, `null` is returned.
  ///
  /// The `onSaved` is only executed if a value is returned.
  ///
  /// If [autoUnfocus] is `true`, the focus on the form is released.
  ///
  /// [key]を渡した[Form]の配下に置かれているすべてのフォームでバリデーションを行ない、問題なければ`onSaved`が実行され、その値を返します。
  ///
  /// バリデーションが問題ある場合は`null`が返されます。
  ///
  /// `onSaved`が実行されるのは値が返される場合のみです。
  ///
  /// [autoUnfocus]が`true`の場合、フォームにあるフォーカスが解除されます。
  TValue? validate({bool autoUnfocus = true}) {
    if (autoUnfocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (key.currentState == null) {
      if (!_validate()) {
        return null;
      }
      _save();
      if (!_validateContainer()) {
        return null;
      }
      return value;
    }
    if (!key.currentState!.validate()) {
      return null;
    }
    key.currentState!.save();
    if (!_validateContainer()) {
      return null;
    }
    return value;
  }

  /// Reset all forms placed under [Form] to which [key] is passed.
  ///
  /// [key]を渡した[Form]の配下に置かれているすべてのフォームをリセットします。
  void reset() {
    for (final field in _fields) {
      field.reset();
    }
    notifyListeners();
  }

  void _save() {
    for (final field in _fields) {
      field.save();
    }
  }

  bool _validate() {
    var hasError = false;
    for (final field in _fields) {
      hasError = !field.validate() || hasError;
    }
    notifyListeners();
    return !hasError;
  }

  bool _validateContainer() {
    var hasError = false;
    for (final container in _containers) {
      hasError = !container._validate() || hasError;
    }
    return !hasError;
  }
}
