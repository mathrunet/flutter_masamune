part of katana_annotation;

/// Annotation indicating a collection in Masamune.
class CollectionPath {
  const CollectionPath(
    this.path, {
    this.keySuffix = "Keys",
    this.converter = const DefaultConverter(),
    this.linkedPath,
  });

  /// Paths for models.
  final String path;

  /// Suffix of the class that defines the key constant for the value.
  final String keySuffix;

  /// Converter for value conversion.
  final ConverterBase converter;

  /// Specifying [linkedPath] allows you to simultaneously create linked documents (e.g., follow and follower documents).
  ///
  /// Must be a path to another collection.
  final String? linkedPath;
}

/// Annotation indicating a document in Masamune.
class DocumentPath {
  const DocumentPath(
    this.path, {
    this.keySuffix = "Keys",
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
