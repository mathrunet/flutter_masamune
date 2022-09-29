// // ignore_for_file: prefer_typing_uninitialized_variables

// import 'dart:async';
// import 'dart:math';

// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:katana_model/katana_model_firebase.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


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
