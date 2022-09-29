// // ignore_for_file: prefer_typing_uninitialized_variables

// import 'dart:async';
// import 'dart:math';

// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:katana_model/katana_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreModelAdapter extends ModelAdapter {
//   const FirestoreModelAdapter(this.database);

//   final FakeFirebaseFirestore database;

//   Query<DynamicMap> _query(
//     Query<DynamicMap> firestoreQuery,
//     ModelAdapterCollectionQuery query,
//   ) {
//     if (query.query.key.isNotEmpty) {
//       if (query.query.isEqualTo != null) {
//         firestoreQuery = firestoreQuery.where(
//           query.query.key!,
//           isEqualTo: query.query.isEqualTo,
//         );
//       }
//       if (query.query.isNotEqualTo != null) {
//         firestoreQuery = firestoreQuery.where(
//           query.query.key!,
//           isNotEqualTo: query.query.isNotEqualTo,
//         );
//       }
//       if (query.query.isGreaterThanOrEqualTo != null) {
//         firestoreQuery = firestoreQuery.where(
//           query.query.key!,
//           isGreaterThanOrEqualTo: query.query.isGreaterThanOrEqualTo,
//         );
//       }
//       if (query.query.isLessThanOrEqualTo != null) {
//         firestoreQuery = firestoreQuery.where(
//           query.query.key!,
//           isLessThanOrEqualTo: query.query.isLessThanOrEqualTo,
//         );
//       }
//       if (query.query.arrayContains != null) {
//         firestoreQuery = firestoreQuery.where(
//           query.query.key!,
//           arrayContains: query.query.arrayContains,
//         );
//       }
//     }
//     if (query.query.limit != null) {
//       firestoreQuery = firestoreQuery.limit(
//         query.query.limit! * query.page,
//       );
//     }
//     if (query.query.orderBy.isNotEmpty) {
//       switch (query.query.order) {
//         case ModelQueryOrder.asc:
//           if (!(query.query.key.isNotEmpty &&
//               query.query.key == query.query.orderBy &&
//               (query.query.isEqualTo != null ||
//                   query.query.isNotEqualTo != null ||
//                   query.query.arrayContainsAny != null ||
//                   query.query.whereIn != null ||
//                   query.query.whereNotIn != null ||
//                   query.query.search != null))) {
//             firestoreQuery = firestoreQuery.orderBy(query.query.orderBy!);
//           }
//           break;
//         case ModelQueryOrder.desc:
//           if (!(query.query.key.isNotEmpty &&
//               query.query.key == query.query.orderBy &&
//               (query.query.isEqualTo ||
//                   query.query.isNotEqualTo != null ||
//                   query.query.arrayContainsAny != null ||
//                   query.query.whereIn != null ||
//                   query.query.whereNotIn != null ||
//                   query.query.search != null))) {
//             firestoreQuery =
//                 firestoreQuery.orderBy(query.query.orderBy!, descending: true);
//           }
//           break;
//       }
//     } else {
//       if (query.query.isGreaterThanOrEqualTo != null) {
//         firestoreQuery = firestoreQuery.orderBy(query.query.key!);
//       } else if (query.query.isLessThanOrEqualTo != null) {
//         firestoreQuery = firestoreQuery.orderBy(query.query.key!);
//       }
//     }

//     return firestoreQuery;
//   }

//   DocumentReference<DynamicMap> _documentReference(
//     ModelAdapterDocumentQuery query,
//   ) =>
//       database.doc(query.query.path);

