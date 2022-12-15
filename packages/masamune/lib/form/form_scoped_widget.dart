part of masamune;

@immutable
class FormContext {
  const FormContext._({
    required this.editId,
  });

  final String? editId;

  bool get isAdding => editId.isEmpty;

  bool get isEditing => editId.isNotEmpty;
}

abstract class FormScopedWidget extends StatefulWidget
    implements ScopedWidgetBase {
  const FormScopedWidget({super.key});

  /// Build the internal widget.
  ///
  /// The [context] used during the build is passed as is.
  ///
  /// Also, [WidgetRef] is passed to [ref] to update the state.
  ///
  /// 内部のウィジェットをビルドします。
  ///
  /// ビルド中に使用される[context]がそのまま渡されます。
  ///
  /// また、[ref]に状態を更新するための[WidgetRef]が渡されます。
  Widget build(BuildContext context, WidgetRef ref, FormContext form);

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
          ref,
          FormContext._(
            editId: editId,
          ),
        ),
      ),
    );
  }
}

abstract class FormAddPageScopedWidget extends StatefulWidget
    implements PageScopedWidget {
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

abstract class FormEditPageScopedWidget extends StatefulWidget
    implements PageScopedWidget {
  const FormEditPageScopedWidget({
    super.key,
    required this.editId,
  });

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
