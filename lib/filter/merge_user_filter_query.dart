part of masamune;

/// Merge user data for all documents in a particular collection.
///
/// The path to the user collection can be specified in [userCollectionPath].
///
/// By specifying [userKey], a key containing the uid of the user of the original document can be specified.
///
/// [keyPrefix] can be specified to prefix user data keys.
@immutable
class MergeUserFilterQuery extends FilterQuery<ListenableDynamicMap> {
  const MergeUserFilterQuery({
    this.userCollectionPath = "user",
    this.userKey = "user",
    this.keyPrefix = "user",
  });

  /// Collection path to search for details.
  final String userCollectionPath;

  /// IDKey to search for the same value.
  final String userKey;

  /// Prefix for key of data to be merged.
  final String keyPrefix;

  /// Processes and returns [source].
  ///
  /// When executing, give [context] or [ref] so that other data can be retrieved.
  @override
  List<ListenableDynamicMap> build(
    List<ListenableDynamicMap> source,
    BuildContext context,
    WidgetRef ref,
  ) {
    return source.mergeUserInformation(
      ref,
      userCollectionPath: userCollectionPath,
      userKey: userKey,
      keyPrefix: keyPrefix,
    );
  }
}
