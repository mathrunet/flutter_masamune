part of katana_module;

/// Abstract class for defining the data retrieved from the model for processing.
@immutable
abstract class FilterQuery<T extends DynamicMap> {
  const FilterQuery();

  /// Processes and returns [source].
  ///
  /// When executing, give [context] or [ref] so that other data can be retrieved.
  List<T> build(
    List<T> source,
    BuildContext context,
    WidgetRef ref,
  );
}
