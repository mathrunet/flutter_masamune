part of masamune.form;

extension FormDynamicMapExtensions on DynamicMap {
  /// Copies from the value passed to [context] to itself.
  ///
  /// The [keyAndInitialValues] is given as a [Map] of the keys in the [context] and
  /// the initial values when the keys are not in the context.
  ///
  /// Finally, it returns its own object.
  DynamicMap copyFrom(BuildContext context, DynamicMap keyAndInitialValues) {
    for (final tmp in keyAndInitialValues.entries) {
      final value = tmp.value;
      if (value == null) {
        continue;
      }
      if (value is List<dynamic>) {
        this[tmp.key] = context.getAsList(tmp.key, value);
      } else if (value is Map<String, dynamic>) {
        this[tmp.key] = context.getAsMap(tmp.key, value);
      } else {
        this[tmp.key] = context.get(tmp.key, value);
      }
    }
    return this;
  }
}