//   List<Query<DynamicMap>> _collectionReference(
//     ModelAdapterCollectionQuery query,
//   ) {
//     if (query.query.key.isNotEmpty) {
//       if (query.query.arrayContainsAny != null) {
//         final items = query.query.arrayContainsAny!;
//         if (items.isNotEmpty) {
//           final queries = <Query<DynamicMap>>[];
//           for (var i = 0; i < items.length; i += 10) {
//             queries.add(
//               _query(
//                 database
//                     .collection(query.query.path.trimQuery().trimString("/")),
//                 query,
//               ).where(
//                 query.query.key!,
//                 arrayContainsAny: items
//                     .sublist(
//                       i,
//                       min(i + 10, items.length),
//                     )
//                     .toList(),
//               ),
//             );
//           }
//           return queries;
//         }
//       } else if (query.query.whereIn != null) {
//         final items = query.query.whereIn!;
//         if (items.isNotEmpty) {
//           final queries = <Query<DynamicMap>>[];
//           for (var i = 0; i < items.length; i += 10) {
//             queries.add(
//               _query(
//                 database
//                     .collection(query.query.path.trimQuery().trimString("/")),
//                 query,
//               ).where(
//                 query.query.key!,
//                 whereIn: items
//                     .sublist(
//                       i,
//                       min(i + 10, items.length),
//                     )
//                     .toList(),
//               ),
//             );
//           }
//           return queries;
//         }
//       } else if (query.query.whereNotIn != null) {
//         final items = query.query.whereNotIn!;
//         if (items.isNotEmpty) {
//           final queries = <Query<DynamicMap>>[];
//           for (var i = 0; i < items.length; i += 10) {
//             queries.add(
//               _query(
//                 database
//                     .collection(query.query.path.trimQuery().trimString("/")),
//                 query,
//               ).where(
//                 query.query.key!,
//                 whereIn: items
//                     .sublist(
//                       i,
//                       min(i + 10, items.length),
//                     )
//                     .toList(),
//               ),
//             );
//           }
//           return queries;
//         }
//       } else if (query.query.geoHash != null) {
//         final items = query.query.geoHash!;
//         if (items.isNotEmpty) {
//           final queries = <Query<DynamicMap>>[];
//           for (var i = 0; i < items.length; i++) {
//             final hash = items[i];
//             queries.add(
//               _query(
//                 database
//                     .collection(query.query.path.trimQuery().trimString("/")),
//                 query,
//               )
//                   .orderBy(
//                 query.query.key!,
//               )
//                   .startAt([hash]).endAt([hash + "\uf8ff"]),
//             );
//           }
//           return queries;
//         }
//       }
//     }
//     return [
//       _query(
//         database.collection(query.query.path.trimQuery().trimString("/")),
//         query,
//       )
//     ];
//   }

//   @override
//   Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
//     return _documentReference(query).delete();
//   }

//   @override
//   Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
//     final snapshot = await _documentReference(query).get();
//     return snapshot.data()?.cast() ?? {};
//   }

//   @override
//   void disposeCollection(ModelAdapterCollectionQuery query) {}

//   @override
//   void disposeDocument(ModelAdapterDocumentQuery query) {}

//   @override
//   Future<Map<String, DynamicMap>> loadCollection(
//     ModelAdapterCollectionQuery query,
//   ) async {
//     final snapshot = await Future.wait<QuerySnapshot<DynamicMap>>(
//       _collectionReference(query).map((reference) => reference.get()),
//     );
//     return snapshot
//         .expand((e) => e.docChanges)
//         .toMap((e) => MapEntry(e.doc.id, e.doc.data()?.cast() ?? {}));
//   }

//   @override
//   Future<void> saveDocument(
//     ModelAdapterDocumentQuery query,
//     DynamicMap value,
//   ) async {
//     return _documentReference(query).set(value);
//   }

//   @override
//   void setRawData(Map<String, DynamicMap> rawData) {
//     Future.forEach<MapEntry<String, Map<String, dynamic>>>(
//       rawData.entries,
//       (tmp) => database.doc(tmp.key).set(tmp.value),
//     );
//   }

//   @override
//   bool get availableListen => true;

//   @override
//   Future<List<StreamSubscription>> listenCollection(
//     ModelAdapterCollectionQuery query,
//   ) async {
//     final streams =
//         _collectionReference(query).map((reference) => reference.snapshots());
//     final subscriptions = streams.map((e) {
//       return e.listen((event) {
//         for (final doc in event.docChanges) {
//           query.callback?.call(
//             ModelUpdateNotification(
//               path: doc.doc.reference.path,
//               id: doc.doc.id,
//               status: _status(doc.type),
//               value: doc.doc.data()?.cast() ?? {},
//               oldIndex: doc.oldIndex,
//               newIndex: doc.newIndex,
//               origin: query.origin,
//             ),
//           );
//         }
//       });
//     }).toList();
//     await Future.wait(streams.map((stream) => stream.first));
//     return subscriptions;
//   }

