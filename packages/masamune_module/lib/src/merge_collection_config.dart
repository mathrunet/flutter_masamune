part of masamune_module;

/// Configuration for merging other collection data into a collection.
@immutable
class MergeCollectionConfig {
  const MergeCollectionConfig({
    required this.path,
    this.key = Const.uid,
    this.prefix = "",
  });

  /// Paths of different collections.
  final String path;

  /// Key for comparison.
  final String key;

  /// Prefix for merging data into the document.
  final String prefix;
}

/// Configuration for merging other user collection data into a collection.
@immutable
class UserMergeCollectionConfig extends MergeCollectionConfig {
  const UserMergeCollectionConfig({
    String path = "user",
    String key = "user",
    String prefix = "user",
  }) : super(
          path: path,
          key: key,
          prefix: prefix,
        );
}
