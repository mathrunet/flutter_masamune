part of model_notifier;

/// Transaction builder for document.
abstract class DocumentTransactionBuilder implements Map<String, dynamic> {
  /// Add/Update an element of document.
  Future<void> save();

  /// Increments the value specified by [key] by [value].
  ///
  /// It is also possible to specify a minus value for [value].
  ///
  /// By specifying [intervals],
  /// it is possible to perform aggregation separated by periods.
  DocumentTransactionBuilder increment(
    String key,
    num value, {
    List<CounterUpdaterInterval> intervals = const [],
  });

  /// Associates the [key] with the given [value].
  ///
  /// The data entered here will be stored in [documentPath].
  @override
  void operator []=(String key, dynamic value);

  /// Retrieves data stored in Transaction.
  ///
  /// The data entered here will be stored in [documentPath].
  @override
  dynamic operator [](Object? key);
}

/// Transaction builder for collection.
abstract class CollectionTransactionBuilder implements Map<String, dynamic> {
  /// Add/Update an element of [id] to [collectionPath].
  ///
  /// If [linkedCollectionPath] is specified, the element of [linkId] is added.
  Future<void> save(
    String id, {
    String? linkId,
  });

  /// Remove an element of [id] to [collectionPath].
  ///
  /// If [linkedCollectionPath] is specified, the element of [linkId] is removed.
  Future<void> delete(String id, {String? linkId});

  /// Create fields for counters.
  ///
  /// Increases or decreases the number of fields marked with [counterSuffix] in the documents in the hierarchy above the [collectionPath] or [linkedCollectionPath] specified when the Builder is created, depending on the increase or decrease in the number of elements.
  ///
  /// You can set up your own counter path using [counterBuilder] or [linkedCounterBuilder].
  ///
  /// Time-delimited counters can be set up by specifying [counterIntervals].
  void setCounterField({
    String counterSuffix = "Count",
    String Function(String path)? counterBuilder,
    String Function(String linkPath)? linkedCounterBuilder,
    List<CounterUpdaterInterval> counterIntervals = const [],
  });

  /// Associates the [key] with the given [value].
  ///
  /// The data entered here will be stored in [collectionPath] and in documents in [linkedCollectionPath].
  @override
  void operator []=(String key, dynamic value);

  /// Retrieves data stored in Transaction.
  ///
  /// The data entered here will be stored in [collectionPath] and in documents in [linkedCollectionPath].
  @override
  dynamic operator [](Object? key);
}

/// Transaction builder for collection for linkedCollection.
class LinkedCollectionTransactionBuilder
    with MapMixin<String, dynamic>
    implements Map<String, dynamic> {
  /// Transaction builder for collection for linkedCollection.
  LinkedCollectionTransactionBuilder(this.builder);

  /// Builder's original data.
  final CollectionTransactionBuilder builder;

  /// Add/Update an element of [id] to [collectionPath].
  ///
  /// If [linkedCollectionPath] is specified, the element of [linkId] is added.
  Future<void> save({
    required String id,
    required String linkId,
  }) =>
      builder.save(id, linkId: linkId);

  /// Remove an element of [id] to [collectionPath].
  ///
  /// If [linkedCollectionPath] is specified, the element of [linkId] is removed.
  Future<void> delete({
    required String id,
    required String linkId,
  }) =>
      builder.delete(id, linkId: linkId);

  /// Create fields for counters.
  ///
  /// Increases or decreases the number of fields marked with [counterSuffix] in the documents in the hierarchy above the [collectionPath] or [linkedCollectionPath] specified when the Builder is created, depending on the increase or decrease in the number of elements.
  ///
  /// You can set up your own counter path using [counterBuilder] or [linkedCounterBuilder].
  ///
  /// Time-delimited counters can be set up by specifying [counterIntervals].
  void setCounterField({
    String counterSuffix = "Count",
    String Function(String path)? counterBuilder,
    String Function(String linkPath)? linkedCounterBuilder,
    List<CounterUpdaterInterval> counterIntervals = const [],
  }) =>
      builder.setCounterField(
        counterBuilder: counterBuilder,
        counterSuffix: counterSuffix,
        linkedCounterBuilder: linkedCounterBuilder,
        counterIntervals: counterIntervals,
      );

  /// Associates the [key] with the given [value].
  ///
  /// The data entered here will be stored in [collectionPath] and in documents in [linkedCollectionPath].
  @override
  void operator []=(String key, dynamic value) => builder[key] = value;

  /// Retrieves data stored in Transaction.
  ///
  /// The data entered here will be stored in [collectionPath] and in documents in [linkedCollectionPath].
  @override
  dynamic operator [](Object? key) => builder[key];

  @override
  void clear() => builder.clear();

  @override
  Iterable<String> get keys => builder.keys;

  @override
  dynamic remove(Object? key) => builder.remove(key);
}
