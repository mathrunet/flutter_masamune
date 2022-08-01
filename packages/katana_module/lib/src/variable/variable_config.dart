part of katana_module;

/// You can set up values and forms to be registered to Firestore etc.
@immutable
class VariableConfig<T> {
  /// You can set up values and forms to be registered to Firestore etc.
  const VariableConfig({
    required this.id,
    required this.label,
    required this.value,
    this.icon,
    this.required = false,
    this.show = true,
    this.form,
    this.view,
  });

  /// ID of variable.
  final String id;

  /// Default value.
  final T value;

  /// Label of variable.
  final String label;

  /// VariableIcon.
  final IconData? icon;

  /// `True` if the data is required.
  final bool required;

  /// `True` if data is to be displayed.
  final bool show;

  /// Data for the form.
  final VariableFormConfig<T>? form;

  /// Data for the view.
  final VariableViewConfig<T>? view;

  /// Create a new VariableConfig by passing a value.
  VariableConfig<T> copyWith({
    String? id,
    String? label,
    T? value,
    IconData? icon,
    bool? required,
    bool? show,
    VariableFormConfig<T>? form,
    VariableViewConfig<T>? view,
  }) {
    return VariableConfig(
      id: id ?? this.id,
      value: value ?? this.value,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      required: required ?? this.required,
      show: show ?? this.show,
      form: form ?? this.form,
      view: view ?? this.view,
    );
  }

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      id.hashCode ^
      value.hashCode ^
      label.hashCode ^
      required.hashCode ^
      icon.hashCode ^
      form.hashCode ^
      view.hashCode;
}
