part of firebase_model_notifier;

/// Class for executing Firestore Transaction.
class FirestoreTransaction {
  const FirestoreTransaction._();

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [documentPath].
  static FirestoreDocumentTransactionBuilder documentTransaction(
    String documentPath,
  ) {
    return FirestoreDocumentTransactionBuilder._(
      documentPath,
    );
  }

  /// Outputs the builder to be written by the transaction.
  ///
  /// Basically, it writes and deletes data for [collectionPath].
  ///
  /// You can add the corresponding element by specifying [linkedCollectionPath].
  static FirestoreCollectionTransactionBuilder collectionTransaction({
    required String collectionPath,
    String? linkedCollectionPath,
  }) {
    return FirestoreCollectionTransactionBuilder._(
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
    await FirebaseCore.initialize();
    List<String> generated = [];
    do {
      // await Future.delayed(Duration(milliseconds: Random().nextInt(100)));
      generated = List.generate(
        10,
        (index) => katana.generateCode(length, charSet: charSet),
      );
      final snapshot = await FirebaseFirestore.instance
          .collection(path)
          .where(key, whereIn: generated)
          .get();
      for (final doc in snapshot.docs) {
        if (!doc.exists) {
          continue;
        }
        final map = doc.data();
        if (map.isEmpty || !map.containsKey(key)) {
          continue;
        }
        generated.remove(map.get(key, ""));
      }
    } while (generated.isEmpty);
    return generated.first;
  }
}

/// Generates a transaction builder.
class FirestoreDocumentTransactionBuilder extends DocumentTransactionBuilder
    with MapMixin<String, dynamic> {
  FirestoreDocumentTransactionBuilder._(this.documentPath)
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
    await FirebaseCore.initialize();
    final firestore = FirebaseFirestore.instance;
    await firestore.runTransaction((transaction) async {
      try {
        final doc = <String, dynamic>{
          ..._additionalData,
          Const.uid: documentPath.split("/").last,
          Const.time: FieldValue.serverTimestamp(),
        };
        doc.addAll(
          _buildCounterUpdate(
            key: _counterKey,
            value: _counterValue,
            enabled: _enableCounter,
            counterIntervals: _counterIntervals ?? [],
          ),
        );
        transaction.set(
          firestore.doc(documentPath),
          doc,
          SetOptions(merge: true),
        );
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    });
  }
}

/// Generates a transaction builder.
class FirestoreCollectionTransactionBuilder extends CollectionTransactionBuilder
    with MapMixin<String, dynamic> {
  FirestoreCollectionTransactionBuilder._({
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
    await FirebaseCore.initialize();
    // await Future.delayed(Duration(milliseconds: Random().nextInt(100)));
    final firestore = FirebaseFirestore.instance;
    final docPath = _counterBuilder?.call(collectionPath) ??
        _buildCounterPath(collectionPath) ??
        "";
    final linkDocPath = linkedCollectionPath.isEmpty
        ? null
        : (_linkedCounterBuilder?.call(linkedCollectionPath!) ??
            _buildCounterPath(linkedCollectionPath!) ??
            "");
    await firestore.runTransaction((transaction) async {
      try {
        DocumentSnapshot<Map<String, dynamic>>? doc;
        DocumentSnapshot<Map<String, dynamic>>? linkDoc;
        await Future.wait([
          transaction
              .get(firestore.doc("$collectionPath/$id"))
              .then((value) => doc = value),
          if (!(linkId.isEmpty || linkedCollectionPath.isEmpty))
            transaction
                .get(firestore.doc("$linkedCollectionPath/$linkId"))
                .then((value) => linkDoc = value)
        ]);
        if (doc != null && !doc!.exists) {
          transaction.set(
            doc!.reference,
            {
              ..._additionalData,
              Const.uid: id,
              Const.time: FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
          if (docPath.isNotEmpty) {
            final key = docPath.split("/").last;
            final path = docPath.replaceFirst(RegExp("/$key\$"), "");
            final countDoc = <String, dynamic>{
              Const.uid: path.split("/").last,
              Const.time: FieldValue.serverTimestamp(),
            };
            countDoc.addAll(
              _buildCounterUpdate(
                key: key,
                value: 1,
                enabled: _enableCounter,
                counterIntervals: _counterIntervals ?? [],
              ),
            );
            transaction.set(
              firestore.doc(path),
              countDoc,
              SetOptions(merge: true),
            );
          }
        }
        if (linkDoc != null && !linkDoc!.exists) {
          transaction.set(
            linkDoc!.reference,
            {
              ..._additionalData,
              Const.uid: linkId,
              Const.time: FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
          if (linkDocPath.isNotEmpty) {
            final key = linkDocPath!.split("/").last;
            final path = linkDocPath.replaceFirst(RegExp("/$key\$"), "");
            final countDoc = <String, dynamic>{
              Const.uid: path.split("/").last,
              Const.time: FieldValue.serverTimestamp(),
            };
            countDoc.addAll(
              _buildCounterUpdate(
                key: key,
                value: 1,
                enabled: _enableCounter,
                counterIntervals: _counterIntervals ?? [],
              ),
            );
            transaction.set(
              firestore.doc(path),
              countDoc,
              SetOptions(merge: true),
            );
          }
        }
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    });
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
    await FirebaseCore.initialize();
    final firestore = FirebaseFirestore.instance;
    final docPath = _counterBuilder?.call(collectionPath) ??
        _buildCounterPath(collectionPath) ??
        "";
    final linkDocPath = linkedCollectionPath.isEmpty
        ? null
        : (_linkedCounterBuilder?.call(linkedCollectionPath!) ??
            _buildCounterPath(linkedCollectionPath!) ??
            "");
    await firestore.runTransaction((transaction) async {
      try {
        DocumentSnapshot<Map<String, dynamic>>? doc;
        DocumentSnapshot<Map<String, dynamic>>? linkDoc;
        await Future.wait([
          transaction
              .get(firestore.doc("$collectionPath/$id"))
              .then((value) => doc = value),
          if (!(linkId.isEmpty || linkedCollectionPath.isEmpty))
            transaction
                .get(firestore.doc("$linkedCollectionPath/$linkId"))
                .then((value) => linkDoc = value)
        ]);
        if (doc != null && doc!.exists) {
          transaction.delete(doc!.reference);
          if (docPath.isNotEmpty) {
            final key = docPath.split("/").last;
            final path = docPath.replaceFirst(RegExp("/$key\$"), "");
            final countDoc = <String, dynamic>{
              Const.uid: path.split("/").last,
              Const.time: FieldValue.serverTimestamp(),
            };
            countDoc.addAll(
              _buildCounterUpdate(
                key: key,
                value: -1,
                enabled: _enableCounter,
                counterIntervals: _counterIntervals ?? [],
              ),
            );
            transaction.set(
              firestore.doc(path),
              countDoc,
              SetOptions(merge: true),
            );
          }
        }
        if (linkDoc != null && linkDoc!.exists) {
          transaction.delete(linkDoc!.reference);
          if (linkDocPath.isNotEmpty) {
            final key = linkDocPath!.split("/").last;
            final path = linkDocPath.replaceFirst(RegExp("/$key\$"), "");
            final countDoc = <String, dynamic>{
              Const.uid: path.split("/").last,
              Const.time: FieldValue.serverTimestamp(),
            };
            countDoc.addAll(
              _buildCounterUpdate(
                key: key,
                value: -1,
                enabled: _enableCounter,
                counterIntervals: _counterIntervals ?? [],
              ),
            );
            transaction.set(
              firestore.doc(path),
              countDoc,
              SetOptions(merge: true),
            );
          }
        }
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    });
  }

  /// Associates the [key] with the given [value].
  ///
  /// The data entered here will be stored in [collectionPath] and in documents in [linkedCollectionPath].
  @override
  void operator []=(String key, value) {
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
