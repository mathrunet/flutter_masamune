part of katana_annotation;

/// Base class for the built collection object.
abstract class BuiltCollectionBase {
  /// Obtains the actual data contained within.
  List<Map<String, dynamic>> value();
}
