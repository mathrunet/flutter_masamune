part of "/masamune.dart";

/// A reference scoped to the form passed from [FormScopedWidget.build].
///
/// [RefHasApp], [RefHasPage] and [RefHasWidget] are implemented to manage state for the scopes [app], [page] and [widget].
///
/// It is also possible to obtain the data ID of the currently editing form at [editId] by placing [FormEditPageScopedWidget] or [FormAddPageScopedWidget] in the parent.
///
/// Then, if [editId] is [Null], [isAdding] will be `true`, otherwise [isEditing] will be `true`.
///
/// [FormScopedWidget.build]から渡されるフォームにスコープしたリファレンス。
///
/// [RefHasApp]と[RefHasPage]、[RefHasWidget]を実装しており[app]と[page]、[widget]のスコープに対して状態を管理できます。
///
/// また、[FormEditPageScopedWidget]や[FormAddPageScopedWidget]を親に配置することにより[editId]で現在フォームを編集中のデータIDを取得することが可能です。
///
/// そのとき、[editId]が[Null]の場合、[isAdding]が`true`になり、それ以外の場合は[isEditing]が`true`になります。
@immutable
class FormRef implements WidgetRef {
  const FormRef._({
    required WidgetRef widgetRef,
    required this.editId,
  }) : _widgetRef = widgetRef;

  final WidgetRef _widgetRef;

  /// Data ID currently being edited.
  ///
  /// It can be obtained by placing [FormEditPageScopedWidget] or [FormAddPageScopedWidget] on the parent.
  ///
  /// If new data is being added, it will be [Null], and if existing data is being edited, the data ID of the data will be entered.
  ///
  /// 現在編集中のデータID。
  ///
  /// [FormEditPageScopedWidget]や[FormAddPageScopedWidget]を親に配置することにより取得可能になります。
  ///
  /// 新規追加の場合[Null]になり、既存データを編集中の場合はそのデータのデータIDが入ります。
  final String? editId;

  /// True` is returned for new additions.
  ///
  /// It can be obtained by placing [FormEditPageScopedWidget] or [FormAddPageScopedWidget] on the parent.
  ///
  /// 新規追加の場合`true`が返されます。
  ///
  /// [FormEditPageScopedWidget]や[FormAddPageScopedWidget]を親に配置することにより取得可能になります。
  bool get isAdding => editId.isEmpty;

  /// True` is returned if existing data is being edited.
  ///
  /// It can be obtained by placing [FormEditPageScopedWidget] or [FormAddPageScopedWidget] on the parent.
  ///
  /// 既存データ編集中の場合`true`が返されます。
  ///
  /// [FormEditPageScopedWidget]や[FormAddPageScopedWidget]を親に配置することにより取得可能になります。
  bool get isEditing => editId.isNotEmpty;

  @override
  AppScopedValueRef get app => _widgetRef.app;

  @override
  PageScopedValueRef get page => _widgetRef.page;

  @override
  WidgetScopedValueRef get widget => _widgetRef.widget;

  /// When a value is being added to a form, [onAdd] is executed; when editing, [onEdit] is executed.
  ///
  /// フォームに値を追加しているときは[onAdd]が実行され、編集しているときは[onEdit]が実行されます。
  T select<T>({
    required T Function() onAdd,
    required T Function(String editId) onEdit,
  }) {
    if (isAdding) {
      return onAdd.call();
    } else {
      return onEdit.call(editId ?? "");
    }
  }
}