//   @override
//   Future<List<StreamSubscription>> listenDocument(
//     ModelAdapterDocumentQuery query,
//   ) async {
//     final stream = _documentReference(query).snapshots();
//     // ignore: cancel_subscriptions
//     final subscription = stream.listen((doc) {
//       query.callback?.call(
//         ModelUpdateNotification(
//           path: doc.reference.path,
//           id: doc.id,
//           status: ModelUpdateNotificationStatus.modified,
//           value: doc.data()?.cast() ?? {},
//           origin: query.origin,
//         ),
//       );
//     });
//     await stream.first;
//     return [subscription];
//   }

//   ModelUpdateNotificationStatus _status(DocumentChangeType type) {
//     switch (type) {
//       case DocumentChangeType.added:
//         return ModelUpdateNotificationStatus.added;
//       case DocumentChangeType.modified:
//         return ModelUpdateNotificationStatus.modified;
//       case DocumentChangeType.removed:
//         return ModelUpdateNotificationStatus.removed;
//     }
//   }
// }

// class FirestoreDynamicCollection
//     extends CollectionBase<FirestoreDynamicDocument, DynamicMap>
//     with LoadableCollectionMixin<FirestoreDynamicDocument, DynamicMap> {
//   FirestoreDynamicCollection(super.query);

//   @override
//   FirestoreDynamicDocument create([String? id]) {
//     return FirestoreDynamicDocument(query.create(id), {});
//   }
// }

// class FirestoreDynamicDocument extends DocumentBase<DynamicMap>
//     with LoadableDocumentMixin<DynamicMap>, SavableDocumentMixin<DynamicMap> {
//   FirestoreDynamicDocument(super.query, super.value);

//   @override
//   DynamicMap fromMap(DynamicMap map) {
//     return Map.unmodifiable(
//       Map.fromEntries(
//         map.entries.where((entry) => !entry.key.startsWith("@")),
//       ),
//     );
//   }

//   @override
//   DynamicMap toMap(DynamicMap value) {
//     return Map.unmodifiable(value);
//   }
// }

