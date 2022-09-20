part of katana_annotation;

/// Annotation indicating a collection in Masamune.
class CollectionPath {
  const CollectionPath(
    this.path, {
    this.keySuffix = "Keys",
    this.converter = const DefaultConverter(),
    this.linkedPath,
    this.enableCollectionCount = false,
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

  /// Record the counts of your own collection in the document in the hierarchy above.
  ///
  /// If you set this to `true`, the collection cannot be counted on the first level.
  final bool enableCollectionCount;
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

/// Annotation for defining relationships within a Document.
///
/// You can specify a key for comparing related objects by specifying [key].
class Relation {
  const Relation({this.key = "uid"});

  final String key;
}

/// Annotation indicating a page in Masamune.
class PagePath {
  const PagePath(this.path);

  /// Paths for models.
  final String path;
}