/// Abstract class to implement the View portion of the form widget used to both add new and edit existing forms.
///
/// The [FormRef] including the function of the [WidgetRef] and form information is passed to [build], and the View is implemented using it.
///
/// Implement [FormAddPageScopedWidget] and [FormEditPageScopedWidget] together as follows.
///
/// 新規追加と既存の編集を両立させるために利用するフォームウィジェットのView部分を実装するための抽象クラス。
///
/// [build]に[WidgetRef]の機能とフォームの情報を含めた[FormRef]が渡されるのでそれを用いてViewを実装します。
///
/// [FormAddPageScopedWidget]と[FormEditPageScopedWidget]を合わせて下記のように実装します。
///
/// {@template form_scoped_widget}
/// ```dart
/// @immutable
/// @PagePath("user/add")
/// class UserAddPage extends FormAddPageScopedWidget {
///   const UserAddPage({
///     super.key,
///   });
///
///   @pageRouteQuery
///   static const query = _$UserAddPageQuery();
///
///   @override
///   FormScopedWidget build(BuildContext context, PageRef ref) =>
///     const UserForm();
/// }
///
/// @immutable
/// @PagePath("user/{edit_id}/edit")
/// class UserEditPage extends FormEditPageScopedWidget {
///   const UserEditPage({
///     super.key,
///     @PageParam("edit_id") required super.editId,
///   });
///
///   @pageRouteQuery
///   static const query = _$UserEditPageQuery();
///
///   @override
///   FormScopedWidget build(BuildContext context, PageRef ref) =>
///     const UserForm();
/// }
///
/// @immutable
/// class UserForm extends FormScopedWidget {
///   const UserForm({super.key});
///
///   @override
///   Widget build(BuildContext context, FormRef ref) {
///     return Scaffold(
///       // Any view form
///     );
///   }
/// }
/// ```
/// {@endtemplate}
abstract class FormScopedWidget extends StatefulWidget
    implements ScopedWidgetBase {
  /// Abstract class to implement the View portion of the form widget used to both add new and edit existing forms.
  ///
  /// The [FormRef] including the function of the [WidgetRef] and form information is passed to [build], and the View is implemented using it.
  ///
  /// Implement [FormAddPageScopedWidget] and [FormEditPageScopedWidget] together as follows.
  ///
  /// 新規追加と既存の編集を両立させるために利用するフォームウィジェットのView部分を実装するための抽象クラス。
  ///
  /// [build]に[WidgetRef]の機能とフォームの情報を含めた[FormRef]が渡されるのでそれを用いてViewを実装します。
  ///
  /// [FormAddPageScopedWidget]と[FormEditPageScopedWidget]を合わせて下記のように実装します。
  ///
  /// {@template form_scoped_widget}
  /// ```dart
  /// @immutable
  /// @PagePath("user/add")
  /// class UserAddPage extends FormAddPageScopedWidget {
  ///   const UserAddPage({
  ///     super.key,
  ///   });
  ///
  ///   @pageRouteQuery
  ///   static const query = _$UserAddPageQuery();
  ///
  ///   @override
  ///   FormScopedWidget build(BuildContext context, PageRef ref) =>
  ///     const UserForm();
  /// }
  ///
  /// @immutable
  /// @PagePath("user/{edit_id}/edit")
  /// class UserEditPage extends FormEditPageScopedWidget {
  ///   const UserEditPage({
  ///     super.key,
  ///     @PageParam("edit_id") required super.editId,
  ///   });
  ///
  ///   @pageRouteQuery
  ///   static const query = _$UserEditPageQuery();
  ///
  ///   @override
  ///   FormScopedWidget build(BuildContext context, PageRef ref) =>
  ///     const UserForm();
  /// }
  ///
  /// @immutable
  /// class UserForm extends FormScopedWidget {
  ///   const UserForm({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context, FormRef ref) {
  ///     return Scaffold(
  ///       // Any view form
  ///     );
  ///   }
  /// }
  /// ```
  /// {@endtemplate}
  const FormScopedWidget({super.key});

  /// Build the internal widget.
  ///
  /// The [context] used during the build is passed as is.
  ///
  /// It also inherits [WidgetRef] for updating the state in [ref] and is passed [FormRef] containing information for the form.
  ///
  /// 内部のウィジェットをビルドします。
  ///
  /// ビルド中に使用される[context]がそのまま渡されます。
  ///
  /// また、[ref]に状態を更新するための[WidgetRef]を継承し、フォーム用の情報が含まれた[FormRef]が渡されます。
  Widget build(BuildContext context, FormRef ref);

  @override
  State<StatefulWidget> createState() => _FormScopedWidget();
}

class _FormScopedWidget extends State<FormScopedWidget> {
  @override
  Widget build(BuildContext context) {
    final editId = _FormPageScopedScope.of(context)?.editId;
    return ScopedWidgetScope(
      widget: widget,
      child: Scoped(
        builder: (context, ref) => widget.build(
          context,
          FormRef._(widgetRef: ref, editId: editId),
        ),
      ),
    );
  }
}

