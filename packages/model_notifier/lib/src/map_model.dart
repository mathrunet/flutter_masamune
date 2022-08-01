part of model_notifier;

/// A model that can be treated as a map.
///
/// All keys in the map will be of type [String].
abstract class MapModel<T> extends ValueModel<Map<String, T>>
    with MapModelMixin<String, T>
    implements Map<String, T>, ListenableMap<String, T> {
  /// A model that can be treated as a map.
  ///
  /// All keys in the map will be of type [String].
  MapModel([Map<String, T>? map]) : super(map ?? {});

  /// Sends a notification to itself when the target [listenable] is updated.
  @override
  void dependOn(
    Listenable listenable, [
    Map<String, T> Function(Map<String, T> origin)? filter,
  ]) {
    listenable.addListener(() {
      if (filter != null) {
        value = filter.call(value);
      } else {
        notifyListeners();
      }
    });
  }
}
