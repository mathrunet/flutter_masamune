part of model_notifier;

class RuntimeTransaction {
  const RuntimeTransaction._();

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [documentPath].
  static RuntimeDocumentTransactionBuilder documentTransaction(
    String documentPath,
  ) {
    return RuntimeDocumentTransactionBuilder._(
      documentPath,
    );
  }

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [collectionPath].
  ///
  /// You can add the corresponding element by specifying [linkedCollectionPath].
  static RuntimeCollectionTransactionBuilder collectionTransaction({
    required String collectionPath,
    String? linkedCollectionPath,
  }) {
    return RuntimeCollectionTransactionBuilder._(
      collectionPath: collectionPath,
      linkedCollectionPath: linkedCollectionPath,
    );
  }

  /// Create a code of length [length] randomly for id.
  ///
  /// Characters that are difficult to understand are omitted.
  ///
  /// If the data of [key] in [path] contains the generated random value,
  /// the random value is generated again.
  static Future<String> generateCode({
    required String path,
    required String key,
    int length = 6,
    String charSet = "23456789abcdefghjkmnpqrstuvwxy",
  }) async {
    List<String> generated = [];
    do {
      // await Future.delayed(Duration(milliseconds: Random().nextInt(100)));
      generated = List.generate(
        10,
        (index) => katana.generateCode(length, charSet: charSet),
      );
      final snapshot = await RuntimeDatabase._db.loadDocument(
        LocalStoreDocumentQuery(path: path),
      );
      if (snapshot != null) {
        for (final map in snapshot.values) {
          if (map.isEmpty || !map.containsKey(key)) {
            continue;
          }
          generated.remove(map.get(key, ""));
        }
      }
    } while (generated.isEmpty);
    return generated.first;
  }
}

