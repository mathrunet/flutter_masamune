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
FormContext useForm([String? editingId]) {
  final uuid = useUuid();
  final context = useContext();
  return FormContext._(
    context: context,
    key: useGlobalKey<FormState>(),
    uid: editingId.isNotEmpty ? context.get(editingId!, uuid) : uuid,
    exists: editingId.isEmpty || !context.arg.containsKey(editingId!),
  );
}

/// The context for handling the form.
///
/// You can generate it with [useForm].
class FormContext {
  const FormContext._({
    required BuildContext context,
    required this.key,
    required this.uid,
    required this.exists,
  }) : _context = context;

  final BuildContext _context;

  /// The key for the form.
  final GlobalKey<FormState> key;

  /// The UID of the document for the form.
  final String uid;

  /// If the form edits an existing one, `true`.
  final bool exists;

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
      _context.unfocus();
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
}
