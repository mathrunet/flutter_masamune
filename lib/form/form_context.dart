part of masamune.form;

/// Create the context for using the form.
///
/// You can determine whether it is new or existing
/// by specifying the ID of the document to be used in the form in [editingId].
///
/// First, create a context with [useForm].
///
/// Pass [FormContext.key] to [Form].
///
/// Run [FormContext.validate()] at the time of applying the changes to check if the values are correct.
///
/// Finally, save all changes to the specified document by running [save()].
// FormContext useForm([String? editingId]) {
//   final uuid = useUuid();
//   final context = useContext();
//   final ref = context as WidgetRef;
//   return FormContext._(
//     ref: ref,
//     key: useGlobalKey<FormState>(),
//     uid: editingId.isNotEmpty ? ref.get(editingId!, uuid) : uuid,
//     exists: editingId.isEmpty || ref.containsKey(editingId!),
//   );
// }

extension WidgetRefFormExtensions on WidgetRef {
  FormContext useForm<T>([String? editingId]) {
    return valueBuilder<FormContext, _FormContextValue>(
      key: "form",
      builder: () {
        return _FormContextValue(editingId);
      },
    );
  }
}

/// The context for handling the form.
///
/// You can generate it with [useForm].
@immutable
class _FormContextValue extends ScopedValue<FormContext> {
  const _FormContextValue(this.editingId);

  final String? editingId;

  @override
  ScopedValueState<FormContext, ScopedValue<FormContext>> createState() =>
      FormContext._();
}

class FormContext extends ScopedValueState<FormContext, _FormContextValue> {
  FormContext._();

  /// The key for the form.
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  /// The UID of the document for the form.
  late final String uid;

  /// If the form edits an existing one, `true`.
  late final bool exists;

  BuildContext get _context => ref as BuildContext;

  @override
  void initValue() {
    super.initValue();
    final editingId = value.editingId;
    uid = editingId.isNotEmpty ? _context.get(editingId!, uuid) : uuid;
    exists = editingId.isEmpty || _context.containsKey(editingId!);
  }

  /// If the document exists, [exist] will be displayed,
  /// and if it is new, [orElse] will be displayed.
  T select<T>(T exist, T orElse) {
    return exists ? exist : orElse;
  }

  /// Validate the data in the form.
  ///
  /// Returns True if the validation is successful.
  ///
  /// If you enter a value in [initial], you can set it to the initial value.
  ///
  /// If [autoUnfocus] is `true`, the focus will be removed automatically.
  bool validate({
    bool autoUnfocus = true,
    DynamicMap initial = const {},
  }) {
    if (autoUnfocus) {
      (ref as BuildContext).unfocus();
    }
    if (key.currentState == null) {
      return false;
    }
    if (!key.currentState!.validate()) {
      return false;
    }
    initial.forEach((key, value) {
      if (key.isEmpty || value == null) {
        return;
      }
      _context[key] = value;
    });
    key.currentState!.save();
    return true;
  }

  /// Copy the data stored in the form and [context] to [target].
  ///
  /// Only the data specified in the key of [keyAndInitialValues] will be copied.
  ///
  /// If there is no data for the specified key, the value of [keyAndInitialValues] is copied as the initial value.
  T copyTo<T extends DynamicMap>(T target, DynamicMap keyAndInitialValues) {
    target.copyFrom(_context, keyAndInitialValues);
    return target;
  }

  @override
  FormContext build() => this;
}