/// Generates a transaction builder.
class RuntimeDocumentTransactionBuilder extends DocumentTransactionBuilder
    with MapMixin<String, dynamic> {
  RuntimeDocumentTransactionBuilder._(this.documentPath)
      : assert(
          !(documentPath.splitLength() <= 0 ||
              documentPath.splitLength() % 2 != 0),
          "The path hierarchy must be an even number: $documentPath",
        );

  /// The document path for the transaction.
  final String documentPath;
  bool _enableCounter = false;
  String? _counterKey;
  num? _counterValue;
  List<CounterUpdaterInterval>? _counterIntervals;
  final DynamicMap _additionalData = {};

  /// Retrieves data stored in Transaction.
  ///
  /// The data entered here will be stored in [documentPath].
  @override
  dynamic operator [](Object? key) {
    return _additionalData[key];
  }

  /// Associates the [key] with the given [value].
  ///
  /// The data entered here will be stored in [documentPath].
  @override
  void operator []=(String key, Object? value) {
    _additionalData[key] = value;
  }

  /// Deletes data associated with a Transaction.
  @override
  void clear() {
    _additionalData.clear();
  }

  /// Acquire the key to the data tied to Transaction.
  @override
  Iterable<String> get keys => _additionalData.keys;

  /// Deletes the data for [key] from the data associated with the Transaction.
  @override
  dynamic remove(Object? key) {
    return _additionalData.remove(key);
  }

  /// Increments the value specified by [key] by [value].
  ///
  /// It is also possible to specify a minus value for [value].
  ///
  /// By specifying [intervals],
  /// it is possible to perform aggregation separated by periods.
  @override
  DocumentTransactionBuilder increment(
    String key,
    num value, {
    List<CounterUpdaterInterval> intervals = const [],
  }) {
    _enableCounter = true;
    _counterKey = key;
    _counterValue = value;
    _counterIntervals = intervals;
    return this;
  }

  /// Add/Update an element of document.
  @override
  Future<void> save() async {
    try {
      final updated = <String, DynamicMap>{};
      final doc = await RuntimeDatabase._db.loadDocument(
            LocalStoreDocumentQuery(path: documentPath),
          ) ??
          <String, dynamic>{};
      doc.addAll(_additionalData);
      doc[Const.uid] = documentPath.split("/").last;
      doc[Const.time] = DateTime.now().millisecondsSinceEpoch;
      updated[documentPath] = _buildCounterUpdate(
        map: doc,
        key: _counterKey,
        value: _counterValue,
        enabled: _enableCounter,
        counterIntervals: _counterIntervals ?? [],
      );
      for (final tmp in updated.entries) {
        await RuntimeDatabase._db.saveDocument(
          LocalStoreDocumentQuery(
            path: tmp.key,
          ),
          tmp.value,
        );
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}

/// Generates a transaction builder.
class RuntimeCollectionTransactionBuilder extends CollectionTransactionBuilder
    with MapMixin<String, dynamic> {
  RuntimeCollectionTransactionBuilder._({
    required this.collectionPath,
    this.linkedCollectionPath,
  })  : assert(
          !(collectionPath.splitLength() <= 0 ||
              collectionPath.splitLength() % 2 != 1),
          "The collection path hierarchy must be an odd number: $collectionPath",
        ),
        assert(
          linkedCollectionPath.isEmpty ||
              !(linkedCollectionPath!.splitLength() <= 0 ||
                  linkedCollectionPath.splitLength() % 2 != 1),
          "The link collection path hierarchy must be an odd number: $linkedCollectionPath",
        );

  bool _enableCounter = false;
  String? _counterSuffix;
  String Function(String path)? _counterBuilder;
  String Function(String linkPath)? _linkedCounterBuilder;
  List<CounterUpdaterInterval>? _counterIntervals;
  final DynamicMap _additionalData = {};

  /// A collection that counts the number of elements.
  final String collectionPath;

  /// A linked collection that counts the number of elements.
  final String? linkedCollectionPath;

  String? _buildCounterPath(String? path) {
    if (path.isEmpty) {
      return null;
    }
    return "$path${_counterSuffix ?? ""}";
  }

  /// Add/Update an element of [id] to [collectionPath].
  ///
  /// If [linkedCollectionPath] is specified, the element of [linkId] is added.
  ///
  /// The contents of [data] will be added to the [collectionPath]/[id] path.
  ///
  /// The contents of [linkedData] will be added to the [linkedCollectionPath]/[linkId] path.
  @override
  Future<void> save(
    String id, {
    String? linkId,
  }) async {
    assert(
      linkId.isEmpty || (linkedCollectionPath.isNotEmpty && linkId.isNotEmpty),
      "When [linkId] is specified, [linkPath] must be specified.",
    );
    // await Future.delayed(Duration(milliseconds: Random().nextInt(100)));
    final docPath = _counterBuilder?.call(collectionPath) ??
        _buildCounterPath(collectionPath) ??
        "";
    final linkDocPath = linkedCollectionPath.isEmpty
        ? null
        : (_linkedCounterBuilder?.call(linkedCollectionPath!) ??
            _buildCounterPath(linkedCollectionPath!) ??
            "");
    final updated = <String, DynamicMap>{};
    final inserted = <String, DynamicMap>{};
    try {
      final doc = await RuntimeDatabase._db.loadDocument(
        LocalStoreDocumentQuery(
          path: "$collectionPath/$id",
        ),
      );
      final linkDoc = linkId.isEmpty || linkedCollectionPath.isEmpty
          ? null
          : await RuntimeDatabase._db.loadDocument(
              LocalStoreDocumentQuery(
                path: "$linkedCollectionPath/$linkId",
              ),
            );
      if (doc.isEmpty) {
        inserted["$collectionPath/$id"] = {
          ..._additionalData,
          Const.uid: id,
          Const.time: DateTime.now().millisecondsSinceEpoch,
        };
        if (docPath.isNotEmpty) {
          final key = docPath.split("/").last;
          final path = docPath.replaceFirst(RegExp("/$key\$"), "");
          final countDoc = await RuntimeDatabase._db.loadDocument(
                LocalStoreDocumentQuery(path: path),
              ) ??
              <String, dynamic>{};
          countDoc[Const.uid] = path.split("/").last;
          countDoc[Const.time] = DateTime.now().millisecondsSinceEpoch;
          updated[path] = _buildCounterUpdate(
            map: countDoc,
            key: key,
            value: 1,
            enabled: _enableCounter,
            counterIntervals: _counterIntervals ?? [],
          );
        }
      }
      if (linkId.isNotEmpty &&
          linkedCollectionPath.isNotEmpty &&
          linkDoc.isEmpty) {
        inserted["$linkedCollectionPath/$linkId"] = {
          ..._additionalData,
          Const.uid: linkId,
          Const.time: DateTime.now().millisecondsSinceEpoch,
        };
        if (linkDocPath.isNotEmpty) {
          final key = linkDocPath!.split("/").last;
          final path = linkDocPath.replaceFirst(RegExp("/$key\$"), "");
          final countDoc = await RuntimeDatabase._db.loadDocument(
                LocalStoreDocumentQuery(path: path),
              ) ??
              <String, dynamic>{};
          countDoc[Const.uid] = path.split("/").last;
          countDoc[Const.time] = DateTime.now().millisecondsSinceEpoch;
          updated[path] = _buildCounterUpdate(
            map: countDoc,
            key: key,
            value: 1,
            enabled: _enableCounter,
            counterIntervals: _counterIntervals ?? [],
          );
        }
      }
      for (final tmp in updated.entries) {
        await RuntimeDatabase._db.saveDocument(
          LocalStoreDocumentQuery(
            path: tmp.key,
          ),
          tmp.value,
        );
      }
      for (final tmp in inserted.entries) {
        await RuntimeDatabase._db.saveDocument(
          LocalStoreDocumentQuery(
            path: tmp.key,
          ),
          tmp.value,
        );
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  /// Remove an element of [id] to [collectionPath].
  ///
  /// If [linkedCollectionPath] is specified, the element of [linkId] is removed.
  @override
  Future<void> delete(String id, {String? linkId}) async {
    assert(
      linkId.isEmpty || (linkedCollectionPath.isNotEmpty && linkId.isNotEmpty),
      "When [linkId] is specified, [linkPath] must be specified.",
    );
    final docPath = _counterBuilder?.call(collectionPath) ??
        _buildCounterPath(collectionPath) ??
        "";
    final linkDocPath = linkedCollectionPath.isEmpty
        ? null
        : (_linkedCounterBuilder?.call(linkedCollectionPath!) ??
            _buildCounterPath(linkedCollectionPath!) ??
            "");
    final updated = <String, DynamicMap>{};
    final deleted = <String>[];
    try {
      final doc = await RuntimeDatabase._db.loadDocument(
        LocalStoreDocumentQuery(
          path: "$collectionPath/$id",
        ),
      );
      final linkDoc = linkId.isEmpty || linkedCollectionPath.isEmpty
          ? null
          : await RuntimeDatabase._db.loadDocument(
              LocalStoreDocumentQuery(
                path: "$linkedCollectionPath/$linkId",
              ),
            );
      if (doc.isNotEmpty) {
        deleted.add("$collectionPath/$id");
        if (docPath.isNotEmpty) {
          final key = docPath.split("/").last;
          final path = docPath.replaceFirst(RegExp("/$key\$"), "");
          final countDoc = await RuntimeDatabase._db.loadDocument(
                LocalStoreDocumentQuery(path: path),
              ) ??
              <String, dynamic>{};
          countDoc[Const.uid] = path.split("/").last;
          countDoc[Const.time] = DateTime.now().millisecondsSinceEpoch;
          updated[path] = _buildCounterUpdate(
            map: countDoc,
            key: key,
            value: -1,
            enabled: _enableCounter,
            counterIntervals: _counterIntervals ?? [],
          );
        }
      }
      if (linkId.isNotEmpty &&
          linkedCollectionPath.isNotEmpty &&
          linkDoc.isNotEmpty) {
        deleted.add("$linkedCollectionPath/$linkId");
        if (linkDocPath.isNotEmpty) {
          final key = linkDocPath!.split("/").last;
          final path = linkDocPath.replaceFirst(RegExp("/$key\$"), "");
          final countDoc = await RuntimeDatabase._db.loadDocument(
                LocalStoreDocumentQuery(path: path),
              ) ??
              <String, dynamic>{};
          countDoc[Const.uid] = path.split("/").last;
          countDoc[Const.time] = DateTime.now().millisecondsSinceEpoch;
          updated[path] = _buildCounterUpdate(
            map: countDoc,
            key: key,
            value: -1,
            enabled: _enableCounter,
            counterIntervals: _counterIntervals ?? [],
          );
        }
      }
      for (final tmp in updated.entries) {
        await RuntimeDatabase._db.saveDocument(
          LocalStoreDocumentQuery(
            path: tmp.key,
          ),
          tmp.value,
        );
      }
      for (final tmp in deleted) {
        await RuntimeDatabase._db.deleteDocument(
          LocalStoreDocumentQuery(
            path: tmp,
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  /// Associates the [key] with the given [value].
  ///
  /// The data entered here will be stored in [collectionPath] and in documents in [linkedCollectionPath].
  @override
  void operator []=(String key, Object? value) {
    _additionalData[key] = value;
  }

  /// Retrieves data stored in Transaction.
  ///
  /// The data entered here will be stored in [collectionPath] and in documents in [linkedCollectionPath].
  @override
  dynamic operator [](Object? key) {
    return _additionalData[key];
  }

  /// Deletes data associated with a Transaction.
  @override
  void clear() {
    return _additionalData.clear();
  }

  /// Acquire the key to the data tied to Transaction.
  @override
  Iterable<String> get keys => _additionalData.keys;

  /// Deletes the data for [key] from the data associated with the Transaction.
  @override
  dynamic remove(Object? key) {
    return _additionalData.remove(key);
  }

  /// Create fields for counters.
  ///
  /// Increases or decreases the number of fields marked with [counterSuffix] in the documents in the hierarchy above the [collectionPath] or [linkedCollectionPath] specified when the Builder is created, depending on the increase or decrease in the number of elements.
  ///
  /// You can set up your own counter path using [counterBuilder] or [linkedCounterBuilder].
  ///
  /// Time-delimited counters can be set up by specifying [counterIntervals].
  @override
  void setCounterField({
    String counterSuffix = "Count",
    String Function(String path)? counterBuilder,
    String Function(String linkPath)? linkedCounterBuilder,
    List<CounterUpdaterInterval> counterIntervals = const [],
  }) {
    _enableCounter = true;
    _counterSuffix = counterSuffix;
    _counterBuilder = counterBuilder;
    _linkedCounterBuilder = linkedCounterBuilder;
    _counterIntervals = counterIntervals;
  }
}
