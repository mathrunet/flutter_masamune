part of katana_annotation;

/// Annotation to set default values for parameters.
class Default {
  const Default(this.defaultValue);

  /// Default value.
  final Object? defaultValue;
}

/// Annotation indicating a collection in Masamune.
class CollectionPath {
  const CollectionPath(this.path);

  /// Paths for models.
  final String path;
}

/// Annotation indicating a document in Masamune.
class DocumentPath {
  const DocumentPath(this.path);

  /// Paths for models.
  final String path;
}

/// Annotation indicating a page in Masamune.
class PagePath {
  const PagePath(this.path);

  /// Paths for models.
  final String path;
}