/// Abstract class for implementing a new add page for form widgets used for both adding new ones and editing existing ones.
///
/// Pass a class inheriting from [FormScopedWidget] to [build].
///
/// 新規追加と既存の編集を両立させるために利用するフォームウィジェットの新規追加ページを実装するための抽象クラス。
///
/// [build]に[FormScopedWidget]を継承したクラスを渡してください。
///
/// {@macro form_scoped_widget}
abstract class FormAddPageScopedWidget extends StatefulWidget
    implements PageScopedWidget {
  /// Abstract class for implementing a new add page for form widgets used for both adding new ones and editing existing ones.
  ///
  /// Pass a class inheriting from [FormScopedWidget] to [build].
  ///
  /// 新規追加と既存の編集を両立させるために利用するフォームウィジェットの新規追加ページを実装するための抽象クラス。
  ///
  /// [build]に[FormScopedWidget]を継承したクラスを渡してください。
  ///
  /// {@macro form_scoped_widget}
  const FormAddPageScopedWidget({super.key});

  @override
  FormScopedWidget build(BuildContext context, PageRef ref);

  @override
  State<StatefulWidget> createState() => _FormAddPageScopedWidgetState();
}

class _FormAddPageScopedWidgetState extends State<FormAddPageScopedWidget> {
  @override
  Widget build(BuildContext context) {
    return _FormPageScopedScope(
      editId: null,
      child: _FormPageScopedBuilder(
        builder: (context, ref) {
          return widget.build(context, ref);
        },
      ),
    );
  }
}

/// Abstract class to implement the existing edit page of a form widget used to both add new and edit existing.
///
/// You must always pass [editId] to edit existing data.
///
/// Pass a class inheriting from [FormScopedWidget] to [build].
///
/// 新規追加と既存の編集を両立させるために利用するフォームウィジェットの既存編集ページを実装するための抽象クラス。
///
/// 必ず既存のデータを編集するための[editId]を渡す必要があります。
///
/// [build]に[FormScopedWidget]を継承したクラスを渡してください。
///
/// {@macro form_scoped_widget}
abstract class FormEditPageScopedWidget extends StatefulWidget
    implements PageScopedWidget {
  /// Abstract class to implement the existing edit page of a form widget used to both add new and edit existing.
  ///
  /// You must always pass [editId] to edit existing data.
  ///
  /// Pass a class inheriting from [FormScopedWidget] to [build].
  ///
  /// 新規追加と既存の編集を両立させるために利用するフォームウィジェットの既存編集ページを実装するための抽象クラス。
  ///
  /// 必ず既存のデータを編集するための[editId]を渡す必要があります。
  ///
  /// [build]に[FormScopedWidget]を継承したクラスを渡してください。
  ///
  /// {@macro form_scoped_widget}
  const FormEditPageScopedWidget({
    required this.editId,
    super.key,
  });

  /// Data ID currently being edited.
  ///
  /// 現在編集中のデータID。
  final String editId;

  @override
  FormScopedWidget build(BuildContext context, PageRef ref);

  @override
  State<StatefulWidget> createState() => _FormEditPageScopedWidgetState();
}

class _FormEditPageScopedWidgetState extends State<FormEditPageScopedWidget> {
  @override
  Widget build(BuildContext context) {
    return _FormPageScopedScope(
      editId: widget.editId,
      child: _FormPageScopedBuilder(
        builder: (context, ref) {
          return widget.build(context, ref);
        },
      ),
    );
  }
}

class _FormPageScopedBuilder extends PageScopedWidget {
  const _FormPageScopedBuilder({
    required this.builder,
  });

  final FormScopedWidget Function(BuildContext context, PageRef ref) builder;
  @override
  Widget build(BuildContext context, PageRef ref) {
    return builder(context, ref);
  }
}

class _FormPageScopedScope extends InheritedWidget {
  const _FormPageScopedScope({
    required super.child,
    required this.editId,
  });

  final String? editId;

  static _FormPageScopedScope? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_FormPageScopedScope>();
    return scope?.widget as _FormPageScopedScope?;
  }

  @override
  bool updateShouldNotify(covariant _FormPageScopedScope oldWidget) => false;
}
