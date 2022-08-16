part of masamune;

/// Merge other collection data for all documents in a particular collection.
///
/// The path to the other collection can be specified in [collectionPath].
///
/// By specifying [idKey], a key containing the uid of the user of the original document can be specified.
///
/// [keyPrefix] can be specified to prefix user data keys.
@immutable
@deprecated
class MergeDetailFilterQuery extends FilterQuery<ListenableDynamicMap> {
  const MergeDetailFilterQuery({
    required this.collectionPath,
    this.idKey = Const.uid,
    this.keyPrefix = "",
  });

  /// Collection path to search for details.
  final String collectionPath;

  /// IDKey to search for the same value.
  final String idKey;

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
    return source.mergeDetailInformation(
      ref,
      collectionPath,
      idKey: idKey,
      keyPrefix: keyPrefix,
    );
  }
}
