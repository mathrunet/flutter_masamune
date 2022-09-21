part of katana_annotation;

/// Annotation indicating a collection in Masamune.
class CollectionModel {
  const CollectionModel(
    this.path, {
    this.converter = const DefaultConverter(),
    this.linkedPath,
    this.enableCollectionCount = false,
  });

  /// Paths for models.
  final String path;

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
class DocumentModel {
  const DocumentModel(
    this.path, {
    this.converter = const DefaultConverter(),
  });

  /// Paths for models.
  final String path;

  /// Converter for value conversion.
  final ConverterBase converter;
}

/// Annotation for defining relationships within a Document.
class Relation {
  const Relation();
}

/// Annotation indicating a page in Masamune.
class AppPage {
  const AppPage(this.path);

  /// Paths for models.
  final String path;
}
