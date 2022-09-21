part of katana_annotation;

/// Base class for the built document object.
abstract class BuiltDocumentBase {
  /// Obtains the actual data contained within.
  Map<String, dynamic> value();

  /// Document uid.
  String get uid;
}