// void main() {
//   test("firestoreDocument.saveAndLoadAndDelete", () async {
//     final adapter = FirestoreModelAdapter(FakeFirebaseFirestore());
//     final query = DocumentModelQuery("test/doc", adapter: adapter);
//     final model = FirestoreDynamicDocument(query, {});
//     await model.load();
//     expect(model.value, {});
//     model.value = {"name": "aaaa", "text": "bbbb"};
//     model.save();
//     await model.saving;
//     expect(model.value, {"name": "aaaa", "text": "bbbb"});
//     final remodel = FirestoreDynamicDocument(query, {});
//     expect(remodel.value, {});
//     expect(await remodel.load(), {"name": "aaaa", "text": "bbbb"});
//     expect(remodel.value, {"name": "aaaa", "text": "bbbb"});
//     remodel.value = {"name": "cccc", "text": "dddd"};
//     remodel.save();
//     await remodel.saving;
//     expect(remodel.value, {"name": "cccc", "text": "dddd"});
//     await model.loading;
//     expect(model.value, {"name": "cccc", "text": "dddd"});
//     await model.delete();
//     expect(model.value, {});
//     expect(remodel.value, {});
//     model.value = {"name": "aaaa", "text": "bbbb"};
//     model.save();
//     await model.saving;
//     expect(remodel.value, {"name": "aaaa", "text": "bbbb"});
//   });
//   test("firestoreCollection.saveAndLoadAndDelete", () async {
//     final adapter = FirestoreModelAdapter(FakeFirebaseFirestore());
//     final query = CollectionModelQuery("test", adapter: adapter);
//     final collection = FirestoreDynamicCollection(query);
//     // collection.load();
//     // await collection.loading;
//     // expect(collection, []);
//     // final query1 = DocumentModelQuery("test/aaa", adapter: adapter);
//     // final model1 = FirestoreDynamicDocument(query1, {});
//     // model1.value = {"name": "aaaa", "text": "bbbb"};
//     // await model1.save();
//     // expect(collection.map((e) => e.value), [
//     //   {"name": "aaaa", "text": "bbbb"}
//     // ]);
//     // final query2 = DocumentModelQuery("test/bbb", adapter: adapter);
//     // final model2 = FirestoreDynamicDocument(query2, {});
//     // model2.value = {"name": "ccc", "text": "ddd"};
//     // await model2.save();
//     // expect(collection.map((e) => e.value), [
//     //   {"name": "aaaa", "text": "bbbb"},
//     //   {"name": "ccc", "text": "ddd"}
//     // ]);
//     // final query3 = DocumentModelQuery("test/ccc", adapter: adapter);
//     // final model3 = FirestoreDynamicDocument(query3, {});
//     // model3.value = {"name": "eee", "text": "fff"};
//     // await model3.save();
//     // expect(collection.map((e) => e.value), [
//     //   {"name": "aaaa", "text": "bbbb"},
//     //   {"name": "ccc", "text": "ddd"},
//     //   {"name": "eee", "text": "fff"}
//     // ]);
//     // final query4 = DocumentModelQuery("test/ddd", adapter: adapter);
//     // final model4 = FirestoreDynamicDocument(query4, {});
//     // model4.value = {"name": "ggg", "text": "hhh"};
//     // await model4.save();
//     // expect(collection.map((e) => e.value), [
//     //   {"name": "aaaa", "text": "bbbb"},
//     //   {"name": "ccc", "text": "ddd"},
//     //   {"name": "eee", "text": "fff"},
//     //   {"name": "ggg", "text": "hhh"}
//     // ]);
//     // final query5 = DocumentModelQuery("test/eee", adapter: adapter);
//     // final model5 = FirestoreDynamicDocument(query5, {});
//     // model5.value = {"name": "iii", "text": "jjj"};
//     // await model5.save();
//     // expect(collection.map((e) => e.value), [
//     //   {"name": "aaaa", "text": "bbbb"},
//     //   {"name": "ccc", "text": "ddd"},
//     //   {"name": "eee", "text": "fff"},
//     //   {"name": "ggg", "text": "hhh"},
//     //   {"name": "iii", "text": "jjj"}
//     // ]);
//     // final query6 = DocumentModelQuery("test/fff", adapter: adapter);
//     // final model6 = FirestoreDynamicDocument(query6, {});
//     // model6.value = {"name": "kkk", "text": "lll"};
//     // await model6.save();
//     // expect(collection.map((e) => e.value), [
//     //   {"name": "aaaa", "text": "bbbb"},
//     //   {"name": "ccc", "text": "ddd"},
//     //   {"name": "eee", "text": "fff"},
//     //   {"name": "ggg", "text": "hhh"},
//     //   {"name": "iii", "text": "jjj"},
//     //   {"name": "kkk", "text": "lll"}
//     // ]);
//     // model4.value = {"name": 123, "text": 456};
//     // await model4.save();
//     // expect(collection.map((e) => e.value), [
//     //   {"name": "aaaa", "text": "bbbb"},
//     //   {"name": "ccc", "text": "ddd"},
//     //   {"name": "eee", "text": "fff"},
//     //   {"name": 123, "text": 456},
//     //   {"name": "iii", "text": "jjj"},
//     //   {"name": "kkk", "text": "lll"}
//     // ]);
//     // model2.value = {"name": 789, "text": 10};
//     // await model2.save();
//     // expect(collection.map((e) => e.value), [
//     //   {"name": "aaaa", "text": "bbbb"},
//     //   {"name": 789, "text": 10},
//     //   {"name": "eee", "text": "fff"},
//     //   {"name": 123, "text": 456},
//     //   {"name": "iii", "text": "jjj"},
//     //   {"name": "kkk", "text": "lll"}
//     // ]);
//   });
// }
