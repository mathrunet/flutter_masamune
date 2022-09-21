part of model_notifier;

/// Abstract class for the convertable value model.
///
/// It defines the required methods.
abstract class ConvertableValueModel<T> extends ValueModel<T> {
  /// Abstract class for the convertable value model.
  ///
  /// It defines the required methods.
  ConvertableValueModel(T value) : super(value);

  /// Creates a specific object from a given [map].
  ///
  /// This is used to convert the loaded data into an object for internal management.
  T fromMap(DynamicMap map);

  /// Creates a [DynamicMap] from its own [value].
  ///
  /// It is used for storing data.
  DynamicMap toMap(T value);
}
