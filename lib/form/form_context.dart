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
    exists: editingId.isEmpty || context.arg.containsKey(editingId!),
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

  /// Gets the value from the [key] of the map stored in [context].
  ///
  /// If [key] does not exist in the map, [orElse] is returned.
  T get<T>(String key, T orElse) => _context.get(key, orElse);

  /// Get the list corresponding to [key] in the map.
  ///
  /// If [key] is not found, the list of [orElse] is returned.
  List<T> getAsList<T>(String key, [List<T>? orElse]) =>
      _context.getAsList(key, orElse);

  /// Get the map corresponding to [key] in the map.
  ///
  /// If [key] is not found, the map of [orElse] is returned.
  Map<String, T> getAsMap<T>(String key, [Map<String, T>? orElse]) =>
      _context.getAsMap(key, orElse);

  /// Get the set corresponding to [key] in the map.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  Set<T> getAsSets<T>(String key, [Set<T>? orElse]) =>
      _context.getAsSets(key, orElse);

  /// Get the set corresponding to [key] in the DateTime.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  DateTime getAsDateTime(String key, [DateTime? orElse]) =>
      _context.getAsDateTime(key, orElse);

  /// Save [value] to [key] of the map stored in [context].
  ///
  /// The data will be unique within the page and can continue to be used even if the widget is rebuilt.
  void operator []=(String key, dynamic value) {
    _context[key] = value;
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
}
