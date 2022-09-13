part of katana_annotation;

/// Annotation indicating a collection in Masamune.
class CollectionPath {
  const CollectionPath(
    this.path, {
    this.keySuffix = "Const",
    this.converter = const DefaultConverter(),
  });

  /// Paths for models.
  final String path;

  /// Suffix of the class that defines the key constant for the value.
  final String keySuffix;

  /// Converter for value conversion.
  final ConverterBase converter;
}

/// Annotation indicating a document in Masamune.
class DocumentPath {
  const DocumentPath(
    this.path, {
    this.keySuffix = "Const",
    this.converter = const DefaultConverter(),
  });

  /// Paths for models.
  final String path;

  /// Suffix of the class that defines the key constant for the value.
  final String keySuffix;

  /// Converter for value conversion.
  final ConverterBase converter;
}

/// Annotation indicating a page in Masamune.
class PagePath {
  const PagePath(this.path);

  /// Paths for models.
  final String path;
}
